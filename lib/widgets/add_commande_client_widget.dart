import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/commande_entate_view_model.dart';
import 'package:gestion_stock/views/command/add_commande.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddCommandeClientWidget extends StatelessWidget {
  final dynamic client;
  const AddCommandeClientWidget({super.key, required this.client});

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
          var entateProvider = Provider.of<CommandeEntateViewModel>(context, listen: false);
          FocusScope.of(context).unfocus();
          entateProvider.addCommandeClient = client;
          // Set default or selected tarif if needed (optional, based on your business logic)
          entateProvider.notifyListeners();
          Navigator.push(context, MaterialPageRoute(builder: (builder) => const AddCommande()));
        },
        child: Container(
          width: width,
          height: height / 12.5,
          padding: EdgeInsets.all(width * 0.01),
          margin: EdgeInsets.only(top: width * 0.04),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            children: [
              Expanded(
                  flex: 6,
                  child: Text(
                    '${client.CLINOM ?? ""} ${client.CLIPRENOM ?? ""}',
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.04, color: Colors.black),
                  )),
              Expanded(
                flex: 3,
                child: Text(
                  '${formatter.format(client.CLISOLDE ?? 0)} DA',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: width * 0.035, color: (client.CLISOLDE ?? 0) >= 0 ? Colors.black : Colors.red),
                ),
              )
            ],
          ),
        ));
  }
}
