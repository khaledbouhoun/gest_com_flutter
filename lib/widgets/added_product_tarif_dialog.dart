import 'package:flutter/material.dart';
import 'package:gestion_stock/models/tarif_detail.dart';
import 'package:gestion_stock/view_models/product_view_model.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:provider/provider.dart';

class AddedProductTarifDialog extends StatefulWidget {
  AddedProductTarifDialog({super.key, this.tarif});
  @override
  State<StatefulWidget> createState() => AddedProductTarifDialogPage();
  TarifDetail? tarif;

  void showEditDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddedProductTarifDialog(
            tarif: tarif,
          );
        });
  }
}

class AddedProductTarifDialogPage extends State<AddedProductTarifDialog> {
  late TextEditingController pap;
  late TextEditingController marge;
  late TextEditingController ttc;

  @override
  void initState() {
    super.initState();
    final stockProvider = Provider.of<StockViewModel>(context, listen: false);
    pap = TextEditingController(
        text: stockProvider.newProduct?.ARTPAP.toString() ?? '0');
    marge = TextEditingController(text: widget.tarif?.marge.toString() ?? '0');
    ttc = TextEditingController(text: widget.tarif?.ttc.toString() ?? '0');
  }

  @override
  void dispose() {
    pap.dispose();
    marge.dispose();
    ttc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Consumer2<StockViewModel, ProductViewModel>(
        builder: (context, stockProvider, productProvider, child) {
      return AlertDialog(
        backgroundColor: Theme.of(context).primaryColor,
        content: SingleChildScrollView(
          child: SizedBox(
            width: width * 0.6, //height: height * 0.75,
            child: Column(
              children: [
                /////////////////////////title
                Center(
                  child: Text(
                    stockProvider.tarifs!
                        .firstWhere(
                            (element) => element.TFENO == widget.tarif!.tfdtfe)
                        .TFENOM,
                    style: TextStyle(
                        fontSize: width * 0.045, fontWeight: FontWeight.bold),
                  ),
                ),

                ///////////////////////tarif filter
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Base',
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: width * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: const Color.fromRGBO(4, 103, 138, 1.0)),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: DropdownButton<int>(
                        value:
                            double.parse(widget.tarif!.base.toString()).toInt(),
                        underline: Container(),
                        isExpanded: true,
                        onChanged: (int? base) {
                          setState(() {
                            widget.tarif!.base = base!;
                          });
                        },
                        items: productProvider.bases.map<DropdownMenuItem<int>>(
                            (Map<int, dynamic> base) {
                          return DropdownMenuItem<int>(
                            value: base.keys.first,
                            child: Container(
                              //padding: EdgeInsets.only(left: width * 0.02),
                              width: width * 0.8,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Text(
                                base[base.keys.first],
                                style: TextStyle(
                                  fontSize: width * 0.035,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // /////P.A.P
                    // if (stockProvider.tarifs!
                    //             .firstWhere((element) =>
                    //                 element.TFENO == widget.tarif!['tarif'])
                    //             .TFETYPE !=
                    //         0 &&
                    //     widget.tarif!['base'] == 2)
                    //   Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       SizedBox(
                    //         height: width * 0.03,
                    //       ),
                    //       Text(
                    //         'P.A.P',
                    //         style: TextStyle(
                    //             color: Theme.of(context).secondaryHeaderColor,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //       Container(
                    //         height: width * 0.1,
                    //         decoration: BoxDecoration(
                    //           border: Border.all(
                    //               color:
                    //                   const Color.fromRGBO(4, 103, 138, 1.0)),
                    //           borderRadius: const BorderRadius.all(
                    //             Radius.circular(10),
                    //           ),
                    //         ),
                    //         child: TextFormField(
                    //           controller: pap,
                    //           keyboardType: TextInputType.number,
                    //           decoration: InputDecoration(
                    //               filled: true,
                    //               fillColor: Colors.white,
                    //               border: UnderlineInputBorder(
                    //                   borderRadius: BorderRadius.circular(10),
                    //                   borderSide: BorderSide.none)),
                    //           onEditingComplete: () {
                    //             if (pap.text == '') {
                    //               pap.text = '0';
                    //             }
                    //             stockProvider.newProduct!.ARTPAP =
                    //                 double.parse(pap.text);
                    //             widget.tarif!['marge'] =
                    //                 ((double.parse(ttc.text) -
                    //                             double.parse(pap.text)) /
                    //                         double.parse(pap.text)) *
                    //                     100;
                    //             widget.tarif!['ttc'] = double.parse(pap.text) +
                    //                 double.parse(pap.text) *
                    //                     (double.parse(marge.text) / 100);
                    //             stockProvider.notify();
                    //           },
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // SizedBox(
                    //   height: width * 0.03,
                    // ),

                    // /////Marge
                    // if (stockProvider.tarifs!
                    //             .firstWhere((element) =>
                    //                 element.TFENO == widget.tarif!['tarif'])
                    //             .TFETYPE !=
                    //         0 &&
                    //     widget.tarif!['base'] == 2)
                    //   Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         'Marge',
                    //         style: TextStyle(
                    //             color: Theme.of(context).secondaryHeaderColor,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //       Container(
                    //         height: width * 0.1,
                    //         decoration: BoxDecoration(
                    //           border: Border.all(
                    //               color:
                    //                   const Color.fromRGBO(4, 103, 138, 1.0)),
                    //           borderRadius: const BorderRadius.all(
                    //             Radius.circular(10),
                    //           ),
                    //         ),
                    //         child: TextFormField(
                    //           controller: marge,
                    //           keyboardType: TextInputType.number,
                    //           decoration: InputDecoration(
                    //               filled: true,
                    //               fillColor: Colors.white,
                    //               border: UnderlineInputBorder(
                    //                   borderRadius: BorderRadius.circular(10),
                    //                   borderSide: BorderSide.none)),
                    //           onEditingComplete: () {
                    //             if (marge.text == '') {
                    //               marge.text = '0';
                    //             }
                    //             widget.tarif!['marge'] =
                    //                 double.parse(marge.text);
                    //             //widget.tarif!['pap'] = double.parse(ttc.text) / ( double.parse(ttc.text) / double.parse(marge.text) * 10 );
                    //             widget.tarif!['ttc'] = double.parse(pap.text) +
                    //                 double.parse(pap.text) *
                    //                     (double.parse(marge.text) / 100);
                    //             stockProvider.notify();
                    //           },
                    //         ),
                    //       ),
                    //     ],
                    //   ),

                    ///////////////////////TTC
                    if (stockProvider.tarifs!
                            .firstWhere((element) =>
                                element.TFENO == widget.tarif!.tfdtfe)
                            .TFETYPE ==
                        0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: width * 0.03,
                          ),
                          Text(
                            'TTC',
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            height: width * 0.1,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      const Color.fromRGBO(4, 103, 138, 1.0)),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: TextFormField(
                              controller: ttc,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none)),
                              onEditingComplete: () {
                                if (ttc.text == '') {
                                  ttc.text = '0';
                                }
                                widget.tarif!.ttc = double.parse(ttc.text);
                                //TFETYPE == 0
                                if (stockProvider.tarifs!
                                        .firstWhere((element) =>
                                            element.TFENO ==
                                            widget.tarif!.tfdtfe)
                                        .TFETYPE ==
                                    0) {
                                  widget.tarif!.marge = double.parse(ttc.text);
                                  //TFETYPE == 1 AND TFDBASE == 2
                                } else {
                                  widget.tarif!.marge =
                                      ((double.parse(ttc.text) -
                                                  double.parse(pap.text)) /
                                              double.parse(pap.text)) *
                                          100;
                                }
                                //widget.tarif!['pap'] = double.parse(ttc.text) / ( double.parse(ttc.text) / double.parse(marge.text) * 10 );
                                stockProvider.notify();
                              },
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(
                  height: width * 0.03,
                ),

                ElevatedButton(
                  onPressed: () {
                    // 1. تحويل النصوص إلى أرقام مرة واحدة لتجنب التكرار والـ Parse Error
                    double parseSafe(String text) {
                      if (text.toLowerCase() == 'nan' || text.isEmpty) {
                        return 0.0;
                      }
                      return double.tryParse(text) ?? 0.0;
                    }

                    final double papValue = parseSafe(pap.text);
                    final double ttcValue = parseSafe(ttc.text);
                    final double margeValue = parseSafe(marge.text);

                    stockProvider.newProduct?.ARTPAP = papValue;

                    final targetTarif = stockProvider.tarifs?.firstWhere(
                      (e) => e.TFENO == widget.tarif?.tfdtfe,
                    );

                    if (targetTarif == null) return;

                    widget.tarif!.ttc = ttcValue;
                    // if (targetTarif.TFETYPE == 0) {
                    //   widget.tarif!.ttc = ttcValue;
                    //   widget.tarif!.marge = 0;
                    // } else {
                    //   // if (widget.tarif!.base == 2) {
                    //   //   if (widget.tarif!.ttc == double.tryParse(ttc.text)) {

                    //   //     widget.tarif!.ttc =
                    //   //         papValue + (papValue * (margeValue / 100));
                    //   //   } else {
                    //   //     widget.tarif!.ttc = ttcValue;
                    //   //   }

                    //   //   if (widget.tarif!.marge ==
                    //   //       double.tryParse(marge.text)) {

                    //   //     widget.tarif!.marge =
                    //   //         ((ttcValue - papValue) / papValue) * 100;
                    //   //   } else {
                    //   //     widget.tarif!.marge = margeValue;
                    //   //   }
                    //   // }
                    // }
                    stockProvider.notify();
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).secondaryHeaderColor)),
                  child: const Text(
                    'Confirmer',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
