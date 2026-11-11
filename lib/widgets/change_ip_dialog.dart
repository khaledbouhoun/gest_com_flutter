import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/widgets/toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

class ChangeIPDialog extends StatefulWidget {
  const ChangeIPDialog({super.key});

  @override
  State<StatefulWidget> createState() => ChangeIPDialogState();

  static void showChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const ChangeIPDialog();
      },
    );
  }
}

class ChangeIPDialogState extends State<ChangeIPDialog> {
  late TextEditingController ipController;
  late TextEditingController portController;
  late TextEditingController urlController;
  String _connectionType = 'ip'; // 'ip' or 'url'

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthViewModel>(context, listen: false);
    _connectionType = authProvider.connectionType;
    ipController = TextEditingController(text: authProvider.ipaddress);
    portController = TextEditingController(text: authProvider.port);
    urlController = TextEditingController(text: authProvider.serverUrl);
  }

  @override
  void dispose() {
    ipController.dispose();
    portController.dispose();
    urlController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final authProvider = Provider.of<AuthViewModel>(context, listen: false);

    if (_connectionType == 'ip') {
      final ipText = ipController.text.trim();
      final portText = portController.text.trim();

      if (ipText.isEmpty) {
        Toast(
          context: context,
          title: 'Veuillez saisir une adresse IP valide',
          style: ToastificationStyle.minimal,
          type: ToastificationType.warning,
          duration: 3,
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();

      authProvider.connectionType = 'ip';
      authProvider.ipaddress = ipText;
      authProvider.port = portText;

      await prefs.setString('connection_type', 'ip');
      await prefs.setString('ipaddress', ipText);
      await prefs.setString('port', portText);
      await prefs.setBool('has_configured_network', true);

      authProvider.notify();

      if (mounted) {
        Toast(
          context: context,
          title: 'Adresse IP: ${authProvider.ipaddress}\nPort: ${authProvider.port}',
          style: ToastificationStyle.minimal,
          type: ToastificationType.info,
          duration: 4,
        );
        Navigator.pop(context);
      }
    } else {
      String urlText = urlController.text.trim();

      if (urlText.isEmpty) {
        Toast(
          context: context,
          title: 'Veuillez saisir une URL valide',
          style: ToastificationStyle.minimal,
          type: ToastificationType.warning,
          duration: 3,
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();

      // Add default https:// scheme if missing
      if (!urlText.startsWith('http://') && !urlText.startsWith('https://')) {
        urlText = 'https://$urlText';
      }

      // Remove trailing slashes
      while (urlText.endsWith('/')) {
        urlText = urlText.substring(0, urlText.length - 1);
      }

      // Try parsing URI to keep host & port in sync
      final parsedUri = Uri.tryParse(urlText);
      if (parsedUri != null && parsedUri.host.isNotEmpty) {
        authProvider.ipaddress = parsedUri.host;
        if (parsedUri.hasPort) {
          authProvider.port = parsedUri.port.toString();
        } else {
          authProvider.port = parsedUri.scheme == 'https' ? '443' : '80';
        }
      }

      authProvider.connectionType = 'url';
      authProvider.serverUrl = urlText;

      await prefs.setString('connection_type', 'url');
      await prefs.setString('server_url', urlText);
      await prefs.setString('ipaddress', authProvider.ipaddress);
      await prefs.setString('port', authProvider.port);
      await prefs.setBool('has_configured_network', true);

      authProvider.notify();

      if (mounted) {
        Toast(
          context: context,
          title: 'URL configurée:\n${authProvider.baseUrl}',
          style: ToastificationStyle.minimal,
          type: ToastificationType.info,
          duration: 4,
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final primaryColor = Theme.of(context).secondaryHeaderColor;

    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      content: SingleChildScrollView(
        child: SizedBox(
          width: width > 500 ? 440 : width * 0.85,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.settings_ethernet_rounded,
                      color: primaryColor,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Configuration Réseau',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        Text(
                          'Choisissez le mode de connexion',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Radio Options Container
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: RadioGroup<String>(
                  groupValue: _connectionType,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _connectionType = value;
                      });
                    }
                  },
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        value: 'ip',
                        activeColor: primaryColor,
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        title: const Text(
                          'Hôte local (IP + Port)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        secondary: Icon(Icons.lan_outlined, color: primaryColor, size: 22),
                      ),
                      Divider(height: 1, color: Colors.grey.shade200),
                      RadioListTile<String>(
                        value: 'url',
                        activeColor: primaryColor,
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        title: const Text(
                          'Adresse URL (Domaine / Web)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        secondary: Icon(Icons.link_rounded, color: primaryColor, size: 22),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Dynamic Form based on Selection
              if (_connectionType == 'ip') ...[
                // IP Address field
                _buildFieldLabel('Adresse IP'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: ipController,
                  hint: 'Ex: 192.168.1.1',
                  icon: Icons.computer_rounded,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 14),

                // Port field
                _buildFieldLabel('Port'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: portController,
                  hint: 'Ex: 8282',
                  icon: Icons.numbers_rounded,
                  keyboardType: TextInputType.number,
                ),
              ] else ...[
                // URL field
                _buildFieldLabel('URL du serveur'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: urlController,
                  hint: 'https://exemple.com:8282',
                  icon: Icons.public_rounded,
                  keyboardType: TextInputType.url,
                ),
              ],

              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Annuler',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Confirmer',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2D3748),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        prefixIcon: Icon(icon, size: 20, color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).secondaryHeaderColor,
            width: 1.8,
          ),
        ),
      ),
    );
  }
}
