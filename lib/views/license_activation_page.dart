import 'package:flutter/material.dart';
import 'package:gestion_stock/ask_first.dart';
import 'package:gestion_stock/flutter_scure_storage.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../view_models/license_view_model.dart';
import '../widgets/toast.dart';

class LicenseActivationPage extends StatefulWidget {
  const LicenseActivationPage({super.key});

  @override
  State<LicenseActivationPage> createState() => _LicenseActivationPageState();
}

class _LicenseActivationPageState extends State<LicenseActivationPage> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  String _previousText = '';
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _loadSavedKey();
  }

  Future<void> _loadSavedKey() async {
    final savedKey = await SecureStorageService.getUserKey();
    if (savedKey != null && savedKey.isNotEmpty && mounted) {
      setState(() {
        _controller.text = savedKey;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleActivation() async {
    final viewModel = Provider.of<LicenseViewModel>(context, listen: false);
    final key = _controller.text.trim();

    if (key.isEmpty) {
      Toast(
        context: context,
        title: 'Clé de licence requise',
        style: ToastificationStyle.minimal,
        type: ToastificationType.warning,
      );
      return;
    }

    final success = await viewModel.activateLicense(key);

    if (!mounted) return;

    if (success) {
      setState(() {
        _isSuccess = true;
      });
      _animationController.forward();

      // Delay navigation to show success animation
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          // Navigate to home or dashboard
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AskFirst()),
          );
        }
      });
    } else if (viewModel.errorMessage != null) {
      Toast(
        context: context,
        title: viewModel.errorMessage!,
        style: ToastificationStyle.minimal,
        type: ToastificationType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.watch<LicenseViewModel>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor,
              theme.secondaryHeaderColor.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Hero(
                    tag: 'logo',
                    child: Icon(
                      Icons.vpn_key_rounded,
                      size: 60,
                      color: theme.secondaryHeaderColor,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Activation Card
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: _isSuccess ? _buildSuccessView(theme) : _buildActivationForm(theme, viewModel),
                ),

                const SizedBox(height: 40),
                Text(
                  '© 2026 Softel Control. All rights reserved.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivationForm(ThemeData theme, LicenseViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activation de la licence',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Entrez la clé de licence pour continuer à utiliser l\'application.',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        const SizedBox(height: 32),

        // License Key Input
        Text(
          'Clé de licence',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          enabled: !viewModel.isLoading,
          maxLength: 19,
          onChanged: (value) {
            final isDeleting = value.length < _previousText.length;

            // save current value for next change
            _previousText = value;

            // allow delete normally
            if (isDeleting) return;

            const breaks = [4, 9, 14];

            if (breaks.contains(value.length)) {
              final newText = '$value-';

              _controller.value = TextEditingValue(
                text: newText,
                selection: TextSelection.collapsed(
                  offset: newText.length,
                ),
              );

              _previousText = newText;
            }
          },
          decoration: InputDecoration(
            hintText: 'XXXX-XXXX-XXXX-XXXX',
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.secondaryHeaderColor,
                width: 2,
              ),
            ),
            prefixIcon: Icon(Icons.key, color: Colors.grey.shade400),
          ),
        ),

        const SizedBox(height: 32),

        // Activate Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: viewModel.isLoading ? null : _handleActivation,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.secondaryHeaderColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: viewModel.isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Activer maintenant',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),

        if (viewModel.errorMessage != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    viewModel.errorMessage!,
                    style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSuccessView(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              color: Colors.green.shade500,
              size: 80,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Licence activée avec succès !',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Votre application a été activée avec succès.\nRedirection...',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600, height: 1.5),
        ),
      ],
    );
  }
}
