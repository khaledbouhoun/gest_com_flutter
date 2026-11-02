import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/fournisseur_view_model.dart';
import 'package:gestion_stock/views/home.dart';
import 'package:provider/provider.dart';

import '../../widgets/exercice_selector.dart';
import '../../widgets/fournisseur_widget.dart';

class Fournisseurs extends StatefulWidget {
  const Fournisseurs({super.key});

  @override
  State<StatefulWidget> createState() => FournisseursPage();
}

class FournisseursPage extends State<Fournisseurs> {
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterFournisseurs);
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<FournisseurViewModel>(context, listen: false);
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      provider.resetPagination();
      provider.getFournisseurs(context, authVM.selectedExercice, offset: 0);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final provider = Provider.of<FournisseurViewModel>(context, listen: false);
      if (provider.isLoadingMore || !provider.hasMore) return;

      print("[fournisseurs.dart] _onScroll triggering loadMoreFournisseurs");
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      provider.loadMoreFournisseurs(context, authVM.selectedExercice);
    }
  }

  @override
  void dispose() {
    searchController.removeListener(_filterFournisseurs);
    _scrollController.removeListener(_onScroll);
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _filterFournisseurs() {
    String query = searchController.text;
    final provider = Provider.of<FournisseurViewModel>(context, listen: false);
    final authVM = Provider.of<AuthViewModel>(context, listen: false);

    // Switch to server-side search
    provider.getFournisseurs(context, authVM.selectedExercice, search: query, offset: 0);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return RefreshIndicator(
      onRefresh: () async {
        final provider = Provider.of<FournisseurViewModel>(context, listen: false);
        final authVM = Provider.of<AuthViewModel>(context, listen: false);
        provider.resetPagination();
        await provider.getFournisseurs(context, authVM.selectedExercice, offset: 0, search: searchController.text);
      },
      child: WillPopScope(
        onWillPop: () async {
          Navigator.push(context, MaterialPageRoute(builder: (builder) => const Home()));
          return false;
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            leading: Icon(Icons.person_rounded, color: Colors.white, size: width * 0.07),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fournisseur',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: width * 0.06),
                ),
                ExerciceSelector(functionType: 'fournisseur')
              ],
            ),
          ),
          body: SafeArea(
            child: SizedBox(
              width: width,
              height: height,
              child: Column(
                children: [
                  Container(
                    width: width,
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).secondaryHeaderColor,
                          blurRadius: 30.0,
                          offset: const Offset(0.0, 0.75),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: height * 0.05,
                                child: TextField(
                                  controller: searchController,
                                  decoration: const InputDecoration(
                                    hintText: 'Entrer nom ou prénom',
                                    prefixIcon: Icon(Icons.search),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(Radius.circular(10))),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        _buildTableHeader(width)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Consumer<FournisseurViewModel>(
                      builder: (context, provider, child) {
                        if (provider.statusCode == 0) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: width * 0.15,
                                  height: width * 0.15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).secondaryHeaderColor,
                                    ),
                                  ),
                                ),
                                SizedBox(height: height * 0.03),
                                Text(
                                  'Chargement...',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: width * 0.04,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        if (provider.statusCode == 404) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.business_outlined,
                                  size: width * 0.2,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: height * 0.02),
                                Text(
                                  'Aucun fournisseur trouvé',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: width * 0.045,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                Text(
                                  'Essayez de modifier la recherche',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: width * 0.035,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        if (provider.statusCode == 500) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_off_rounded,
                                  size: width * 0.2,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: height * 0.02),
                                Text(
                                  'Impossible de se connecter',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: width * 0.045,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                Text(
                                  'Vérifiez votre connexion',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: width * 0.035,
                                  ),
                                ),
                                SizedBox(height: height * 0.03),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.08,
                                      vertical: width * 0.04,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                  ),
                                  onPressed: () {
                                    _filterFournisseurs();
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.refresh_rounded, size: width * 0.05),
                                      SizedBox(width: width * 0.02),
                                      Text(
                                        'Réessayer',
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: width * 0.03),
                          child: ListView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: (provider.filteredFournisseurs.length) + (provider.isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index < (provider.filteredFournisseurs.length)) {
                                return FournisseurWidget(fournisseur: provider.filteredFournisseurs[index]);
                              } else {
                                return const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(double width) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: width * 0.02,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Text(
              'Nom Complet',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.04,
              ),
            ),
          ),
          Container(
            width: 1,
            height: width * 0.05,
            color: Colors.white.withValues(alpha: 0.3),
            margin: EdgeInsets.symmetric(horizontal: width * 0.02),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Solde',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.04,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
