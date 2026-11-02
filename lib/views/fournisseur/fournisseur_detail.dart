import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/location_view_model.dart';
import 'package:gestion_stock/views/fournisseur/fournisseurs.dart';
import 'package:gestion_stock/widgets/detail_card.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/fournisseur_view_model.dart';

class FournisseurDetail extends StatelessWidget {
  const FournisseurDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    var provider = Provider.of<FournisseurViewModel>(context, listen: false);
    NumberFormat formatter = NumberFormat('#,##0.00', "fr");
    List details = [
      //personal informations
      {
        'Nom & Prénom': provider.selectedFournisseur!.FOUNOM,
        'section': 'Informations Personnelles'
      },

      //contact informations
      {
        'Téléphone 01': provider.selectedFournisseur!.FOUTEL1,
        'section': 'Contact'
      },
      {
        'Téléphone 02': provider.selectedFournisseur!.FOUTEL2,
      },
      {
        'Fax': provider.selectedFournisseur!.FOUFAX,
      },
      {
        'Email': provider.selectedFournisseur!.FOUEMAIL,
      },
      {
        'Web': provider.selectedFournisseur!.FOUWEB,
      },

      //address informations
      {
        'Adresse 01': provider.selectedFournisseur!.FOUADR1,
        'section': 'Adresse'
      },
      {
        'Adresse 02': provider.selectedFournisseur!.FOUADR2,
      },
      {
        'Adresse 03': provider.selectedFournisseur!.FOUADR3,
      },
      {
        'Adresse 04': provider.selectedFournisseur!.FOUADR4,
      },
      {
        'Pays': Provider.of<LocationViewModel>(context, listen: false)
            .filtredPays
            ?.firstWhere((element) =>
                element.PYSNO == provider.selectedFournisseur!.FOUPAYS)
            .PYSNOM
      },
      {
        'Territoire': Provider.of<LocationViewModel>(context, listen: false)
            .filtredTerritoires!
            .firstWhere((element) =>
                element.TERNO == provider.selectedFournisseur!.FOUTERR &&
                element.TERPAYS == provider.selectedFournisseur!.FOUPAYS)
            .TERNOM,
      },
      {
        'Region': Provider.of<LocationViewModel>(context, listen: false)
            .regions
            .firstWhere((element) =>
                element.REGNO == provider.selectedFournisseur!.FOUREGION)
            .REGNOM,
      },

      //financial informations
      {
        'Solde (par ${Provider.of<AuthViewModel>(context, listen: false).selectedExercice!.EXENO})':
            '${formatter.format(provider.selectedFournisseur!.FOUSOLDE).toString()}DA',
        'section': 'Financial'
      },
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
                    provider.selectedFournisseur!.FOUNOM,
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
