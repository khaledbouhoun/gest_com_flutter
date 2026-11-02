import 'package:flutter/material.dart';
import 'package:gestion_stock/models/tarif_entate.dart';
import 'package:gestion_stock/view_models/facture_entate_view_model.dart';
import 'package:provider/provider.dart';
import '../models/exercice.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';

class TarifSelector extends StatelessWidget {
  const TarifSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Consumer2<FactureEntateViewModel, StockViewModel>(builder: (context, entateProvider, stockProvider, child) {
      return Container(
        padding: EdgeInsets.only(left: width * 0.009),
        width: width * 0.35,
        height: width * 0.06,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
        child: DropdownButton<String>(
          value: entateProvider.addSelectedTarif,
          underline: Container(),
          isExpanded: true,
          onChanged: (String? tarif) async {
            entateProvider.addSelectedTarif = tarif;
            entateProvider.notifyListeners();
            await stockProvider.getStock(
              context,
              Exercice(EXENO: DateTime.now().year),
              vente: true,
            );
          },
          items: stockProvider.tarifs!.map<DropdownMenuItem<String>>((TarifEntate tarif) {
            return DropdownMenuItem<String>(
              value: tarif.TFENO,
              child: Container(
                //padding: EdgeInsets.only(left: width * 0.02),
                width: width * 0.8,
                decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Text(
                  tarif.TFENOM,
                  style: TextStyle(
                    fontSize: width * 0.035,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}
