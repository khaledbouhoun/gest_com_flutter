import 'package:flutter/material.dart';
import 'package:gestion_stock/models/commande_product.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/facture_entate_view_model.dart';
import 'package:gestion_stock/views/facture_entate/add_facture.dart';
import 'package:gestion_stock/widgets/toast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../models/product.dart';

class AddFactureProductWidget extends StatelessWidget {
  final Product? product;
  const AddFactureProductWidget({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    var entateProvider =
        Provider.of<FactureEntateViewModel>(context, listen: false);
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    NumberFormat formatter = NumberFormat('#,##0.00', "fr");

    return Container(
      width: width,
      margin: EdgeInsets.only(top: width * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).secondaryHeaderColor.withOpacity(0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            FocusScope.of(context).unfocus();

            if (!entateProvider.addFactureProducts!
                .any((element) => element.product.ARTNO == product!.ARTNO)) {
              if (product!.ARTQTETHEOR! <= 0) {
                if (authProvider.sellSettings!.PRMAUTSTKNEGAB == 0) {
                  Toast(
                      title: 'Quantité insuffisante',
                      style: ToastificationStyle.minimal,
                      type: ToastificationType.warning,
                      context: context);
                } else {
                  entateProvider.addFactureProducts!.add(CommandeProduct(
                    product: product!,
                    quantity: 1,
                    tarif: entateProvider.addSelectedTarif,
                    negative: true,
                  ));
                  entateProvider.notifyListeners();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const AddFacture()));
                }
              } else {
                entateProvider.addFactureProducts!.add(CommandeProduct(
                  product: product!,
                  quantity: 1,
                  tarif: entateProvider.addSelectedTarif,
                ));
                entateProvider.notifyListeners();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const AddFacture()));
              }
            } else {
              int index = entateProvider.addFactureProducts!.indexWhere(
                  (element) => element.product.ARTNO == product!.ARTNO);
              entateProvider.addFactureProducts![index].quantity += 1;
              entateProvider.notifyListeners();
              Navigator.push(context,
                  MaterialPageRoute(builder: (builder) => const AddFacture()));
            }
          },
          child: Padding(
            padding: EdgeInsets.all(width * 0.03),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product!.ARTNOM ?? 'N/A',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.04,
                          color: const Color(0xFF2d3436),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: width * 0.01),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              product!.ARTNO ?? '',
                              style: TextStyle(
                                fontSize: width * 0.03,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          Expanded(
                            child: Text(
                              product!.ARTREF ?? '',
                              style: TextStyle(
                                fontSize: width * 0.03,
                                color: Colors.grey[500],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: width * 0.1,
                  color: Colors.grey[200],
                  margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${formatter.format(product!.ARTPRIX ?? 0)} DA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.035,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                      SizedBox(height: width * 0.01),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: (product!.ARTQTETHEOR ?? 0) > 0
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          formatter.format(product!.ARTQTETHEOR ?? 0),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.032,
                            color: (product!.ARTQTETHEOR ?? 0) > 0
                                ? Colors.green[700]
                                : Colors.red[700],
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
      ),
    );
  }
}
