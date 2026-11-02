import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/facture_entate_view_model.dart';
import 'package:gestion_stock/views/facture_entate/add_facture_clients.dart';
import 'package:gestion_stock/views/facture_entate/add_facture_products.dart';
import 'package:gestion_stock/views/facture_entate/factures.dart';
import 'package:gestion_stock/widgets/add_facture_selected_product_widget.dart';
import 'package:gestion_stock/widgets/barcode_scanner_screen.dart';
import 'package:gestion_stock/widgets/reset_facture_dialog.dart';
import 'package:gestion_stock/widgets/save_facture_page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../../widgets/toast.dart';

class AddFacture extends StatelessWidget {
  const AddFacture({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    NumberFormat formatter = NumberFormat('#,##0.00', "fr");
    return Consumer2<FactureEntateViewModel, AuthViewModel>(builder: (context, entateProvider, authProvider, child) {
      entateProvider.totalFacture = 0;
      entateProvider.totalFacturePoids = 0;
      entateProvider.totalFactureColis = 0;

      for (var element in entateProvider.addFactureProducts!) {
        entateProvider.totalFacture += (element.product.ARTPRIX ?? 0.0) * element.quantity;
        entateProvider.totalFacturePoids += (element.product.ARTPOIDS ?? 0.0) * element.quantity;
        entateProvider.totalFactureColis +=
            entateProvider.coliscalcul(element.product.ARTCOLIS, element.product.ARTUNTCOL, element.quantity);
      }
      return SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F9FC),
          body: WillPopScope(
            onWillPop: () async {
              if (entateProvider.addFactureProducts!.isNotEmpty || entateProvider.addFactureClient != null) {
                ResetFactureDialog.showResetFactureDialoge(context);
                return false;
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (builder) => const Factures()));
                return false;
              }
            },
            child: Column(
              children: [
                Container(height: MediaQuery.of(context).padding.top),
                Expanded(flex: 1, child: _buildHeaderSection(width, context, entateProvider)),
                Expanded(
                  flex: 3,
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

  Widget _buildHeaderSection(double width, BuildContext context, FactureEntateViewModel entateProvider) {
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
        borderRadius: const BorderRadius.all(Radius.circular(25)),
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
                        'Client',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: width * 0.03,
                        ),
                      ),
                      Text(
                        '${entateProvider.addFactureClient?.CLINOM ?? "Aucun client sélectionné"} ${entateProvider.addFactureClient?.CLIPRENOM ?? ""}',
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
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => const AddFactureClients()));
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
              'Prix.U TTC',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.bold,
                fontSize: width * 0.035,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildProductsList(double width, FactureEntateViewModel entateProvider) {
    if (entateProvider.addFactureProducts!.isEmpty) {
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
      itemCount: entateProvider.addFactureProducts!.length,
      itemBuilder: (context, index) {
        return AddFactureSelectedProductWidget(product: entateProvider.addFactureProducts![index]);
      },
    );
  }

  Widget _buildBottomBar(
    double width,
    BuildContext context,
    FactureEntateViewModel entateProvider,
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
                Text(
                  '${formatter.format(entateProvider.totalFacture)} DA',
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
          Row(
            children: [
              _modernBlueActionButton(
                width: width,
                icon: Icons.restart_alt_rounded,
                label: 'Reset',
                accent: Colors.orangeAccent,
                onTap: () {
                  entateProvider.resetAddFacture();
                },
              ),
              _modernBlueActionButton(
                width: width,
                icon: Icons.add_shopping_cart_rounded,
                label: 'Ajouter',
                accent: Colors.white,
                onTap: () {
                  if (entateProvider.addFactureClient == null) {
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
                        builder: (_) => const AddFactureProducts(),
                      ),
                    );
                  }
                },
              ),
              _modernBlueActionButton(
                width: width,
                icon: Icons.qr_code_rounded,
                label: 'Scanner',
                accent: Colors.cyanAccent,
                onTap: () async {
                  if (entateProvider.addFactureClient == null) {
                    Toast(
                      title: 'Sélectionner un client d\'abord',
                      style: ToastificationStyle.minimal,
                      type: ToastificationType.warning,
                      context: context,
                    );
                  } else {
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
                      entateProvider.scanProduct(context, rawContent);
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
                  if (entateProvider.addFactureProducts!.isNotEmpty && entateProvider.addFactureClient != null) {
                    entateProvider.setSelectedT(
                        tipe: entateProvider.listTipe.firstWhere((element) => element.tipeno == 1));
                    await entateProvider.defalutDate();
                    await entateProvider.getJournals(context);
                    await entateProvider.getSites(context);
                    await entateProvider.getcodebon(context);

                    Navigator.push(context, MaterialPageRoute(builder: (builder) => SaveFacturePage()));
                  } else {
                    Toast(
                        title: "Client et articles requis",
                        style: ToastificationStyle.minimal,
                        type: ToastificationType.warning,
                        context: context);
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
                  style: TextStyle(color: accent, fontWeight: FontWeight.w600, fontSize: width * 0.03),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
