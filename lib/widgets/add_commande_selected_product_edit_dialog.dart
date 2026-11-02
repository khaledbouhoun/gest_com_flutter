import 'package:flutter/material.dart';
import 'package:gestion_stock/models/commande_product.dart';
import 'package:gestion_stock/models/tarif_detail.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/commande_entate_view_model.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:gestion_stock/widgets/toast.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../models/tarif_entate.dart';

class AddCommandeSelectedProductEditDialog extends StatefulWidget {
  final CommandeProduct commondProduct;
  const AddCommandeSelectedProductEditDialog({super.key, required this.commondProduct});
  @override
  State<StatefulWidget> createState() => AddCommandeSelectedProductEditDialogPage();

  void showEditDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddCommandeSelectedProductEditDialog(
            commondProduct: commondProduct,
          );
        });
  }
}

class AddCommandeSelectedProductEditDialogPage extends State<AddCommandeSelectedProductEditDialog> {
  TextEditingController price = TextEditingController();
  TextEditingController qte = TextEditingController();
  List<TarifDetail> tarifsDetails = [];

  @override
  void initState() {
    super.initState();
    price.text = widget.commondProduct.product.ARTPRIX!.toStringAsFixed(2);
    qte.text = widget.commondProduct.quantity.toStringAsFixed(2);
    tarifsDetails = widget.commondProduct.tarifs;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        qte.selection = TextSelection(
          baseOffset: 0,
          extentOffset: qte.text.length,
        );
      }
    });
  }

  @override
  void dispose() {
    price.dispose();
    qte.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Consumer3<CommandeEntateViewModel, StockViewModel, AuthViewModel>(
      builder: (context, entateProvider, stockProvider, authProvider, child) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: width * 0.08),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: width * 0.05, horizontal: width * 0.06),
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.shopping_cart_checkout_rounded, color: Colors.white, size: width * 0.1),
                        SizedBox(height: width * 0.02),
                        Text(
                          widget.commondProduct.product.ARTNOM!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(width * 0.06),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Tarif Commande', Icons.sell_rounded),
                        SizedBox(height: width * 0.02),
                        _buildCustomDropdown(stockProvider, entateProvider, authProvider),
                        SizedBox(height: width * 0.05),
                        _buildLabel('Prix Unitaire TTC', Icons.payments_rounded),
                        SizedBox(height: width * 0.02),
                        _buildInputField(
                          controller: price,
                          icon: Icons.edit_rounded,
                          suffixText: 'DA',
                          onChanged: (value) {
                            widget.commondProduct.product.ARTPRIX = double.tryParse(value) ?? 0.0;
                          },
                        ),
                        SizedBox(height: width * 0.05),
                        _buildLabel('Quantité souhaitée', Icons.inventory_2_rounded),
                        SizedBox(height: width * 0.02),
                        _buildInputField(
                          controller: qte,
                          icon: Icons.add_rounded,
                          autofocus: true,
                          onChanged: (qty) => _handleQuantityChange(qty, stockProvider, authProvider, entateProvider),
                        ),
                        SizedBox(height: width * 0.08),
                        SizedBox(
                          width: double.infinity,
                          height: width * 0.13,
                          child: ElevatedButton(
                            onPressed: () => _confirmChanges(entateProvider),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: Theme.of(context).secondaryHeaderColor,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  'Valider la commande',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).secondaryHeaderColor),
        const SizedBox(width: 8),
        Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Color(0xFF636e72),
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    bool autofocus = false,
    String? suffixText,
    Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F9FC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.1), width: 1.5),
      ),
      child: TextFormField(
        controller: controller,
        autofocus: autofocus,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3436)),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Theme.of(context).secondaryHeaderColor, size: 18),
          suffixText: suffixText,
          suffixStyle: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).secondaryHeaderColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildCustomDropdown(
      StockViewModel stockProvider, CommandeEntateViewModel entateProvider, AuthViewModel authProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F9FC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.1), width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: widget.commondProduct.tarif,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: Theme.of(context).secondaryHeaderColor),
          onChanged: (String? newValue) async {
            if (newValue == null) return;

            widget.commondProduct.tarif = newValue;
            // var productViewModel = Provider.of<ProductViewModel>(context, listen: false);

            TarifEntate currentTarif = stockProvider.tarifs!.firstWhere(
              (element) => element.TFENO == newValue,
              orElse: () => stockProvider.tarifs!.first,
            );

            var prix = 0.0;
            var base = 0.0;
            final product = widget.commondProduct.product;

            TarifDetail productDetails = tarifsDetails.firstWhere((element) => element.tfdtfe == newValue);
            switch (currentTarif.TFETYPE) {
              case 0:
                prix = productDetails.ttc ?? 0.0;
                break;
              case 1:
                switch (currentTarif.TFEBASE.toInt()) {
                  case 0:
                    base = product.ARTPMP ?? 0.0;
                    break;
                  case 1:
                    base = product.ARTDPA ?? 0.0;
                    break;
                  case 2:
                    base = product.ARTPAP ?? 0.0;
                    break;
                }
                prix = base * (1 + (productDetails.marge) / 100);
                break;
            }

            setState(() {
              product.ARTPRIX = prix;
              price.text = prix.toStringAsFixed(2);

              entateProvider.totalCommande =
                  entateProvider.addCommandeProducts.fold(0.0, (sum, item) => sum + (item.product.ARTPRIX ?? 0.0));
            });

            entateProvider.notify();
          },
          items: stockProvider.filterTarifs().map<DropdownMenuItem<String>>((TarifEntate tarif) {
                return DropdownMenuItem<String>(
                  value: tarif.TFENO,
                  child: Text(
                    tarif.TFENOM,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2D3436)),
                  ),
                );
              }).toList() ??
              [],
        ),
      ),
    );
  }

  void _handleQuantityChange(
      String qty, StockViewModel stockProvider, AuthViewModel authProvider, CommandeEntateViewModel entateProvider) {
    final parsedQty = (double.tryParse(qty) ?? 0).toInt();
    if (qty.isEmpty || parsedQty < 0) return;

    final productInStock = stockProvider.filteredProducts.firstWhere(
      (element) => element.ARTNO == widget.commondProduct.product.ARTNO,
      orElse: () => widget.commondProduct.product,
    );

    final currentTheorStock = productInStock.ARTQTETHEOR ?? 0;

    if (parsedQty <= currentTheorStock) {
      widget.commondProduct.quantity = parsedQty;
    } else {
      _handleStockWarning(parsedQty, currentTheorStock, authProvider);
    }
    entateProvider.notify();
  }

  void _handleStockWarning(int parsedQty, double currentTheorStock, AuthViewModel authProvider) {
    final sellSettings = authProvider.sellSettings!;

    if (sellSettings.PRMAUTSTKNEG == 0) {
      qte.text = currentTheorStock.toInt().toString();
      widget.commondProduct.quantity = currentTheorStock.toInt();
      Toast(
          title: 'Quantité insuffisante',
          style: ToastificationStyle.minimal,
          type: ToastificationType.warning,
          context: context);
    } else if (sellSettings.PRMAUTSTKNEG == 1) {
      if (sellSettings.PRMAUTSTKNEGAVERTAB == 1) {
        Toast(
            title: 'Quantité insuffisante (Stock Négatif Autorisé)',
            style: ToastificationStyle.minimal,
            type: ToastificationType.warning,
            context: context);
      }
      widget.commondProduct.quantity = parsedQty;
    } else {
      if (widget.commondProduct.product.ARTAUTSTKNEGAB == 1) {
        if (sellSettings.PRMAUTSTKNEGAVERTAB == 1) {
          Toast(
              title: 'Quantité insuffisante (Autorisé par article)',
              style: ToastificationStyle.minimal,
              type: ToastificationType.warning,
              context: context);
        }
        widget.commondProduct.quantity = parsedQty;
      } else {
        Toast(
            title: 'Quantité insuffisante',
            style: ToastificationStyle.minimal,
            type: ToastificationType.warning,
            context: context);
      }
    }
  }

  void _confirmChanges(CommandeEntateViewModel entateProvider) {
    entateProvider.notify();
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }
}
