import 'package:gestion_stock/widgets/barcode_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:gestion_stock/models/family.dart';
import 'package:gestion_stock/models/product.dart';
import 'package:gestion_stock/view_models/product_view_model.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:gestion_stock/views/product/product_details.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../../models/brand.dart';
import '../../models/package.dart';
import '../../models/subfamily.dart';
import '../../models/tva.dart';
import '../../models/unit.dart';
import '../../widgets/product_tarif_widget.dart';
import '../../widgets/toast.dart';

class ModifyProduct extends StatefulWidget {
  const ModifyProduct({super.key});

  @override
  State<StatefulWidget> createState() => ModifyProductPage();
}

class ModifyProductPage extends State<ModifyProduct> {
  TextEditingController title = TextEditingController();
  TextEditingController optionalTitle = TextEditingController();
  TextEditingController reference = TextEditingController();
  TextEditingController barcode = TextEditingController();
  TextEditingController qteinit = TextEditingController();
  TextEditingController qtemin = TextEditingController();
  TextEditingController qtemax = TextEditingController();
  TextEditingController alerte = TextEditingController();
  TextEditingController long = TextEditingController();
  TextEditingController larg = TextEditingController();
  TextEditingController wieght = TextEditingController();
  TextEditingController volume = TextEditingController();
  TextEditingController unitByPackage = TextEditingController();
  TextEditingController casier = TextEditingController();

  @override
  void initState() {
    var provider = Provider.of<ProductViewModel>(context, listen: false);
    provider.getProductTarifs(context, provider.modifiedProduct!.ARTNO!);
    title.text = provider.modifiedProduct!.ARTNOM!;
    optionalTitle.text = provider.modifiedProduct!.ARTNOMSUP ?? '';
    reference.text = provider.modifiedProduct!.ARTREF!;
    barcode.text = provider.modifiedProduct!.ARTCAB!.toString();
    qteinit.text = provider.modifiedProduct!.ARTQTEINITAB!.toString();
    qtemin.text = provider.modifiedProduct!.ARTQTEMIN!.toString();
    qtemax.text = provider.modifiedProduct!.ARTQTEMAX!.toString();
    alerte.text = provider.modifiedProduct!.ARTALERTE!.toString();
    long.text = provider.modifiedProduct!.ARTLONG!.toString();
    larg.text = provider.modifiedProduct!.ARTLARG!.toString();
    wieght.text = provider.modifiedProduct!.ARTPOIDS!.toString();
    volume.text = provider.modifiedProduct!.ARTVOLUME!.toString();
    unitByPackage.text = provider.modifiedProduct!.ARTUNTCOL!.toString();
    casier.text = provider.modifiedProduct!.ARTCASIER ?? '';
    super.initState();
  }

