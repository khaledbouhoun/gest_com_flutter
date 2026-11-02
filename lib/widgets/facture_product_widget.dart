import 'package:flutter/material.dart';
import 'package:gestion_stock/models/facture_detail.dart';
import 'package:intl/intl.dart';
import 'package:expandable/expandable.dart';

class FactureProductWidget extends StatelessWidget {
  final FactureDetail? product;
  const FactureProductWidget({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final NumberFormat formatter = NumberFormat('#,##0.00', "fr");

    return ExpandableNotifier(
      child: Container(
        width: width,
        //height: height / 13,
        padding: EdgeInsets.all(width * 0.02),
        margin: EdgeInsets.only(top: width * 0.04),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: ScrollOnExpand(
          scrollOnExpand: true,
          scrollOnCollapse: false,
          child: ExpandablePanel(
            theme: const ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              tapBodyToExpand: true,
              tapBodyToCollapse: true,
              hasIcon: true,
            ),
            header: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                        text: product!.FTDARTNOM,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.035,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )),
                  Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                            text: 'Quantité: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.035,
                              color: Theme.of(context).secondaryHeaderColor,
                            )),
                        TextSpan(
                          text: product!.FTDQTE.toStringAsFixed(2),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.035,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (product!.FTDUNTCOL != 0)
                    Text.rich(TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                            text: 'Nbr. Colis: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.035,
                              color: Theme.of(context).secondaryHeaderColor,
                            )),
                        TextSpan(
                          text: (product!.FTDQTE / product!.FTDUNTCOL)
                              .toStringAsFixed(2),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.035,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )),
                ],
              ),
            ),
            collapsed: Container(),
            expanded: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text.rich(
                //   TextSpan(
                //     children: <InlineSpan>[
                //       TextSpan(
                //           text: 'Colisage: ',
                //           style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             fontSize: width * 0.035,
                //             color: Theme.of(context).secondaryHeaderColor,
                //           )),
                //       TextSpan(
                //         text: product!.FTDCOLISAGE,
                //         style: TextStyle(
                //           fontWeight: FontWeight.bold,
                //           fontSize: width * 0.035,
                //           color: Colors.black,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                          text: 'Prix unitaire: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.035,
                            color: Theme.of(context).secondaryHeaderColor,
                          )),
                      TextSpan(
                        text:
                            '${formatter.format(product!.FTDPUTTC).toString()} DA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.035,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                          text: 'Montant TTC: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.035,
                            color: Theme.of(context).secondaryHeaderColor,
                          )),
                      TextSpan(
                        text:
                            '${formatter.format(product!.FTDMNTTTC).toString()} DA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.035,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                          text: 'Longeur: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.035,
                            color: Theme.of(context).secondaryHeaderColor,
                          )),
                      TextSpan(
                        text:
                            '${formatter.format(product!.FTDLONG).toString()} m',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.035,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                          text: 'Largeur: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.035,
                            color: Theme.of(context).secondaryHeaderColor,
                          )),
                      TextSpan(
                        text:
                            '${formatter.format(product!.FTDLARG).toString()} m',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.035,
                          color: Colors.black,
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
