import 'package:flutter/material.dart';
import 'package:gestion_stock/models/fournisseur.dart';

import 'package:gestion_stock/view_models/reception_entate_view_model.dart';
import 'package:gestion_stock/views/reception_entate/add_receptions.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddReceptionsFournisseurWidget extends StatelessWidget {
  Fournisseur? fournisseur;

  AddReceptionsFournisseurWidget({super.key, this.fournisseur});

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
          var entateProvider = Provider.of<ReceptionEntateViewModel>(context, listen: false);
          FocusScope.of(context).unfocus();
          Map<String, dynamic> map = fournisseur!.toJson();
          entateProvider.addReceptionFournisseur = Fournisseur.fromJson(map);

          entateProvider.notifyListeners();
          Navigator.push(context, MaterialPageRoute(builder: (builder) => AddReceptions()));
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
                    '${fournisseur!.FOUNOM} ${fournisseur!.FOUPRENOM}',
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.04, color: Colors.black),
                  )),
              Expanded(
                flex: 3,
                child: Text(
                  '${formatter.format(fournisseur!.FOUSOLDE)} DA',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: width * 0.035, color: fournisseur!.FOUSOLDE >= 0 ? Colors.black : Colors.red),
                ),
              )
            ],
          ),
        ));
  }
}
