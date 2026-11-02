import 'package:flutter/material.dart';
import 'package:gestion_stock/models/client.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/client_view_model.dart';
import 'package:gestion_stock/view_models/location_view_model.dart';
import 'package:gestion_stock/views/client/client_details.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../../models/tiers_category.dart';
import '../../models/nature.dart';
import '../../models/pays.dart';
import '../../models/region.dart';
import '../../models/territoire.dart';
import '../../models/ville.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/toast.dart';

class ModifyClient extends StatefulWidget {
  const ModifyClient({super.key});

  @override
  State<StatefulWidget> createState() => ModifyClientPage();
}

class ModifyClientPage extends State<ModifyClient> {
  TextEditingController nom = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController activity = TextEditingController();
  TextEditingController nom_facturation = TextEditingController();
  TextEditingController solde = TextEditingController();
  TextEditingController tel1 = TextEditingController();
  TextEditingController tel2 = TextEditingController();
  TextEditingController fax = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController web = TextEditingController();
  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  TextEditingController address3 = TextEditingController();
  TextEditingController address4 = TextEditingController();
  TextEditingController reg_com = TextEditingController();
  TextEditingController id_fiscal = TextEditingController();
  TextEditingController article_imp = TextEditingController();
  TextEditingController nis = TextEditingController();
  TextEditingController notes = TextEditingController();
  TextEditingController localisation = TextEditingController();

  @override
  void initState() {
    var provider = Provider.of<ClientViewModel>(context, listen: false);
    nom.text = provider.modifiedClient!.CLINOM;
    prenom.text = provider.modifiedClient!.CLIPRENOM;
    activity.text = provider.modifiedClient!.CLIACTIVITE;
    nom_facturation.text = provider.modifiedClient!.CLINOMFACT;
    solde.text = provider.modifiedClient!.CLISOLDE.toString();
    tel1.text = provider.modifiedClient!.CLITEL1;
    tel2.text = provider.modifiedClient!.CLITEL2;
    fax.text = provider.modifiedClient!.CLIFAX;
    email.text = provider.modifiedClient!.CLIEMAIL;
    web.text = provider.modifiedClient!.CLIWEB;
    address1.text = provider.modifiedClient!.CLIADR1;
    address2.text = provider.modifiedClient!.CLIADR2;
    address3.text = provider.modifiedClient!.CLIADR3;
    address4.text = provider.modifiedClient!.CLIADR4;
    reg_com.text = provider.modifiedClient!.CLIRC;
    id_fiscal.text = provider.modifiedClient!.CLIIF;
    article_imp.text = provider.modifiedClient!.CLIAI;
    nis.text = provider.modifiedClient!.CLINIS;
    notes.text = provider.modifiedClient!.CLINOTES ?? '';
    localisation.text = provider.modifiedClient!.CLILOCALISATION;
    super.initState();
  }

