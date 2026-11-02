import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gestion_stock/models/commande_detail.dart';
import 'package:intl/intl.dart';

class CommandeProductWidget extends StatelessWidget {
  final CommandeDetail product;
  const CommandeProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final NumberFormat formatter = NumberFormat('#,##0.00', "fr");
    final bool isRSV = product.cDERSVCOURS == 1;

    return ExpandableNotifier(
      child: Container(
        width: width,
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
                  Container(
                      child: Text(product.cDDARTNOM ?? product.cDENO ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.04,
                            color: Colors.black,
                          ))),
                  Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                            text: 'Quantité: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.035,
                              color: isRSV
                                  ? Colors.redAccent
                                  : Theme.of(context).secondaryHeaderColor,
                            )),
                        TextSpan(
                          text: product.cDDQTE?.toStringAsFixed(2) ?? '0.00',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.035,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (product.cDDUNTCOL != null && product.cDDUNTCOL != 0)
                    Text.rich(TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                            text: 'Nbr. Colis: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.035,
                              color: isRSV
                                  ? Colors.redAccent
                                  : Theme.of(context).secondaryHeaderColor,
                            )),
                        TextSpan(
                          text: ((product.cDDQTE ?? 0) / product.cDDUNTCOL!)
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
                Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                          text: 'Prix unitaire: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.035,
                            color: isRSV
                                ? Colors.redAccent
                                : Theme.of(context).secondaryHeaderColor,
                          )),
                      TextSpan(
                        text:
                            '${formatter.format(product.cDDPUTTC ?? product.cDEMNTHT ?? 0).toString()} DA',
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
                            color: isRSV
                                ? Colors.redAccent
                                : Theme.of(context).secondaryHeaderColor,
                          )),
                      TextSpan(
                        text:
                            '${formatter.format(product.cDDMNTTTC ?? product.cDEMNTTTC ?? 0).toString()} DA',
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
                            color: isRSV
                                ? Colors.redAccent
                                : Theme.of(context).secondaryHeaderColor,
                          )),
                      TextSpan(
                        text:
                            '${formatter.format(product.cDDLONG ?? 0).toString()} m',
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
                            color: isRSV
                                ? Colors.redAccent
                                : Theme.of(context).secondaryHeaderColor,
                          )),
                      TextSpan(
                        text:
                            '${formatter.format(product.cDDLARG ?? 0).toString()} m',
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
