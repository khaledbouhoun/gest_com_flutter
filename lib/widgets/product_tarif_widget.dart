import 'package:flutter/material.dart';
import 'package:gestion_stock/models/tarif_detail.dart';
import 'package:gestion_stock/widgets/added_product_tarif_dialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'modified_product_tarif_dialog.dart';

class ProductTarifWidget extends StatelessWidget {
  ProductTarifWidget({super.key, this.tarif, this.direction});

  TarifDetail? tarif;
  int? direction;

  @override
  Widget build(BuildContext context) {
    if (tarif == null) return const SizedBox.shrink();

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    NumberFormat formatter = NumberFormat('#,##0.00', "fr");
    var provider = Provider.of<StockViewModel>(context, listen: false);

    String tarifNom = "Tarif inconnu";
    try {
      tarifNom = provider.tarifs!
          .firstWhere((element) => element.TFENO == tarif!.tfdtfe)
          .TFENOM;
    } catch (e) {
      print("Error finding tarif name: $e");
    }

    return TextButton(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
      ),
      onPressed: () {
        if (direction == 1) {
          AddedProductTarifDialog addedProductTarifDialog =
              AddedProductTarifDialog(tarif: tarif);
          addedProductTarifDialog.showEditDialog(context);
        } else {
          ModifiedProductTarifDialog modifiedProductTarifDialog =
              ModifiedProductTarifDialog(tarif: tarif);
          modifiedProductTarifDialog.showEditDialog(context);
        }
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
        margin: EdgeInsets.only(bottom: width * 0.04),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    tarifNom,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: width * 0.04,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(left: width * 0.0035),
                child: Text(
                  '${formatter.format(tarif!.ttc)} DA',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.035,
                      color: Colors.black),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).secondaryHeaderColor,
            )
          ],
        ),
      ),
    );
  }
}