  @override
  void dispose() {
    nom.dispose();
    prenom.dispose();
    activity.dispose();
    nom_facturation.dispose();
    solde.dispose();
    tel1.dispose();
    tel2.dispose();
    fax.dispose();
    email.dispose();
    web.dispose();
    address1.dispose();
    address2.dispose();
    address3.dispose();
    address4.dispose();
    reg_com.dispose();
    id_fiscal.dispose();
    article_imp.dispose();
    nis.dispose();
    notes.dispose();
    localisation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Consumer3<ClientViewModel, AuthViewModel, LocationViewModel>(
        builder: (context, client, auth, location, child) {
      return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.white,
          ),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          title: Center(
            child: Text(
              "Modifier le dossier client",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.055),
            ),
          ),
        ),
        body: SizedBox(
          width: width,
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: width,
                padding: EdgeInsets.only(
                  top: width * 0.02,
                  right: width * 0.03,
                  left: width * 0.03,
                ),
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
                child: Center(
                    child: Text(
                  '${client.selectedClient!.CLINOM} ${client.selectedClient!.CLIPRENOM}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.05,
                      color: Colors.white),
                )),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(width * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///category selector
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Catégorie',
                            style: TextStyle(
                                fontSize: width * 0.045,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: width,
                            height: width * 0.15,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: DropdownButton<String>(
                              value: client.modifiedClient!.CLICATEG,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (String? category) {
                                client.modifiedClient!.CLICATEG = category!;
                                client.notify();
                              },
                              items: auth.categories
                                  .where((element) => element.TRCTYPE == 0)
                                  .map<DropdownMenuItem<String>>(
                                      (TiersCategory category) {
                                return DropdownMenuItem<String>(
                                  value: category.TRCNO,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: width * 0.02),
                                    width: width,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Text(
                                      category.TRCNOM,
                                      style: TextStyle(
                                        fontSize: width * 0.04,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: width * 0.03),

                      ///nature selector
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nature',
                            style: TextStyle(
                                fontSize: width * 0.045,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: width,
                            height: width * 0.15,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: DropdownButton<String>(
                              value: client.modifiedClient!.CLINATURE,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (String? nature) {
                                client.modifiedClient!.CLINATURE = nature!;
                                client.notify();
                              },
                              items: auth.natures.map<DropdownMenuItem<String>>(
                                  (Nature nature) {
                                return DropdownMenuItem<String>(
                                  value: nature.NATNO,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: width * 0.02),
                                    width: width,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Text(
                                      '${nature.NATNO} - ${nature.NATNOM}',
                                      style: TextStyle(
                                        fontSize: width * 0.04,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: width * 0.03),

                      buildTextField(context, 'Nom', nom, TextInputType.text),
                      SizedBox(height: width * 0.03),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Prenom',
                            style: TextStyle(
                                fontSize: width * 0.045,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: width,
                            height: width * 0.15,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: TextFormField(
                              controller: prenom,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none),
                                fillColor: Colors.white,
                                filled: true,
                                enabled: (client.modifiedClient!.CLINATURE ==
                                        '01' ||
                                    client.modifiedClient!.CLINATURE == '02'),
                                hintText: "Prenom",
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: width * 0.03),

                      buildTextField(
                          context, 'Activité', activity, TextInputType.text),
                      SizedBox(height: width * 0.03),

                      buildTextField(context, 'Nom Facturation',
                          nom_facturation, TextInputType.text),
                      SizedBox(height: width * 0.03),

                      buildTextField(
                          context, 'Solde', solde, TextInputType.number),
                      SizedBox(height: width * 0.03),

                      buildTextField(
                          context, 'Téléphone 1', tel1, TextInputType.phone),
                      SizedBox(height: width * 0.03),

                      buildTextField(
                          context, 'Téléphone 2', tel2, TextInputType.phone),
                      SizedBox(height: width * 0.03),

                      buildTextField(context, 'Fax', fax, TextInputType.phone),
                      SizedBox(height: width * 0.03),

                      buildTextField(
                          context, 'Email', email, TextInputType.emailAddress),
                      SizedBox(height: width * 0.03),

                      buildTextField(context, 'Web', web, TextInputType.url),
                      SizedBox(height: width * 0.03),

                      buildTextField(
                          context, 'Adresse 1', address1, TextInputType.text),
                      SizedBox(height: width * 0.03),

                      buildTextField(
                          context, 'Adresse 2', address2, TextInputType.text),
                      SizedBox(height: width * 0.03),

                      buildTextField(
                          context, 'Adresse 3', address3, TextInputType.text),
                      SizedBox(height: width * 0.03),

                      buildTextField(
                          context, 'Adresse 4', address4, TextInputType.number),
                      SizedBox(height: width * 0.03),

                      buildTextField(
                        context,
                        'Localisation (Google Maps URL)',
                        localisation,
                        TextInputType.url,
                        suffixIcon: IconButton(
                          icon:
                              const Icon(Icons.open_in_new, color: Colors.blue),
                          onPressed: () async {
                            if (localisation.text.trim().isNotEmpty) {
                              final String urlText = localisation.text.trim();
                              final Uri? url = Uri.tryParse(urlText);
                              if (url != null) {
                                try {
                                  bool launched = false;
                                  if (await canLaunchUrl(url)) {
                                    launched = await launchUrl(url,
                                        mode: LaunchMode.externalApplication);
                                  }
                                  if (!launched) {
                                    try {
                                      await launchUrl(url,
                                          mode: LaunchMode.externalApplication);
                                    } catch (e) {
                                      if (context.mounted) {
                                        Toast(
                                          context: context,
                                          title: 'Impossible d\'ouvrir l\'URL',
                                          style: ToastificationStyle.minimal,
                                          type: ToastificationType.error,
                                        );
                                      }
                                    }
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    Toast(
                                      context: context,
                                      title: 'Erreur lors de l\'ouverture',
                                      style: ToastificationStyle.minimal,
                                      type: ToastificationType.error,
                                    );
                                  }
                                }
                              } else {
                                Toast(
                                  context: context,
                                  title: 'URL invalide',
                                  style: ToastificationStyle.minimal,
                                  type: ToastificationType.error,
                                );
                              }
                            } else {
                              Toast(
                                context: context,
                                title: 'Veuillez entrer une URL',
                                style: ToastificationStyle.minimal,
                                type: ToastificationType.warning,
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: width * 0.03),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pays',
                            style: TextStyle(
                                fontSize: width * 0.045,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: width,
                            height: width * 0.15,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: DropdownButton<String>(
                              value: client.modifiedClient!.CLIPAYS,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (String? pays) {
                                client.modifiedClient!.CLIPAYS = pays!;
                                client.modifiedClient!.CLITERR = location
                                        .filtredTerritoires
                                        ?.where((element) =>
                                            element.TERPAYS == pays)
                                        .firstOrNull
                                        ?.TERNO ??
                                    '';
                                client.modifiedClient!.CLIVILLE = location
                                        .filtredVilles
                                        ?.where((element) =>
                                            element.VILPAYS == pays &&
                                            element.VILTERR ==
                                                client.modifiedClient!.CLITERR)
                                        .firstOrNull
                                        ?.VILNO ??
                                    '';
                                client.notify();
                              },
                              items: location.filtredPays!
                                  .map<DropdownMenuItem<String>>((Pays pays) {
                                return DropdownMenuItem<String>(
                                  value: pays.PYSNO,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: width * 0.02),
                                    width: width,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Text(
                                      pays.PYSNOM,
                                      style: TextStyle(
                                        fontSize: width * 0.04,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: width * 0.03),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Territoire',
                            style: TextStyle(
                                fontSize: width * 0.045,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: width,
                            height: width * 0.15,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: DropdownButton<String>(
                              value: client.modifiedClient!.CLITERR,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (String? territoire) {
                                client.modifiedClient!.CLITERR = territoire!;
                                client.modifiedClient!.CLIVILLE = location
                                        .filtredVilles
                                        ?.where((element) =>
                                            element.VILPAYS ==
                                                client
                                                    .modifiedClient!.CLIPAYS &&
                                            element.VILTERR == territoire)
                                        .firstOrNull
                                        ?.VILNO ??
                                    '';
                                client.notify();
                              },
                              items: location.filtredTerritoires!
                                  .where((element) =>
                                      element.TERPAYS ==
                                      client.modifiedClient!.CLIPAYS)
                                  .map<DropdownMenuItem<String>>(
                                      (Territoire territoire) {
                                return DropdownMenuItem<String>(
                                  value: territoire.TERNO,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: width * 0.02),
                                    width: width,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Text(
                                      '${territoire.TERNO} - ${territoire.TERNOM}',
                                      style: TextStyle(
                                        fontSize: width * 0.04,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: width * 0.03),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ville',
                            style: TextStyle(
                                fontSize: width * 0.045,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: width,
                            height: width * 0.15,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: DropdownButton<String>(
                              value: client.modifiedClient!.CLIVILLE,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (String? ville) {
                                client.modifiedClient!.CLIVILLE = ville!;
                                client.notify();
                              },
                              items: location.filtredVilles!
                                  .where((element) =>
                                      element.VILPAYS ==
                                          client.modifiedClient!.CLIPAYS &&
                                      element.VILTERR ==
                                          client.modifiedClient!.CLITERR)
                                  .map<DropdownMenuItem<String>>((Ville ville) {
                                return DropdownMenuItem<String>(
                                  value: ville.VILNO,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: width * 0.02),
                                    width: width,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Text(
                                      '${ville.VILNOM}',
                                      style: TextStyle(
                                        fontSize: width * 0.04,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: width * 0.03),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Region',
                            style: TextStyle(
                                fontSize: width * 0.045,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: width,
                            height: width * 0.15,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: DropdownButton<String>(
                              value: client.modifiedClient!.CLIREGION,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (String? region) {
                                client.modifiedClient!.CLIREGION = region!;
                                client.notify();
                              },
                              items: location.regions
                                  .map<DropdownMenuItem<String>>(
                                      (Region region) {
                                return DropdownMenuItem<String>(
                                  value: region.REGNO,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: width * 0.02),
                                    width: width,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Text(
                                      '${region.REGNOM}',
                                      style: TextStyle(
                                        fontSize: width * 0.04,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: width * 0.03),

                      buildTextField(context, 'Registre commercial', reg_com,
                          TextInputType.text),
                      SizedBox(height: width * 0.03),

                      buildTextField(
                          context, 'ID. Fiscal', id_fiscal, TextInputType.text),
                      SizedBox(height: width * 0.03),

                      buildTextField(context, 'Article. Imp.', article_imp,
                          TextInputType.text),
                      SizedBox(height: width * 0.03),

                      buildTextField(
                          context, 'N.I.S', nis, TextInputType.number),
                      SizedBox(height: width * 0.03),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Note',
                            style: TextStyle(
                                fontSize: width * 0.045,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: width,
                            height: width * 0.5,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: TextFormField(
                              maxLines: 50,
                              controller: notes,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Entrer note",
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: width * 0.03),

                      Center(
                        child: TextButton(
                          style: ButtonStyle(
                              padding:
                                  WidgetStateProperty.all(EdgeInsets.zero)),
                          onPressed: () async {
                            await verifyFields(context);
                            client.notify();
                          },
                          child: Container(
                            width: width * 0.6,
                            height: width * 0.12,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).secondaryHeaderColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: client.modifyButtonVisible
                                ? Text(
                                    "Modifier",
                                    style: TextStyle(
                                        fontSize: width * 0.05,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                : CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildTextField(BuildContext context, String label,
      TextEditingController controller, TextInputType inputType,
      {Widget? suffixIcon}) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: width * 0.045,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        Container(
          width: width,
          height: width * 0.15,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: inputType,
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              fillColor: Colors.white,
              filled: true,
              hintText: "Entrer $label",
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> verifyFields(BuildContext context) async {
    var provider = Provider.of<ClientViewModel>(context, listen: false);
    if (nom.text == '' ||
        (prenom.text == '' &&
            (provider.modifiedClient!.CLINATURE == '01' ||
                provider.modifiedClient!.CLINATURE == '02')) ||
        provider.modifiedClient!.CLINATURE == null ||
        provider.modifiedClient!.CLIPAYS == null ||
        provider.modifiedClient!.CLITERR == null ||
        provider.modifiedClient!.CLIVILLE == null ||
        provider.modifiedClient!.CLIREGION == null ||
        provider.modifiedClient!.CLICATEG == null) {
      Toast(
          context: context,
          title: 'Veuillez remplir les champs vides',
          style: ToastificationStyle.minimal,
          type: ToastificationType.warning);
    } else {
      provider.modifiedClient!.CLINOM = nom.text;
      provider.modifiedClient!.CLIPRENOM = prenom.text;
      provider.modifiedClient!.CLIACTIVITE = activity.text;
      provider.modifiedClient!.CLINOMFACT = nom_facturation.text;
      provider.modifiedClient!.CLISOLDE =
          double.parse(solde.text == '' ? '0' : solde.text);
      provider.modifiedClient!.CLITEL1 = tel1.text;
      provider.modifiedClient!.CLITEL2 = tel2.text;
      provider.modifiedClient!.CLIFAX = fax.text;
      provider.modifiedClient!.CLIEMAIL = email.text;
      provider.modifiedClient!.CLIWEB = web.text;
      provider.modifiedClient!.CLIADR1 = address1.text;
      provider.modifiedClient!.CLIADR2 = address2.text;
      provider.modifiedClient!.CLIADR3 = address3.text;
      provider.modifiedClient!.CLIADR4 = address4.text;
      provider.modifiedClient!.CLIRC = reg_com.text;
      provider.modifiedClient!.CLIIF = id_fiscal.text;
      provider.modifiedClient!.CLIAI = article_imp.text;
      provider.modifiedClient!.CLINIS = nis.text;
      provider.modifiedClient!.CLINOTES = notes.text;
      provider.modifiedClient!.CLILOCALISATION = localisation.text;
      FocusScope.of(context).unfocus();
      await provider.modifyClient();
      if (provider.modifyStatusCode == 200) {
        Map<String, dynamic> json = provider.modifiedClient!.toJson();
        provider.setSelectedClient(Client.modified(json));
        provider.notifyListeners();
        Toast(
            context: context,
            title: 'Modifier avec succès',
            style: ToastificationStyle.minimal,
            type: ToastificationType.success);
        Navigator.push(context,
            MaterialPageRoute(builder: (builder) => const ClientDetails()));
      }
      if (provider.modifyStatusCode == 409) {
        Toast(
            context: context,
            title: 'Ce client est déjà existant',
            style: ToastificationStyle.minimal,
            type: ToastificationType.error);
      }
      if (provider.modifyStatusCode == 500) {
        Toast(
            context: context,
            title: 'Impossible de se connecter au serveur',
            style: ToastificationStyle.minimal,
            type: ToastificationType.error);
      }
    }
  }
}
