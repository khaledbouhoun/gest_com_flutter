import 'package:flutter/material.dart';
import 'package:gestion_stock/models/client.dart';
import 'package:gestion_stock/view_models/facture_entate_view_model.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:gestion_stock/views/facture_entate/add_facture.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddFactureClientWidget extends StatelessWidget {
  final Client? client;

  const AddFactureClientWidget({super.key, this.client});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    NumberFormat formatter = NumberFormat('#,##0.00', "fr");
    return TextButton(
        style: ButtonStyle(
            padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
            overlayColor: WidgetStateProperty.all<Color>(Colors.transparent)),
        onPressed: () {
          var entateProvider =
              Provider.of<FactureEntateViewModel>(context, listen: false);
          FocusScope.of(context).unfocus();
          Map<String, dynamic> map = client!.toJson();
          entateProvider.addFactureClient = Client.fromJson(map);
          if (entateProvider.addFactureClient!.CLITARIFAB == '..' ||
              entateProvider.addFactureClient!.CLITARIFAB == '') {
            entateProvider.addSelectedTarif =
                Provider.of<StockViewModel>(context, listen: false)
                    .defaultTarif!
                    .TFENO;
          } else {
            entateProvider.addSelectedTarif =
                Provider.of<StockViewModel>(context, listen: false)
                    .tarifs!
                    .firstWhere((element) =>
                        element.TFENO ==
                        entateProvider.addFactureClient!.CLITARIFAB)
                    .TFENO;
          }
          entateProvider.notifyListeners();
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => const AddFacture()));
        },
        child: Container(
          width: width,
          height: height / 12.5,
          padding: EdgeInsets.all(width * 0.01),
          margin: EdgeInsets.only(top: width * 0.04),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            children: [
              Expanded(
                  flex: 6,
                  child: Text(
                    '${client!.CLINOM} ${client!.CLIPRENOM}',
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.04,
                        color: Colors.black),
                  )),
              Expanded(
                flex: 3,
                child: Text(
                  '${formatter.format(client!.CLISOLDE)} DA',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.035,
                      color: client!.CLISOLDE >= 0 ? Colors.black : Colors.red),
                ),
              )
            ],
          ),
        ));
  }
}
