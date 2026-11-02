import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/client_view_model.dart';
import 'package:gestion_stock/view_models/location_view_model.dart';
import 'package:gestion_stock/views/client/clients.dart';
import 'package:gestion_stock/views/client/modify_client.dart';
import 'package:gestion_stock/widgets/detail_card.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../../models/client.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import '../../widgets/toast.dart';

class ClientDetails extends StatelessWidget {
  const ClientDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    var provider = Provider.of<ClientViewModel>(context, listen: false);
    NumberFormat formatter = NumberFormat('#,##0.00', "fr");
    List details = [
      //personal informations
      {
        'Nom & Prénom':
            '${provider.selectedClient!.CLINOM} ${provider.selectedClient!.CLIPRENOM}',
        'section': 'Informations Personnelles'
      },

      //contact informations
      {'Téléphone 01': provider.selectedClient!.CLITEL1, 'section': 'Contact'},
      {
        'Téléphone 02': provider.selectedClient!.CLITEL2,
      },
      {
        'Fax': provider.selectedClient!.CLIFAX,
      },
      {
        'Email': provider.selectedClient!.CLIEMAIL,
      },
      {
        'Web': provider.selectedClient!.CLIWEB,
      },
      {
        'LOCALISATION': provider.selectedClient!.CLILOCALISATION,
      },

      //address informations
      {'Adresse 01': provider.selectedClient!.CLIADR1, 'section': 'Adresse'},
      {
        'Adresse 02': provider.selectedClient!.CLIADR2,
      },
      {
        'Adresse 03': provider.selectedClient!.CLIADR3,
      },
      {
        'Adresse 04': provider.selectedClient!.CLIADR4,
      },
      {
        'Pays': Provider.of<LocationViewModel>(context, listen: false)
                .filtredPays
                ?.where((element) =>
                    element.PYSNO == provider.selectedClient!.CLIPAYS)
                .firstOrNull
                ?.PYSNOM ??
            'Inconnu'
      },
      {
        'Territoire': Provider.of<LocationViewModel>(context, listen: false)
                .filtredTerritoires
                ?.where((element) =>
                    element.TERNO == provider.selectedClient!.CLITERR &&
                    element.TERPAYS == provider.selectedClient!.CLIPAYS)
                .firstOrNull
                ?.TERNOM ??
            'Inconnu',
      },
      {
        'Ville': Provider.of<LocationViewModel>(context, listen: false)
                .filtredVilles
                ?.where((element) =>
                    element.VILNO == provider.selectedClient!.CLIVILLE &&
                    element.VILPAYS == provider.selectedClient!.CLIPAYS &&
                    element.VILTERR == provider.selectedClient!.CLITERR)
                .firstOrNull
                ?.VILNOM ??
            'Inconnu',
      },
      {
        'Region': Provider.of<LocationViewModel>(context, listen: false)
                .regions
                .where((element) =>
                    element.REGNO == provider.selectedClient!.CLIREGION)
                .firstOrNull
                ?.REGNOM ??
            'Inconnu',
      },

      //financial informations
      {
        'Solde (par ${Provider.of<AuthViewModel>(context, listen: false).selectedExercice!.EXENO})':
            '${formatter.format(provider.selectedClient!.CLISOLDE).toString()}DA',
        'section': 'Financial'
      },
    ];

    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F9FC),
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            elevation: 0,
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.white,
            ),
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                onPressed: () {
                  if (verifyAccess(context)) {
                    Map<String, dynamic> json =
                        provider.selectedClient!.toJson();
                    provider.modifiedClient = Client.modified(json);
                    provider.notifyListeners();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const ModifyClient()));
                  } else {
                    Toast(
                        context: context,
                        title:
                            'Pas de permission pour Modifier dossier de client',
                        style: ToastificationStyle.minimal,
                        type: ToastificationType.warning);
                  }
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit_rounded,
                      color: Colors.white, size: 20),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delete_rounded,
                      color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Column(
            children: [
              Container(
                width: width,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20,
                  bottom: 30,
                  left: 20,
                  right: 20,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).secondaryHeaderColor,
                      Theme.of(context).secondaryHeaderColor.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .secondaryHeaderColor
                          .withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_outline_rounded,
                          size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${provider.selectedClient!.CLINOM} ${provider.selectedClient!.CLIPRENOM}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.06,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'ID: ${provider.selectedClient!.CLINO}',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: details.length,
                  itemBuilder: (context, index) {
                    final detail = details[index];
                    final String key =
                        detail.keys.firstWhere((k) => k != 'section');
                    final String? section = detail['section'];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (section != null) ...[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, top: 20, bottom: 12),
                            child: Text(
                              section.toUpperCase(),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .secondaryHeaderColor
                                    .withOpacity(0.7),
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
                        DetailCard(
                          title: key,
                          subtitle: detail[key]?.toString() ?? '/',
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }

  bool verifyAccess(BuildContext context) {
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    if (authProvider.selectedUser!.USRTYPE == 0) {
      return authProvider.accessList!
              .where((element) =>
                  element.URSTRS == '03' &&
                  element.URSRES == '01' &&
                  element.URSDRO == '03')
              .length ==
          1;
    } else if (authProvider.selectedUser!.USRTYPE == 1) {
      return authProvider.accessList!
          .where((element) =>
              element.URSTRS == '03' &&
              element.URSRES == '01' &&
              element.URSDRO == '03')
          .isEmpty;
    } else {
      return true;
    }
  }
}
