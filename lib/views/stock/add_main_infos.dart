import 'dart:convert';
import 'dart:io';

import 'package:gestion_stock/widgets/barcode_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:gestion_stock/models/tarif_detail.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:gestion_stock/view_models/product_view_model.dart';
import 'package:gestion_stock/views/stock/add_classifications.dart';
import 'package:gestion_stock/views/stock/stock.dart';
import 'package:gestion_stock/widgets/cancel_add_dialog.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../../widgets/toast.dart';
import '../../widgets/product_tarif_widget.dart';
import 'package:http/http.dart' as http;

class AddMainInfos extends StatefulWidget {
  const AddMainInfos({super.key});

  @override
  State<StatefulWidget> createState() => AddMainInfosPage();
}

class AddMainInfosPage extends State<AddMainInfos>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  final TextEditingController title = TextEditingController();
  final TextEditingController optionalTitle = TextEditingController();
  final TextEditingController reference = TextEditingController();
  final TextEditingController barcode = TextEditingController();
  final TextEditingController casier = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFetchingBarcode = false;
  List<TarifDetail> listtarifslocal = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _animation = Tween<double>(begin: 0.0, end: 0.33).animate(_controller!);
  }

  Future<void> generateBarcode(AuthViewModel auth) async {
    if (_isFetchingBarcode) return;
    _isFetchingBarcode = true;
    try {
      http.Response response = await http.get(Uri.parse(
          "http://${auth.ipaddress}:${auth.port}/Code_Bar_Gnr?path=${auth.selectedFolder?.DOSBDD}"));
      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body);
        barcode.text = data['cab'];
      }
    } catch (e) {
      print("error ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingBarcode = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    title.dispose();
    optionalTitle.dispose();
    reference.dispose();
    barcode.dispose();
    casier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        CancelAddDialog.show(context, const Stock());
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F9FC),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          leading: BackButton(
            onPressed: () {
              title.clear();
              optionalTitle.clear();
              reference.clear();
              barcode.clear();
              casier.clear();
              listtarifslocal.clear();

              CancelAddDialog.show(context, const Stock());
            },
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          title: const Text(
            'Nouvel Article',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Consumer3<ProductViewModel, StockViewModel, AuthViewModel>(
          builder: (context, product, stock, auth, child) {
            if (barcode.text.isEmpty && !_isFetchingBarcode) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (barcode.text.isEmpty && !_isFetchingBarcode) {
                  generateBarcode(auth);
                }
              });
            }
            return Column(
              children: [
                Container(
                  width: width,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 20,
                    bottom: 25,
                    left: 20,
                    right: 20,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).secondaryHeaderColor,
                        Theme.of(context)
                            .secondaryHeaderColor
                            .withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .secondaryHeaderColor
                            .withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text('Étape 1 sur 3',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 8),
                      const Text(
                        'Informations Principales',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 15),
                      Stack(
                        children: [
                          Container(
                            width: width * 0.6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _animation!,
                            builder: (context, child) {
                              return Container(
                                width: (width * 0.6) * _animation!.value,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildSectionCard(
                            context,
                            'Informations de Base',
                            [
                              _buildTextField(
                                  context,
                                  'Désignation *',
                                  title,
                                  TextInputType.text,
                                  Icons.shopping_bag_outlined,
                                  required: true),
                              const SizedBox(height: 16),
                              _buildTextField(
                                  context,
                                  'Désignation Optionnelle',
                                  optionalTitle,
                                  TextInputType.text,
                                  Icons.label_outline),
                              const SizedBox(height: 16),
                              _buildTextField(context, 'Référence', reference,
                                  TextInputType.text, Icons.tag),
                              const SizedBox(height: 16),
                              _buildBarcodeField(context, 'Code à barre',
                                  barcode, Icons.qr_code_scanner, auth),
                              const SizedBox(height: 16),
                              _buildTextField(
                                  context,
                                  'Casier',
                                  casier,
                                  TextInputType.text,
                                  Icons.inventory_2_outlined),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildSectionCard(
                            context,
                            'Paramètres de Vente',
                            [
                              _buildDropdownField<String>(
                                context,
                                'TVA',
                                stock.newProduct!.ARTTVA,
                                product.tvas!
                                    .map((t) => DropdownMenuItem(
                                        value: t.TVANO,
                                        child: Text('${t.TVATAUX}%')))
                                    .toList(),
                                (val) {
                                  stock.newProduct!.ARTTVA = val!;
                                  stock.notify();
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildDropdownField<double>(
                                context,
                                'Type d\'article',
                                stock.newProduct!.ARTTYPE,
                                const [
                                  DropdownMenuItem(
                                      value: 0.0, child: Text('Stockable')),
                                  DropdownMenuItem(
                                      value: 1.0, child: Text('Service')),
                                ],
                                (val) {
                                  stock.newProduct!.ARTTYPE = val!;
                                  stock.notify();
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildSectionCard(
                            context,
                            'Tarifs de Vente',
                            [
                              if (stock.tarifs != null &&
                                  listtarifslocal.isEmpty)
                                Center(
                                  child: TextButton.icon(
                                    onPressed: () {
                                      for (var t in stock.tarifs!) {
                                        listtarifslocal.add(TarifDetail(
                                          tfdtfe: t.TFENO,
                                          tariftype: t.TFETYPE,
                                          ttc: 0.0,
                                          marge: 0.0,
                                          base: 1,
                                        ));
                                      }
                                      stock.notify();
                                    },
                                    icon: const Icon(Icons.add_chart),
                                    label: const Text("Générer les tarifs"),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Theme.of(context)
                                          .secondaryHeaderColor,
                                    ),
                                  ),
                                ),
                              ...listtarifslocal.map((tarif) {
                                return ProductTarifWidget(
                                  tarif: tarif,
                                  direction: 1,
                                );
                              }),
                            ],
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () => _formKey.currentState!.validate()
                                ? verifyFields(context)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).secondaryHeaderColor,
                              foregroundColor: Colors.white,
                              minimumSize: Size(width * 0.7, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 5,
                            ),
                            child: const Text("Continuer",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionCard(
      BuildContext context, String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).secondaryHeaderColor)),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String label,
      TextEditingController controller, TextInputType inputType, IconData icon,
      {bool required = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        const SizedBox(height: 8),
        TextFormField(
          validator: required
              ? (value) {
                  if (value!.isEmpty) {
                    return "Veuillez entrer $label";
                  }
                  return null;
                }
              : null,
          controller: controller,
          keyboardType: inputType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: Colors.grey),
            hintText: "Entrer $label",
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: const Color(0xFFF8FAFB),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFFE0E0E0), width: 1)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: Theme.of(context).secondaryHeaderColor, width: 1.5)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1)),
          ),
        ),
      ],
    );
  }

  Widget _buildBarcodeField(BuildContext context, String label,
      TextEditingController controller, IconData icon, AuthViewModel auth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: IconButton(
              icon: Icon(Icons.qr_code_rounded, size: 20, color: Colors.blue),
              onPressed: () async {
                generateBarcode(auth);
              },
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.camera_alt_outlined, color: Colors.blue),
              onPressed: () async {
                final String? rawContent = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
                );
                if (!mounted) return;
                if (rawContent != null && rawContent.isNotEmpty) {
                  controller.text = rawContent;
                }
              },
            ),
            hintText: "Scanner ou entrer $label",
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: const Color(0xFFF8FAFB),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFFE0E0E0), width: 1)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: Theme.of(context).secondaryHeaderColor, width: 1.5)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>(BuildContext context, String label, T? value,
      List<DropdownMenuItem<T>> items, ValueChanged<T?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              items: items,
              onChanged: onChanged,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  void verifyFields(BuildContext context) {
    if (title.text.isEmpty) {
      Toast(
          context: context,
          title: 'Veuillez entrer une désignation',
          style: ToastificationStyle.minimal,
          type: ToastificationType.warning);
      return;
    }
    var provider = Provider.of<StockViewModel>(context, listen: false);
    provider.newProduct!.ARTNOM = title.text;
    provider.newProduct!.ARTNOMSUP = optionalTitle.text;
    provider.newProduct!.ARTREF = reference.text;
    provider.newProduct!.ARTCAB = barcode.text;
    provider.newProduct!.ARTCASIER = casier.text;
    provider.addedProductPrices = listtarifslocal;

    FocusScope.of(context).unfocus();
    Navigator.push(context,
        MaterialPageRoute(builder: (builder) => const AddClassifications()));
  }
}
