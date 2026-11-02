import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/commande_entate_view_model.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:gestion_stock/views/command/add_commande.dart';
import 'package:gestion_stock/widgets/add_commande_product_widget.dart';
import 'package:provider/provider.dart';

class AddCommandeProducts extends StatefulWidget {
  const AddCommandeProducts({super.key});

  @override
  State<StatefulWidget> createState() => AddCommandeProductsPage();
}

class AddCommandeProductsPage extends State<AddCommandeProducts> {
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterProducts);
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final stockVM = Provider.of<StockViewModel>(context, listen: false);
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      final commandeVM = Provider.of<CommandeEntateViewModel>(context, listen: false);

      stockVM.resetPagination();
      if (authVM.selectedExercice != null && commandeVM.prmtarifdefautab != null) {
        stockVM.getStock(context, authVM.selectedExercice!, offset: 0, vente: true, search: searchController.text);
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final stockVM = Provider.of<StockViewModel>(context, listen: false);
      if (stockVM.isLoadingMore || !stockVM.hasMore) return;

      final authVM = Provider.of<AuthViewModel>(context, listen: false);

      stockVM.loadMoreStock(context, authVM.selectedExercice, vente: true);
    }
  }

  @override
  void dispose() {
    searchController.removeListener(_filterProducts);
    _scrollController.removeListener(_onScroll);
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    String query = searchController.text;
    final stockVM = Provider.of<StockViewModel>(context, listen: false);
    final authVM = Provider.of<AuthViewModel>(context, listen: false);

    stockVM.filtreStock(context, authVM.selectedExercice, query, vente: true);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return RefreshIndicator(
      color: Theme.of(context).secondaryHeaderColor,
      onRefresh: () async {
        final stockVM = Provider.of<StockViewModel>(context, listen: false);
        final authVM = Provider.of<AuthViewModel>(context, listen: false);
        stockVM.resetPagination();
        await stockVM.getStock(context, authVM.selectedExercice, search: searchController.text, vente: true);
      },
      child: WillPopScope(
        onWillPop: () async {
          Navigator.push(context, MaterialPageRoute(builder: (builder) => const AddCommande()));
          return false;
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F9FC),
          // appBar: _buildAppBar(context, width),
          body: SafeArea(
            child: Column(
              children: [
                _buildHeaderSection(width, height, context),
                SizedBox(height: width * 0.03),
                Expanded(
                  child: _buildProductsList(width, height, context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(double width, double height, BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.symmetric(horizontal: width * 0.03),
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).secondaryHeaderColor,
            Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search bar
          Container(
            height: width * 0.12,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Entrer désignation ou référence',
                hintStyle: TextStyle(
                  fontSize: width * 0.035,
                  color: Colors.grey[400],
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: width * 0.03),
              ),
            ),
          ),
          SizedBox(height: width * 0.04),

          // Table header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03,
              vertical: width * 0.02,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    'Désignation',
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
                  flex: 2,
                  child: Text(
                    'Prix/Qté',
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
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(double width, double height, BuildContext context) {
    return Consumer<StockViewModel>(
      builder: (context, stockViewModel, child) {
        if (stockViewModel.statusCode == 0) {
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

        if (stockViewModel.statusCode == 404) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_outlined,
                  size: width * 0.2,
                  color: Colors.grey[400],
                ),
                SizedBox(height: height * 0.02),
                Text(
                  'Aucun Article trouvé',
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

        if (stockViewModel.statusCode == 500) {
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
                    _filterProducts();
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
            itemCount: stockViewModel.filteredProducts.length + (stockViewModel.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < stockViewModel.filteredProducts.length) {
                return Padding(
                  padding: EdgeInsets.only(bottom: width * 0.02),
                  child: AddCommandeProductWidget(
                    product: stockViewModel.filteredProducts[index],
                  ),
                );
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
    );
  }

  bool verifyAccess(BuildContext context) {
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    if (authProvider.selectedUser!.USRTYPE == 0) {
      return authProvider.accessList!
              .where((element) => element.URSTRS == '01' && element.URSRES == '04' && element.URSDRO == '02')
              .length ==
          1;
    } else if (authProvider.selectedUser!.USRTYPE == 1) {
      return authProvider.accessList!
          .where((element) => element.URSTRS == '01' && element.URSRES == '04' && element.URSDRO == '02')
          .isEmpty;
    } else {
      return true;
    }
  }
}