  @override
  void dispose() {
    title.dispose();
    optionalTitle.dispose();
    reference.dispose();
    barcode.dispose();
    qteinit.dispose();
    qtemin.dispose();
    qtemax.dispose();
    alerte.dispose();
    long.dispose();
    larg.dispose();
    wieght.dispose();
    volume.dispose();
    unitByPackage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Consumer<ProductViewModel>(builder: (context, product, child) {
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
              "Modifier l'article",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.08),
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
                  '${product.selectedProduct!.ARTNOM}',
                  textAlign: TextAlign.center,
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
                      buildBarcodeField(context, barcode),
                      SizedBox(height: width * 0.03),

                      buildTextField(
                          context, 'Désignation *', title, TextInputType.text),
                      SizedBox(height: width * 0.03),

                      buildTextField(context, 'Désignation supplimentaire',
                          optionalTitle, TextInputType.text),
                      SizedBox(height: width * 0.03),

                      buildTextField(
                          context, 'Référence', reference, TextInputType.text),
                      SizedBox(height: width * 0.03),

                      if (product.getProductTarifsStatusCode == 200)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Les tarifs',
                              style: TextStyle(
                                  fontSize: width * 0.045,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            ...product.selectedProductTarifs.map((tarif) {
                              return ProductTarifWidget(
                                tarif: tarif,
                                direction: 2,
                              );
                            }),
                          ],
                        ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Casier',
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
                              controller: casier,
                              keyboardType: TextInputType.text,
                              maxLength: 20,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Entrer casier",
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: width * 0.03),

                      //TVA selector
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TVA',
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
                              value: product.modifiedProduct!.ARTTVA,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (String? tva) {
                                product.modifiedProduct!.ARTTVA = tva;
                                product.notify();
                              },
                              items: product.tvas!
                                  .map<DropdownMenuItem<String>>((Tva tva) {
                                return DropdownMenuItem<String>(
                                  value: tva.TVANO,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: width * 0.02),
                                    width: width,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Text(
                                      '${tva.TVANO} - ${tva.TVATAUX}',
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

                      //type selector
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Type',
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
                            child: DropdownButton<double>(
                              value: product.modifiedProduct!.ARTTYPE,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (double? type) {
                                product.modifiedProduct!.ARTTYPE = type;
                                product.notify();
                              },
                              items: product.type.map<DropdownMenuItem<double>>(
                                  (Map<double, String> type) {
                                return DropdownMenuItem<double>(
                                  value: type.keys.first,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: width * 0.02),
                                    width: width,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Text(
                                      '${type[type.keys.first]}',
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
                            'Famille',
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
                              value: product.modifiedProduct!.ARTFAM,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (String? family) {
                                product.modifiedProduct!.ARTFAM = family;
                                product.modifiedProduct!.ARTSFAM = null;
                                product.notify();
                              },
                              items: product.families!
                                  .map<DropdownMenuItem<String>>(
                                      (Family family) {
                                return DropdownMenuItem<String>(
                                  value: family.FAMNO,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: width * 0.02),
                                    width: width,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Text(
                                      family.FAMNOM!,
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
                            'Sous famille',
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
                              value: product.modifiedProduct!.ARTSFAM,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (String? subFamily) {
                                product.modifiedProduct!.ARTSFAM = subFamily;
                                product.notify();
                              },
                              items: product.subfamilies!
                                  .where((element) =>
                                      element.SOUFAM ==
                                      product.modifiedProduct!.ARTFAM)
                                  .map<DropdownMenuItem<String>>(
                                      (SubFamily subFamily) {
                                return DropdownMenuItem<String>(
                                  value: subFamily.SOUNO,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: width * 0.02),
                                    width: width,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Text(
                                      subFamily.SOUNOM!,
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
                            'Marque',
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
                              value: product.modifiedProduct!.ARTMARQUE,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (String? brand) {
                                product.modifiedProduct!.ARTMARQUE = brand;
                                product.notify();
                              },
                              items: product.brands!
                                  .map<DropdownMenuItem<String>>((Brand brand) {
                                return DropdownMenuItem<String>(
                                  value: brand.MRQNO,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: width * 0.02),
                                    width: width,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Text(
                                      brand.MRQNOM!,
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
                            'Unité',
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
                              value: product.modifiedProduct!.ARTUNI,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (String? family) {
                                product.modifiedProduct!.ARTUNI = family;
                                product.notify();
                              },
                              items: product.units!
                                  .map<DropdownMenuItem<String>>((Unit unit) {
                                return DropdownMenuItem<String>(
                                  value: unit.UNINO,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: width * 0.02),
                                    width: width,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Text(
                                      unit.UNINOM!,
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
                            'Colisage',
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
                              value: product.modifiedProduct!.ARTCOLIS,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (String? package) {
                                product.modifiedProduct!.ARTCOLIS = package;
                                product.notify();
                              },
                              items: product.packages!
                                  .map<DropdownMenuItem<String>>(
                                      (Package package) {
                                return DropdownMenuItem<String>(
                                  value: package.COLNO,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: width * 0.02),
                                    width: width,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Text(
                                      package.COLNOM!,
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
                      /*
                          ///
                           */
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Unité par colis *",
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
                              controller: unitByPackage,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Entrer Unité par colis *",
                              ),
                              enabled:
                                  product.modifiedProduct!.ARTCOLIS != '00',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: width * 0.03),
                      /*

                           */

                      buildTextField(context, 'Quantité initial', qteinit,
                          TextInputType.number),
                      SizedBox(height: width * 0.03),

                      buildTextField(context, 'Quantité min', qtemin,
                          TextInputType.number),
                      SizedBox(height: width * 0.03),

                      buildTextField(context, 'Quantité max', qtemax,
                          TextInputType.number),
                      SizedBox(height: width * 0.03),

                      buildTextField(context, "Stock d'alerte", alerte,
                          TextInputType.number),
                      SizedBox(height: width * 0.03),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Longueur (M)',
                                style: TextStyle(
                                    fontSize: width * 0.045,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                width: width * 0.45,
                                height: width * 0.15,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: TextFormField(
                                  controller: long,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "Entrer longueur ",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Largeur (M)',
                                style: TextStyle(
                                    fontSize: width * 0.045,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                width: width * 0.45,
                                height: width * 0.15,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: TextFormField(
                                  controller: larg,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "Entrer largeur",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: width * 0.03),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Poids (Kg)',
                                style: TextStyle(
                                    fontSize: width * 0.045,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                width: width * 0.45,
                                height: width * 0.15,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: TextFormField(
                                  controller: wieght,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "Entrer Poids",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Volume (M\u00b3)',
                                style: TextStyle(
                                    fontSize: width * 0.045,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                width: width * 0.45,
                                height: width * 0.15,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: TextFormField(
                                  controller: volume,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "Entrer volume",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: width * 0.03),

                      //buy by selector
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Achat par',
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
                            child: DropdownButton<double>(
                              value: product.modifiedProduct!.ARTACHPAR,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (double? by) {
                                product.modifiedProduct!.ARTACHPAR = by;
                                product.notify();
                              },
                              items: product.operationBy
                                  .map<DropdownMenuItem<double>>(
                                      (Map<double, String> by) {
                                return DropdownMenuItem<double>(
                                  value: by.keys.first,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: width * 0.02),
                                    width: width,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Text(
                                      '${by[by.keys.first]}',
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

                      //sell by selector
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vente par',
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
                            child: DropdownButton<double>(
                              value: product.modifiedProduct!.ARTVTEPAR,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (double? by) {
                                product.modifiedProduct!.ARTVTEPAR = by;
                                product.notify();
                              },
                              items: product.operationBy
                                  .map<DropdownMenuItem<double>>(
                                      (Map<double, String> by) {
                                return DropdownMenuItem<double>(
                                  value: by.keys.first,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: width * 0.02),
                                    width: width,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Text(
                                      '${by[by.keys.first]}',
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

                      Center(
                        child: TextButton(
                          style: ButtonStyle(
                              padding:
                                  WidgetStateProperty.all(EdgeInsets.zero)),
                          onPressed: () async {
                            await verifyFields(context);
                            product.notify();
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
                            child: product.modifyButtonVisible
                                ? Text(
                                    "Modifier",
                                    style: TextStyle(
                                        fontSize: width * 0.05,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                : const CircularProgressIndicator(
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
      TextEditingController controller, TextInputType inputType) {
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
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBarcodeField(
      BuildContext context, TextEditingController barcode) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Code à barre',
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
            controller: barcode,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              fillColor: Colors.white,
              filled: true,
              hintText: "Entrer code à barre",
              suffixIcon: IconButton(
                onPressed: () async {
                  final String? rawContent = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
                  );
                  if (rawContent != null && rawContent.isNotEmpty) {
                    barcode.text = rawContent;
                  }
                },
                icon: Icon(Icons.barcode_reader, size: width * 0.1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> verifyFields(BuildContext context) async {
    var stockProvider = Provider.of<StockViewModel>(context, listen: false);
    var productProvider = Provider.of<ProductViewModel>(context, listen: false);
    if (title.text == '' ||
        barcode.text == '' ||
        productProvider.modifiedProduct!.ARTTVA == null ||
        productProvider.modifiedProduct!.ARTTYPE == null ||
        productProvider.modifiedProduct!.ARTFAM == null ||
        productProvider.modifiedProduct!.ARTSFAM == null ||
        productProvider.modifiedProduct!.ARTMARQUE == null ||
        productProvider.modifiedProduct!.ARTUNI == null ||
        productProvider.modifiedProduct!.ARTCOLIS == null ||
        (unitByPackage.text == '' &&
            productProvider.modifiedProduct!.ARTCOLIS != '00') ||
        productProvider.modifiedProduct!.ARTACHPAR == null ||
        productProvider.modifiedProduct!.ARTVTEPAR == null) {
      Toast(
          context: context,
          title: 'Veuillez remplir les champs vides',
          style: ToastificationStyle.minimal,
          type: ToastificationType.warning);
    } else {
      if ((barcode.text == productProvider.selectedProduct!.ARTCAB) ||
          (!stockProvider.filteredProducts.any((element) =>
              element.ARTCAB == barcode.text ||
              element.ARTCAB2 == barcode.text ||
              element.ARTCAB3 == barcode.text ||
              element.ARTCAB4 == barcode.text ||
              element.ARTCAB5 == barcode.text ||
              element.ARTCAB6 == barcode.text ||
              element.ARTCAB7 == barcode.text ||
              element.ARTCAB8 == barcode.text ||
              element.ARTCAB9 == barcode.text ||
              element.ARTCAB10 == barcode.text))) {
        unitByPackage.text =
            unitByPackage.text == '' ? '0' : unitByPackage.text;
        productProvider.modifiedProduct!.ARTNOM = title.text;
        productProvider.modifiedProduct!.ARTNOMSUP = optionalTitle.text;
        productProvider.modifiedProduct!.ARTREF = reference.text;
        productProvider.modifiedProduct!.ARTCAB = barcode.text;
        productProvider.modifiedProduct!.ARTCASIER = casier.text;
        productProvider.modifiedProduct!.ARTQTEINITAB =
            double.parse(qteinit.text == '' ? '0' : qteinit.text);
        productProvider.modifiedProduct!.ARTQTEMIN =
            double.parse(qtemin.text == '' ? '0' : qtemin.text);
        productProvider.modifiedProduct!.ARTQTEMAX =
            double.parse(qtemax.text == '' ? '0' : qtemax.text);
        productProvider.modifiedProduct!.ARTALERTE =
            double.parse(alerte.text == '' ? '0' : alerte.text);
        productProvider.modifiedProduct!.ARTLONG =
            double.parse(long.text == '' ? '0' : long.text);
        productProvider.modifiedProduct!.ARTLARG =
            double.parse(larg.text == '' ? '0' : larg.text);
        productProvider.modifiedProduct!.ARTPOIDS =
            double.parse(wieght.text == '' ? '0' : wieght.text);
        productProvider.modifiedProduct!.ARTVOLUME =
            double.parse(volume.text == '' ? '0' : volume.text);
        productProvider.modifiedProduct!.ARTUNTCOL =
            double.parse(unitByPackage.text == '' ? '0' : unitByPackage.text);
        FocusScope.of(context).unfocus();
        await productProvider.modifyProduct(context);
        if (productProvider.modifyStatusCode == 200) {
          Map<String, dynamic> json = productProvider.modifiedProduct!.toJson();
          productProvider.selectedProduct = Product.modified(json);
          productProvider.notifyListeners();
          Toast(
              context: context,
              title: 'Modifier avec succès',
              style: ToastificationStyle.minimal,
              type: ToastificationType.success);
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => ProductDetails()));
        }
        if (productProvider.modifyStatusCode == 409) {
          Toast(
              context: context,
              title: 'Ce code à barre est déjà existant',
              style: ToastificationStyle.minimal,
              type: ToastificationType.error);
        }
        if (productProvider.modifyStatusCode == 500) {
          Toast(
              context: context,
              title: 'Impossible de se connecter au serveur',
              style: ToastificationStyle.minimal,
              type: ToastificationType.error);
        }
      } else {
        Toast(
            context: context,
            title: 'Ce code à barre est déjà existant',
            style: ToastificationStyle.minimal,
            type: ToastificationType.error);
      }
    }
  }
}
