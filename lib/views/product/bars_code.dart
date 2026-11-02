import 'package:flutter/material.dart';
import 'package:gestion_stock/views/product/product_details.dart';
import 'package:provider/provider.dart';
import 'package:gestion_stock/view_models/product_view_model.dart';
import '../../widgets/detail_card.dart';

class BarsCode extends StatelessWidget {
  const BarsCode({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    var provider = Provider.of<ProductViewModel>(context, listen: false);
    List details = [
      {'Code à barre 01': provider.selectedProduct!.ARTCAB},
      {'Code à barre 02': provider.selectedProduct!.ARTCAB2},
      {'Code à barre 03': provider.selectedProduct!.ARTCAB3},
      {'Code à barre 04': provider.selectedProduct!.ARTCAB4},
      {'Code à barre 05': provider.selectedProduct!.ARTCAB5},
      {'Code à barre 06': provider.selectedProduct!.ARTCAB6},
      {'Code à barre 07': provider.selectedProduct!.ARTCAB7},
      {'Code à barre 08': provider.selectedProduct!.ARTCAB8},
      {'Code à barre 09': provider.selectedProduct!.ARTCAB9},
      {'Code à barre 10': provider.selectedProduct!.ARTCAB10},
    ];

    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.white,
            ),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            title: Center(
              child: Text(
                Provider.of<ProductViewModel>(context, listen: false)
                    .selectedProduct!
                    .ARTNOM!,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.045,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          body: SizedBox(
            width: width,
            height: height,
            child: Column(
              children: [
                Container(
                  width: width,
                  padding: EdgeInsets.all(width * 0.02),
                  //margin: EdgeInsets.only(bottom: width * 0.02),
                  decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).secondaryHeaderColor,
                            blurRadius: 30.0,
                            offset: const Offset(0.0, 0.75))
                      ]),
                  child: Text(
                    'Code-Barres',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.05,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: details.length,
                        itemBuilder: (context, index) {
                          var key = details[index].keys.first;
                          return DetailCard(
                            title: key,
                            subtitle: details[index][key],
                          );
                        }))
              ],
            ),
          ),
        ));
  }
}
