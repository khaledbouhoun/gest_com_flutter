import 'package:flutter/material.dart';
import 'package:gestion_stock/models/commande_product.dart';
import 'package:gestion_stock/view_models/facture_entate_view_model.dart';
import 'package:gestion_stock/widgets/add_facture_selected_product_edit_dialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddFactureSelectedProductWidget extends StatelessWidget {
  final CommandeProduct product;
  const AddFactureSelectedProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    NumberFormat formatter = NumberFormat('#,##0.00', "fr");
    bool isNegative = product.negative;

    return Container(
      width: width,
      margin: EdgeInsets.only(top: width * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isNegative
              ? Colors.red.withOpacity(0.3)
              : Colors.grey.withOpacity(0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            AddFactureSelectedProductEditDialog(product: product)
                .showEditDialog(context);
          },
          child: Padding(
            padding: EdgeInsets.all(width * 0.03),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Text(
                    product.product.ARTNOM!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: width * 0.032,
                      color: const Color(0xFF2d3436),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: width * 0.05,
                  color: Colors.grey[200],
                  margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    product.quantity.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.035,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: width * 0.05,
                  color: Colors.grey[200],
                  margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    formatter.format(product.product.ARTPRIX!),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: width * 0.035,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    var provider = Provider.of<FactureEntateViewModel>(context,
                        listen: false);
                    provider.addFactureProducts!
                        .removeWhere((element) => element == product);
                    provider.notifyListeners();
                  },
                  icon: const Icon(Icons.remove_circle_rounded,
                      color: Colors.redAccent),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  iconSize: width * 0.06,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
