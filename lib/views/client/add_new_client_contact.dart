import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/client_view_model.dart';
import 'package:gestion_stock/views/stock/stock.dart';
import 'package:gestion_stock/widgets/cancel_add_dialog.dart';
import 'package:provider/provider.dart';
import 'add_new_client_address.dart';

class AddNewClientContact extends StatefulWidget {
  const AddNewClientContact({super.key});

  @override
  State<StatefulWidget> createState() => AddNewClientContactPage();
}

class AddNewClientContactPage extends State<AddNewClientContact>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  final TextEditingController tel1 = TextEditingController();
  final TextEditingController tel2 = TextEditingController();
  final TextEditingController fax = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController web = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: false);

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller!)
      ..addListener(() {});
    _controller!.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
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
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.white,
            ),
            backgroundColor: Colors.transparent,
            title: Text(
              'Nouveau client',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.05),
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
                          Theme.of(context)
                              .secondaryHeaderColor
                              .withValues(alpha: 0.8),
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
                              .withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Étape 2 sur 4',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Informations de Contact',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
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
                                  width: (width * 0.6) *
                                      (2 / 4) *
                                      _animation!.value,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionCard(
                            context,
                            'Coordonnées Téléphoniques',
                            [
                              _buildTextField(context, 'Téléphone 1', tel1,
                                  TextInputType.phone, Icons.phone_outlined,
                                  maxLength: 15),
                              const SizedBox(height: 16),
                              _buildTextField(
                                  context,
                                  'Téléphone 2',
                                  tel2,
                                  TextInputType.phone,
                                  Icons.phone_android_outlined,
                                  maxLength: 15),
                              const SizedBox(height: 16),
                              _buildTextField(context, 'Fax', fax,
                                  TextInputType.phone, Icons.fax_outlined,
                                  maxLength: 15),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildSectionCard(
                            context,
                            'Présence Numérique',
                            [
                              _buildTextField(
                                  context,
                                  'Email',
                                  email,
                                  TextInputType.emailAddress,
                                  Icons.email_outlined),
                              const SizedBox(height: 16),
                              _buildTextField(context, 'Web', web,
                                  TextInputType.url, Icons.language_outlined),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: ElevatedButton(
                              onPressed: () => verifyFields(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).secondaryHeaderColor,
                                foregroundColor: Colors.white,
                                minimumSize: Size(width * 0.7, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 5,
                              ),
                              child: const Text(
                                "Continuer",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          )),
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
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String label,
      TextEditingController controller, TextInputType inputType, IconData icon,
      {int? maxLength}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: inputType,
          maxLength: maxLength,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: Colors.grey),
            hintText: "Entrer $label",
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: const Color(0xFFF8FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: Theme.of(context).secondaryHeaderColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  void verifyFields(BuildContext context) {
    var provider = Provider.of<ClientViewModel>(context, listen: false);
    provider.newClient!.CLITEL1 = tel1.text;
    provider.newClient!.CLITEL2 = tel2.text;
    provider.newClient!.CLIFAX = fax.text;
    provider.newClient!.CLIEMAIL = email.text;
    provider.newClient!.CLIWEB = web.text;
    FocusScope.of(context).unfocus();
    Navigator.push(context,
        MaterialPageRoute(builder: (builder) => const AddNewClientAddress()));
  }
}
