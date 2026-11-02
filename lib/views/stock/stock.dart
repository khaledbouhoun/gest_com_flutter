import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:gestion_stock/views/home.dart';
import 'package:gestion_stock/views/stock/add_main_infos.dart';
import 'package:gestion_stock/widgets/barcode_scanner_screen.dart';
import 'package:gestion_stock/widgets/exercice_selector.dart';
import 'package:gestion_stock/widgets/product_widget.dart';
import 'package:gestion_stock/widgets/toast.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../../models/product.dart';

class Stock extends StatefulWidget {
  const Stock({super.key});

  @override
  State<StatefulWidget> createState() => StockPage();
}

class StockPage extends State<Stock> {
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterProducts);
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final stockVM = Provider.of<StockViewModel>(context, listen: false);
        final authVM = Provider.of<AuthViewModel>(context, listen: false);
        stockVM.resetPagination();
        stockVM.getStock(context, authVM.selectedExercice, offset: 0);
        stockVM.newProduct = Product();
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final stockVM = Provider.of<StockViewModel>(context, listen: false);
      if (stockVM.isLoadingMore || !stockVM.hasMore) return;

      print("[stock.dart] _onScroll triggering loadMoreStock");
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      stockVM.loadMoreStock(context, authVM.selectedExercice);
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

    stockVM.getStock(context, authVM.selectedExercice, search: query, offset: 0);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return RefreshIndicator(
      onRefresh: () async {
        final stockVM = Provider.of<StockViewModel>(context, listen: false);
        final authVM = Provider.of<AuthViewModel>(context, listen: false);
        stockVM.resetPagination();
        await stockVM.getStock(context, authVM.selectedExercice, offset: 0, search: searchController.text);
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
            leading: Icon(Icons.inventory_2_rounded, color: Colors.white, size: width * 0.07),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Articles',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: width * 0.06),
                ),
                ExerciceSelector(functionType: 'stock')
              ],
            ),
          ),
          body: SafeArea(
            child: Consumer2<StockViewModel, AuthViewModel>(builder: (context, stockVM, authVM, child) {
              return SizedBox(
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
                                    decoration: InputDecoration(
                                      hintText: 'Désignation / Référence',
                                      hintStyle: TextStyle(fontSize: width * 0.035),
                                      prefixIcon: Icon(Icons.search),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(Radius.circular(10))),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    final String? rawContent = await Navigator.push<String>(
                                      context,
                                      MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
                                    );
                                    if (rawContent == null || rawContent.isEmpty) {
                                      Toast(
                                          title: 'Aucun article trouvé',
                                          style: ToastificationStyle.minimal,
                                          type: ToastificationType.warning);
                                    } else {
                                      await stockVM.getStock(
                                        context,
                                        authVM.selectedExercice,
                                        search: rawContent,
                                        offset: 0,
                                      );

                                      // if (stockVM.products.isNotEmpty) {
                                      //   Provider.of<ProductViewModel>(context, listen: false).selectedProduct =
                                      //       stockVM.products.first;
                                      //   Navigator.push(
                                      //       context, MaterialPageRoute(builder: (builder) => const ProductDetails()));
                                      // } else {
                                      //   Toast(
                                      //       title: 'Aucun article trouvé',
                                      //       style: ToastificationStyle.minimal,
                                      //       type: ToastificationType.warning);
                                      // }
                                    }
                                  },
                                  icon: Icon(
                                    Icons.qr_code_rounded,
                                    color: Colors.white,
                                    size: width * 0.09,
                                  )),
                              FutureBuilder<ApplicationType>(
                                  future: Provider.of<AuthViewModel>(context).typeApp,
                                  builder: (context, snapshot) {
                                    final appType = snapshot.data ?? ApplicationType.none;
                                    return appType == ApplicationType.general
                                        ? IconButton(
                                            onPressed: () async {
                                              if (verifyAccess(context)) {
                                                Provider.of<StockViewModel>(context, listen: false).newProduct =
                                                    Product();
                                                Navigator.push(context,
                                                    MaterialPageRoute(builder: (builder) => const AddMainInfos()));
                                              } else {
                                                Toast(
                                                    context: context,
                                                    title: 'Pas de permission pour ajouter un nouveau article',
                                                    style: ToastificationStyle.minimal,
                                                    type: ToastificationType.warning);
                                              }
                                            },
                                            icon: Icon(
                                              Icons.add_circle,
                                              color: Colors.white,
                                              size: width * 0.09,
                                            ))
                                        : SizedBox();
                                  })
                            ],
                          ),
                          _buildTableHeader(width),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Consumer<StockViewModel>(
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
                              itemCount:
                                  stockViewModel.filteredProducts.length + (stockViewModel.isLoadingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index < stockViewModel.filteredProducts.length) {
                                  return ProductWidget(product: stockViewModel.filteredProducts[index]);
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
              );
            }),
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
            flex: 3,
            child: Text(
              'Prix / Qté',
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

  bool verifyAccess(BuildContext context) {
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    if (authProvider.selectedUser!.USRTYPE == 0) {
      return authProvider.accessList!
              .where((element) => element.URSTRS == '01' && element.URSRES == '01' && element.URSDRO == '02')
              .length ==
          1;
    } else if (authProvider.selectedUser!.USRTYPE == 1) {
      return authProvider.accessList!
          .where((element) => element.URSTRS == '01' && element.URSRES == '01' && element.URSDRO == '02')
          .isEmpty;
    } else {
      return true;
    }
  }
}
