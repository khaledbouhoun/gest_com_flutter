import 'package:flutter/material.dart';
import 'package:gestion_stock/models/commande_product.dart';
import 'package:gestion_stock/view_models/commande_entate_view_model.dart';
import 'package:gestion_stock/widgets/add_commande_selected_product_edit_dialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddCommandeSelectedProductWidget extends StatelessWidget {
  final CommandeProduct product;
  AddCommandeSelectedProductWidget({super.key, required this.product});

  final TextEditingController qte = TextEditingController();

  @override
  Widget build(BuildContext context) {
    qte.text = product.quantity.toString();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    NumberFormat formatter = NumberFormat('#,##0.00', "fr");
    return TextButton(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
      ),
      onPressed: () {
        AddCommandeSelectedProductEditDialog editDialog = AddCommandeSelectedProductEditDialog(commondProduct: product);
        editDialog.showEditDialog(context);
      },
      child: Container(
        width: width,
        height: height / 17,
        padding: EdgeInsets.only(
          left: width * 0.02,
          top: width * 0.02,
          bottom: width * 0.02,
          right: width * 0.02,
        ),
        margin: EdgeInsets.only(top: width * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
              stops: const [0.01, 0.01], colors: [product.negative ? Colors.red : Colors.white, Colors.white]),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.product.ARTNOM!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: width * 0.03, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: width * 0.01),
                decoration: BoxDecoration(border: Border(left: BorderSide(width: width * 0.002, color: Colors.grey))),
                child: Text(
                  product.quantity.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.035, color: Colors.black),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: width * 0.0035),
                decoration: BoxDecoration(border: Border(left: BorderSide(width: width * 0.002, color: Colors.grey))),
                child: Text(
                  formatter.format(product.product.ARTPRIX ?? 0.0),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.035, color: Colors.black),
                ),
              ),
            ),
            _buildRemoveButton(context, product)
          ],
        ),
      ),
    );
  }
}

Widget _buildRemoveButton(BuildContext context, CommandeProduct product) {
  return Consumer<CommandeEntateViewModel>(
    builder: (context, entateProvider, child) {
      return IconButton(
        icon: const Icon(
          Icons.remove_circle_rounded,
          color: Colors.red,
          size: 26,
        ),
        splashRadius: 22,
        tooltip: "Remove product",
        onPressed: () {
          entateProvider.addCommandeProducts.removeWhere((element) => element == product);

          entateProvider.notifyListeners();
        },
      );
    },
  );
}
