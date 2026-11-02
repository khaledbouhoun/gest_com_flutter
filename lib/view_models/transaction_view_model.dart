import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_stock/models/comptes.dart';
import 'package:gestion_stock/models/transaction.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/widgets/http_extensions.dart';
import 'package:http/http.dart' as http;

class TransactionViewModel extends ChangeNotifier {
  AuthViewModel authProvider;
  TransactionViewModel(this.authProvider);
  void notify() {
    Future.microtask(() => notifyListeners());
  }

  List<Comptes> comptes = [];
  List<Comptes> selectedComptesList = [];
  Comptes? selectedComptes;

  List<Transaction> filteredTransactions = [];
  Transaction? _selectedTransaction;
  Transaction? get selectedTransaction => _selectedTransaction;
  int statusCode = 0;

  // Pagination state
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  int _offset = 0;
  final int _limit = 50;
  int totalRows = 0;

  double totalDebit = 0, totalCredit = 0;
  double totalDebitToday = 0, totalCreditToday = 0;

  DateTime? startDate;
  DateTime? endDate;

  List<Map<int, String>> sensList = [
    {0: 'Débit'},
    {1: 'Crédit'},
    {2: 'Tous'},
  ];

  int selectedSens = 2;

  String? selection = '';

  bool clients = true;
  bool fournisseurs = true;
  bool employees = true;
  bool sansTiers = true;
  bool totaloperations = true;

  void setDates(DateTime? start, DateTime? end) {
    if (start != null) startDate = start;
    if (end != null) endDate = end;
    notify();
  }

  void setSelectedTransaction(Transaction transaction) {
    _selectedTransaction = transaction;
    notify();
  }

