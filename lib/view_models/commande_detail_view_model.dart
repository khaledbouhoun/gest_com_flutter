import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_stock/models/commande_entate.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/commande_detail.dart';
import 'auth_view_model.dart';

class CommandeDetailViewModel extends ChangeNotifier {
  AuthViewModel authProvider;
  CommandeDetailViewModel(this.authProvider);
  void notify() {
    Future.microtask(() => notifyListeners());
  }


  int statusCode = 0;
  CommandeEntate? selectedCommande;
  List<CommandeDetail>? products;

  Future getCommandeProducts() async {
    if (selectedCommande == null) {
      return;
    }
    try {
      statusCode = 0;
      http.Response response = await http.post(
        Uri.parse(
            '${authProvider.baseUrl}/selected_commande?date=${DateFormat('yyyy-MM-dd').format(selectedCommande!.cDEDATE!)}&code=${selectedCommande!.cDENO}'),
        body: jsonEncode({'path': authProvider.selectedFolder?.DOSBDD}),
      );
      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        products = CommandeDetail.listFromJson(data['products']);
        statusCode = 200;
      } else {
        statusCode = response.statusCode;
      }
      notify();
    } catch (err) {
      print(err);
      statusCode = 500;
      notify();
    }
  }
}
