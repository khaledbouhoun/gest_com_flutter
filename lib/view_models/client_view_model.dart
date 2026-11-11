import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_stock/models/client.dart';
import 'package:gestion_stock/models/paginated_response.dart';
import 'package:gestion_stock/models/pagination_meta.dart';
import 'package:gestion_stock/widgets/http_extensions.dart';
import 'package:http/http.dart' as http;
import '../models/exercice.dart';
import 'auth_view_model.dart';

class ClientViewModel extends ChangeNotifier {
  AuthViewModel authProvider;
  ClientViewModel(this.authProvider) {
    selectedExerciceClient = authProvider.initialExercice;
  }

  Exercice? selectedExerciceClient;

  List<Client>? clients;
  Client? _selectedClient;
  Client? get selectedClient => _selectedClient;
  int statusCode = 0;

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

  PaginationMeta? paginationMeta;

  int? addStatusCode;
  Client? newClient = Client();
  bool addButtonVisible = true;

  int? modifyStatusCode;
  Client? modifiedClient = Client();
  bool modifyButtonVisible = true;

  void setSelectedClient(Client client) {
    _selectedClient = client;
    notify(); // Notify listeners if the UI needs to update
  }

  bool isSoldAllowed() {
    final hasAccess = authProvider.accessList?.any((e) => e.URSTRS == "03" && e.URSRES == "11" && e.URSDRO == "01") ?? false;

    switch (authProvider.selectedUser!.USRTYPE) {
      case 0:
        return hasAccess;
      case 1:
        return !hasAccess;
      default:
        return true;
    }
  }

  Future<void> getClients(
    BuildContext context,
    Exercice? selectedExercice, {
    String? search,
    int? limit,
    int? offset,
    bool isVente = false,
  }) async {
    // print("[client_view_model.dart] getClients search $search, limit $limit, offset $offset");
    if (selectedExercice == null) return;

    // Do not refetch if not required (initial load already done and no search/offset provided)
    if (clients != null && clients!.isNotEmpty && search == null && offset == null) return;

    try {
      if (offset == 0) {
        statusCode = 0;
        notify();
      }

      if (search != null) {
        _searchQuery = search;
        if (offset == null) _currentOffset = 0;
      }

      final effectiveLimit = limit ?? 50;
      final effectiveOffset = offset ?? _currentOffset;
      final effectiveSearch = search ?? _searchQuery;

      final userType = authProvider.selectedUser!.USRTYPE;
      final body = _buildRequestBody(
        userType: userType,
        exercice: selectedExercice.EXENO.toString(),
        offset: effectiveOffset,
        limit: effectiveLimit,
        search: effectiveSearch,
        isVente: isVente,
      );

      if (body['statusCode'] == 404) {
        if (effectiveOffset == 0) {
          clients = [];
          statusCode = 404;
        } else {
          _hasMore = false;
        }
        notify();
        return;
      }

      final response = await "/client".authPost(context, body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final paginated = PaginatedResponse<Client>.fromJson(data, (item) => Client.fromJson(item));

        if (effectiveOffset == 0) {
          clients = paginated.data;
        } else {
          clients?.addAll(paginated.data);
        }

        paginationMeta = paginated.meta;
        _hasMore = paginated.meta.hasMore;
        _currentOffset = effectiveOffset + paginated.data.length;
        print("[client_view_model.dart] Total clients: ${clients?.length}, hasMore: $_hasMore");
        statusCode = 200;
      } else {
        statusCode = response.statusCode;
        if ((response.statusCode == 404 || response.statusCode == 401) && effectiveOffset == 0) {
          clients = [];
        }
      }
    } catch (e) {
      print('getClients error: $e');
      statusCode = 500;
    } finally {
      notify();
    }
  }

  Map<String, dynamic> _buildRequestBody({
    required int userType,
    required String? exercice,
    required int offset,
    required int limit,
    required String search,
    bool isVente = false,
  }) {
    final categoriesList = authProvider.catgClients.where((e) => isVente ? (e.write == true) : (e.read == true)).map((e) => e.rubrique).toList();

    final territoiresList =
        authProvider.clientsTerritoires.where((e) => isVente ? (e.write == true) : (e.read == true)).map((e) => e.rubrique).toList();

    if (userType == 0 && (categoriesList.isEmpty || territoiresList.isEmpty)) {
      return {
        'statusCode': 404,
      };
    }

    return {
      'path': authProvider.selectedFolder?.DOSBDD,
      "exercice": exercice ?? authProvider.initialExercice?.EXENO.toString(),
      "typeUser": userType,
      "offset": offset,
      "limit": limit,
      "search": search,
      'categories': categoriesList.toString(),
      'territoires': territoiresList.toString(),
      'categories_length': categoriesList.length,
      'territoires_length': territoiresList.length,
    };
  }

