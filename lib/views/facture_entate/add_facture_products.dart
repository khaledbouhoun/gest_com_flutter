import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/facture_entate_view_model.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:gestion_stock/views/facture_entate/add_facture.dart';
import 'package:gestion_stock/widgets/add_facture_product_widget.dart';
import 'package:provider/provider.dart';

class AddFactureProducts extends StatefulWidget {
  const AddFactureProducts({super.key});

  @override
  State<StatefulWidget> createState() => AddFactureProductsPage();
}

class AddFactureProductsPage extends State<AddFactureProducts> {
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
      final factureVM = Provider.of<FactureEntateViewModel>(context, listen: false);

      stockVM.resetPagination();
      stockVM.getStock(context, authVM.selectedExercice!, offset: 0, vente: true, search: searchController.text);
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
          Navigator.push(context, MaterialPageRoute(builder: (builder) => const AddFacture()));
          return false;
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F9FC),
          body: SafeArea(
            child: Column(
              children: [
                _buildHeaderSection(width, context),
                SizedBox(height: width * 0.02),
                Expanded(
                  child: _buildProductsList(width, context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(double width, BuildContext context) {
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
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
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
          // Row(
          //   children: [
          //     IconButton(
          //       onPressed: () {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (builder) => const AddFacture()));
          //       },
          //       icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          //     ),
          //     Expanded(
          //       child: Text(
          //         'Sélectionner un article',
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontWeight: FontWeight.bold,
          //           fontSize: width * 0.05,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // SizedBox(height: width * 0.02),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     ExerciceSelector(functionType: 'stock'),
          //     TarifSelector(),
          //   ],
          // ),
          SizedBox(height: width * 0.04),
          _buildSearchBar(width),
          SizedBox(height: width * 0.03),
          _buildTableHeader(width),
        ],
      ),
    );
  }

  Widget _buildSearchBar(double width) {
    return Container(
      height: width * 0.11,
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
          hintText: 'Désignation ou référence...',
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
          contentPadding: EdgeInsets.symmetric(vertical: width * 0.02),
        ),
      ),
    );
  }

  Widget _buildTableHeader(double width) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              'Désignation',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.bold,
                fontSize: width * 0.04,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Prix/Qté',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.bold,
                fontSize: width * 0.04,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(double width, BuildContext context) {
    return Consumer<StockViewModel>(
      builder: (context, provider, child) {
        if (provider.statusCode == 0) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).secondaryHeaderColor),
            ),
          );
        }
        if (provider.statusCode == 404) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: width * 0.2, color: Colors.grey[300]),
                SizedBox(height: width * 0.02),
                Text('Aucun Article trouvé', style: TextStyle(color: Colors.grey[400])),
              ],
            ),
          );
        }
        if (provider.statusCode == 500) {
          return _buildErrorState(width, context);
        }
        return ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          itemCount: provider.filteredProducts.length + (provider.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < provider.filteredProducts.length) {
              return AddFactureProductWidget(product: provider.filteredProducts[index]);
            } else {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildErrorState(double width, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Impossible de se connecter au serveur'),
          SizedBox(height: width * 0.04),
          ElevatedButton(
            onPressed: () => _filterProducts(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }
}
