import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_stock/models/pays.dart';
import 'package:gestion_stock/models/region.dart';
import 'package:gestion_stock/models/territoire.dart';
import 'package:gestion_stock/models/ville.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:http/http.dart' as http;

class LocationViewModel extends ChangeNotifier {
  AuthViewModel authProvider;
  LocationViewModel(this.authProvider);

  List<Pays>? filtredPays;
  List<Territoire>? filtredTerritoires;
  List<Ville>? filtredVilles;
  List<Region> regions = [
    Region(REGNO: '01', REGNOM: 'Centre'),
    Region(REGNO: '02', REGNOM: 'Est'),
    Region(REGNO: '03', REGNOM: 'Ouest'),
    Region(REGNO: '04', REGNOM: 'Sud'),
  ];
  int statusCode = 0;

  void notify() {
    Future.microtask(() => notifyListeners());
  }

  //get list of pays
  Future getPays() async {
    try {
      statusCode = 0;
      notify();
      http.Response response = await http.post(
          Uri.parse(
              '${authProvider.baseUrl}/pays'),
          body: jsonEncode({'path': authProvider.selectedFolder?.DOSBDD}));
      statusCode = response.statusCode;

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        filtredPays = Pays.paysFromJson(data['pays'] ?? data);
      } else if (response.statusCode == 404) {
        filtredPays = [];
      }
      notify();
    } catch (err) {
      statusCode = 500;
      notify();
    }
  }

  //get list of territoires
  Future getTerritoires() async {
    try {
      statusCode = 0;
      notify();
      http.Response response = await http.post(
          Uri.parse(
              '${authProvider.baseUrl}/territoires'),
          body: jsonEncode({'path': authProvider.selectedFolder?.DOSBDD}));
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        filtredTerritoires =
            Territoire.territoiresFromJson(data['territoires'] ?? data);
      } else if (response.statusCode == 404) {
        filtredTerritoires = [];
      }
      notify();
    } catch (err) {
      statusCode = 500;
      notify();
    }
  }

  //get list of villes
  Future getVilles() async {
    try {
      statusCode = 0;
      notify();
      http.Response response = await http.post(
          Uri.parse(
              '${authProvider.baseUrl}/villes'),
          body: jsonEncode({'path': authProvider.selectedFolder?.DOSBDD}));
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        filtredVilles = Ville.villesFromJson(data['villes'] ?? data);
      } else if (response.statusCode == 404) {
        filtredVilles = [];
      }
      notify();
    } catch (err) {
      statusCode = 500;
      notify();
    }
  }

  //get list of regions
  Future getRegions() async {
    // Regions are static for now, or fetch if needed
    notify();
  }
}
