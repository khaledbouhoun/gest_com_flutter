import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_stock/models/client.dart';
import 'package:gestion_stock/models/commande_product.dart';
import 'package:gestion_stock/models/facture_entate.dart';
import 'package:gestion_stock/models/journal.dart';
import 'package:gestion_stock/models/paginated_response.dart';
import 'package:gestion_stock/models/pagination_meta.dart';
import 'package:gestion_stock/models/product.dart';
import 'package:gestion_stock/models/site.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:gestion_stock/views/facture_entate/add_facture.dart';
import 'package:gestion_stock/views/facture_entate/factures.dart';
import 'package:gestion_stock/widgets/http_extensions.dart';
import 'package:gestion_stock/widgets/toast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class FactureEntateViewModel extends ChangeNotifier {
  // ============================================================
  // Constructor & notifier
  // ============================================================

  final formKey = GlobalKey<FormState>();

  AuthViewModel authProvider;
  FactureEntateViewModel(this.authProvider);

  void notify() {
    Future.microtask(() => notifyListeners());
  }

  // ============================================================
  // Factures state
  // ============================================================

  List<FactureEntate>? factures = [];
  List<FactureEntate>? filteredFactures = [];

  FactureEntate? _selectedFacture;
  FactureEntate? get selectedFacture => _selectedFacture;

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

  int _pageSize = 50;
  int get pageSize => _pageSize;

  int _totalRows = 0;
  int get totalRows => _totalRows;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  PaginationMeta? _paginationMeta;

  // ============================================================
  // Add facture state
  // ============================================================

  Client? addFactureClient;
  List<CommandeProduct>? addFactureProducts = [];

  double totalFacture = 0;
  double totalFacturePoids = 0;
  double totalFactureColis = 0;

  String? addSelectedTarif;

  // ============================================================
  // Facture selection
  // ============================================================

  void setSelectedFacture(FactureEntate facture) {
    _selectedFacture = facture;
    notify();
  }

  // ============================================================
  // Get & filter factures
  // ============================================================

  // bool isRetourAllowed(int ftetype) {
  //   if (ftetype != 2) return true;

  //   final hasAccess = authProvider.accessList?.any((e) => e.URSTRS == "03" && e.URSRES == "40" && e.URSDRO == "01") ?? false;

  //   switch (authProvider.selectedUser!.USRTYPE) {
  //     case 0:
  //       return hasAccess;
  //     case 1:
  //       return !hasAccess;
  //     default:
  //       return true;
  //   }
  // }

  Future getFactures(
    BuildContext context, {
    int ftetype = 1,
    String? search,
    int? limit,
    int? offset,
  }) async {
    print("[facture_entate_view_model.dart] getFactures search: $search, offset: $offset");
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
      String url = "/facture";

      final reqBody = _buildRequestBody(
        userType: authProvider.selectedUser!.USRTYPE,
        datedu: DateFormat('yyyy-MM-dd').format(startDate!),
        dateau: DateFormat('yyyy-MM-dd').format(endDate!),
        ftetype: ftetype,
        limit: effectiveLimit,
        offset: effectiveOffset,
        search: _searchQuery,
      );
      print("[facture_entate_view_model.dart] getFactures reqBody: $reqBody");

      if (reqBody['statusCode'] == 404) {
        if (effectiveOffset == 0) {
          factures = [];
          filteredFactures = [];
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
          final paginated = PaginatedResponse<FactureEntate>.fromJson(
            data,
            (item) => FactureEntate.fromJson(item),
          );
          if (effectiveOffset == 0) {
            factures = paginated.data;
          } else {
            factures ??= [];
            factures!.addAll(paginated.data);
          }
          _paginationMeta = paginated.meta;
          _hasMore = paginated.meta.hasMore;
          _currentOffset = effectiveOffset + paginated.data.length;
          print("[facture_entate_view_model.dart] Loaded ${paginated.data.length} factures. Total: ${factures?.length}, hasMore: $_hasMore");
        } else {
          // Legacy format fallback
          print("[facture_entate_view_model.dart] Warning: Received legacy response format. Pagination disabled.");
          factures = FactureEntate.listFromJson(data['factures']);
          _hasMore = false;
        }

        filteredFactures = List.from(factures!);
      } else if (response.statusCode == 404) {
        if (effectiveOffset == 0) {
          factures = [];
          filteredFactures = [];
        }
      }

      notify();
    } catch (err) {
      print("[facture_entate_view_model.dart] getFactures error: $err");
      statusCode = 500;
      notify();
    }
  }

  Map<String, dynamic> _buildRequestBody({
    required int userType,
    required String datedu,
    required String dateau,
    required int ftetype,
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
      'ftetype': ftetype,
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

  Future filtreFacture(BuildContext context, String query, {int ftetype = 1}) async {
    _searchQuery = query;
    _currentOffset = 0;
    _hasMore = true;
    await getFactures(context, ftetype: ftetype, search: query, offset: 0, limit: _pageSize);
  }

  // ============================================================
  // Update product price by tarif
  // ============================================================

  Future updateAddedProduct(BuildContext context, Duration timeout, Product product, String tarif) async {
    final completer = Completer<http.Response>();
    final timer = Timer(timeout, () {
      completer.completeError(TimeoutException('The connection has timed out!'));
    });

    try {
      http.Response response =
          await "/update_added_product?artno=${product.ARTNO}&tarif=$tarif".authPost(context, {'path': authProvider.selectedFolder?.DOSBDD});

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
  // ============================================================
  // Save facture state
  // ============================================================

  DateTime datesave = DateTime.now();
  String? codeBon;
  Tipe _selectedT = Tipe(tipe: 'Vente', tipeno: 1);
  Tipe get selectedT => _selectedT;

  TextEditingController edtBCNo = TextEditingController();
  TextEditingController codeselController = TextEditingController();

  List<Tipe> listTipe = [
    Tipe(tipe: 'Vente', tipeno: 1),
    Tipe(tipe: 'Retour', tipeno: 2),
  ];

  List<JournalModel> listJournals = [];
  JournalModel? selectedJournal;

  List<SiteModel> listSites = [];
  SiteModel? selectedSite;
  bool siteerorr = false;

  // ============================================================
  // Helpers
  // ============================================================

  void setSelectedT({Tipe? tipe}) {
    _selectedT = tipe ?? Tipe(tipe: 'Vente', tipeno: 1);
    notifyListeners();
  }

  double coliscalcul(String? code, double? colis, int? qty) {
    double? col = 0;
    if (code != '00' && colis != 0) {
      col = qty! / colis!;
    }
    return col;
  }

  Future<void> scanProduct(BuildContext context, String code) async {
    await Provider.of<StockViewModel>(context, listen: false).getStock(context, authProvider.selectedExercice, search: code, offset: 0);

    if (Provider.of<StockViewModel>(context, listen: false).products.isEmpty) {
      Toast(title: 'Aucun article trouvé', style: ToastificationStyle.minimal, type: ToastificationType.warning, context: context);
      return;
    }
    Product product = Provider.of<StockViewModel>(context, listen: false).products.first;

    if (!addFactureProducts!.any((element) => element.product.ARTNO == product.ARTNO)) {
      if (product.ARTQTETHEOR! <= 0) {
        if (authProvider.sellSettings!.PRMAUTSTKNEGAB == 0) {
          Toast(title: 'Quantité insuffisante', style: ToastificationStyle.minimal, type: ToastificationType.warning, context: context);
        } else {
          addFactureProducts!.add(CommandeProduct(product: product, quantity: 1, tarif: addSelectedTarif, negative: true));
          notifyListeners();
          Navigator.push(context, MaterialPageRoute(builder: (builder) => const AddFacture()));
        }
      } else {
        addFactureProducts!.add(CommandeProduct(product: product, quantity: 1, tarif: addSelectedTarif));
        notifyListeners();
        Navigator.push(context, MaterialPageRoute(builder: (builder) => const AddFacture()));
      }
    } else {
      int index = addFactureProducts!.indexWhere((element) => element.product.ARTNO == product.ARTNO);
      addFactureProducts![index].quantity += 1;
      notifyListeners();
      Navigator.push(context, MaterialPageRoute(builder: (builder) => const AddFacture()));
    }
  }

  // ============================================================
  // Dates
  // ============================================================

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

    notify();
  }

  Future<void> defalutDate() async {
    if (authProvider.initialExercice!.EXENO == DateTime.now().year) {
      datesave = DateTime.now();
    } else {
      datesave = DateTime(authProvider.initialExercice!.EXENO!, 12, 31);
    }
    notify();
  }

  // ============================================================
  // Journals & sites
  // ============================================================

  Future getJournals(BuildContext context) async {
    try {
      statusCode = 0;

      String? Journaeudefault = authProvider.rubriques.where((r) => r.USBTRS == '03' && r.USBTRB == '03' && r.USBDEFAULT == 1).firstOrNull?.USBRUB ??
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

      http.Response response =
          await "/get_journals".authPost(context, {'path': authProvider.selectedFolder?.DOSBDD, "journaux": query, "JouType": 5});
      statusCode = response.statusCode;

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        listJournals = JournalModel.listFromJson(data['journal']);
        selectedJournal =
            authProvider.selectedUser!.USRTYPE == 0 ? listJournals.firstWhere((element) => element.jouNo == Journaeudefault) : listJournals.first;
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
        "clscli": addFactureClient?.CLINO,
        "clinom": addFactureClient?.CLINOM,
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
  // ============================================================
  // Code bon
  // ============================================================

  Future getcodebon(BuildContext context) async {
    String parms = 'Tipe=${selectedT.tipeno}'
        '&Date=${DateFormat('yyyy-MM-dd').format(datesave)}'
        '&PrmCodificationBon=${authProvider.sellSettings!.PRMCODIFICATIONBON.toInt()}'
        '&ExeCourant=${authProvider.initialExercice!.EXENO}';

    try {
      statusCode = 0;

      http.Response response = await "/get_code_bon?$parms".authPost(context, {'path': authProvider.selectedFolder?.DOSBDD});

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

  // ============================================================
  // Reset
  // ============================================================

  void resetAddFacture() {
    addFactureClient = null;
    addFactureProducts = [];
    totalFacture = 0;
    totalFacturePoids = 0;
    totalFactureColis = 0;
    notify();
  }

  // ============================================================
  // Save facture
  // ============================================================

  Future saveFacture(BuildContext context) async {
    await getcodebon(context);

    if (addFactureClient == null || authProvider.selectedUser == null || authProvider.sellSettings == null || authProvider.initialExercice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs obligatoires.')),
      );
      return;
    }

    try {
      List<Map<String, String>> depots = await authProvider.getDepots(context);
      await saveProducts(context);

      String parms2 = '&codebon=$codeBon'
          '&edtBCNo=${edtBCNo.text}'
          '&codesel=${codeselController.text}'
          '&journal=${selectedJournal!.jouNo}'
          '&clino=${addFactureClient!.CLINO}'
          '&Site=${(selectedSite == null || selectedSite!.cLSNO == "00") ? "" : selectedSite!.cLSNO}'
          '&TotTTC=$totalFacture'
          '&TotPoids=$totalFacturePoids'
          '&TotColis=$totalFactureColis'
          '&Usr_Login=${authProvider.selectedUser!.USRLOGIN}';

      String parms = 'Tipe=${selectedT.tipeno}'
          '&Date=${DateFormat('yyyy-MM-dd').format(datesave)}'
          '&PrmCodificationBon=${authProvider.sellSettings!.PRMCODIFICATIONBON.toInt()}'
          '&ExeCourant=${authProvider.initialExercice!.EXENO}'
          '$parms2'
          '&PrmDepotDefautTourneeAB=${authProvider.sellSettings!.PRMDEPOTDEFAUTAB}'
          '&PrmConsomMatPrem2=${authProvider.sellSettings!.PRMCONSOMMATPREM2.toInt()}'
          '&PrmCalculPrixTTC=${authProvider.sellSettings!.PRMCALCULPRIXTTC.toInt()}'
          '&PrmDepotDefautAB=${authProvider.getDepotsDefault(depots)}'
          '&catgClr=${authProvider.catgClr ?? "00"}';

      http.Response response = await "/Save_Facture?$parms".authPost(context, {'path': authProvider.selectedFolder?.DOSBDD});

      statusCode = response.statusCode;

      if (response.statusCode == 200) {
        codeselController.clear();
        edtBCNo.clear();

        addFactureProducts?.clear();
        totalFacture = 0;
        totalFacturePoids = 0;
        totalFactureColis = 0;

        addFactureClient = null;
        codeBon = null;
        datesave = DateTime.now();

        selectedSite = null;
        listJournals = [];
        listSites = [];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Factures()),
        );

        notify();
      }
    } catch (err) {
      print(err);
      statusCode = 500;
      notify();
    }
  }

  // ============================================================
  // Save products
  // ============================================================

  Future<void> saveProducts(BuildContext context) async {
    for (var product in addFactureProducts!) {
      try {
        http.Response response = await "/save_facture_products".authPost(context, {
          'path': authProvider.selectedFolder?.DOSBDD,
          "datestr": DateFormat('yyyy-MM-dd').format(datesave),
          "codebon": codeBon,
          "ArtNo": product.product.ARTNO,
          "Ordre": addFactureProducts!.indexOf(product) + 1,
          "ArtNom": product.product.ARTNOM,
          "ArtVtePar": product.product.ARTVTEPAR,
          "ArtLong": product.product.ARTLONG,
          "ArtLarg": product.product.ARTLARG,
          "ArtColis": product.product.ARTCOLIS,
          "NbrColis": coliscalcul(
            product.product.ARTCOLIS,
            product.product.ARTUNTCOL,
            product.quantity,
          ),
          "ArtUntCol": product.product.ARTUNTCOL,
          "qte": product.quantity,
          "PuTTC": product.product.ARTPRIX,
          "Base": 0.0,
          "Marge": 0.0,
          "CoutU": 0.0,
          "CDepot": authProvider.getDepotsWrite() ?? authProvider.sellSettings!.PRMDEPOTDEFAUTAB,
        });

        statusCode = response.statusCode;
        notify();
      } catch (err) {
        statusCode = 500;
        notify();
      }
    }
  }

  // ============================================================
  // Pagination helpers
  // ============================================================

  Future<void> loadMoreFactures(BuildContext context, {int ftetype = 1}) async {
    print("[facture_entate_view_model.dart] loadMoreFactures called. isLoadingMore: $_isLoadingMore, hasMore: $_hasMore");
    if (_isLoadingMore || !_hasMore) return;
    try {
      _isLoadingMore = true;
      notify();
      await getFactures(context, ftetype: ftetype, offset: _currentOffset);
    } finally {
      _isLoadingMore = false;
      notify();
    }
  }

  Future<void> setSearch(BuildContext context, String query, {int ftetype = 1}) async {
    _searchQuery = query;
    _currentOffset = 0;
    _hasMore = true;
    await getFactures(context, ftetype: ftetype, search: query, offset: 0, limit: _pageSize);
  }

  void setPageSize(int size) {
    _pageSize = size.clamp(1, 1000);
    _currentOffset = 0;
    _hasMore = true;
    notify();
  }

  void resetPagination() {
    _searchQuery = '';
    _currentOffset = 0;
    _searchQuery = '';
    _pageSize = 50;
    _totalRows = 0;
    _hasMore = true;
    _isLoadingMore = false;
    _paginationMeta = null;
    factures = [];
    filteredFactures = [];
    notify();
  }
}

// ============================================================
// Models
// ============================================================

class Tipe {
  String tipe;
  int tipeno;

  Tipe({required this.tipe, required this.tipeno});

  @override
  bool operator ==(Object other) => identical(this, other) || other is Tipe && runtimeType == other.runtimeType && tipeno == other.tipeno;

  @override
  int get hashCode => tipeno.hashCode;
}
