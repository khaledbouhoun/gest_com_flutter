import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/client_view_model.dart';
import 'package:gestion_stock/view_models/location_view_model.dart';
import 'package:gestion_stock/views/client/add_new_client_coordinates.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/toast.dart';

class AddNewClientAddress extends StatefulWidget {
  const AddNewClientAddress({super.key});

  @override
  State<StatefulWidget> createState() => AddNewClientAddressPage();
}

class AddNewClientAddressPage extends State<AddNewClientAddress>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  final TextEditingController address1 = TextEditingController();
  final TextEditingController address2 = TextEditingController();
  final TextEditingController address3 = TextEditingController();
  final TextEditingController address4 = TextEditingController();
  final TextEditingController localisation = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller!);
  }

  @override
  void dispose() {
    _controller?.dispose();
    address1.dispose();
    address2.dispose();
    address3.dispose();
    address4.dispose();
    localisation.dispose();
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
        body: Consumer2<LocationViewModel, ClientViewModel>(
          builder: (context, location, client, child) {
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
                      const Text('Étape 3 sur 4',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 8),
                      const Text(
                        'Localisation & Adresse',
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
                                    (width * 0.6) * (3 / 4) * _animation!.value,
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
                          'Localisation',
                          [
                            _buildDropdownField<String>(
                              context,
                              'Pays *',
                              client.newClient!.CLIPAYS,
                              location.filtredPays!
                                  .map((p) => DropdownMenuItem(
                                      value: p.PYSNO, child: Text(p.PYSNOM)))
                                  .toList(),
                              (val) {
                                setState(() {
                                  client.newClient!.CLIPAYS = val!;
                                  var terr = location.filtredTerritoires!
                                      .where((e) => e.TERPAYS == val)
                                      .firstOrNull;
                                  if (terr != null) {
                                    client.newClient!.CLITERR = terr.TERNO;
                                    var vil = location.filtredVilles!
                                        .where((e) =>
                                            e.VILPAYS == val &&
                                            e.VILTERR == terr.TERNO)
                                        .firstOrNull;
                                    if (vil != null) {
                                      address3.text = vil.VILNOM ?? '';
                                      client.newClient!.CLIVILLE = vil.VILNO;
                                    }
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildDropdownField<String>(
                              context,
                              'Territoire *',
                              client.newClient!.CLITERR,
                              location.filtredTerritoires!
                                  .where((e) =>
                                      e.TERPAYS == client.newClient!.CLIPAYS)
                                  .map((t) => DropdownMenuItem(
                                      value: t.TERNO,
                                      child: Text('${t.TERNO} - ${t.TERNOM}')))
                                  .toList(),
                              (val) {
                                setState(() {
                                  client.newClient!.CLITERR = val!;
                                  var terr = location.filtredTerritoires!
                                      .where((e) =>
                                          e.TERPAYS ==
                                              client.newClient!.CLIPAYS &&
                                          e.TERNO == val)
                                      .firstOrNull;
                                  if (terr != null) {
                                    address3.text = terr.TERNOM ?? '';
                                  }
                                  var vil = (location.filtredVilles ?? [])
                                      .where((e) =>
                                          e.VILPAYS ==
                                              client.newClient!.CLIPAYS &&
                                          e.VILTERR == val)
                                      .firstOrNull;
                                  if (vil != null) {
                                    client.newClient!.CLIVILLE = vil.VILNO;
                                    address2.text = vil.VILNOM ?? '';
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildDropdownField<String>(
                              context,
                              'Ville *',
                              client.newClient!.CLIVILLE,
                              (location.filtredVilles ?? [])
                                  .where((e) =>
                                      e.VILPAYS == client.newClient!.CLIPAYS &&
                                      e.VILTERR == client.newClient!.CLITERR)
                                  .map((v) => DropdownMenuItem(
                                      value: v.VILNO,
                                      child: Text(v.VILNOM ?? '')))
                                  .toList(),
                              (val) {
                                setState(() {
                                  client.newClient!.CLIVILLE = val!;
                                  var vil = (location.filtredVilles ?? [])
                                      .where((e) =>
                                          e.VILPAYS ==
                                              client.newClient!.CLIPAYS &&
                                          e.VILTERR ==
                                              client.newClient!.CLITERR &&
                                          e.VILNO == val)
                                      .firstOrNull;
                                  if (vil != null) {
                                    address2.text = vil.VILNOM ?? '';
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildSectionCard(
                          context,
                          'Détails de l\'Adresse',
                          [
                            _buildTextField(
                                context,
                                'Adresse Ligne 1',
                                address1,
                                TextInputType.streetAddress,
                                Icons.location_on_outlined),
                            const SizedBox(height: 16),
                            _buildTextField(
                                context,
                                'Adresse Ligne 2',
                                address2,
                                TextInputType.text,
                                Icons.add_location_alt_outlined),
                            const SizedBox(height: 16),
                            _buildTextField(
                                context,
                                'Adresse Ligne 3',
                                address3,
                                TextInputType.text,
                                Icons.map_outlined),
                            const SizedBox(height: 16),
                            _buildTextField(
                                context,
                                'Adresse Ligne 4',
                                address4,
                                TextInputType.text,
                                Icons.mark_as_unread_outlined),
                            const SizedBox(height: 16),
                            _buildTextField(
                                context,
                                'Localisation (Google Maps URL)',
                                localisation,
                                TextInputType.url,
                                Icons.map_outlined,
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.open_in_new,
                                      color: Colors.blue),
                                  onPressed: () async {
                                    if (localisation.text.trim().isNotEmpty) {
                                      final String urlText =
                                          localisation.text.trim();
                                      final Uri? url = Uri.tryParse(urlText);
                                      if (url != null) {
                                        try {
                                          // Note: on Android 11+ canLaunchUrl might return false without <queries>
                                          // We try to launch anyway if it's a valid scheme
                                          bool launched = false;
                                          if (await canLaunchUrl(url)) {
                                            launched = await launchUrl(url,
                                                mode: LaunchMode
                                                    .externalApplication);
                                          }

                                          if (!launched) {
                                            // Fallback attempt if canLaunchUrl was being too strict
                                            try {
                                              await launchUrl(url,
                                                  mode: LaunchMode
                                                      .externalApplication);
                                            } catch (e) {
                                              if (context.mounted) {
                                                Toast(
                                                  context: context,
                                                  title:
                                                      'Impossible d\'ouvrir l\'URL',
                                                  style: ToastificationStyle
                                                      .minimal,
                                                  type:
                                                      ToastificationType.error,
                                                );
                                              }
                                            }
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            Toast(
                                              context: context,
                                              title:
                                                  'Erreur lors de l\'ouverture',
                                              style:
                                                  ToastificationStyle.minimal,
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
                                )),
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
      {Widget? suffixIcon}) {
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
            suffixIcon: suffixIcon,
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
    var provider = Provider.of<ClientViewModel>(context, listen: false);
    var location = Provider.of<LocationViewModel>(context, listen: false);
    if (provider.newClient!.CLIPAYS == null ||
        provider.newClient!.CLITERR == null ||
        provider.newClient!.CLIVILLE == null) {
      Toast(
          context: context,
          title: 'Veuillez remplir les champs obligatoires',
          style: ToastificationStyle.minimal,
          type: ToastificationType.warning);
    } else {
      provider.newClient!.CLIADR1 = address1.text;
      provider.newClient!.CLIADR2 = address2.text.isEmpty
          ? (location.filtredVilles ?? [])
                  .where((e) =>
                      e.VILPAYS == provider.newClient!.CLIPAYS &&
                      e.VILTERR == provider.newClient!.CLITERR)
                  .firstOrNull
                  ?.VILNOM ??
              ''
          : address2.text;
      provider.newClient!.CLIADR3 = address3.text.isEmpty
          ? (location.filtredTerritoires ?? [])
                  .where((e) => e.TERPAYS == provider.newClient!.CLIPAYS)
                  .firstOrNull
                  ?.TERNOM ??
              ''
          : address3.text;
      provider.newClient!.CLIADR4 = address4.text;
      provider.newClient!.CLILOCALISATION = localisation.text;
      FocusScope.of(context).unfocus();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const AddNewClientCoordinates()));
    }
  }
}
