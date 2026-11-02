import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:gestion_stock/views/stock/stock.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:gestion_stock/view_models/product_view_model.dart';
import '../../widgets/toast.dart';

class AddOthers extends StatefulWidget {
  const AddOthers({super.key});

  @override
  State<StatefulWidget> createState() => AddOthersPage();
}

class AddOthersPage extends State<AddOthers>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  final TextEditingController qteinit = TextEditingController();
  final TextEditingController qtemin = TextEditingController();
  final TextEditingController qtemax = TextEditingController();
  final TextEditingController alerte = TextEditingController();
  final TextEditingController long = TextEditingController();
  final TextEditingController larg = TextEditingController();
  final TextEditingController weight = TextEditingController();
  final TextEditingController volume = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _animation = Tween<double>(begin: 0.66, end: 1.0).animate(_controller!);

    Provider.of<StockViewModel>(context, listen: false).newProduct!.ARTACHPAR =
        Provider.of<ProductViewModel>(context, listen: false)
            .operationBy
            .first
            .entries
            .first
            .key;

    Provider.of<StockViewModel>(context, listen: false).newProduct!.ARTVTEPAR =
        Provider.of<ProductViewModel>(context, listen: false)
            .operationBy
            .first
            .entries
            .first
            .key;
  }

  @override
  void dispose() {
    _controller?.dispose();
    qteinit.dispose();
    qtemin.dispose();
    qtemax.dispose();
    alerte.dispose();
    long.dispose();
    larg.dispose();
    weight.dispose();
    volume.dispose();
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
        body: Consumer2<StockViewModel, ProductViewModel>(
          builder: (context, stock, product, child) {
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
                      const Text('Étape 3 sur 3',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 8),
                      const Text(
                        'Autres Détails',
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
                          'Gestion de Stock',
                          [
                            // _buildTextField(
                            //     context,
                            //     'Quantité initial',
                            //     qteinit,
                            //     TextInputType.number,
                            //     Icons.inventory_rounded),
                            // const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                    child: _buildTextField(
                                        context,
                                        'Qté min',
                                        qtemin,
                                        TextInputType.number,
                                        Icons.vertical_align_bottom_rounded)),
                                const SizedBox(width: 16),
                                Expanded(
                                    child: _buildTextField(
                                        context,
                                        'Qté max',
                                        qtemax,
                                        TextInputType.number,
                                        Icons.vertical_align_top_rounded)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                                context,
                                "Stock d'alerte",
                                alerte,
                                TextInputType.number,
                                Icons.warning_amber_rounded),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildSectionCard(
                          context,
                          'Dimensions & Poids',
                          [
                            Row(
                              children: [
                                Expanded(
                                    child: _buildTextField(
                                        context,
                                        'Longueur (M)',
                                        long,
                                        TextInputType.number,
                                        Icons.straighten_rounded)),
                                const SizedBox(width: 16),
                                Expanded(
                                    child: _buildTextField(
                                        context,
                                        'Largeur (M)',
                                        larg,
                                        TextInputType.number,
                                        Icons.straighten_rounded)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                    child: _buildTextField(
                                        context,
                                        'Poids (Kg)',
                                        weight,
                                        TextInputType.number,
                                        Icons.monitor_weight_outlined)),
                                const SizedBox(width: 16),
                                Expanded(
                                    child: _buildTextField(
                                        context,
                                        'Volume (M³)',
                                        volume,
                                        TextInputType.number,
                                        Icons.view_in_ar_rounded)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildSectionCard(
                          context,
                          'Opérations',
                          [
                            _buildDropdownField<double>(
                              context,
                              'Achat par *',
                              stock.newProduct!.ARTACHPAR,
                              product.operationBy
                                  .map((o) => DropdownMenuItem(
                                      value: o.keys.first,
                                      child: Text(o.values.first)))
                                  .toList(),
                              (val) {
                                stock.newProduct!.ARTACHPAR = val;
                                stock.newProduct!.ARTVTEPAR =
                                    product.operationBy.first.keys.first;
                                stock.notifyListeners();
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildDropdownField<double>(
                              context,
                              'Vente par *',
                              stock.newProduct!.ARTVTEPAR,
                              product.operationBy
                                  .map((o) => DropdownMenuItem(
                                      value: o.keys.first,
                                      child: Text(o.values.first)))
                                  .toList(),
                              (val) {
                                stock.newProduct!.ARTVTEPAR = val;
                                stock.notifyListeners();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            if (stock.addButtonVisible) {
                              await verifyFields(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).secondaryHeaderColor,
                            foregroundColor: Colors.white,
                            minimumSize: Size(width * 0.7, 55),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 8,
                            shadowColor: Theme.of(context)
                                .secondaryHeaderColor
                                .withValues(alpha: 0.4),
                          ),
                          child: !stock.addButtonVisible
                              ? const SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : const Text("Ajouter l'Article",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
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
            hintText: "0.0",
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

  Future<void> verifyFields(BuildContext context) async {
    var provider = Provider.of<StockViewModel>(context, listen: false);
    if (provider.newProduct!.ARTACHPAR == null ||
        provider.newProduct!.ARTVTEPAR == null) {
      Toast(
          context: context,
          title: 'Veuillez remplir les champs obligatoires',
          style: ToastificationStyle.minimal,
          type: ToastificationType.warning);
    } else {
      provider.newProduct!.ARTQTEINITAB = double.tryParse(qteinit.text) ?? 0;
      provider.newProduct!.ARTQTEMIN = double.tryParse(qtemin.text) ?? 0;
      provider.newProduct!.ARTQTEMAX = double.tryParse(qtemax.text) ?? 0;
      provider.newProduct!.ARTALERTE = double.tryParse(alerte.text) ?? 0;
      provider.newProduct!.ARTLONG = double.tryParse(long.text) ?? 0;
      provider.newProduct!.ARTLARG = double.tryParse(larg.text) ?? 0;
      provider.newProduct!.ARTPOIDS = double.tryParse(weight.text) ?? 0;
      provider.newProduct!.ARTVOLUME = double.tryParse(volume.text) ?? 0;

      FocusScope.of(context).unfocus();
      await provider.addNewProduct(context);

      if (!mounted) return;

      if (provider.addStatusCode == 200) {
        Toast(
            context: context,
            title: 'Article ajouté avec succès',
            style: ToastificationStyle.minimal,
            type: ToastificationType.success);

        provider.addedProductPrices.clear();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => const Stock()),
            (route) => route.isFirst);
      } else if (provider.addStatusCode == 409) {
        Toast(
            context: context,
            title: 'Cet article existe déjà',
            style: ToastificationStyle.minimal,
            type: ToastificationType.error);
      } else {
        Toast(
            context: context,
            title: 'Erreur lors de l\'ajout',
            style: ToastificationStyle.minimal,
            type: ToastificationType.error);
      }
    }
  }
}
