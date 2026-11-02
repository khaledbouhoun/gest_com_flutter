import 'package:flutter/material.dart';
import 'package:gestion_stock/models/transaction.dart';
import 'package:gestion_stock/view_models/transaction_view_model.dart';
import 'package:gestion_stock/views/caisse/caisse.dart';
import 'package:gestion_stock/widgets/detail_card.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactiondDetails extends StatelessWidget {
  TransactiondDetails({super.key});
  String? title;
  @override
  Widget build(BuildContext context) {
    Transaction? transaction =
        Provider.of<TransactionViewModel>(context, listen: false)
            .selectedTransaction;
    switch (transaction!.JNLTYPE) {
      case (-1):
        title = transaction.JNLDESC;
        break;
      case (5):
        title = transaction.RUBNOM;
        break;
      default:
        title = transaction.TIERSNOM + transaction.TIERSPRENOM;
    }
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    NumberFormat formatter =
        NumberFormat.decimalPatternDigits(locale: 'en_us', decimalDigits: 2);
    List details = [
      {'Nom & Prénom': '${transaction.TIERSNOM} ${transaction.TIERSPRENOM}'},
      {'Date': DateFormat('dd/MM/yyyy').format(transaction.JNLDATE)},
      {'Compte': transaction.CPTABV},
      {'Code': transaction.JNLSOURCE},
      {
        'Montant':
            formatter.format(transaction.JNLDEBIT - transaction.JNLCREDIT)
      },
      {'Description': transaction.JNLDESC},
      {'Rubrique': transaction.RUBNOM},
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
            title: const Center(),
            actions: [
              TextButton(
                  onPressed: () {},
                  child: Container(
                    padding: EdgeInsets.all(width * 0.01),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: Icon(
                      Icons.edit,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  )),
              TextButton(
                  onPressed: () {},
                  child: Container(
                    padding: EdgeInsets.all(width * 0.01),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )),
            ],
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
                    title!,
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
                          if (details[index]['section'] != null) {
                            var key = details[index].keys.first;
                            return DetailCard(
                              title: key,
                              subtitle: details[index][key],
                              section: details[index]['section'],
                            );
                          }
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