  Future<void> getTransactions(
    BuildContext context, {
    bool isLoadMore = false,
    bool isTodayOnly = false,
  }) async {
    if (isLoadMore) {
      if (isLoadingMore || !hasMore) return;
      isLoadingMore = true;
    } else if (isTodayOnly) {
      statusCode = 0;
      totalDebitToday = 0;
      totalCreditToday = 0;
    } else {
      if (isLoading) return;
      isLoading = true;
      statusCode = 0;
      _offset = 0;
      hasMore = true;
      filteredTransactions = [];
      totalDebit = 0;
      totalCredit = 0;
    }
    notify();

    try {
      final DateTime? today = isTodayOnly ? DateTime.now() : null;
      var body = _buildRequestTransactionBody(
        isTodayOnly: isTodayOnly,
        userType: authProvider.selectedUser!.USRTYPE,
        exercice: authProvider.initialExercice?.EXENO.toString(),
        offset: isLoadMore ? _offset : 0,
        limit: _limit,
        search: '',
        customStartDate: today,
        customEndDate: today,
      );

      if (body['statusCode'] == 404) {
        if (isLoadMore) {
          hasMore = false;
        } else {
          filteredTransactions = [];
          statusCode = 404;
        }
        return;
      }

      final response = await "/caisse".authPost(context, body).timeout(const Duration(minutes: 3));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final newItems = Transaction.listFromJson(decoded['transactions'], selectedSens);

        if (isTodayOnly) {
          filteredTransactions = newItems;
          totalDebitToday = (decoded['totalDebit'] ?? 0).toDouble();
          totalCreditToday = (decoded['totalCredit'] ?? 0).toDouble();
          statusCode = 200;
        } else if (isLoadMore) {
          filteredTransactions = [...filteredTransactions, ...newItems];
          hasMore = (decoded['hasMore'] ?? 0) == 1;
          _offset += _limit;
          totalDebit = (decoded['totalDebit'] ?? 0).toDouble();
          totalCredit = (decoded['totalCredit'] ?? 0).toDouble();
        } else {
          print(' hasMore: ${decoded['hasMore']}');
          print(' totalRows: ${decoded['totalRows']}');
          filteredTransactions = newItems;
          totalRows = decoded['totalRows'] ?? 0;
          hasMore = (decoded['hasMore'] ?? 0) == 1;
          _offset = _limit;
          totalDebit = (decoded['totalDebit'] ?? 0).toDouble();
          totalCredit = (decoded['totalCredit'] ?? 0).toDouble();
          statusCode = 200;
        }
      } else {
        if (isLoadMore) {
          hasMore = false;
        } else {
          if (isTodayOnly && response.statusCode == 404) {
            filteredTransactions = [];
            statusCode = 404;
          } else {
            statusCode = response.statusCode;
          }
        }
      }
      filteredTransactions;
    } catch (err) {
      if (isTodayOnly) {
        print('where $err');
      }
      if (isLoadMore) {
        hasMore = false;
      } else {
        statusCode = 500;
      }
    } finally {
      if (isLoadMore) {
        isLoadingMore = false;
      } else if (!isTodayOnly) {
        isLoading = false;
      }
      notify();
    }
  }

  bool _hasAccess(String trs, String res) {
    final user = authProvider.selectedUser;
    if (user == null) return false;

    final access = authProvider.accessList ?? [];
    final match = access.any((r) => r.URSTRS == trs && r.URSRES == res && r.URSDRO == '01');

    return user.USRTYPE == 2 || (user.USRTYPE == 1 && !match) || (user.USRTYPE == 0 && match);
  }

  Map<String, dynamic> _buildRequestTransactionBody({
    required bool isTodayOnly,
    required int userType,
    required String? exercice,
    required int offset,
    required int limit,
    required String search,
    DateTime? customStartDate,
    DateTime? customEndDate,
  }) {
    String comptesSql = '1=1';
    String rubriques = '1=1';

    // Filter options based on user access permissions
    final clientsAllowed = _hasAccess('07', '01') && clients;
    final fournisseursAllowed = _hasAccess('07', '02') && fournisseurs;
    final employeesAllowed = _hasAccess('06', '02') && employees;
    final sansTiersAllowed = _hasAccess('07', '03') && sansTiers;

    // True if at least one option is enabled and user has access
    final hasAnyAccess = clientsAllowed || fournisseursAllowed || employeesAllowed || sansTiersAllowed || totaloperations;

    final readableRubriques = authProvider.rubriquesCaisse.where((r) => r.read).toList();

    if (selectedComptesList.isEmpty || hasAnyAccess == false || (userType == 0 && sansTiersAllowed && readableRubriques.isEmpty)) {
      return {'statusCode': 404};
    }

    switch (authProvider.selectedUser!.USRTYPE) {
      case 0:
        rubriques = " R.rubno IN ('${readableRubriques.map((r) => r.rubrique).join("','")}')";

        break;
      case 1:
        rubriques = readableRubriques.isEmpty ? '1=1' : " R.rubno NOT IN ('${readableRubriques.map((r) => r.rubrique).join("','")}')";

        break;
      case 2:
        rubriques = " 1=1 ";

        break;
    }
    comptesSql = " ('${selectedComptesList.map((e) => e.cptNo).join("','")}')";

    final start = customStartDate ?? startDate!;
    final end = customEndDate ?? endDate!;

    return {
      'path': authProvider.selectedFolder?.DOSBDD,
      'codesel': selection ?? '',
      'comptesSql': 'JnlCpt IN $comptesSql',
      'ComptesArr': 'JnlTrfCpt IN $comptesSql',
      'Rubriques': rubriques,
      'datedu': start.toIso8601String().split('T')[0],
      'dateau': end.toIso8601String().split('T')[0],
      'jnlsens': selectedSens,
      'clients': clientsAllowed,
      'fournisseurs': fournisseursAllowed,
      'employees': employeesAllowed,
      'sanstiers': sansTiersAllowed,
      'totaloperations': totaloperations,
      'soldeInitial': start.month == 1 && start.day == 1,
      'total': totaloperations,
      'limit': limit,
      'offset': offset,
      'search': search,
    };
  }

  Future getComptes(BuildContext context) async {
    try {
      final reqBody = _buildRequestBody(userType: authProvider.selectedUser!.USRTYPE);
      if (reqBody['statusCode'] == 404) {
        comptes = [];
        statusCode = 404;
        notify();
        return;
      }
      http.Response response = await "/comptes".authPost(context, reqBody);
      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        comptes = (data['comptes'] as List).map((e) => Comptes.fromJson(e)).toList();
        selectedComptesList = comptes.where((e) => e.cptSelect == 1).toList();
      } else {
        comptes = [];
      }
      notify();
    } catch (err) {
      comptes = [];
      print('error: $err');
      notify();
    }
  }

  Map<String, dynamic> _buildRequestBody({
    required int userType,
  }) {
    final comptesList = authProvider.comptes.where((e) => e.read == true).map((e) => e.rubrique).toList();

    // User type 0 must have authorized accounts
    if (comptesList.isEmpty && userType == 0) {
      return {
        'statusCode': 404,
      };
    }

    String comptesCondition = '';

    switch (userType) {
      case 0:
        comptesCondition = " AND CPTNO IN (${comptesList.join(',')})";
        break;

      case 1:
        comptesCondition = comptesList.isEmpty ? " AND 1=1 " : " AND CPTNO NOT IN (${comptesList.join(',')})";
        break;

      default:
        comptesCondition = '';
    }

    return {
      'path': authProvider.selectedFolder?.DOSBDD,
      'comptes': comptesCondition,
    };
  }

  _DatePeriod resolvePeriod({
    required int? intervalType,
    required int exerciceYear,
  }) {
    final now = DateTime.now().year == exerciceYear ? DateTime.now() : DateTime(exerciceYear, 12, 31);

    switch (intervalType) {
      /// سنة كاملة
      case 0:
        return _DatePeriod(
          start: DateTime(exerciceYear, 1, 1),
          end: DateTime(exerciceYear, 12, 31),
        );

      /// شهر جاري
      case 1:
        final firstDayNextMonth = DateTime(exerciceYear, now.month + 1, 1);

        return _DatePeriod(
          start: DateTime(exerciceYear, now.month, 1),
          end: firstDayNextMonth.subtract(const Duration(days: 1)),
        );

      /// أسبوع (السبت → الخميس)
      case 2:
        final daysToPreviousSaturday = (now.weekday + 1) % 7;
        final start = now.subtract(Duration(days: daysToPreviousSaturday));

        var daysToNextThursday = (DateTime.thursday - now.weekday + 7) % 7;
        if (daysToNextThursday == 0) daysToNextThursday = 7;

        final end = now.add(Duration(days: daysToNextThursday));

        return _DatePeriod(start: start, end: end);

      /// اليوم
      case 3:
      default:
        return _DatePeriod(start: now, end: now);
    }
  }

  Future<void> restoerDefaults(BuildContext context) async {
    selectedComptesList = comptes.where((e) => e.cptSelect == 1).toList();
    final period = resolvePeriod(
      intervalType: authProvider.caisseSettings!.PRMJRDINTERVDATE.toInt(),
      exerciceYear: authProvider.initialExercice!.EXENO!,
    );
    startDate = period.start;
    endDate = period.end;
    selectedSens = 2;
    selection = '';
    clients = true;
    fournisseurs = true;
    employees = true;
    sansTiers = true;
    totaloperations = true;
    notifyListeners();
  }
}

class _DatePeriod {
  final DateTime start;
  final DateTime end;

  const _DatePeriod({
    required this.start,
    required this.end,
  });
}
