import 'package:flutter/material.dart';
import 'package:gestion_stock/models/commande_product.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/commande_entate_view_model.dart';
import 'package:gestion_stock/view_models/product_view_model.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:gestion_stock/views/command/add_commande_clients.dart';
import 'package:gestion_stock/views/command/add_commande_products.dart';
import 'package:gestion_stock/views/command/commandes.dart';
import 'package:gestion_stock/views/command/save_commande_page.dart';
import 'package:gestion_stock/widgets/add_commande_selected_product_widget.dart';
import 'package:gestion_stock/widgets/barcode_scanner_screen.dart';
import 'package:gestion_stock/widgets/reset_commande_dialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../../widgets/toast.dart';

class AddCommande extends StatelessWidget {
  const AddCommande({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    NumberFormat formatter = NumberFormat('#,##0.00', "fr");

    return Consumer2<CommandeEntateViewModel, AuthViewModel>(
      builder: (context, entateProvider, authProvider, child) {
        entateProvider.totalCommande = 0;

        for (var element in entateProvider.addCommandeProducts) {
          // Safely calculate total, handling possible null values
          final product = element.product;
          final qty = element.quantity;
          if (product.ARTPRIX != null) {
            entateProvider.totalCommande += (product.ARTPRIX ?? 0) * qty;
          }
        }

        return SafeArea(
          top: false,
          child: Scaffold(
            backgroundColor: const Color(0xFFF4F9FC),
            // appBar: _buildAppBar(context, width, entateProvider),
            body: WillPopScope(
              onWillPop: () async {
                if ((entateProvider.addCommandeProducts.isNotEmpty ?? false) ||
                    entateProvider.addCommandeClient != null) {
                  ResetCommandeDialog.showResetCommandeDialoge(context);
                  return false;
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (builder) => const Commandes()));
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
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, double width, CommandeEntateViewModel entateProvider) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      leading: IconButton(
        onPressed: () {
          if ((entateProvider.addCommandeProducts.isNotEmpty ?? false) || entateProvider.addCommandeClient != null) {
            ResetCommandeDialog.showResetCommandeDialoge(context);
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (builder) => const Commandes()));
          }
        },
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_cart_rounded, color: Colors.white, size: width * 0.06),
          SizedBox(width: width * 0.02),
          Text(
            'Bon de commande',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: width * 0.055,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeaderSection(double width, BuildContext context, CommandeEntateViewModel entateProvider) {
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
          // Client selection
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Client sélectionné',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: width * 0.032,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: width * 0.02),
                    Text(
                      '${entateProvider.addCommandeClient?.CLINOM ?? "/"} ${entateProvider.addCommandeClient?.CLIPRENOM ?? ""}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.045,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    Provider.of<StockViewModel>(context, listen: false)
                        .getStock(context, Provider.of<AuthViewModel>(context, listen: false).selectedExercice);
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => const AddCommandeClients()));
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.all(width * 0.03),
                    child: Icon(
                      Icons.person_add_alt_1_rounded,
                      color: Theme.of(context).secondaryHeaderColor,
                      size: width * 0.07,
                    ),
                  ),
                ),
              ),
            ],
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
                    'Qté',
                    textAlign: TextAlign.center,
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
                  flex: 5,
                  child: Text(
                    'Prix.U TTC',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.04,
                    ),
                  ),
                ),
                SizedBox(width: width * 0.08),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(double width, CommandeEntateViewModel entateProvider) {
    if (entateProvider.addCommandeProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_basket_outlined,
              size: width * 0.2,
              color: Colors.grey[400],
            ),
            SizedBox(height: width * 0.04),
            Text(
              'Aucun Article ajouté',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: width * 0.045,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: width * 0.02),
            Text(
              'Appuyez sur + pour ajouter des Articles',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: width * 0.035,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.03),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: entateProvider.addCommandeProducts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: width * 0.02),
            child: AddCommandeSelectedProductWidget(
              product: entateProvider.addCommandeProducts[index],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(
    double width,
    BuildContext context,
    CommandeEntateViewModel entateProvider,
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
                  '${formatter.format(entateProvider.totalCommande)} DA',
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
                  entateProvider.resetAddCommande();
                },
              ),
              _modernBlueActionButton(
                width: width,
                icon: Icons.add_shopping_cart_rounded,
                label: 'Ajouter',
                accent: Colors.white,
                onTap: () {
                  if (entateProvider.addCommandeClient == null) {
                    Toast(
                      title: 'Sélectionner un client d\'abord',
                      style: ToastificationStyle.minimal,
                      type: ToastificationType.warning,
                      context: context,
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddCommandeProducts(),
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
                  final stockVM = context.read<StockViewModel>();
                  final authVM = context.read<AuthViewModel>();
                  final productVM = context.read<ProductViewModel>();

                  if (entateProvider.addCommandeClient == null) {
                    Toast(
                      title: 'Sélectionner un client d\'abord',
                      style: ToastificationStyle.minimal,
                      type: ToastificationType.warning,
                      context: context,
                    );
                    return;
                  }

                  final String? rawContent = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
                  );

                  if (rawContent == null || rawContent.isEmpty) {
                    return;
                  }

                  await stockVM.getStock(
                    context,
                    authVM.selectedExercice,
                    search: rawContent,
                    offset: 0,
                  );

                  if (stockVM.products.isEmpty) {
                    Toast(
                      title: 'Aucun article trouvé',
                      style: ToastificationStyle.minimal,
                      type: ToastificationType.warning,
                      context: context,
                    );
                    return;
                  }

                  final product = stockVM.products.first;

                  await productVM.getProductTarifs(
                    context,
                    product.ARTNO!,
                  );

                  final existingProduct = entateProvider.addCommandeProducts
                      .where((item) => item.product.ARTNO == product.ARTNO)
                      .firstOrNull;

                  if (existingProduct == null) {
                    entateProvider.addCommandeProducts.add(
                      CommandeProduct(
                        product: product,
                        tarifs: productVM.selectedProductTarifs,
                        quantity: 1,
                        tarif: entateProvider.prmtarifdefautab,
                        negative: true,
                      ),
                    );
                  } else {
                    existingProduct.quantity++;
                  }

                  entateProvider.notifyListeners();
                },
              ),
              _modernBlueActionButton(
                width: width,
                icon: Icons.save_rounded,
                label: 'Enregistrer',
                accent: Colors.greenAccent,
                onTap: () async {
                  if (entateProvider.addCommandeProducts.isNotEmpty && entateProvider.addCommandeClient != null) {
                    entateProvider.selectedT = entateProvider.listTipe.firstWhere((e) => e.tipeno == 1);
                    entateProvider.checkedRSV = false;

                    await entateProvider.defalutDate();
                    await entateProvider.getJournals(context);
                    await entateProvider.getSites(context);
                    await entateProvider.getcodebon(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SaveCommandePage(),
                      ),
                    );
                  } else {
                    Toast(
                      title: "Sélectionner un client et des Articles d'abord",
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
                    fontSize: width * 0.035,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    double width,
    IconData icon,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 4,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: width * 0.03,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: width * 0.07),
              SizedBox(height: width * 0.01),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: width * 0.028,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
