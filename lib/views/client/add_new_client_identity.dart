import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/client_view_model.dart';
import 'package:gestion_stock/view_models/location_view_model.dart';
import 'package:gestion_stock/views/client/add_new_client_contact.dart';
import 'package:gestion_stock/widgets/cancel_add_dialog.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../../widgets/toast.dart';
import 'clients.dart';

class AddNewClientIdentity extends StatefulWidget {
  const AddNewClientIdentity({super.key});

  @override
  State<StatefulWidget> createState() => AddNewClientIdentityPage();
}

class AddNewClientIdentityPage extends State<AddNewClientIdentity>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  final TextEditingController nom = TextEditingController();
  final TextEditingController prenom = TextEditingController();
  final TextEditingController activity = TextEditingController();
  final TextEditingController nomFacturation = TextEditingController();
  final TextEditingController solde = TextEditingController();

  @override
  void initState() {
    super.initState();
    var clientProvider = Provider.of<ClientViewModel>(context, listen: false);
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    var locationProvider =
        Provider.of<LocationViewModel>(context, listen: false);

    // Initialize default values
    if (authProvider.categories.isNotEmpty) {
      clientProvider.newClient!.CLICATEG = authProvider.categories.first.TRCNO;
    }
    if (authProvider.natures.isNotEmpty) {
      clientProvider.newClient!.CLINATURE = authProvider.natures.first.NATNO;
    }

    if (locationProvider.regions.isNotEmpty) {
      clientProvider.newClient!.CLIREGION =
          locationProvider.regions.first.REGNO;
    }
    if (locationProvider.filtredPays != null &&
        locationProvider.filtredPays!.isNotEmpty) {
      clientProvider.newClient!.CLIPAYS =
          locationProvider.filtredPays?.first.PYSNO;
    }

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller!);
  }

  @override
  void dispose() {
    _controller?.dispose();
    nom.dispose();
    prenom.dispose();
    activity.dispose();
    nomFacturation.dispose();
    solde.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        CancelAddDialog.show(context, const Clients());
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F9FC),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          elevation: 0,
          leading: BackButton(
            onPressed: () => CancelAddDialog.show(context, const Clients()),
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          title: const Text(
            'Nouveau client',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Consumer2<AuthViewModel, ClientViewModel>(
          builder: (context, auth, client, child) {
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
                      const Text('Étape 1 sur 4',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 8),
                      const Text(
                        'Identité du Client',
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
                                width:
                                    (width * 0.6) * (1 / 4) * _animation!.value,
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
                          'Catégorisation',
                          [
                            _buildDropdownField<String>(
                              context,
                              'Catégorie',
                              client.newClient!.CLICATEG,
                              auth.categories
                                  .where((e) => e.TRCTYPE == 0)
                                  .map((c) => DropdownMenuItem(
                                      value: c.TRCNO, child: Text(c.TRCNOM)))
                                  .toList(),
                              (val) {
                                client.newClient!.CLICATEG = val!;
                                client.notifyListeners();
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildDropdownField<String>(
                              context,
                              'Nature',
                              client.newClient!.CLINATURE,
                              auth.natures
                                  .map((n) => DropdownMenuItem(
                                      value: n.NATNO,
                                      child: Text('${n.NATABV}')))
                                  .toList(),
                              (val) {
                                client.newClient!.CLINATURE = val!;
                                client.notifyListeners();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildSectionCard(
                          context,
                          'Informations Générales',
                          [
                            _buildTextField(context, 'Nom *', nom,
                                TextInputType.text, Icons.person_outline),
                            const SizedBox(height: 16),
                            _buildTextField(
                              context,
                              'Prénom ${client.newClient!.CLINATURE == '01' || client.newClient!.CLINATURE == '02' ? '*' : ''}',
                              prenom,
                              TextInputType.text,
                              Icons.person_outline,
                              isEnabled: (client.newClient!.CLINATURE == '01' ||
                                  client.newClient!.CLINATURE == '02'),
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(context, 'Activité', activity,
                                TextInputType.text, Icons.work_outline),
                            const SizedBox(height: 16),
                            _buildTextField(
                                context,
                                'Nom Facturation',
                                nomFacturation,
                                TextInputType.text,
                                Icons.receipt_long_outlined),
                            // const SizedBox(height: 16),
                            // _buildTextField(
                            //     context,
                            //     'Solde Initial',
                            //     solde,
                            //     TextInputType.number,
                            //     Icons.account_balance_wallet_outlined),
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
      {bool isEnabled = true}) {
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
          enabled: isEnabled,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: Colors.grey),
            hintText: "Entrer $label",
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: isEnabled
                ? const Color(0xFFF8FAFB)
                : Colors.grey.withOpacity(0.1),
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
    var provider = Provider.of<ClientViewModel>(context, listen: false);
    if (nom.text.isEmpty ||
        (prenom.text.isEmpty &&
            (provider.newClient!.CLINATURE == '01' ||
                provider.newClient!.CLINATURE == '02'))) {
      Toast(
          context: context,
          title: 'Veuillez remplir les champs obligatoires',
          style: ToastificationStyle.minimal,
          type: ToastificationType.warning);
    } else {
      provider.newClient!.CLINOM = nom.text;
      provider.newClient!.CLIPRENOM = prenom.text;
      provider.newClient!.CLIACTIVITE = activity.text;
      provider.newClient!.CLINOMFACT = nomFacturation.text;
      provider.newClient!.CLISOLDE = double.tryParse(solde.text) ?? 0;
      FocusScope.of(context).unfocus();
      Navigator.push(context,
          MaterialPageRoute(builder: (builder) => const AddNewClientContact()));
    }
  }
}
