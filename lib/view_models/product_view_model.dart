import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_stock/models/brand.dart';
import 'package:gestion_stock/models/family.dart';
import 'package:gestion_stock/models/package.dart';
import 'package:gestion_stock/models/subfamily.dart';
import 'package:gestion_stock/models/tarif_detail.dart';
import 'package:gestion_stock/models/tva.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:gestion_stock/widgets/http_extensions.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/unit.dart';
import 'auth_view_model.dart';

class ProductViewModel extends ChangeNotifier {
  StockViewModel stockProvider;
  AuthViewModel authProvider;
  ProductViewModel(this.stockProvider, this.authProvider);

  List<Map<double, String>> operationBy = [
    {0.0: 'Unité'},
    {1.0: 'Périmètre (ML)'},
    {2.0: 'Surface (M\u00b2)'},
  ];

  List<Map<double, String>> type = [
    {0.0: 'Stockable'},
    {1.0: 'Service'},
  ];

  List<Map<int, String>> bases = [
    {0: 'P.M.P'},
    {1: 'D.P.A'},
    {2: 'P.A.P'},
  ];

  Product? selectedProduct;
  Product? modifiedProduct;

  Family? selectedFamily;
  List<Family>? families;

  SubFamily? selectedSubFamily;
  List<SubFamily>? subfamilies;

  Brand? selectedBrand;
  List<Brand>? brands;

  Package? selectedPackage;
  List<Package>? packages;

  Unit? selectedUnit;
  List<Unit>? units;

  Tva? selectedTva;
  List<Tva>? tvas;

  int statusCode = 0;

  int modifyStatusCode = 0;
  bool modifyButtonVisible = true;

  int getProductTarifsStatusCode = 0;
  List<TarifDetail> selectedProductTarifs = [];

  void notify() {
    Future.microtask(() => notifyListeners());
  }

  Future getProductDetails(BuildContext context) async {
    try {
      statusCode = 0;
      notify();

      http.Response response =
          await "/get_product_details".authPost(context, {'path': authProvider.selectedFolder?.DOSBDD});

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);

        families = Family.listFromJson(data['families']);
        selectedFamily = families!.isNotEmpty ? families!.first : null;

        subfamilies = SubFamily.listFromJson(data['subfamilies']);
        if (selectedFamily != null && subfamilies != null) {
          selectedSubFamily = subfamilies!
              .firstWhere((element) => element.SOUFAM == selectedFamily!.FAMNO, orElse: () => subfamilies!.first);
        }

        brands = Brand.listFromJson(data['brands']);
        selectedBrand = brands!.isNotEmpty ? brands!.first : null;

        packages = Package.listFromJson(data['packages']);
        selectedPackage = packages!.isNotEmpty ? packages!.first : null;

        units = Unit.listFromJson(data['units']);
        selectedUnit = units!.isNotEmpty ? units!.first : null;

        tvas = Tva.listFromJson(data['tvas']);
        selectedTva = tvas!.isNotEmpty ? tvas!.first : null;

        statusCode = 200;
      } else if (response.statusCode == 404) {
        statusCode = 404;
      } else {
        statusCode = response.statusCode;
      }
      notify();
    } catch (err) {
      statusCode = 500;
      notify();
    }
  }

  Future getProductTarifs(BuildContext context, String artno) async {
    try {
      getProductTarifsStatusCode = 0;
      selectedProductTarifs = [];
      notify();
      final vteTarifsAuth = authProvider.vteTarifs.where((e) => e.write == true);
      final tar = vteTarifsAuth.map((e) => "'${e.rubrique}'").join(',');

      if (vteTarifsAuth.isEmpty && authProvider.selectedUser!.USRTYPE == 0) {
        return;
      }

      String query = "";
      switch (authProvider.selectedUser!.USRTYPE) {
        case 0:
          query = " AND TFDTFE IN ($tar) ";
          break;
        case 1:
          query = vteTarifsAuth.isNotEmpty ? " AND TFDTFE NOT IN ($tar) " : " ";
          break;
        default:
          query = "  ";
          break;
      }

      http.Response response = await "/get_product_tarifs?artno=$artno".authPost(context, {
        'path': authProvider.selectedFolder?.DOSBDD,
        "tarifs": query,
      });
      var data = jsonDecode(response.body);
      getProductTarifsStatusCode = response.statusCode;
      if (getProductTarifsStatusCode == 200) {
        selectedProductTarifs = TarifDetail.listFromJson(data['tarifs'], context);
      } else if (response.statusCode == 404) {
        getProductTarifsStatusCode = 404;
        selectedProductTarifs = [];
      }
      notify();
    } catch (err) {
      debugPrint(err.toString());
      getProductTarifsStatusCode = 500;
      notify();
    }
  }

  Future modifyProduct(BuildContext context) async {
    try {
      modifyStatusCode = 0;
      modifyButtonVisible = !modifyButtonVisible;
      notify();
      Map<String, dynamic> body = {
        'path': authProvider.selectedFolder?.DOSBDD,
        "artno": modifiedProduct!.ARTNO,
        "artcab": modifiedProduct!.ARTCAB,
        "artnom": modifiedProduct!.ARTNOM,
        "artnomsup": modifiedProduct!.ARTNOMSUP, //
        "artref": modifiedProduct!.ARTREF,
        "artfam": modifiedProduct!.ARTFAM,
        "artsfam": modifiedProduct!.ARTSFAM,
        "artuni": modifiedProduct!.ARTUNI,
        "artcolis": modifiedProduct!.ARTCOLIS,
        "artmarque": modifiedProduct!.ARTMARQUE, //
        "artqtemin": modifiedProduct!.ARTQTEMIN,
        "artqtemax": modifiedProduct!.ARTQTEMAX,
        "artalerte": modifiedProduct!.ARTALERTE,
        "artlong": modifiedProduct!.ARTLONG,
        "artlarg": modifiedProduct!.ARTLARG,
        "artpoids": modifiedProduct!.ARTPOIDS,
        "artvolume": modifiedProduct!.ARTVOLUME,
        "artuntcol": modifiedProduct!.ARTUNTCOL,
        "artqteinitab": modifiedProduct!.ARTQTEINITAB,
        "arttva": modifiedProduct!.ARTTVA,
        "artachpar": modifiedProduct!.ARTACHPAR,
        "artvtepar": modifiedProduct!.ARTVTEPAR,
        "arttype": modifiedProduct!.ARTTYPE,
        "artcasier": modifiedProduct!.ARTCASIER,
        "artpap": modifiedProduct!.ARTPAP,
        "tarifs": selectedProductTarifs
      };

      http.Response response = await "/modify_product".authPost(context, body);

      modifyStatusCode = response.statusCode;
      modifyButtonVisible = !modifyButtonVisible;
      notify();
    } catch (e) {
      print(e);
      modifyStatusCode = 500;
      modifyButtonVisible = !modifyButtonVisible;
      notify();
    }
  }
}
