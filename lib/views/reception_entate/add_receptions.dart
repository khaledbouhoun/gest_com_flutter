import 'package:flutter/material.dart';
import 'package:gestion_stock/models/commande_product.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/reception_entate_view_model.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:gestion_stock/views/reception_entate/add_receptions_clients.dart';
import 'package:gestion_stock/views/reception_entate/add_receptions_products.dart';
import 'package:gestion_stock/views/reception_entate/receptions.dart';
import 'package:gestion_stock/widgets/add_reception_selected_product_widget.dart';
import 'package:gestion_stock/widgets/barcode_scanner_screen.dart';
import 'package:gestion_stock/widgets/reset_facture_dialog.dart';
import 'package:gestion_stock/widgets/save_reception_page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../../models/product.dart';
import '../../widgets/toast.dart';

class AddReceptions extends StatelessWidget {
  const AddReceptions({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    NumberFormat formatter = NumberFormat('#,##0.00', "fr");
    return Consumer2<ReceptionEntateViewModel, AuthViewModel>(builder: (context, entateProvider, authProvider, child) {
      entateProvider.totalReception = 0;

      for (var element in entateProvider.addReceptionProducts) {
        entateProvider.totalReception += element.product.ARTPRIX! * element.quantity;
      }
      return SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F9FC),
          body: WillPopScope(
            onWillPop: () async {
              if (entateProvider.addReceptionProducts.isNotEmpty || entateProvider.addReceptionFournisseur != null) {
                ResetReceptionsDialog.showResetReceptionsDialoge(context);
                return false;
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (builder) => const Receptions()));
                return false;
              }
            },
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).viewPadding.top),
                _buildHeaderSection(width, context, entateProvider),
                SizedBox(height: width * 0.03),
                Expanded(
                  child: _buildProductsList(width, entateProvider),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomBar(width, context, entateProvider, formatter),
        ),
      );
    });
  }

  Widget _buildHeaderSection(double width, BuildContext context, ReceptionEntateViewModel entateProvider) {
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
        borderRadius: BorderRadius.circular(25),
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
          Container(
            padding: EdgeInsets.all(width * 0.03),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(width * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person_rounded, color: Colors.white, size: width * 0.05),
                ),
                SizedBox(width: width * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fournisseur',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: width * 0.03,
                        ),
                      ),
                      Text(
                        '${entateProvider.addReceptionFournisseur?.FOUNOM ?? "Aucun fournisseur sélectionné"} ${entateProvider.addReceptionFournisseur?.FOUPRENOM ?? ""}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.04,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => const AddReceptionsClients()));
                  },
                  icon: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: width * 0.04),
          _buildTableHeader(width),
        ],
      ),
    );
  }

  Widget _buildTableHeader(double width) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Text(
              'Désignation',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.bold,
                fontSize: width * 0.035,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Qté',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.bold,
                fontSize: width * 0.035,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              'Prix',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.bold,
                fontSize: width * 0.035,
              ),
            ),
          ),
          const SizedBox(width: 48), // Action spacer
        ],
      ),
    );
  }

  Widget _buildProductsList(double width, ReceptionEntateViewModel entateProvider) {
    if (entateProvider.addReceptionProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_basket_outlined, size: width * 0.2, color: Colors.grey[300]),
            SizedBox(height: width * 0.04),
            Text(
              'Aucun Article ajouté',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: width * 0.045,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
      itemCount: entateProvider.addReceptionProducts.length,
      itemBuilder: (context, index) {
        return AddReceptionSelectedProductWidget(product: entateProvider.addReceptionProducts[index]);
      },
    );
  }

  Widget _buildBottomBar(
    double width,
    BuildContext context,
    ReceptionEntateViewModel entateProvider,
    NumberFormat formatter,
  ) {
    const Color primaryBlue = Color.fromRGBO(0, 157, 224, 1);
    const Color darkBlue = Color.fromRGBO(0, 122, 179, 1);

    return Container(
      width: width,
      padding: EdgeInsets.all(width * 0.03),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            primaryBlue,
            darkBlue,
          ],
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withValues(alpha: 0.35),
            blurRadius: 30,
            offset: const Offset(0, -12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// TOTAL GLASS CARD
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.02,
              vertical: width * 0.02,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              children: [
                /// ICON CONTAINER
                Container(
                  padding: EdgeInsets.all(width * 0.025),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: width * 0.045,
                  ),
                ),

                SizedBox(width: width * 0.03),

                /// LABEL
                Expanded(
                  child: Text(
                    'Total à payer',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: width * 0.035,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                /// PRICE
                Text(
                  '${formatter.format(entateProvider.totalReception)} DA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: width * 0.045),

          /// ACTION BUTTONS
          Row(
            children: [
              _modernBlueActionButton(
                width: width,
                icon: Icons.restart_alt_rounded,
                label: 'Reset',
                accent: Colors.orangeAccent,
                onTap: () {
                  entateProvider.resetAddReception();
                },
              ),
              _modernBlueActionButton(
                width: width,
                icon: Icons.add_shopping_cart_rounded,
                label: 'Ajouter',
                accent: Colors.white,
                onTap: () {
                  if (entateProvider.addReceptionFournisseur == null) {
                    Toast(
                      title: 'Sélectionner un fournisseur d\'abord',
                      style: ToastificationStyle.minimal,
                      type: ToastificationType.warning,
                      context: context,
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddReceptionsProducts(),
                      ),
                    );
                  }
                },
              ),
              _modernBlueActionButton(
                width: width,
                icon: Icons.barcode_reader,
                label: 'Scanner',
                accent: Colors.cyanAccent,
                onTap: () async {
                  final stockVM = Provider.of<StockViewModel>(context, listen: false);
                  final authVM = Provider.of<AuthViewModel>(context, listen: false);
                  if (entateProvider.addReceptionFournisseur == null) {
                    Toast(
                      title: 'Sélectionner un fournisseur d\'abord',
                      style: ToastificationStyle.minimal,
                      type: ToastificationType.warning,
                      context: context,
                    );
                  } else {
                    final String? rawContent = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
                    );
                    if (rawContent == null || rawContent.isEmpty) return;
                    await stockVM.getStock(
                      context,
                      authVM.selectedExercice,
                      search: rawContent,
                      offset: 0,
                    );
                    if (stockVM.products.isNotEmpty) {
                      Product product = stockVM.products.first;
                      if (!entateProvider.addReceptionProducts
                          .any((element) => element.product.ARTNO == product.ARTNO)) {
                        entateProvider.getGetReceptionStockGnrAchat(context, product.ARTNO!).then((prix) {
                          product.ARTPRIX = prix;
                          entateProvider.addReceptionProducts.add(CommandeProduct(product: product, quantity: 1));
                          entateProvider.notifyListeners();
                          Navigator.push(context, MaterialPageRoute(builder: (builder) => const AddReceptions()));
                        });
                      } else {
                        int index = entateProvider.addReceptionProducts
                            .indexWhere((element) => element.product.ARTNO == product.ARTNO);
                        entateProvider.addReceptionProducts[index].quantity += 1;
                        entateProvider.notifyListeners();
                        Navigator.push(context, MaterialPageRoute(builder: (builder) => const AddReceptions()));
                      }
                    } else {
                      Toast(
                          title: 'Aucun article trouvé',
                          style: ToastificationStyle.minimal,
                          type: ToastificationType.warning);
                    }
                  }
                },
              ),
              _modernBlueActionButton(
                width: width,
                icon: Icons.save_rounded,
                label: 'Sauver',
                accent: Colors.greenAccent,
                onTap: () async {
                  if (entateProvider.addReceptionProducts.isNotEmpty &&
                      entateProvider.addReceptionFournisseur != null) {
                    entateProvider.selectedT = entateProvider.listTipe.firstWhere((e) => e.tipeno == 1);
                    await entateProvider.defalutDate();
                    await entateProvider.getJournals(context);
                    await entateProvider.getcodebon(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SaveReceptionPage(),
                      ),
                    );
                  } else {
                    Toast(
                      title: "Fournisseur et articles requis",
                      style: ToastificationStyle.minimal,
                      type: ToastificationType.warning,
                      context: context,
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _modernBlueActionButton({
    required double width,
    required IconData icon,
    required String label,
    required Color accent,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.01),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: width * 0.03),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: accent.withValues(alpha: 0.6),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: accent, size: width * 0.06),
                SizedBox(height: width * 0.015),
                Text(
                  label,
                  style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.w600,
                    fontSize: width * 0.03,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
