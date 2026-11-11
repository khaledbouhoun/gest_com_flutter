import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_stock/models/facture_entate.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/facture_detail.dart';
import 'auth_view_model.dart';

class FactureDetailViewModel extends ChangeNotifier {
  AuthViewModel authProvider;
  FactureDetailViewModel(this.authProvider);
  void notify() {
    Future.microtask(() => notifyListeners());
  }


  int statusCode = 0;
  FactureEntate? selectedFacture;
  List<FactureDetail>? products;
  Future getFactureProducts() async {
  
    try {
      statusCode = 0;
    
      http.Response response = await http.post(
          Uri.parse(
              '${authProvider.baseUrl}/selected_facture?date=${DateFormat('yyyy-MM-dd').format(selectedFacture!.FTEDATE)}&code=${selectedFacture!.FTENO}'),
          body: jsonEncode({'path': authProvider.selectedFolder?.DOSBDD}));
      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        products = FactureDetail.listFromJson(data['products']);
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
