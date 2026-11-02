import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_stock/models/reception_entate.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:http/http.dart' as http;
import 'package:gestion_stock/widgets/http_extensions.dart';
import 'package:intl/intl.dart';
import '../models/reception_detail.dart';

class ReceptionDetailViewModel extends ChangeNotifier {
  AuthViewModel authProvider;
  ReceptionDetailViewModel(this.authProvider);
  void notify() {
    Future.microtask(() => notifyListeners());
  }


  int statusCode = 0;
  ReceptionEntate? selectedReception;
  List<ReceptionDetail>? products;

  Future getReceptionProducts(BuildContext context) async {
    try {
      statusCode = 0;
      if (selectedReception == null || selectedReception!.FTEDATE == null) {
        statusCode = 400;
        notify();
        return;
      }


      http.Response response =
          await "/selected_reception?date=${DateFormat('yyyy-MM-dd').format(selectedReception!.FTEDATE!)}&code=${selectedReception!.FTENO}"
              .authPost(context, {'path': authProvider.selectedFolder?.DOSBDD});
      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        products = (data['products'] as List)
            .map((item) => ReceptionDetail.fromJson(item))
            .toList();

        statusCode = 200;
      } else {
        statusCode = response.statusCode;
      }
      notify();
    } catch (err) {
      statusCode = 500;
      notify();
    }
  }
}
