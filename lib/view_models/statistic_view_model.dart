import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_stock/models/exercice.dart';
import 'package:gestion_stock/models/statistic.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:gestion_stock/widgets/http_extensions.dart';
import 'package:http/http.dart' as http;

class StatisticViewModel extends ChangeNotifier {
  AuthViewModel authViewModel;
  StatisticViewModel(this.authViewModel);

  int? statusCode;
  List<Statistic>? comparedTurnovers;

  int? compareByMonthStatusCode;
  List<Map>? monthlyComparedTurnover;

  int? turnoverByMonthStatusCode;
  List<Statistic>? monthlyTurnover;

  int? turnoverByProductStatusCode;
  List<Statistic>? monthlyTurnoverByProduct;

  void notify() {
    Future.microtask(() => notifyListeners());
  }

  Future<void> compare(BuildContext context) async {
    try {
      statusCode = 0;
      notify();

      http.Response response = await "/compare".authPost(
          context, {'path': authViewModel.selectedFolder!.DOSBDD, 'exercice': authViewModel.initialExercice!.EXENO});
      statusCode = response.statusCode;

      if (statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        comparedTurnovers = Statistic.listFromJson(data['data']);
        comparedTurnovers!.sort((a, b) => a.X.compareTo(b.X));
      }
    } catch (err) {
      print('compare error: $err');
      statusCode = 500;
    } finally {
      notify();
    }
  }

  Future<void> compareByMonth(BuildContext context) async {
    try {
      compareByMonthStatusCode = 0;
      notify();

      http.Response response =
          await "/compare_by_month".authPost(context, {'path': authViewModel.selectedFolder!.DOSBDD});
      compareByMonthStatusCode = response.statusCode;

      if (compareByMonthStatusCode == 200) {
        dynamic data = jsonDecode(response.body);
        List statisticsData = data['data'];
        monthlyComparedTurnover = [];
        for (var element in statisticsData) {
          monthlyComparedTurnover?.add({'year': element['year'], 'months': Statistic.listFromJson(element['months'])});
        }
      }
    } catch (err) {
      print('compareByMonth error: $err');
      compareByMonthStatusCode = 500;
    } finally {
      notify();
    }
  }

  Future<void> turnoverByMonth(BuildContext context, Exercice exercice) async {
    try {
      turnoverByMonthStatusCode = 0;
      notify();

      http.Response response = await "/turnover_by_month?year=${exercice.EXENO}"
          .authPost(context, {'path': authViewModel.selectedFolder!.DOSBDD});
      turnoverByMonthStatusCode = response.statusCode;

      if (turnoverByMonthStatusCode == 200) {
        dynamic data = jsonDecode(response.body);
        print('turnoverByMonth data: $data');
        monthlyTurnover = Statistic.listFromJson(data['data']);
      }
    } catch (err) {
      print('turnoverByMonth error: $err');
      turnoverByMonthStatusCode = 500;
    } finally {
      notify();
    }
  }

  Future<void> getTurnoverByProduct(BuildContext context, Exercice exercice, StatisticProductModel product) async {
    try {
      turnoverByProductStatusCode = 0;
      notify();

      http.Response response = await "/turnover_by_product?year=${exercice.EXENO}&product=${product.ARTNO}"
          .authPost(context, {'path': authViewModel.selectedFolder!.DOSBDD});
      turnoverByProductStatusCode = response.statusCode;

      if (turnoverByProductStatusCode == 200) {
        dynamic data = jsonDecode(response.body);
        monthlyTurnoverByProduct = Statistic.listFromJson(data['data']);
      }
    } catch (err) {
      print('getTurnoverByProduct error: $err');
      turnoverByProductStatusCode = 500;
    } finally {
      notify();
    }
  }
}
