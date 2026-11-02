import 'package:flutter/material.dart';
import 'package:gestion_stock/models/facture_entate.dart';
import 'package:gestion_stock/view_models/facture_deatail_view_model.dart';
import 'package:gestion_stock/views/facture_detail/facture_details.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FactureWidget extends StatelessWidget {
  final FactureEntate? facture;
  const FactureWidget({super.key, this.facture});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    NumberFormat formatter = NumberFormat('#,##0.00', "fr");
    final isReturn = facture!.FTETYPE == 2;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          Provider.of<FactureDetailViewModel>(context, listen: false).selectedFacture = facture;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (builder) => const FactureDetails()),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: width,
          margin: EdgeInsets.symmetric(vertical: width * 0.01),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.2),
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
                          color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.receipt_long_rounded,
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
                              '${facture!.CLINOM ?? ''} ${facture!.CLIPRENOM ?? ''}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Theme.of(context).secondaryHeaderColor,
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
                                  DateFormat('dd/MM/yyyy').format(facture!.FTEDATE),
                                  //  ${(facture!.FTEDATE.hour).toString().padLeft(2, '0')}:${(facture!.FTEDATE.minute).toString().padLeft(2, '0')}',
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
                          color: Theme.of(context).secondaryHeaderColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '${formatter.format(facture!.FTENAP ?? 0)} DA',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
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
                          color: isReturn ? const Color(0xFFFF5252).withValues(alpha: 0.1) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          facture!.FTENO ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: isReturn ? const Color(0xFFD32F2F) : Colors.black87,
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
