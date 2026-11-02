import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:gestion_stock/views/stock/add_others.dart';
import 'package:provider/provider.dart';
import 'package:gestion_stock/view_models/product_view_model.dart';
import 'package:gestion_stock/models/subfamily.dart';

class AddClassifications extends StatefulWidget {
  const AddClassifications({super.key});

  @override
  State<StatefulWidget> createState() => AddClassificationsPage();
}

class AddClassificationsPage extends State<AddClassifications>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  final TextEditingController unitByPackage = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _animation = Tween<double>(begin: 0.33, end: 0.66).animate(_controller!);

    Provider.of<StockViewModel>(context, listen: false).newProduct!.ARTFAM =
        Provider.of<ProductViewModel>(context, listen: false)
            .families!
            .first
            .FAMNO;
    Provider.of<StockViewModel>(context, listen: false).newProduct!.ARTSFAM =
        Provider.of<ProductViewModel>(context, listen: false)
            .subfamilies!
            .first
            .SOUNO;
    Provider.of<StockViewModel>(context, listen: false).newProduct!.ARTMARQUE =
        Provider.of<ProductViewModel>(context, listen: false)
            .brands!
            .first
            .MRQNO;

    Provider.of<StockViewModel>(context, listen: false).newProduct!.ARTUNI =
        Provider.of<ProductViewModel>(context, listen: false).units!.last.UNINO;

    Provider.of<StockViewModel>(context, listen: false).newProduct!.ARTCOLIS =
        Provider.of<ProductViewModel>(context, listen: false)
            .packages!
            .first
            .COLNO;
  }

  @override
  void dispose() {
    _controller?.dispose();
    unitByPackage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F9FC),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          title: const Text(
            'Nouvel Article',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Consumer2<ProductViewModel, StockViewModel>(
          builder: (context, product, stock, child) {
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
                      const Text('Étape 2 sur 3',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 8),
                      const Text(
                        'Classifications',
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
                    child: Column(
                      children: [
                        _buildSectionCard(
                          context,
                          'Catégories & Marques',
                          [
                            _buildDropdownField<String>(
                              context,
                              'Famille *',
                              stock.newProduct!.ARTFAM,
                              product.families!
                                  .map((f) => DropdownMenuItem(
                                      value: f.FAMNO, child: Text(f.FAMNOM!)))
                                  .toList(),
                              (val) {
                                stock.newProduct!.ARTFAM = val!;

                                // Safely find the first sub-family for the selected family
                                final matchingSubfamilies = product.subfamilies!
                                    .where((sf) => sf.SOUFAM == val)
                                    .toList();

                                if (matchingSubfamilies.isNotEmpty) {
                                  stock.newProduct!.ARTSFAM =
                                      matchingSubfamilies.first.SOUNO;
                                } else {
                                  stock.newProduct!.ARTSFAM = null;
                                }

                                // Reset brand when family changes to avoid inconsistent states.
                                // This also prevents a crash if product.brands is empty.
                                stock.newProduct!.ARTMARQUE =
                                    product.brands!.first.MRQNO;

                                stock.notify();
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildDropdownField<String>(
                              context,
                              'Sous-Famille *',
                              stock.newProduct!.ARTSFAM,
                              product.subfamilies!
                                  .where((sf) =>
                                      sf.SOUFAM == stock.newProduct!.ARTFAM)
                                  .fold<List<SubFamily>>([], (list, sf) {
                                    if (!list.any((e) => e.SOUNO == sf.SOUNO)) {
                                      list.add(sf);
                                    }
                                    return list;
                                  })
                                  .map((sf) => DropdownMenuItem(
                                      value: sf.SOUNO,
                                      child: Text(sf.SOUNOM ?? '')))
                                  .toList(),
                              (val) {
                                stock.newProduct!.ARTSFAM = val!;
                                stock.newProduct!.ARTMARQUE =
                                    product.brands!.first.MRQNO;
                                stock.notify();
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildDropdownField<String>(
                              context,
                              'Marque *',
                              stock.newProduct!.ARTMARQUE,
                              product.brands!
                                  .map((b) => DropdownMenuItem(
                                      value: b.MRQNO, child: Text(b.MRQNOM!)))
                                  .toList(),
                              (val) {
                                stock.newProduct!.ARTMARQUE = val!;
                                stock.notify();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildSectionCard(
                          context,
                          'Conditionnement',
                          [
                            _buildDropdownField<String>(
                              context,
                              'Unité de mesure *',
                              stock.newProduct!.ARTUNI,
                              product.units!
                                  .map((u) => DropdownMenuItem(
                                      value: u.UNINO, child: Text(u.UNIABV!)))
                                  .toList(),
                              (val) {
                                stock.newProduct!.ARTUNI = val!;
                                stock.newProduct!.ARTCOLIS =
                                    product.packages!.first.COLNO;
                                print(stock.newProduct!.ARTCOLIS);
                                stock.notify();
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildDropdownField<String>(
                              context,
                              'Colisage *',
                              stock.newProduct!.ARTCOLIS,
                              product.packages!
                                  .map((pk) => DropdownMenuItem(
                                      value: pk.COLNO, child: Text(pk.COLNOM!)))
                                  .toList(),
                              (val) {
                                stock.newProduct!.ARTCOLIS = val!;
                                stock.notify();
                              },
                            ),
                            const SizedBox(height: 16),
                            Visibility(
                              visible: stock.newProduct!.ARTCOLIS != '00',
                              child: _buildTextField(
                                  context,
                                  'Unités par Paquet',
                                  unitByPackage,
                                  TextInputType.number,
                                  Icons.layers_outlined),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () => verifyFields(context),
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

  Widget _buildTextField(
      BuildContext context,
      String label,
      TextEditingController controller,
      TextInputType inputType,
      IconData icon) {
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
    var provider = Provider.of<StockViewModel>(context, listen: false);
    provider.newProduct!.ARTUNTCOL = double.tryParse(unitByPackage.text) ?? 0;
    FocusScope.of(context).unfocus();
    Navigator.push(
        context, MaterialPageRoute(builder: (builder) => const AddOthers()));
  }
}
