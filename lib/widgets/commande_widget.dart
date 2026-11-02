import 'package:flutter/material.dart';
import 'package:gestion_stock/models/commande_entate.dart';
import 'package:gestion_stock/view_models/commande_detail_view_model.dart';
import 'package:gestion_stock/view_models/commande_entate_view_model.dart';
import 'package:gestion_stock/views/command/commande_details.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommandeWidget extends StatelessWidget {
  final CommandeEntate? commande;
  const CommandeWidget({super.key, required this.commande});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    NumberFormat formatter = NumberFormat('#,##0.00', "fr");
    bool isRSV = commande!.cDERSVCOURS == 1;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          Provider.of<CommandeEntateViewModel>(context, listen: false).setSelectedCommande(commande!);
          Provider.of<CommandeDetailViewModel>(context, listen: false).selectedCommande = commande;
          Navigator.push(context, MaterialPageRoute(builder: (builder) => const CommandeDetails()));
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: width,
          margin: EdgeInsets.symmetric(vertical: width * 0.01),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isRSV ? Colors.redAccent : Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isRSV ? Colors.redAccent.withValues(alpha: 0.2) : Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03,
              vertical: width * 0.03,
            ),
            child: Row(
              children: [
                // Client Info Section
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(width * 0.02),
                        decoration: BoxDecoration(
                          color: isRSV ? Colors.redAccent.withValues(alpha: 0.2) : Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: isRSV
                            ? Text(
                                ' R ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.04,
                                  color: Colors.redAccent,
                                ),
                              )
                            : Icon(
                                Icons.shopping_cart_rounded,
                                size: width * 0.05,
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                      ),
                      SizedBox(width: width * 0.02),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${commande!.cLINOM ?? ''} ${commande!.cLIPRENOM ?? ''}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: isRSV ? Colors.redAccent : Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                            SizedBox(height: width * 0.01),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: width * 0.03,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: width * 0.01),
                                Text(
                                  commande!.cDEDATE != null ? DateFormat('dd/MM/yyyy').format(commande!.cDEDATE!) : '',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: width * 0.02),

                // Amount and Number Section
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.02,
                          vertical: width * 0.015,
                        ),
                        decoration: BoxDecoration(
                          color: isRSV ? Colors.redAccent : Theme.of(context).secondaryHeaderColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isRSV ? Colors.redAccent : Theme.of(context).secondaryHeaderColor,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '${formatter.format(commande!.cDENAP ?? 0)} DA',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: width * 0.01),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.02,
                          vertical: width * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          commande!.cDENO ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.black87,
                          ),
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
