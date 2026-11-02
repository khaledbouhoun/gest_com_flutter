import 'package:flutter/material.dart';
import 'package:gestion_stock/models/commande_product.dart';
import 'package:gestion_stock/view_models/reception_entate_view_model.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:gestion_stock/widgets/toast.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';

class AddReceptionSelectedProductEditDialog extends StatefulWidget {
  final CommandeProduct product;
  const AddReceptionSelectedProductEditDialog({super.key, required this.product});
  @override
  State<StatefulWidget> createState() =>
      AddReceptionSelectedProductEditDialogPage();

  void showEditDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddReceptionSelectedProductEditDialog(
            product: product,
          );
        });
  }
}

class AddReceptionSelectedProductEditDialogPage
    extends State<AddReceptionSelectedProductEditDialog> {
  TextEditingController price = TextEditingController();
  TextEditingController qte = TextEditingController();

  @override
  void initState() {
    super.initState();
    price.text = widget.product.product.ARTPRIX.toString();
    qte.text = widget.product.quantity.toString();

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

    return Consumer3<ReceptionEntateViewModel, StockViewModel, AuthViewModel>(
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
                  // Header
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
                        Icon(Icons.receipt_long_rounded,
                            color: Colors.white, size: width * 0.1),
                        SizedBox(height: width * 0.02),
                        Text(
                          widget.product.product.ARTNOM ?? '',
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
                        _buildLabel(
                            'Prix d\'Achat Unitaire', Icons.payments_rounded),
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
                        _buildLabel('Quantité reçue', Icons.inventory_rounded),
                        SizedBox(height: width * 0.02),
                        _buildInputField(
                          controller: qte,
                          icon: Icons.add_rounded,
                          autofocus: true,
                          onChanged: (qty) {
                            final parsedQty =
                                (double.tryParse(qty) ?? 0).toInt();
                            if (qty.isNotEmpty && parsedQty >= 0) {
                              widget.product.quantity = parsedQty;
                              entateProvider.notify();
                            }
                          },
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
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Theme.of(context).secondaryHeaderColor,
                                  Theme.of(context).secondaryHeaderColor
                                ]),
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
                                  'Confirmer la réception',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
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
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).secondaryHeaderColor,
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
            color: Theme.of(context).secondaryHeaderColor.withOpacity(0.1),
            width: 1.5),
      ),
      child: TextFormField(
        controller: controller,
        autofocus: autofocus,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Color(0xFF2D3436)),
        decoration: InputDecoration(
          prefixIcon: Icon(icon,
              color: Theme.of(context).secondaryHeaderColor, size: 18),
          suffixText: suffixText,
          suffixStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).secondaryHeaderColor),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: onChanged,
      ),
    );
  }

  void _confirmChanges(ReceptionEntateViewModel entateProvider) {
    entateProvider.notify();
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }
}