  Future addNewClient() async {
    try {
      addStatusCode = 0;
      addButtonVisible = !addButtonVisible;
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      Map<String, dynamic> body = {
        'path': authProvider.selectedFolder?.DOSBDD,
        "clinature": newClient!.CLINATURE,
        "clinom": newClient!.CLINOM,
        "cliprenom": newClient!.CLIPRENOM,
        "cliactivite": newClient!.CLIACTIVITE,
        "clinomfact": newClient!.CLINOMFACT,
        "clisolde": newClient!.CLISOLDE,
        "clitel1": newClient!.CLITEL1,
        "clitel2": newClient!.CLITEL2,
        "clifax": newClient!.CLIFAX,
        "cliemail": newClient!.CLIEMAIL,
        "cliweb": newClient!.CLIWEB,
        "cliadr1": newClient!.CLIADR1,
        "cliadr2": newClient!.CLIADR2,
        "cliadr3": newClient!.CLIADR3,
        "cliadr4": newClient!.CLIADR4,
        "clilocalisation": newClient!.CLILOCALISATION,
        "clipays": newClient!.CLIPAYS,
        "cliterr": newClient!.CLITERR,
        "cliville": newClient!.CLIVILLE,
        "cliregion": newClient!.CLIREGION,
        "clirc": newClient!.CLIRC,
        "cliif": newClient!.CLIIF,
        "cliai": newClient!.CLIAI,
        "clinis": newClient!.CLINIS,
        "clicateg": newClient!.CLICATEG,
        "clinotes": newClient!.CLINOTES,
        "clicrepar": authProvider.selectedUser!.USRNOM,
        "climodpar": authProvider.selectedUser!.USRNOM,
        "cliexe": authProvider.initialExercice!.EXENO.toString(),
        "PrmCodificationBon": authProvider.sellSettings!.PRMCODIFICATIONBON.toInt(),
      };

      http.Response response;
      response =
          await http.post(Uri.parse('${authProvider.baseUrl}/add_client'), body: jsonEncode(body), headers: headers);
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

  Future modifyClient() async {
    try {
      modifyStatusCode = 0;
      modifyButtonVisible = !modifyButtonVisible;
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      Map<String, dynamic> body = {
        'path': authProvider.selectedFolder?.DOSBDD,
        "clino": modifiedClient!.CLINO,
        "clinature": modifiedClient!.CLINATURE,
        "clinom": modifiedClient!.CLINOM,
        "cliprenom": modifiedClient!.CLIPRENOM,
        "cliactivite": modifiedClient!.CLIACTIVITE,
        "clinomfact": modifiedClient!.CLINOMFACT,
        "clisolde": modifiedClient!.CLISOLDE,
        "clitel1": modifiedClient!.CLITEL1,
        "clitel2": modifiedClient!.CLITEL2,
        "clifax": modifiedClient!.CLIFAX,
        "cliemail": modifiedClient!.CLIEMAIL,
        "cliweb": modifiedClient!.CLIWEB,
        "cliadr1": modifiedClient!.CLIADR1,
        "cliadr2": modifiedClient!.CLIADR2,
        "cliadr3": modifiedClient!.CLIADR3,
        "cliadr4": modifiedClient!.CLIADR4,
        "clipays": modifiedClient!.CLIPAYS,
        "cliterr": modifiedClient!.CLITERR,
        "cliville": modifiedClient!.CLIVILLE,
        "cliregion": modifiedClient!.CLIREGION,
        "clirc": modifiedClient!.CLIRC,
        "cliif": modifiedClient!.CLIIF,
        "cliai": modifiedClient!.CLIAI,
        "clinis": modifiedClient!.CLINIS,
        "clicateg": modifiedClient!.CLICATEG,
        "clinotes": modifiedClient!.CLINOTES,
        "climodpar": authProvider.selectedUser!.USRNOM,
        "cliexe": authProvider.selectedExercice!.EXENO.toString()
      };

      http.Response response;
      response =
          await http.post(Uri.parse('${authProvider.baseUrl}/modify_client'), body: jsonEncode(body), headers: headers);
      modifyStatusCode = response.statusCode;
      modifyButtonVisible = !modifyButtonVisible;
      notify();
    } catch (e) {
      print(e);
      addStatusCode = 500;
      modifyButtonVisible = !modifyButtonVisible;
      notify();
    }
  }

  void notify() {
    Future.microtask(() => notifyListeners());
  }

  // ============================================================
  // Pagination helpers
  // ============================================================

  Future<void> loadMoreClients(BuildContext context, Exercice? selectedExercice) async {
    print("[client_view_model.dart] loadMoreClients scrolling----->");
    print("[client_view_model.dart] _isLoadingMore-----> $_isLoadingMore");
    print("[client_view_model.dart] hasMore-----> $_hasMore");
    print("[client_view_model.dart] selectedExercice-----> $selectedExercice");
    print("[client_view_model.dart] result -----> ${!_isLoadingMore && _hasMore && selectedExercice != null}");

    if (_isLoadingMore || !_hasMore || selectedExercice == null) return;

    try {
      _isLoadingMore = true;
      notify();

      await getClients(
        context,
        selectedExercice,
        offset: _currentOffset,
      );
    } finally {
      _isLoadingMore = false;
      notify();
    }
  }

  void resetPagination() {
    _searchQuery = '';
    _currentOffset = 0;
    _isLoadingMore = false;
    _hasMore = true;
    clients = null;
    paginationMeta = null;
    notify();
  }
}
