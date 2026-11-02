import 'package:flutter/material.dart';
import 'package:gestion_stock/models/transaction.dart';
import 'package:gestion_stock/view_models/transaction_view_model.dart';
import 'package:gestion_stock/views/caisse/transaction_details.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionWidget extends StatelessWidget {
  Transaction? transaction;
  DateTime? date;
  TransactionWidget({super.key, this.transaction, this.date});
  String? title;

  Color getAccountColorFromTitle() {
    if (title!.isEmpty) {
      return Colors.grey.shade400;
    }

    final match = RegExp(r'\[([A-Z])\]').firstMatch(title!);

    if (match == null) {
      return Colors.grey.shade400;
    }

    final code = match.group(1);

    switch (code) {
      case 'F': // Fournisseur
        return const Color(0xFFFF6B6B);
      case 'C': // Client
        return const Color(0xFF4ECDC4);
      case 'E': // Employe
        return const Color(0xFFFFE66D);
      default:
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    NumberFormat formatter = NumberFormat('#,##0.00', "fr");

    switch (transaction!.JNLTYPE) {
      case (-1):
        title = transaction!.JNLDESC;
        break;
      case (5):
        title = transaction!.RUBNOM;
        break;
      case (17):
        title = " ${transaction!.JnlValideArr}";
        break;
      default:
        title = transaction!.TIERSNOM + transaction!.TIERSPRENOM;
    }

    if (transaction!.JNLTYPE == -2) {
      // final isFirstDayOfYear = date!.month == 1 && date!.day == 1;
      // if (Provider.of<TransactionViewModel>(context, listen: false)
      //         .totaloperations &&
      //     !isFirstDayOfYear) {
      return _buildTotalCard(width, height, formatter);
      // } else {
      //   return const SizedBox.shrink();
      // }
    } else if (transaction!.JNLTYPE == -1) {
      // final isFirstDayOfYear = date!.month == 1 && date!.day == 1;
      // if (isFirstDayOfYear) {
      return _buildSoldeInitialCard(width, height, formatter);
      // } else {
      //   return const SizedBox.shrink();
      // }
    } else if (transaction!.JNLTYPE == 17) {
      return _buildTransferCard(context, width, height, formatter);
    } else {
      return _buildTransactionCard(context, width, height, formatter);
    }
  }

  Widget _buildTotalCard(double width, double height, NumberFormat formatter) {
    final cardColor = getAccountColorFromTitle();

    return Container(
      width: width,
      margin: EdgeInsets.symmetric(vertical: width * 0.01),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cardColor.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: cardColor.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: width * 0.025,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              cardColor.withValues(alpha: 0.08),
              cardColor.withValues(alpha: 0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                transaction!.JNLDESC,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: width * 0.038,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ),
            Container(
              width: 1,
              height: width * 0.1,
              margin: EdgeInsets.symmetric(horizontal: width * 0.02),
              color: Colors.grey.shade300,
            ),
            Expanded(
              flex: 2,
              child: Text(
                formatter.format(transaction!.JNLDEBIT - transaction!.JNLCREDIT),
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.04,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context, double width, double height, NumberFormat formatter) {
    final cardColor = getAccountColorFromTitle();
    final isDebit = transaction!.JNLSENS == 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          Provider.of<TransactionViewModel>(context, listen: false).setSelectedTransaction(transaction!);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (builder) => TransactiondDetails()),
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
              color: cardColor.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: cardColor.withValues(alpha: 0.15),
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  cardColor.withValues(alpha: 0.08),
                  cardColor.withValues(alpha: 0.02),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Account Code Section
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.015,
                      vertical: width * 0.02,
                    ),
                    decoration: BoxDecoration(
                      color: cardColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      transaction!.CPTABV,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: width * 0.02),

                // Transaction Details Section
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.black87,
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
                            DateFormat('dd/MM/yyyy').format(transaction!.JNLDATE),
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

                Container(
                  width: 1,
                  height: width * 0.1,
                  margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                  color: Colors.grey.shade300,
                ),

                // Amount Section
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.02,
                    vertical: width * 0.015,
                  ),
                  decoration: BoxDecoration(
                    color: isDebit ? const Color(0xFF4CAF50).withValues(alpha: 0.1) : const Color(0xFFFF5252).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDebit ? const Color(0xFF4CAF50).withValues(alpha: 0.3) : const Color(0xFFFF5252).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    isDebit ? '+${formatter.format(transaction!.JNLDEBIT)}' : '-${formatter.format(transaction!.JNLCREDIT)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: isDebit ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransferCard(BuildContext context, double width, double height, NumberFormat formatter) {
    final cardColor = getAccountColorFromTitle();
    final sens = transaction!.JNLSENS;

    final left = sens == 0 ? transaction!.CptABVArr : transaction!.CPTABV;
    final right = sens == 0 ? transaction!.CPTABV : transaction!.CptABVArr;

    final icon = sens == 0 ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded;

    final color = switch (transaction!.status) {
      TransactionStatus.debit => const Color(0xFF2E7D32),
      TransactionStatus.credit => const Color(0xFFD32F2F),
      TransactionStatus.all => const Color(0xFF009DE0),
    };

    final montant = switch (transaction!.status) {
      TransactionStatus.debit => '+${formatter.format(transaction!.JNLDEBIT)}',
      TransactionStatus.credit => '-${formatter.format(transaction!.JNLCREDIT)}',
      TransactionStatus.all => '+-${formatter.format(transaction!.JNLCREDIT)}',
    };
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          Provider.of<TransactionViewModel>(context, listen: false).setSelectedTransaction(transaction!);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (builder) => TransactiondDetails()),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: width,
          margin: EdgeInsets.symmetric(vertical: width * 0.01),
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.03,
            vertical: width * 0.03,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.05),
            border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Account Code Section
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: cardColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            left,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(width: width * 0.02),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: cardColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            icon,
                            size: width * 0.05,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: width * 0.02),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: cardColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            right,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: width * 0.03,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: width * 0.01),
                        Text(
                          DateFormat('dd/MM/yyyy').format(transaction!.JNLDATE),
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

              Container(
                width: 1,
                height: width * 0.1,
                margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                color: Colors.grey.shade300,
              ),

              // Amount Section
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.02,
                  vertical: width * 0.015,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: color.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  montant,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSoldeInitialCard(double width, double height, NumberFormat formatter) {
    return Container(
      width: width,
      margin: EdgeInsets.symmetric(vertical: width * 0.01),
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: width * 0.025,
      ),
      decoration: BoxDecoration(
        color: Color.fromARGB(0, 193, 206, 211),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFF009DE0).withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF009DE0).withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.015,
                vertical: width * 0.02,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFF009DE0).withValues(alpha: 0.3),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                transaction!.CPTABV,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            height: width * 0.08,
            margin: EdgeInsets.symmetric(horizontal: width * 0.01),
            color: Colors.grey.shade300,
          ),
          Expanded(
            flex: 3,
            child: Text(
              "Sold Init : ${transaction!.JNLDESC.substring(14, 18)}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: width * 0.038,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
          Container(
            width: 1,
            height: width * 0.08,
            margin: EdgeInsets.symmetric(horizontal: width * 0.01),
            color: Colors.grey.shade300,
          ),
          Expanded(
            flex: 3,
            child: Text(
              formatter.format(transaction!.JNLDEBIT - transaction!.JNLCREDIT),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: width * 0.04,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
