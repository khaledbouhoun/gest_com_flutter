import 'package:flutter/material.dart';
import 'package:gestion_stock/models/reception_detail.dart';
import 'package:intl/intl.dart';
import 'package:expandable/expandable.dart';

class ReceptionProductWidget extends StatelessWidget {
  final ReceptionDetail? product;
  const ReceptionProductWidget({super.key, this.product});

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
                  Container(
                      child: Text(product!.fTDARTNOM!,
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
                              color: Theme.of(context).secondaryHeaderColor,
                            )),
                        TextSpan(
                          text: product!.fTDQTE!.toStringAsFixed(2),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.035,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (product!.fTDUNTCOL != 0)
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
                          text: (product!.fTDQTE! / product!.fTDUNTCOL!)
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
                            color: Theme.of(context).secondaryHeaderColor,
                          )),
                      TextSpan(
                        text:
                            '${formatter.format(product!.fTDPUTTC).toString()} DA',
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
                            '${formatter.format(product!.fTDMNTTTC).toString()} DA',
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
                            '${formatter.format(product!.fTDLONG).toString()} m',
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
                            '${formatter.format(product!.fTDLARG).toString()} m',
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
