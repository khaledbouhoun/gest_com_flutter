import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/client_view_model.dart';
import 'package:gestion_stock/views/client/clients.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../../widgets/toast.dart';

class AddNewClientCoordinates extends StatefulWidget {
  const AddNewClientCoordinates({super.key});

  @override
  State<StatefulWidget> createState() => AddNewClientCoordinatesPage();
}

class AddNewClientCoordinatesPage extends State<AddNewClientCoordinates>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  final TextEditingController regCom = TextEditingController();
  final TextEditingController idFiscal = TextEditingController();
  final TextEditingController articleImp = TextEditingController();
  final TextEditingController nis = TextEditingController();
  final TextEditingController note = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _animation = Tween<double>(begin: 0.75, end: 1.0).animate(_controller!);
  }

  @override
  void dispose() {
    _controller?.dispose();
    regCom.dispose();
    idFiscal.dispose();
    articleImp.dispose();
    nis.dispose();
    note.dispose();
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
          scrolledUnderElevation: 0,
          elevation: 0,
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          title: const Text(
            'Nouveau client',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Consumer<ClientViewModel>(
          builder: (context, provider, child) {
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
                        Theme.of(context).secondaryHeaderColor.withOpacity(0.8),
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
                            .withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text('Étape 4 sur 4',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 8),
                      const Text(
                        'Coordonnées & Notes',
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
                              color: Colors.white.withOpacity(0.2),
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
                          'Identifiants Fiscaux',
                          [
                            _buildTextField(
                                context,
                                'Registre de commerce',
                                regCom,
                                TextInputType.text,
                                Icons.description_outlined,
                                maxCracter: 30),
                            const SizedBox(height: 16),
                            _buildTextField(context, 'Identifiant fiscal',
                                idFiscal, TextInputType.text, Icons.fingerprint,
                                maxCracter: 20),
                            const SizedBox(height: 16),
                            _buildTextField(
                                context,
                                'Article d\'imposition',
                                articleImp,
                                TextInputType.text,
                                Icons.receipt_long_outlined,
                                maxCracter: 11),
                            const SizedBox(height: 16),
                            _buildTextField(context, 'NIS', nis,
                                TextInputType.text, Icons.badge_outlined,
                                maxCracter: 20),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildSectionCard(
                          context,
                          'Informations Complémentaires',
                          [
                            _buildTextField(
                                context,
                                'Note',
                                note,
                                TextInputType.multiline,
                                Icons.note_alt_outlined),
                          ],
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            if (provider.addButtonVisible) {
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
                                .withOpacity(0.4),
                          ),
                          child: !provider.addButtonVisible
                              ? const SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : const Text("Ajouter le Client",
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
              color: Colors.black.withOpacity(0.05),
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
      {int? maxCracter}) {
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
          maxLines: inputType == TextInputType.multiline ? 3 : 1,
          maxLength: maxCracter,
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

  Future<void> verifyFields(BuildContext context) async {
    var provider = Provider.of<ClientViewModel>(context, listen: false);
    provider.newClient!.CLIRC = regCom.text;
    provider.newClient!.CLIIF = idFiscal.text;
    provider.newClient!.CLIAI = articleImp.text;
    provider.newClient!.CLINIS = nis.text;
    provider.newClient!.CLINOTES = note.text;

    FocusScope.of(context).unfocus();
    await provider.addNewClient();

    if (provider.addStatusCode == 200) {
      Toast(
          context: context,
          title: 'Client ajouté avec succès',
          style: ToastificationStyle.minimal,
          type: ToastificationType.success);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Clients()),
          (route) => route.isFirst);
    } else if (provider.addStatusCode == 409) {
      Toast(
          context: context,
          title: 'Client déjà existant',
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
