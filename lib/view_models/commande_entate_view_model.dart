import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:gestion_stock/models/client.dart';
import 'package:gestion_stock/models/commande_entate.dart';
// import 'package:gestion_stock/models/commande_entate.dart'; // Uncomment and create this model if needed
import 'package:gestion_stock/models/commande_product.dart';
import 'package:gestion_stock/models/journal.dart';
import 'package:gestion_stock/models/paginated_response.dart';
import 'package:gestion_stock/models/pagination_meta.dart';
import 'package:gestion_stock/models/product.dart';
import 'package:gestion_stock/models/site.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/views/command/commandes.dart';
import 'package:gestion_stock/widgets/http_extensions.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CommandeEntateViewModel extends ChangeNotifier {
  AuthViewModel authProvider;
  CommandeEntateViewModel(this.authProvider);
  void notify() {
    Future.microtask(() => notifyListeners());
  }

  final formKey = GlobalKey<FormState>();
  // List<CommandeEntate>? filteredCommandes; // Uncomment and use your model
  List<CommandeEntate>? filteredCommandes;
  List<CommandeEntate>? commandes;

  CommandeEntate? _selectedCommande; // Use your CommandeEntate model if available
  CommandeEntate? get selectedCommande => _selectedCommande;

  int statusCode = 0;

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

  int _pageSize = 50;
  int get pageSize => _pageSize;

  int _totalRows = 0;
  int get totalRows => _totalRows;

  PaginationMeta? _paginationMeta;

  Client? addCommandeClient;
  List<CommandeProduct> addCommandeProducts = [];
  double totalCommande = 0;

  String? get prmtarifdefautab => authProvider.sellSettings?.PRMTARIFDEFAUTAB ?? '01';

  void setSelectedCommande(CommandeEntate commande) {
    _selectedCommande = commande;
    notify();
  }

  Future getCommandes(
    BuildContext context, {
    String? search,
    int? limit,
    int? offset,
  }) async {
    print("[commande_entate_view_model.dart] getCommandes search: $search, offset: $offset");
    try {
      if (offset == 0 || offset == null) {
        statusCode = 0;
        notify();
      }

      // Update search/pagination state
      if (search != null) _searchQuery = search;
      final effectiveLimit = limit ?? _pageSize;
      final effectiveOffset = offset ?? _currentOffset;

      // Build URL (clean)
      String url = "/commande";

      final reqBody = _buildRequestBody(
        userType: authProvider.selectedUser!.USRTYPE,
        datedu: DateFormat('yyyy-MM-dd').format(startDate!),
        dateau: DateFormat('yyyy-MM-dd').format(endDate!),
        limit: effectiveLimit,
        offset: effectiveOffset,
        search: _searchQuery,
      );

      if (reqBody['statusCode'] == 404) {
        if (effectiveOffset == 0) {
          commandes = [];
          filteredCommandes = [];
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
          final paginated = PaginatedResponse<CommandeEntate>.fromJson(
            data,
            (item) => CommandeEntate.fromJson(item),
          );
          if (effectiveOffset == 0) {
            commandes = paginated.data;
          } else {
            commandes ??= [];
            commandes!.addAll(paginated.data);
          }
          _paginationMeta = paginated.meta;
          _hasMore = paginated.meta.hasMore;
          _currentOffset = effectiveOffset + paginated.data.length;
          print(
              "[commande_entate_view_model.dart] Loaded ${paginated.data.length} commandes. Total: ${commandes?.length}, hasMore: $_hasMore");
        } else {
          // Legacy format fallback
          print("[commande_entate_view_model.dart] Warning: Received legacy response format. Pagination disabled.");
          commandes = (data['Commandes'] as List).map((e) => CommandeEntate.fromJson(e)).toList();
          _hasMore = false;
        }

        filteredCommandes = commandes;
      } else if (response.statusCode == 404) {
        if (effectiveOffset == 0) {
          commandes = [];
          filteredCommandes = [];
        }
      }

      notify();
    } catch (err) {
      print("[commande_entate_view_model.dart] getCommandes error: $err");
      statusCode = 500;
      notify();
    }
  }

  Map<String, dynamic> _buildRequestBody({
    required int userType,
    required String datedu,
    required String dateau,
    required int limit,
    required int offset,
    required String search,
  }) {
    final categoriesCli = authProvider.catgClients.where((e) => e.read == true).map((e) => e.rubrique).toList();
    final territoires = authProvider.clientsTerritoires.where((e) => e.read == true).map((e) => e.rubrique).toList();
    final jernaeu = authProvider.vteJournaux.where((e) => e.read == true).map((e) => e.rubrique).toList();

    if (userType == 0 && (categoriesCli.isEmpty || territoires.isEmpty || jernaeu.isEmpty)) {
      return {
        'statusCode': 404,
      };
    }

    return {
      'path': authProvider.selectedFolder?.DOSBDD,
      'typeUser': userType,
      'datedu': datedu,
      'dateau': dateau,
      'limit': limit,
      'offset': offset,
      'search': search,
      'categoriesCli': categoriesCli.toString(),
      'categoriesCli_length': categoriesCli.length,
      'jernaeu': jernaeu.toString(),
      'jernaeu_length': jernaeu.length,
      'territoires': territoires.toString(),
      'territoires_length': territoires.length,
    };
  }

  Future filtreCommande(String query) async {
    try {
      if (query.isEmpty) {
        filteredCommandes = commandes;
        notify();
        return;
      }
      final parts = query.toLowerCase().trim().split(' ').where((e) => e.isNotEmpty).toList();

      filteredCommandes = commandes!.where((commande) {
        // Search by client name
        final name = '${commande.cDENO!.toLowerCase()} ${commande.cLINOM!.toLowerCase()}';
        // Search by command code
        final commandCode = commande.cDENO?.toLowerCase() ?? '';

        // Check if any part matches either the name or command code
        return parts.every((part) => name.contains(part) || commandCode.contains(part));
      }).toList();

      notify();
    } catch (err) {
      print('Error filtering commandes: $err');
      notify();
    }
  }

  Future updateAddedProduct(BuildContext context, Duration timeout, Product product, String tarif) async {
    final completer = Completer<http.Response>();
    final timer = Timer(timeout, () {
      completer.completeError(TimeoutException('The connection has timed out!'));
    });
    try {
      http.Response response = await "/update_added_commande_product?artno=${product.ARTNO}&tarif=$tarif"
          .authPost(context, {'path': authProvider.selectedFolder?.DOSBDD});
      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        product.TFDPRIX = double.parse(data['product']['TFDPRIX'].toString());
        product.TFDPRIXTTC = double.parse(data['product']['TFDPRIXTTC'].toString());
        product.TFDBASE = double.parse(data['product']['TFDBASE'].toString());
      }
      if (!completer.isCompleted) {
        completer.complete(response);
      }
    } catch (err) {
      if (!completer.isCompleted) {
        completer.completeError(err);
      }
    } finally {
      timer.cancel();
    }
  }

  DateTime datesave = DateTime.now();
  DateTime dtpDateLivr = DateTime.now();
  DateTime dtpDateRSV = DateTime.now();
  bool checkedRSV = false;
  String? codeBon;
  Tipe? selectedT;

  TextEditingController edtBCNo = TextEditingController();
  TextEditingController codeselController = TextEditingController();

  List<Tipe> listTipe = [
    Tipe(tipe: 'Commande', tipeno: 1),
    Tipe(tipe: 'Retour', tipeno: 2),
  ];

  List<JournalModel> listJournals = [];
  JournalModel? selectedJournal;

  List<SiteModel> listSites = [];
  SiteModel? selectedSite;
  bool siteerorr = false;

  double coliscalcul(String? code, double? colis, int? qty) {
    double? col = 0;
    if (code != '00' && colis != 0) {
      col = qty! / colis!;
    }
    return col;
  }

  void resetAddCommande() {
    addCommandeClient = null;
    addCommandeProducts = [];
    totalCommande = 0;
    addSelectedTarif = authProvider.sellSettings?.PRMTARIFDEFAUTAB ?? '01';

    notify();
  }

  set addSelectedTarif(String? value) {
    authProvider.sellSettings?.PRMTARIFDEFAUTAB = value;
    notify();
  }

  Future<DateTime> selectDate(BuildContext context, DateTime changedDate) async {
    // Ensure the initialDate is within the valid range
    DateTime initialDate = changedDate;
    DateTime firstDate = DateTime(authProvider.initialExercice!.EXENO!, 1, 1);
    DateTime lastDate = DateTime(authProvider.initialExercice!.EXENO!, 12, 31);

    // If the changedDate is outside the valid range, use the lastDate as initialDate
    if (changedDate.isAfter(lastDate)) {
      initialDate = lastDate;
    } else if (changedDate.isBefore(firstDate)) {
      initialDate = firstDate;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      initialDate = picked;
    }
    return initialDate;
  }

  Future<void> defalutDate() async {
    if (authProvider.initialExercice!.EXENO == DateTime.now().year) {
      datesave = DateTime.now();
    } else {
      datesave = DateTime(authProvider.initialExercice!.EXENO!, 12, 31);
    }
    notify();
  }

  Future getJournals(BuildContext context) async {
    try {
      statusCode = 0;

      String? Journaeudefault = authProvider.rubriques
              .where((r) => r.USBTRS == '03' && r.USBTRB == '03' && r.USBDEFAULT == 1)
              .firstOrNull
              ?.USBRUB ??
          authProvider.sellSettings!.PRMJNLDEFAUT2;
      final vteJourAuth = authProvider.vteJournaux.where((e) => e.write == true);
      final journaux = vteJourAuth.map((e) => "'${e.rubrique}'").join(',');

      if (vteJourAuth.isEmpty && authProvider.selectedUser!.USRTYPE == 0) {
        listJournals = [];
        selectedJournal = null;
        notify();
        return;
      }

      String query = "";
      switch (authProvider.selectedUser!.USRTYPE) {
        case 0:
          query = " AND JOUNO IN ($journaux) ";
          break;
        case 1:
          query = vteJourAuth.isNotEmpty ? " AND JOUNO NOT IN ($journaux) " : " ";
          break;
        default:
          query = "  ";
          break;
      }

      http.Response response = await "/get_journals"
          .authPost(context, {'path': authProvider.selectedFolder?.DOSBDD, "journaux": query, "JouType": 5});
      statusCode = response.statusCode;

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        listJournals = JournalModel.listFromJson(data['journal']);
        selectedJournal = authProvider.selectedUser!.USRTYPE == 0
            ? listJournals.firstWhere((element) => element.jouNo == Journaeudefault)
            : listJournals.first;
      } else {
        listJournals = [];
        selectedJournal = null;
      }
      notify();
    } catch (err) {
      print(err);
      statusCode = 500;
      listJournals = [];
      selectedJournal = null;
      notify();
    }
  }

  Future getSites(BuildContext context) async {
    try {
      statusCode = 0;

      http.Response response = await "/get_Site".authPost(context, {
        'path': authProvider.selectedFolder?.DOSBDD,
        "clscli": addCommandeClient?.CLINO,
        "clinom": addCommandeClient?.CLINOM,
      });
      statusCode = response.statusCode;

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        listSites = (data['sites'] as List).map((item) => SiteModel.fromJson(item)).toList();

        if (listSites.length == 1) {
          selectedSite = listSites.first;
        } else {
          selectedSite = null;
        }
      } else {
        listSites = [];
        selectedSite = null;
      }
      notify();
    } catch (err) {
      print(err);
      statusCode = 500;
      listSites = [];
      selectedSite = null;
      notify();
    }
  }

  Future getcodebon(BuildContext context) async {
    String parms = 'ExeCourant=${authProvider.initialExercice!.EXENO}';
    try {
      statusCode = 0;
      http.Response response =
          await "/get_code_bon_commande?$parms".authPost(context, {'path': authProvider.selectedFolder?.DOSBDD});
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

  Future saveCommande(BuildContext context) async {
    await getcodebon(context);
    if (addCommandeClient == null ||
        selectedT == null ||
        addCommandeProducts.isEmpty ||
        authProvider.selectedUser == null ||
        authProvider.sellSettings == null ||
        authProvider.initialExercice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs obligatoires.')),
      );
      return;
    }
    try {
      List<Map<String, String>> depots = await authProvider.getDepots(context);
      await saveProducts(context, depots);
      String parms2 =
          '&codebon=$codeBon&BC=${edtBCNo.text}&codesel=${codeselController.text}&journal=${selectedJournal!.jouNo}&clino=${addCommandeClient!.CLINO}&Site=${(selectedSite == null) || (selectedSite!.cLSNO == '00') ? "" : selectedSite!.cLSNO}&TotTTC=$totalCommande&Usr_Login=${authProvider.selectedUser!.USRLOGIN}';
      String parms =
          '&Date=${DateFormat('yyyy-MM-dd').format(datesave)}&dtpDateLivr=${DateFormat('yyyy-MM-dd').format(dtpDateLivr)}&dtpDateRSV=${DateFormat('yyyy-MM-dd').format(checkedRSV ? dtpDateRSV : DateTime.now())}&CheckedRSV=$checkedRSV';
      String parms3 =
          "&PrmMajStk=${authProvider.sellSettings!.PRMMAJSTK.toInt()}&PrmBDTournee=${authProvider.genSettings!.prmBDTournee}&PrmDepotDefautTourneeAB=${authProvider.sellSettings!.PRMDEPOTDEFAUTTOURNEEAB}&PrmConsomMatPrem2=${authProvider.sellSettings!.PRMCONSOMMATPREM2.toInt()}&PrmCalculPrixTTC=1&ExeCourant=${authProvider.initialExercice!.EXENO}&catgClr=${authProvider.catgClr}";

      statusCode = 0;
      http.Response response =
          await "/Save_Commande?$parms$parms2$parms3".authPost(context, {'path': authProvider.selectedFolder?.DOSBDD});
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        codeselController.clear();
        edtBCNo.clear();
        addCommandeProducts.clear();
        totalCommande = 0;
        addCommandeClient = null;
        codeBon = null;
        datesave = DateTime.now();
        dtpDateLivr = DateTime.now();
        dtpDateRSV = DateTime.now();
        checkedRSV = false;
        selectedSite = null;
        selectedJournal = null;

        listJournals = [];
        listSites = [];
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => Commandes()));
        notify();
      }
    } catch (err) {
      print(err);
      statusCode = 500;
      notify();
    }
  }

  Future<void> saveProducts(BuildContext context, List<Map<String, String>> depots) async {
    for (var product in addCommandeProducts) {
      statusCode = 0;
      try {
        http.Response response = await "/save_commande_products".authPost(context, {
          'path': authProvider.selectedFolder?.DOSBDD,
          "datestr": DateFormat('yyyy-MM-dd').format(datesave),
          "codebon": codeBon,
          "ArtNo": product.product.ARTNO,
          "ARTTYPE": product.product.ARTTYPE,
          "ExeCourant": authProvider.initialExercice!.EXENO,
          "Ordre": addCommandeProducts.indexOf(product) + 1,
          "ArtNom": product.product.ARTNOM,
          "ArtVtePar": product.product.ARTVTEPAR,
          "ArtLong": product.product.ARTLONG,
          "ArtLarg": product.product.ARTLARG,
          "ArtColis": product.product.ARTCOLIS,
          "NbrColis": coliscalcul(product.product.ARTCOLIS, product.product.ARTUNTCOL, product.quantity),
          "ArtUntCol": product.product.ARTUNTCOL,
          "qte": product.quantity,
          "PuTTC": product.product.ARTPRIX,
          "Base": 0.0,
          "Marge": 0.0,
          "CDepot": authProvider.getDepotsDefault(depots),
        });

        statusCode = response.statusCode;
        if (response.statusCode == 200) {
          // Product
        }
        notify();
      } catch (err) {
        print(err);
        statusCode = 500;
        notify();
      }
    }
  }

  // ============================================================
  // Pagination helpers
  // ============================================================

  // Load more commandes (infinite scroll)
  Future<void> loadMoreCommandes(BuildContext context) async {
    print(
        "[commande_entate_view_model.dart] loadMoreCommandes called. isLoadingMore: $_isLoadingMore, hasMore: $_hasMore");
    if (_isLoadingMore || !_hasMore) return;
    try {
      _isLoadingMore = true;
      notify();
      await getCommandes(context, offset: _currentOffset);
    } finally {
      _isLoadingMore = false;
      notify();
    }
  }

  // Search commandes
  Future<void> setSearchCommandes(BuildContext context, String query) async {
    _searchQuery = query;
    _currentOffset = 0;
    _hasMore = true;
    await getCommandes(context, search: query, offset: 0, limit: _pageSize);
  }

  void setPageSize(int size) {
    _pageSize = size.clamp(1, 1000);
    _currentOffset = 0;
    _hasMore = true;
    notify();
  }

  void resetPagination() {
    _currentOffset = 0;
    _searchQuery = '';
    _pageSize = 50;
    _totalRows = 0;
    _hasMore = true;
    _isLoadingMore = false;
    commandes = [];
    filteredCommandes = [];
    _paginationMeta = null;
    notify();
  }
}

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
