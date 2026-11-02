import 'package:flutter/material.dart';
import 'package:gestion_stock/models/commande_product.dart';
import 'package:gestion_stock/models/product.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/commande_entate_view_model.dart';
import 'package:gestion_stock/view_models/product_view_model.dart';
import 'package:gestion_stock/views/command/add_commande.dart';
import 'package:gestion_stock/widgets/toast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class AddCommandeProductWidget extends StatelessWidget {
  final Product product;
  const AddCommandeProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    var entateProvider = Provider.of<CommandeEntateViewModel>(context, listen: false);
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    NumberFormat formatter = NumberFormat('#,##0.00', "fr");
    return TextButton(
        style: ButtonStyle(
            padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
            overlayColor: WidgetStateProperty.all<Color>(Colors.transparent)),
        onPressed: () async {
          FocusScope.of(context).unfocus();

          if (authProvider.sellSettings == null) {
            Toast(
              title: 'Erreur interne: données manquantes',
              style: ToastificationStyle.minimal,
              type: ToastificationType.error,
              context: context,
            );
            return;
          }

          final productViewModel = Provider.of<ProductViewModel>(context, listen: false);

          await productViewModel.getProductTarifs(
            context,
            product.ARTNO!,
          );

          final tarifs = productViewModel.selectedProductTarifs;

          final existingProduct =
              entateProvider.addCommandeProducts.where((item) => item.product.ARTNO == product.ARTNO).firstOrNull;

          if (existingProduct == null) {
            entateProvider.addCommandeProducts.add(
              CommandeProduct(
                product: product,
                tarifs: tarifs,
                quantity: 1,
                tarif: authProvider.getTarifPerDefault(),
                negative: true,
              ),
            );
          } else {
            final maxQuantity = product.ARTQTETHEOR ?? 0.0;

            if (existingProduct.quantity < maxQuantity) {
              existingProduct.quantity++;
              existingProduct.negative = true;
            }
          }

          entateProvider.notifyListeners();

          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddCommande(),
              ),
            );
          }
        },
        child: Container(
          width: width,
          padding: EdgeInsets.all(width * 0.02),
          margin: EdgeInsets.only(top: width * 0.04),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Theme.of(context).secondaryHeaderColor, width: 1)),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      maxLines: 3,
                      product.ARTNOM ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.04, color: Colors.black),
                    ),
                    Text(
                      '${product.ARTNO ?? ''} / ${product.ARTREF ?? ''}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.035, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.only(left: width * 0.0035),
                  decoration: BoxDecoration(border: Border(left: BorderSide(width: width * 0.002, color: Colors.grey))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${formatter.format(product.ARTPRIX ?? 0)} DA',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.035,
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                      Text(
                        formatter.format(product.ARTQTETHEOR ?? 0),
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.035, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
