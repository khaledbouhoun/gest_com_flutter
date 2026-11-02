import 'package:flutter/material.dart';
import 'package:gestion_stock/models/commande_product.dart';
import 'package:gestion_stock/models/product.dart';
import 'package:gestion_stock/view_models/facture_entate_view_model.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:gestion_stock/widgets/toast.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../models/tarif_entate.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';

class AddFactureSelectedProductEditDialog extends StatefulWidget {
  final CommandeProduct product;
  const AddFactureSelectedProductEditDialog({super.key, required this.product});
  @override
  State<StatefulWidget> createState() =>
      AddFactureSelectedProductEditDialogPage();

  void showEditDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddFactureSelectedProductEditDialog(
            product: product,
          );
        });
  }
}

class AddFactureSelectedProductEditDialogPage
    extends State<AddFactureSelectedProductEditDialog> {
  TextEditingController price = TextEditingController();
  TextEditingController qte = TextEditingController();

  @override
  void initState() {
    super.initState();
    price.text = widget.product.product.ARTPRIX.toString();
    qte.text = widget.product.quantity.toString();

    // Auto-select quantity when dialog opens
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

    return Consumer3<FactureEntateViewModel, StockViewModel, AuthViewModel>(
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
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        vertical: width * 0.05, horizontal: width * 0.06),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).secondaryHeaderColor,
                          Theme.of(context).secondaryHeaderColor
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.edit_note_rounded,
                            color: Colors.white, size: width * 0.1),
                        SizedBox(height: width * 0.02),
                        Text(
                          widget.product.product.ARTNOM ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
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
                        // --- Tarif Selection ---
                        _buildLabel(
                            'Tarif affecté', Icons.sell_rounded, context),
                        SizedBox(height: width * 0.02),
                        _buildCustomDropdown(
                            width, stockProvider, entateProvider),

                        SizedBox(height: width * 0.05),

                        // --- Price Input ---
                        _buildLabel('Prix Unitaire TTC', Icons.payments_rounded,
                            context),
                        SizedBox(height: width * 0.02),
                        _buildInputField(
                          controller: price,
                          icon: Icons.edit_rounded,
                          suffixText: 'DA',
                          onChanged: (value) {
                            widget.product.product.ARTPRIX =
                                double.tryParse(value) ?? 0.0;
                          },
                        ),

                        SizedBox(height: width * 0.05),

                        // --- Quantity Input ---
                        _buildLabel('Quantité souhaitée',
                            Icons.inventory_2_rounded, context),
                        SizedBox(height: width * 0.02),
                        _buildInputField(
                          controller: qte,
                          icon: Icons.add_rounded,
                          autofocus: true,
                          onChanged: (qty) => _handleQuantityChange(
                              qty, stockProvider, authProvider, entateProvider),
                        ),

                        SizedBox(height: width * 0.08),

                        // --- Action Button ---
                        SizedBox(
                          width: double.infinity,
                          height: width * 0.13,
                          child: ElevatedButton(
                            onPressed: () => _confirmChanges(entateProvider),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).secondaryHeaderColor,
                                    Theme.of(context).secondaryHeaderColor
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .secondaryHeaderColor
                                        .withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  'Valider la modification',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
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

  Widget _buildLabel(String text, IconData icon, BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF14AAF0)),
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
        border: Border.all(
            color: const Color(0xFF14AAF0).withOpacity(0.1), width: 1.5),
      ),
      child: TextFormField(
        controller: controller,
        autofocus: autofocus,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Color(0xFF2D3436)),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF14AAF0), size: 18),
          suffixText: suffixText,
          suffixStyle: const TextStyle(
              fontWeight: FontWeight.bold, color: Color(0xFF14AAF0)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildCustomDropdown(double width, StockViewModel stockProvider,
      FactureEntateViewModel entateProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F9FC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFF14AAF0).withOpacity(0.1), width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: widget.product.tarif,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF14AAF0)),
          onChanged: (String? tarif) async {
            if (tarif == null) return;
            widget.product.tarif = tarif;
            await entateProvider.updateAddedProduct(context,
                const Duration(seconds: 10), widget.product.product, tarif);

            _updatePriceBasedOnTarif(tarif, stockProvider, entateProvider);
          },
          items: stockProvider.tarifs
                  ?.map<DropdownMenuItem<String>>((TarifEntate tarif) {
                return DropdownMenuItem<String>(
                  value: tarif.TFENO,
                  child: Text(
                    tarif.TFENOM,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3436)),
                  ),
                );
              }).toList() ??
              [],
        ),
      ),
    );
  }

  void _updatePriceBasedOnTarif(String tarif, StockViewModel stockProvider,
      FactureEntateViewModel entateProvider) {
    var prix = 0.0;
    var base = 0.0;

    final selectedTarifDetail =
        stockProvider.tarifs!.firstWhere((element) => element.TFENO == tarif);

    switch (selectedTarifDetail.TFETYPE) {
      case 0:
        prix = widget.product.product.TFDPRIXTTC ?? 0.0;
        break;
      case 1:
        switch (widget.product.product.TFDBASE) {
          case 0:
            base = widget.product.product.ARTPMP ?? 0.0;
            break;
          case 1:
            base = widget.product.product.ARTDPA ?? 0.0;
            break;
          case 2:
            base = widget.product.product.ARTPAP ?? 0.0;
            break;
        }
        prix =
            base * (1 + (widget.product.product.TFDPRIX ?? 0.0) / 100);
    }

    widget.product.product.ARTPRIX = prix;
    price.text = prix.toStringAsFixed(2);

    entateProvider.totalFacture = 0;
    for (var element in entateProvider.addFactureProducts!) {
      entateProvider.totalFacture += (element.product.ARTPRIX ?? 0.0);
    }
    entateProvider.notifyListeners();
  }

  void _handleQuantityChange(String qty, StockViewModel stockProvider,
      AuthViewModel authProvider, FactureEntateViewModel entateProvider) {
    final parsedQty = (double.tryParse(qty) ?? 0).toInt();
    if (qty.isEmpty || parsedQty < 0) return;

    final productInStock = stockProvider.filteredProducts.firstWhere(
      (element) => element.ARTNO == widget.product.product.ARTNO,
      orElse: () => widget.product.product,
    );

    final currentTheorStock = productInStock.ARTQTETHEOR ?? 0;

    if (parsedQty <= currentTheorStock) {
      widget.product.quantity = parsedQty;
      entateProvider.notify();
    } else {
      _handleStockWarning(
          parsedQty, currentTheorStock, authProvider, entateProvider);
    }
  }

  void _handleStockWarning(int parsedQty, double currentTheorStock,
      AuthViewModel authProvider, FactureEntateViewModel entateProvider) {
    final sellSettings = authProvider.sellSettings!;

    if (sellSettings.PRMAUTSTKNEG == 0) {
      qte.text = currentTheorStock.toInt().toString();
      widget.product.quantity = currentTheorStock.toInt();
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
      widget.product.quantity = parsedQty;
    } else {
      // Logic for ART_AUT_STK_NEG_AB
      if (widget.product.product.ARTAUTSTKNEGAB == 1) {
        if (sellSettings.PRMAUTSTKNEGAVERTAB == 1) {
          Toast(
              title: 'Quantité insuffisante (Autorisé par article)',
              style: ToastificationStyle.minimal,
              type: ToastificationType.warning,
              context: context);
        }
        widget.product.quantity = parsedQty;
      } else {
        Toast(
            title: 'Quantité insuffisante',
            style: ToastificationStyle.minimal,
            type: ToastificationType.warning,
            context: context);
      }
    }
    entateProvider.notify();
  }

  void _confirmChanges(FactureEntateViewModel entateProvider) {
    if (qte.text.isEmpty) {
      Toast(
          title: 'Quantité invalide',
          style: ToastificationStyle.minimal,
          type: ToastificationType.error,
          context: context);
      return;
    }

    widget.product.quantity = (double.tryParse(qte.text) ?? 0).toInt();

    entateProvider.notify();
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }
}
