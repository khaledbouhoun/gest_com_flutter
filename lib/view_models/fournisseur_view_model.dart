import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_stock/models/fournisseur.dart';
import 'package:gestion_stock/models/paginated_response.dart';
import 'package:gestion_stock/models/pagination_meta.dart';
import 'package:gestion_stock/widgets/http_extensions.dart';

import '../models/exercice.dart';
import 'auth_view_model.dart';

class FournisseurViewModel extends ChangeNotifier {
  AuthViewModel authProvider;
  FournisseurViewModel(this.authProvider) {
    selectedExerciceFourniseur = authProvider.initialExercice;
  }

  Exercice? selectedExerciceFourniseur;

  List<Fournisseur> fournisseurs = [];
  List<Fournisseur> filteredFournisseurs = [];
  Fournisseur? _selectedFournisseur;
  Fournisseur? get selectedFournisseur => _selectedFournisseur;
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

  PaginationMeta? _paginationMeta;
  void setSelectedFournisseur(Fournisseur fournisseur) {
    _selectedFournisseur = fournisseur;
    notify(); // Notify listeners if the UI needs to update
  }

  bool isSoldAllowed() {
    final hasAccess = authProvider.accessList?.any((e) => e.URSTRS == "02" && e.URSRES == "07" && e.URSDRO == "01") ?? false;

    switch (authProvider.selectedUser!.USRTYPE) {
      case 0:
        return hasAccess;
      case 1:
        return !hasAccess;
      default:
        return true;
    }
  }

  Future<void> getFournisseurs(
    BuildContext context,
    Exercice? selectedExercice, {
    String? search,
    int? limit,
    int? offset,
    bool isAchat = false,
  }) async {
    print("[fournisseur_view_model.dart] getFournisseurs search: $search, offset: $offset");
    if (selectedExercice == null) return;

    try {
      if (offset == 0 || offset == null) {
        statusCode = 0;
        notify();
      }

      if (search != null) _searchQuery = search;
      final effectiveLimit = limit ?? 50;
      final effectiveOffset = offset ?? _currentOffset;

      final reqBody = _buildRequestBody(
        userType: authProvider.selectedUser!.USRTYPE,
        exercice: selectedExercice.EXENO.toString(),
        limit: effectiveLimit,
        offset: effectiveOffset,
        search: _searchQuery,
        isAchat: isAchat,
      );

      if (reqBody['statusCode'] == 404) {
        if (effectiveOffset == 0) {
          fournisseurs = [];
          filteredFournisseurs = [];
          statusCode = 404;
        } else {
          _hasMore = false;
        }
        notify();
        return;
      }

      final response = await "/fournisseur".authPost(
        context,
        reqBody,
      );

      statusCode = response.statusCode;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final paginated = PaginatedResponse<Fournisseur>.fromJson(data, (item) => Fournisseur.fromJson(item));

        if (effectiveOffset == 0) {
          fournisseurs = paginated.data;
        } else {
          fournisseurs.addAll(paginated.data);
        }

        _paginationMeta = paginated.meta;
        _hasMore = paginated.meta.hasMore;
        _currentOffset = effectiveOffset + paginated.data.length;
        print("[fournisseur_view_model.dart] Loaded ${paginated.data.length} fournisseurs. Total: ${fournisseurs.length}, hasMore: $_hasMore");

        filteredFournisseurs = fournisseurs;
      } else if (response.statusCode == 404 || response.statusCode == 401) {
        if (effectiveOffset == 0) {
          fournisseurs = [];
          filteredFournisseurs = [];
        }
      }
    } catch (e) {
      print('[fournisseur_view_model.dart] getFournisseurs error: $e');
      statusCode = 500;
    } finally {
      notify();
    }
  }

  Map<String, dynamic> _buildRequestBody({
    required int userType,
    required String exercice,
    required int limit,
    required int offset,
    required String search,
    bool isAchat = false,
  }) {
    final categories = authProvider.catgFournisseurs.where((e) => isAchat ? (e.write == true) : (e.read == true)).map((e) => e.rubrique).toList();

    if (userType == 0 && categories.isEmpty) {
      return {
        'statusCode': 404,
      };
    }

    return {
      'path': authProvider.selectedFolder?.DOSBDD,
      'typeUser': userType,
      'exercice': exercice,
      'limit': limit,
      'offset': offset,
      'search': search,
      'categories': categories.toString(),
      'categories_length': categories.length,
    };
  }

  // ============================================================
  // Pagination helpers
  // ============================================================

  void notify() {
    Future.microtask(() => notifyListeners());
  }

  Future<void> loadMoreFournisseurs(BuildContext context, Exercice? selectedExercice) async {
    print("[fournisseur_view_model.dart] loadMoreFournisseurs called. isLoadingMore: $_isLoadingMore, hasMore: $_hasMore");
    if (_isLoadingMore || !_hasMore || selectedExercice == null) return;
    try {
      _isLoadingMore = true;
      notify();
      await getFournisseurs(context, selectedExercice, offset: _currentOffset);
    } finally {
      _isLoadingMore = false;
      notify();
    }
  }

  Future<void> setSearch(BuildContext context, Exercice? exercice, String query) async {
    _searchQuery = query;
    _currentOffset = 0;
    _hasMore = true;
    await getFournisseurs(context, exercice, search: query, offset: 0);
  }

  void setPageSize(int size) {
    _currentOffset = 0;
    notify();
  }

  void resetPagination() {
    _searchQuery = '';
    _currentOffset = 0;
    _hasMore = true;
    _isLoadingMore = false;
    fournisseurs = [];
    filteredFournisseurs = [];
    _paginationMeta = null;
    notify();
  }
}
