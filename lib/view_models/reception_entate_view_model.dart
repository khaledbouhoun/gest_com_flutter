import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_stock/models/commande_product.dart';
import 'package:gestion_stock/models/fournisseur.dart';
import 'package:gestion_stock/models/journal.dart';
import 'package:gestion_stock/models/paginated_response.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/views/reception_entate/receptions.dart';
import 'package:gestion_stock/widgets/http_extensions.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/reception_entate.dart';

class ReceptionEntateViewModel extends ChangeNotifier {
  AuthViewModel authProvider;
  ReceptionEntateViewModel(this.authProvider);
  void notify() {
    Future.microtask(() => notifyListeners());
  }

  int? statusCode = 0;
  double totalReception = 0.0;
  Fournisseur? addReceptionFournisseur;
  List<ReceptionEntate>? filterdReceptions;
  List<ReceptionEntate>? receptions;

  SaveState saveState = SaveState.idle;

  ReceptionEntate? selectedReception;
  List<CommandeProduct> addReceptionProducts = [];

  DateTime? startDate;
  DateTime? endDate;

  // ============================================================
  // Pagination & search state
  // ============================================================

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  int _currentOffset = 0;
  int get currentOffset => _currentOffset;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  List<Map<double, String>> types = [
    {1: 'Réception'},
    {2: 'Routeur'},
  ];

  Map<double, String>? selectedType;

  Future<void> getReceptions(
    BuildContext context, {
    String? search,
    int? limit,
    int? offset,
  }) async {
    try {
      if (offset == 0 || offset == null) {
        statusCode = 0;
        notify();
      }

      // Update search/pagination state
      if (search != null) _searchQuery = search;
      final effectiveLimit = limit ?? 50;
      final effectiveOffset = offset ?? _currentOffset;

      // Build URL (clean)
      String url = "/achat";

      final reqBody = _buildRequestBody(
        userType: authProvider.selectedUser!.USRTYPE,
        datedu: DateFormat('yyyy-MM-dd').format(startDate!),
        dateau: DateFormat('yyyy-MM-dd').format(endDate!),
        typeRecp: selectedType!.keys.first,
        limit: effectiveLimit,
        offset: effectiveOffset,
        search: _searchQuery,
      );

      if (reqBody['statusCode'] == 404) {
        if (effectiveOffset == 0) {
          receptions = [];
          filterdReceptions = [];
          statusCode = 404;
        } else {
          _hasMore = false;
        }
        notify();
        return;
      }

      http.Response response = await url.authPost(
        context,
        reqBody,
      );

      statusCode = response.statusCode;

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);

        // Support both paginated and legacy response formats
        if (data.containsKey('data')) {
          final paginated = PaginatedResponse<ReceptionEntate>.fromJson(
            data,
            (item) => ReceptionEntate.fromJson(item),
          );
          if (effectiveOffset == 0) {
            receptions = paginated.data;
          } else {
            receptions ??= [];
            receptions!.addAll(paginated.data);
          }
          _currentOffset = effectiveOffset + paginated.data.length;
          _hasMore = paginated.meta.hasMore;
        } else {
          receptions = ReceptionEntate.listFromJson(data['receptions']);
          _hasMore = false;
          _currentOffset = 0;
        }

        filterdReceptions = receptions;
        filterdReceptions!.sort((a, b) => b.FTEDHCRE!.compareTo(a.FTEDHCRE!));
      } else if (response.statusCode == 404) {
        if (effectiveOffset == 0) {
          receptions = [];
          filterdReceptions = [];
        }
      }

