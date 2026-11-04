import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_stock/models/exercice.dart';
import 'package:gestion_stock/models/paginated_response.dart';
import 'package:gestion_stock/models/product.dart';
import 'package:gestion_stock/models/tarif_detail.dart';
import 'package:gestion_stock/models/tarif_entate.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/widgets/http_extensions.dart';
import 'package:http/http.dart' as http;

class StockViewModel extends ChangeNotifier {
  AuthViewModel authProvider;

  StockViewModel(this.authProvider) {
    selectedExerciceStock = authProvider.initialExercice;
  }

  Exercice? selectedExerciceStock;

  List<Product> products = [];
  List<Product> filteredProducts = [];
  int? statusCode;

  List<StatisticProductModel> statisticProducts = [];
  StatisticProductModel? selectedStatisticProduct;

  int? addStatusCode = 0;
  Product? newProduct = Product();
  bool addButtonVisible = true;

  int tarifStatusCode = 0;
  TarifEntate? defaultTarif;
  List<TarifEntate>? tarifs;

  List<TarifDetail> addedProductPrices = [];

  // ============================================================
  // Pagination & search state
  // ============================================================

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  int _currentOffset = 0;
  int get currentOffset => _currentOffset;

  int _pageSize = 50;
  int get pageSize => _pageSize;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  Future getTarifs(BuildContext context) async {
    try {
      tarifStatusCode = 0;
      notify();
      print('>> Fetching tarifs...');

      http.Response response = await "/get_tarifs".authPost(context, {'path': authProvider.selectedFolder?.DOSBDD});

      print('<< Tarifs status: ${response.statusCode}');

      tarifStatusCode = response.statusCode;
      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        defaultTarif = TarifEntate.fromJson(data['defaultTarif'][0]);
        tarifs = TarifEntate.listFromJson(data['tarifs']);
        tarifStatusCode = 200;
        print('================= successful ====================== >> get_tarifs');
      } else if (response.statusCode == 404) {
        tarifStatusCode = 404;
        tarifs = [];
        defaultTarif = null;
      }

      notify();
    } catch (err) {
      print('!! Tarifs exception: $err');
      tarifStatusCode = 500;
      notify();
    }
  }

  Future<void> getStock(
    BuildContext context,
    Exercice? selectedExercice, {
    String? search,
    int? limit,
    int? offset,
    bool vente = false,
  }) async {
    print("[stock_view_model.dart] getStock search: $search, offset: $offset");

    try {
      if (offset == 0 || offset == null) {
        statusCode = 0;
        notify();
      }

      // Validation
      if (selectedExercice == null || authProvider.selectedUser == null) {
        statusCode = 404;
        _clearProducts();
        notify();
        return;
      }

      // Update search state
      if (search != null) {
        _searchQuery = search;
      }

      final effectiveLimit = limit ?? _pageSize;
      final effectiveOffset = offset ?? _currentOffset;

      String url = "/getstock";

      var body = _buildRequestBody(authProvider.selectedUser!.USRTYPE, vente);

      if (body['statusCode'] == 404) {
        if (effectiveOffset == 0) {
          _clearProducts();
          statusCode = 404;
        } else {
          _hasMore = false;
        }
        notify();
        return;
      }

      final response = await url.authPost(
        context,
        body
          ..addAll({
            'path': authProvider.selectedFolder?.DOSBDD,
            'exercice': selectedExercice.EXENO,
            'limit': effectiveLimit,
            'offset': effectiveOffset,
            'search': _searchQuery,
            'prmtarifdefautab': vente ? " where TE.tfeno = ${authProvider.sellSettings?.PRMTARIFDEFAUTAB ?? '01'} " : '',
          }),
      );

      statusCode = response.statusCode;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Support paginated + legacy formats
        if (data.containsKey('data')) {
          final paginated = PaginatedResponse<Product>.fromJson(
            data,
            (item) => Product.fromJson(item),
          );

          if (effectiveOffset == 0) {
            products = paginated.data;
          } else {
            products.addAll(paginated.data);
          }

          _currentOffset = effectiveOffset + paginated.data.length;
          _hasMore = paginated.meta.hasMore;

          print(
            "[stock_view_model.dart] Loaded ${paginated.data.length} products. "
            "Total: ${products.length}, hasMore: $_hasMore",
          );
        } else {
          // Legacy fallback
          print(
            "[stock_view_model.dart] Warning: Received legacy response format. "
            "Pagination disabled.",
          );

          final parsed = Product.listFromJson(data['products']);

          if (effectiveOffset == 0) {
            products = parsed;
          } else {
            products.addAll(parsed);
          }

          _currentOffset = effectiveOffset + parsed.length;
          _hasMore = false;
        }

        filteredProducts = List.from(products);
      } else if (response.statusCode == 404 || response.statusCode == 401) {
        if (effectiveOffset == 0) {
          _clearProducts();
        }
      }
    } catch (e) {
      print('[stock_view_model.dart] getStock error: $e');

      statusCode = 500;
      _clearProducts();
    } finally {
      notify();
    }
  }

  void _clearProducts() {
    products = [];
    filteredProducts = [];
  }

  //get all products
  Map<String, dynamic> _buildRequestBody(int userType, bool isVente) {
    String sqlDepots = " SUM(ArtQte) AS QTE FROM Stk_Articles_Exe_AB WHERE ";

    final famills = authProvider.stkFamills.where((e) => isVente ? (e.write == true) : (e.read == true)).map((e) => e.rubrique).toList();
    final depots = authProvider.stkDepots.where((e) => isVente ? (e.write == true) : (e.read == true)).map((e) => e.rubrique).toList();
    final tarifs = authProvider.getTarifPerDefault();

    if (userType == 0 && (famills.isEmpty)) {
      return {
        'statusCode': 404,
      };
    } else if (userType == 0 && depots.isEmpty) {
      sqlDepots = " 0.0 AS QTE FROM Stk_Articles_Exe_AB WHERE ";
    }

    String buildIn(List<String> values) => values.map((e) => "'$e'").join(', ');

    String famillsSql;
    String depotsSql;

    switch (userType) {
      case 0:
        famillsSql = famills.isEmpty ? '' : " AND A.ArtFam IN (${buildIn(famills)})";

        depotsSql = depots.isEmpty ? '' : "   ArtDepot IN (${buildIn(depots)})";
        break;

      case 1:
        famillsSql = famills.isEmpty ? " AND 1=1 " : " AND A.ArtFam NOT IN (${buildIn(famills)}) ";

        depotsSql = depots.isEmpty ? "  1=1 " : "  ArtDepot NOT IN (${buildIn(depots)}) ";
        break;

      case 2:
      default:
        famillsSql = " AND 1=1 ";
        depotsSql = "  1=1 ";
        break;
    }

    return {
      'TarifDefaut': authProvider.selectedUser?.USRTYPE == 0 ? "ON TE.TfeNo = $tarifs" : "ON TE.TfeNo = p.PrmTarifDefautAB",
      'families': famillsSql,
      'depots': sqlDepots + depotsSql,
    };
  }

  //filter products
  Future filtreStock(BuildContext context, Exercice? selectedExercice, String query, {bool vente = false}) async {
    _searchQuery = query;
    _currentOffset = 0;
    _hasMore = true;
    await getStock(context, selectedExercice, search: query, offset: 0, limit: _pageSize, vente: vente);
  }

  Future addNewProduct(BuildContext context) async {
    try {
      addStatusCode = 0;
      addButtonVisible = !addButtonVisible;
      Map<String, dynamic> body = {
        'path': authProvider.selectedFolder?.DOSBDD,
        "artcab": newProduct!.ARTCAB,
        "artnom": newProduct!.ARTNOM,
        "artnomsup": newProduct!.ARTNOMSUP,
        "artref": newProduct!.ARTREF,
        "artfam": newProduct!.ARTFAM,
        "artsfam": newProduct!.ARTSFAM,
        "artuni": newProduct!.ARTUNI,
        "artcolis": newProduct!.ARTCOLIS,
        "artmarque": newProduct!.ARTMARQUE,
        "artqtemin": newProduct!.ARTQTEMIN,
        "artqteinitab": newProduct!.ARTQTEINITAB,
        "artqtemax": newProduct!.ARTQTEMAX,
        "artalerte": newProduct!.ARTALERTE,
        "artlong": newProduct!.ARTLONG,
        "artlarg": newProduct!.ARTLARG,
        "artpoids": newProduct!.ARTPOIDS,
        "artvolume": newProduct!.ARTVOLUME,
        "artuntcol": newProduct!.ARTUNTCOL,
        "arttva": newProduct!.ARTTVA ?? "01",
        "artachpar": newProduct!.ARTACHPAR,
        "artvtepar": newProduct!.ARTVTEPAR,
        "arttype": newProduct!.ARTTYPE,
        "artcasier": newProduct!.ARTCASIER,
        "artpap": newProduct!.ARTPAP ?? 0,
        "artexe": authProvider.initialExercice!.EXENO.toString(),
        "ExeCourant": authProvider.initialExercice!.EXENO!.toInt().toString(),
        "prices": addedProductPrices.map((e) => e.toJson()).toList(),
      };

      http.Response response = await "/add_product".authPost(context, body);
      addStatusCode = response.statusCode;
      addButtonVisible = !addButtonVisible;
      notify();
    } catch (e) {
      print(e);
      addStatusCode = 500;
      addButtonVisible = !addButtonVisible;
      notify();
    }
  }

  Future getStatisticProducts(BuildContext context, {bool forceGet = false}) async {
    try {
      if (!forceGet && statisticProducts.isNotEmpty) return;

      statisticProducts = [];
      selectedStatisticProduct = null;
      statusCode = 0;

      final response = await "/statistic_products".authPost(
        context,
        {'path': authProvider.selectedFolder?.DOSBDD},
      );

      statusCode = response.statusCode;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        statisticProducts = StatisticProductModel.listFromJson(
          data['products'],
        );

        if (statisticProducts.isNotEmpty) {
          selectedStatisticProduct = statisticProducts.first;
        }
      } else if (response.statusCode == 404) {
        statisticProducts = [];
        selectedStatisticProduct = null;
      }

      notify();
    } catch (err, stackTrace) {
      print('stk $err');
      print(stackTrace);

      statusCode = 500;
      notify();
    }
  }

  void notify() {
    Future.microtask(() => notifyListeners());
  }

  Future<void> loadMoreStock(BuildContext context, Exercice? selectedExercice, {bool vente = false}) async {
    print("[stock_view_model.dart] loadMoreStock called. isLoadingMore: $_isLoadingMore, hasMore: $_hasMore");
    if (_isLoadingMore || !_hasMore || selectedExercice == null) return;
    try {
      _isLoadingMore = true;
      notify();
      await getStock(context, selectedExercice, offset: _currentOffset, vente: vente);
    } finally {
      _isLoadingMore = false;
      notify();
    }
  }

  void resetPagination() {
    _currentOffset = 0;
    _searchQuery = '';
    _pageSize = 50;
    _hasMore = true;
    _isLoadingMore = false;
    products = [];
    filteredProducts = [];
    notify();
  }

  //filter tarifs with user vte write permissions
  List<TarifEntate> filterTarifs() {
    if (authProvider.selectedUser!.USRTYPE == 0) {
      return tarifs!.where((element) => authProvider.vteTarifs.where((e) => e.write == true).map((e) => e.rubrique).contains(element.TFENO)).toList();
    } else if (authProvider.selectedUser!.USRTYPE == 1) {
      return tarifs!
          .where((element) => !authProvider.vteTarifs.where((e) => e.write == true).map((e) => e.rubrique).contains(element.TFENO))
          .toList();
    } else {
      return tarifs!;
    }
  }
}

class StatisticProductModel {
  String? ARTNO;
  String? ARTNOM;

  StatisticProductModel({this.ARTNO, this.ARTNOM});

  factory StatisticProductModel.fromJson(Map<String, dynamic> json) {
    return StatisticProductModel(
      ARTNO: json['ARTNO']?.toString(),
      ARTNOM: json['ARTNOM']?.toString(),
    );
  }

  static List<StatisticProductModel> listFromJson(dynamic jsonList) {
    if (jsonList is! List) return [];

    return jsonList.whereType<Map<String, dynamic>>().map(StatisticProductModel.fromJson).toList();
  }
}
