import 'package:flutter/material.dart';
import 'package:gestion_stock/login.dart';
import 'package:gestion_stock/main.dart';
import 'package:gestion_stock/view_models/license_view_model.dart';
import 'package:gestion_stock/widgets/change_ip_dialog.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class AskFirst extends StatefulWidget {
  const AskFirst({super.key});

  @override
  State<AskFirst> createState() => _AskFirstState();
}

class _AskFirstState extends State<AskFirst> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.all(width * 0.08),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.white.withValues(alpha: 0.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.3),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Text.rich(TextSpan(children: [
                            TextSpan(
                              text: "Gest",
                              style: TextStyle(
                                fontSize: width * 0.1,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF14AAF0),
                              ),
                            ),
                            TextSpan(
                              text: "Com",
                              style: TextStyle(
                                fontSize: width * 0.1,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2d3436),
                              ),
                            ),
                          ]))),

                      SizedBox(height: height * 0.06),

                      // Main card
                      Container(
                        width: width * 0.85,
                        margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                        padding: EdgeInsets.all(width * 0.06),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Configuration Réseau",
                              style: TextStyle(
                                fontSize: width * 0.055,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2d3436),
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            Text(
                              "Voulez-vous changer l'adresse IP et le port, ou continuer avec les paramètres actuels?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: width * 0.038,
                                color: const Color(0xFF636e72),
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: height * 0.04),

                            // Buttons
                            _buildModernButton(
                              context: context,
                              label: "Continuer",
                              icon: Icons.arrow_forward_rounded,
                              gradient: const LinearGradient(
                                colors: [Color.fromARGB(255, 21, 182, 168), Color(0xFF38ef7d)],
                              ),
                              onPressed: () async {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Vérification des paramètres...'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                                CheckResult isLicenseValid = await Provider.of<LicenseViewModel>(
                                  context,
                                  listen: false,
                                ).checkActivationStatus();

                                if (isLicenseValid == CheckResult.success || true) {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => const Login(),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        return FadeTransition(opacity: animation, child: child);
                                      },
                                    ),
                                  );
                                } else {
                                  Provider.of<LicenseViewModel>(
                                    context,
                                    listen: false,
                                  ).showSessionExpiredDialog(
                                    context,
                                    initialError: isLicenseValid,
                                  );
                                }
                              },
                            ),

                            SizedBox(height: height * 0.02),

                            _buildModernButton(
                              context: context,
                              label: "Changer Configuration",
                              icon: Icons.settings_rounded,
                              gradient: const LinearGradient(
                                colors: [Color.fromARGB(255, 52, 134, 155), Color.fromARGB(255, 70, 198, 230)],
                              ),
                              onPressed: () async {
                                ChangeIPDialog.showChangeDialog(context);
                              },
                            ),
                            SizedBox(height: height * 0.02),

                            _buildModernButton(
                              context: context,
                              label: "Déconnecté",
                              icon: Icons.logout_rounded,
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 161, 40, 40),
                                  Color.fromARGB(255, 230, 52, 52),
                                ],
                              ),
                              onPressed: () async {
                                var licenseViewModel = Provider.of<LicenseViewModel>(
                                  context,
                                  listen: false,
                                );
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    backgroundColor: Theme.of(context).cardColor,
                                    contentPadding: const EdgeInsets.all(20),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent.withValues(alpha: 0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.warning_amber_rounded,
                                              size: 50, color: Colors.redAccent),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          'Déconnexion',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).textTheme.bodyLarge?.color,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Voulez-vous vraiment déconnecter cet appareil ?',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                                          ),
                                        ),
                                        const SizedBox(height: 25),
                                        Row(
                                          children: [
                                            // زر الإلغاء
                                            Expanded(
                                              child: TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                style: TextButton.styleFrom(
                                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                                  shape:
                                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                ),
                                                child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            // زر التأكيد
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  // نستخدم الـ ViewModel هنا
                                                  bool isDeleted = await licenseViewModel.deleteLicense();
                                                  if (isDeleted) {
                                                    if (context.mounted) {
                                                      licenseViewModel.clearPrefs();
                                                      Navigator.pop(context);
                                                      Navigator.pushReplacement(
                                                        context,
                                                        PageRouteBuilder(
                                                          pageBuilder: (_, __, ___) => const MyHomePage(),
                                                          transitionsBuilder: (_, anim, __, child) =>
                                                              FadeTransition(opacity: anim, child: child),
                                                        ),
                                                      );
                                                    }
                                                  } else {
                                                    Toastification().show(
                                                      context: context,
                                                      title: Text(
                                                        licenseViewModel.errorMessage!,
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      type: ToastificationType.error,
                                                    );
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.redAccent,
                                                  foregroundColor: Colors.white,
                                                  elevation: 0,
                                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                                  shape:
                                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                ),
                                                child: Consumer<LicenseViewModel>(
                                                  builder: (context, vm, _) {
                                                    return vm.isLoadingDelete
                                                        ? const SizedBox(
                                                            height: 20,
                                                            width: 20,
                                                            child: CircularProgressIndicator(
                                                                strokeWidth: 2, color: Colors.white),
                                                          )
                                                        : const Text('Confirmer',
                                                            style: TextStyle(fontWeight: FontWeight.bold));
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: height * 0.1),

                      // Footer text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 20,
                        children: [
                          Text(
                            "Par",
                            style: TextStyle(
                              fontSize: width * 0.05,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Image.asset("assets/softel_logo.png", width: width * 0.3),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onPressed,
  }) {
    final width = MediaQuery.of(context).size.width;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        focusColor: Colors.transparent,
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: width * 0.15,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withValues(alpha: 0.4),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(5, 5),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            vertical: width * 0.04,
            horizontal: width * 0.06,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: width * 0.055),
              SizedBox(width: width * 0.03),
              Text(
                label,
                style: TextStyle(
                  fontSize: width * 0.042,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