      notify();
    } catch (err) {
      statusCode = 500;
      notify();
    }
  }

  Map<String, dynamic> _buildRequestBody({
    required int userType,
    required String datedu,
    required String dateau,
    required double typeRecp,
    required int limit,
    required int offset,
    required String search,
  }) {
    final categoriesFou = authProvider.catgFournisseurs.where((e) => e.read == true).map((e) => e.rubrique).toList();
    final jernaeu = authProvider.achtJournaux.where((e) => e.read == true).map((e) => e.rubrique).toList();

    if (userType == 0 && (categoriesFou.isEmpty || jernaeu.isEmpty)) {
      return {
        'statusCode': 404,
      };
    }

    return {
      'path': authProvider.selectedFolder?.DOSBDD,
      'typeUser': userType,
      'datedu': datedu,
      'dateau': dateau,
      'typeRecp': typeRecp,
      'limit': limit,
      'offset': offset,
      'search': search,
      'categoriesFou': categoriesFou.toString(),
      'categoriesFou_length': categoriesFou.length,
      'jernaeu': jernaeu.toString(),
      'jernaeu_length': jernaeu.length,
    };
  }

  Future<void> filtreReceptions(String query) async {
    try {
      if (query.isEmpty) {
        filterdReceptions = receptions;
        notify();
        return;
      }
      final parts = query.toLowerCase().trim().split(' ').where((e) => e.isNotEmpty).toList();

      filterdReceptions = receptions!.where((facture) {
        final name = '${facture.FTENO.toLowerCase()} ${facture.FOUNOM?.toLowerCase()}';
        return parts.every((part) => name.contains(part));
      }).toList();

      notify();
    } catch (err) {
      notify();
    }
  }

  Future<double> getGetReceptionStockGnrAchat(BuildContext context, String artno) async {
    double prix = 0.0;
    try {
      notify();

      final prixTTC = authProvider.sellSettings!.PRMCALCULPRIXTTC.toInt();

      final body = {
        'path': authProvider.selectedFolder?.DOSBDD,
      };

      final response =
          await "/Get_Reception_Stock_Gnr_Achat?ARTNO=$artno&PRMCALCULPRIXTTC=$prixTTC".authPost(context, body);

      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        prix = data['achat'] ?? 0.0;
      }
    } catch (e) {
      print('getReceptionStock error: $e');
      statusCode = 500;
    } finally {
      notify();
    }
    return prix;
  }

  DateTime datesave = DateTime.now();
  String codeBon = '';
  Tipe? selectedT;

  TextEditingController codeselController = TextEditingController();
  TextEditingController noPiece = TextEditingController();

  List<Tipe> listTipe = [
    Tipe(tipe: 'Réception', tipeno: 1),
    Tipe(tipe: 'Routeur', tipeno: 2),
  ];

  List<JournalModel> listJournals = [];
  JournalModel? selectedJournal;

  Future<void> selectDate(BuildContext context, DateTime changedDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: changedDate,
      firstDate: DateTime(authProvider.initialExercice!.EXENO!, 1, 1),
      lastDate: DateTime(authProvider.initialExercice!.EXENO!, 12, 31),
    );
    if (picked != null && picked != datesave) {
      datesave = picked;
    }
    Future.microtask(() => notifyListeners());
  }

  Future<void> defalutDate() async {
    if (authProvider.initialExercice!.EXENO == DateTime.now().year) {
      datesave = DateTime.now();
    } else {
      datesave = DateTime(authProvider.initialExercice!.EXENO!, 12, 31);
    }
    Future.microtask(() => notifyListeners());
  }

  Future getJournals(BuildContext context) async {
    try {
      statusCode = 0;
      listJournals = [];
      http.Response response =
          await "/get_journals".authPost(context, {'path': authProvider.selectedFolder?.DOSBDD, 'JouType': 6});
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        listJournals = JournalModel.listFromJson(data['journal']);
        selectedJournal = listJournals.first;
      }
      notify();
    } catch (err) {
      print(err);
      statusCode = 500;
      notify();
    }
  }

  Future<void> getcodebon(BuildContext context) async {
    try {
      String parms = 'Tipe=${selectedT!.tipeno}&Date=${DateFormat('yyyy-MM-dd').format(datesave)}';
      statusCode = 0;
      http.Response response =
          await "/Get_Code_Bon_Reception?$parms".authPost(context, {'path': authProvider.selectedFolder?.DOSBDD});
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        codeBon = data['codebon'];
      }
      notify();
    } catch (err) {
      print(err);
      statusCode = 500;
      notify();
    }
  }

  void resetAddReception() {
    addReceptionFournisseur = null;
    addReceptionProducts = [];
    totalReception = 0;
    Future.microtask(() => notifyListeners());
  }

  Future<void> saveReception(BuildContext context) async {
    await getcodebon(context);

    saveState = SaveState.loading;
    statusCode = 0;
    Future.microtask(() => notifyListeners());

    try {
      /// 1️⃣ Save products first
      final productsSaved = await saveProducts(context);
      if (!productsSaved) {
        throw Exception('Failed to save reception products');
      }
      print('Products saved successfully, proceeding to save reception header');

      /// 2️⃣ Save reception header

      // Validate required values and build safe query params
      final tipeVal = selectedT?.tipeno ?? 0;
      final dateVal = DateFormat('yyyy-MM-dd').format(datesave);
      final exeVal = authProvider.initialExercice?.EXENO?.toString() ?? '';
      final journalVal = selectedJournal?.jouNo ?? '';
      final fournisseurVal = addReceptionFournisseur?.FOUNO ?? '';
      final totTTCVal = totalReception.toString();
      final usrVal = authProvider.selectedUser?.USRLOGIN ?? '';
      final depotDefautVal = authProvider.sellSettings?.PRMDEPOTDEFAUTAB?.toString() ?? '';
      final prmConsomVal = authProvider.sellSettings?.PRMCONSOMMATPREM2.toInt().toString() ?? '0';
      final prmCalcPrixTTCVal = authProvider.buySettings?.pRMCALCULPRIXTTC?.toString() ?? '';
      final catgClrVal = authProvider.catgClr;

      String queryParams =
          'Tipe=$tipeVal&Date=$dateVal&ExeCourant=$exeVal&codebon=$codeBon&journal=$journalVal&CodeFournis=$fournisseurVal&TotTTC=$totTTCVal&Usr_Login=$usrVal&clino=$fournisseurVal&PrmDepotDefautTourneeAB=$depotDefautVal&PrmConsomMatPrem2=$prmConsomVal&PrmCalculPrixTTC=$prmCalcPrixTTCVal&catgClr=$catgClrVal';

      /// 3️⃣ Save reception header
      final response = await "/Save_Reception?$queryParams".authPost(
        context,
        {
          'path': authProvider.selectedFolder?.DOSBDD,
          'codesel': codeselController.text.isEmpty ? "" : codeselController.text,
          'NoPiece': noPiece.text.isEmpty ? "" : noPiece.text,
        },
      );

      statusCode = response.statusCode;

      if (response.statusCode != 200) {
        throw Exception('Reception save failed');
      }

      /// 4️⃣ Reset state (SUCCESS)
      _resetReceptionData();
      resetPagination();
      saveState = SaveState.success;
      noPiece.clear();
      codeselController.clear();
      notify();

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => Receptions()));
    } catch (e) {
      debugPrint('Save reception error: $e');
      saveState = SaveState.error;
      statusCode = 500;
      notify();
    }
  }

  Future<bool> saveProducts(BuildContext context) async {
    if (addReceptionProducts.isEmpty) return true;

    try {
      for (int i = 0; i < addReceptionProducts.length; i++) {
        final product = addReceptionProducts[i];

        final prod = product.product;
        final artUnCol = prod.ARTUNTCOL ?? 0;
        final computedNbrColis = artUnCol == 0 ? 0 : product.quantity / artUnCol;
        final nbrColis = (computedNbrColis is double && !computedNbrColis.isFinite) ? 0 : computedNbrColis;
        final artAchPar = prod.ARTACHPAR ?? 0.0;

        final body = {
          'path': authProvider.selectedFolder?.DOSBDD,
          'datestr': DateFormat('yyyy-MM-dd').format(datesave),
          'codebon': codeBon,
          'ArtNo': prod.ARTNO ?? '',
          'Ordre': i + 1,
          'ArtNom': prod.ARTNOM ?? '',
          'ARTACHPAR': artAchPar.toInt(),
          'ArtLong': prod.ARTLONG ?? 0.0,
          'ArtLarg': prod.ARTLARG ?? 0.0,
          'ArtColis': prod.ARTCOLIS ?? '',
          'NbrColis': nbrColis,
          'ArtUntCol': prod.ARTUNTCOL ?? 0.0,
          'qte': product.quantity,
          'PuTTC': prod.ARTPRIX ?? 0.0,
          'CDepot': authProvider.getDepotsWrite() ?? authProvider.sellSettings?.PRMDEPOTDEFAUTAB ?? 0,
        };

        final response = await "/Save_Reception_Products".authPost(context, body);

        if (response.statusCode != 200) {
          throw Exception('Product save failed at index $i');
        }
      }

      return true;
    } catch (e) {
      debugPrint('Save products error: $e');
      statusCode = 500;
      return false;
    }
  }

  void _resetReceptionData() {
    codeselController.clear();
    noPiece.clear();

    addReceptionProducts.clear();
    listJournals.clear();

    totalReception = 0;
    codeBon = "";
    datesave = DateTime.now();
    addReceptionFournisseur = null;
  }

  // ============================================================
  // Pagination helpers
  // ============================================================

  Future<void> loadMoreReceptions(BuildContext context) async {
    print(
        "[reception_entate_view_model.dart] loadMoreReceptions called. isLoadingMore: $_isLoadingMore, hasMore: $_hasMore");
    if (_isLoadingMore || !_hasMore) return;
    try {
      _isLoadingMore = true;
      notify();
      await getReceptions(context, offset: _currentOffset);
    } finally {
      _isLoadingMore = false;
      notify();
    }
  }

  void setPageSize(int size) {
    _currentOffset = 0;
    notify();
  }

  void resetPagination() {
    _currentOffset = 0;
    _searchQuery = '';
    _hasMore = true;
    _isLoadingMore = false;
    receptions = [];
    notify();
  }
}

enum SaveState { idle, loading, success, error }

class Tipe {
  String tipe;
  int tipeno;

  Tipe({required this.tipe, required this.tipeno});

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Tipe && runtimeType == other.runtimeType && tipeno == other.tipeno;

  @override
  int get hashCode => tipeno.hashCode;
}
