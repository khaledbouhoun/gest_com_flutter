import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:gestion_stock/load_data.dart';
import 'package:gestion_stock/models/folder.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/widgets/change_ip_dialog.dart';
import 'package:gestion_stock/widgets/toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import 'models/exercice.dart';
import 'models/user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<AuthViewModel>(context, listen: false).getUsersAndFolders(context);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Consumer<AuthViewModel>(
            builder: (context, provider, child) {
              if (provider.statusCode == 0) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                );
              }
              if (provider.statusCode == 500) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                    child: Container(
                      width: width * 0.9,
                      padding: EdgeInsets.all(width * 0.06),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // الأيقونة العلوية
                          Container(
                            padding: EdgeInsets.all(width * 0.05),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFff6b6b).withValues(alpha: 0.1),
                            ),
                            child: Icon(
                              Icons.cloud_off_rounded,
                              size: width * 0.15,
                              color: const Color(0xFFff6b6b),
                            ),
                          ),
                          SizedBox(height: height * 0.025),

                          // العنوان
                          Text(
                            'Erreur de connexion',
                            style: TextStyle(
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2d3436),
                            ),
                          ),
                          SizedBox(height: height * 0.015),

                          // النص التفصيلي الملون (تم تحسينه بـ const)
                          Text.rich(
                            TextSpan(
                              text: 'Impossible de se connecter. La cause peut être le ',
                              style: TextStyle(
                                fontSize: width * 0.038,
                                color: const Color(0xFF636e72),
                                height: 1.5,
                              ),
                              children: const [
                                TextSpan(
                                  text: 'Serveur (Configuration)',
                                  style: TextStyle(
                                    color: Color(0xFFe74c3c),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: ' ou votre '),
                                TextSpan(
                                  text: 'Connexion Internet',
                                  style: TextStyle(
                                    color: Color(0xFFe67e22),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: ' interrompue.\n\nVeuillez vérifier ces éléments.',
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: height * 0.03),

                          // زر إعادة المحاولة
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF14AAF0),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.08,
                                vertical: width * 0.035,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 2,
                            ),
                            onPressed: () {
                              provider.getUsersAndFolders(context);
                            },
                            icon: const Icon(Icons.refresh_rounded),
                            label: Text(
                              'Réessayer',
                              style: TextStyle(
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.015),

                          // زر تغيير الإعدادات
                          TextButton.icon(
                            onPressed: () {
                              ChangeIPDialog.showChangeDialog(context);
                            },
                            icon: Icon(
                              Icons.settings_ethernet_rounded,
                              color: const Color(0xFF14AAF0),
                              size: width * 0.045,
                            ),
                            label: Text(
                              "Changer l'adresse IP et port",
                              style: TextStyle(
                                fontSize: width * 0.035,
                                color: const Color(0xFF14AAF0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: height * 0.05),

                        // Logo/Icon

                        Text(
                          'Connexion',
                          style: TextStyle(
                            fontSize: width * 0.07,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF14AAF0),
                            letterSpacing: 1,
                          ),
                        ),

                        SizedBox(height: height * 0.01),

                        Text(
                          'Gestion de Stock',
                          style: TextStyle(
                            fontSize: width * 0.04,
                            color: Color(0xFF14AAF0).withValues(alpha: 0.9),
                            letterSpacing: 0.5,
                          ),
                        ),

                        SizedBox(height: height * 0.04),

                        // Main form card
                        Container(
                          width: width * 0.9,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDropdownField(
                                context: context,
                                label: 'Utilisateur',
                                icon: Icons.person_rounded,
                                child: DropdownButton<User>(
                                  value: provider.selectedUser,
                                  underline: Container(),
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: const Color(0xFF14AAF0),
                                  ),
                                  onChanged: (User? user) async {
                                    if (user != null) {
                                      provider.selectedUser = user;
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setString('user', provider.selectedUser!.USRNO);
                                      provider.notifyListeners();
                                    }
                                  },
                                  items: provider.users?.map<DropdownMenuItem<User>>((user) {
                                    return DropdownMenuItem<User>(
                                      value: user,
                                      child: Text(
                                        user.USRLOGIN,
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: const Color(0xFF2d3436),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),

                              SizedBox(height: height * 0.025),

                              _buildTextField(
                                context: context,
                                label: 'Mot de passe',
                                icon: Icons.lock_rounded,
                                controller: _passwordController,
                                obscureText: provider.hide,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    provider.hide = !provider.hide;
                                    provider.notifyListeners();
                                  },
                                  icon: Icon(
                                    provider.hide ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                    color: const Color(0xFF14AAF0),
                                  ),
                                ),
                              ),

                              SizedBox(height: height * 0.025),

                              _buildDropdownField(
                                context: context,
                                label: 'Dossier',
                                icon: Icons.folder_rounded,
                                child: DropdownButton<Folder>(
                                  value: provider.selectedFolder,
                                  underline: Container(),
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: const Color(0xFF14AAF0),
                                  ),
                                  onChanged: (Folder? folder) async {
                                    if (folder != null) {
                                      provider.selectedFolder = folder;
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setString('folder', provider.selectedFolder!.DOSNO);
                                      provider.getExercices(context);
                                      provider.notifyListeners();
                                    }
                                  },
                                  items: provider.folders?.map<DropdownMenuItem<Folder>>((folder) {
                                    return DropdownMenuItem<Folder>(
                                      value: folder,
                                      child: Text(
                                        folder.DOSNOM,
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: const Color(0xFF2d3436),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),

                              SizedBox(height: height * 0.025),

                              _buildDropdownField(
                                context: context,
                                label: 'Exercice',
                                icon: Icons.calendar_today_rounded,
                                child: DropdownButton<Exercice>(
                                  value: provider.initialExercice,
                                  underline: Container(),
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: const Color(0xFF14AAF0),
                                  ),
                                  onChanged: (Exercice? exercice) {
                                    provider.initialExercice = exercice;
                                    provider.notifyListeners();
                                  },
                                  items: provider.exercices!.map<DropdownMenuItem<Exercice>>((Exercice exercice) {
                                    return DropdownMenuItem<Exercice>(
                                      value: exercice,
                                      child: Text(
                                        exercice.EXENO.toString(),
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: const Color(0xFF2d3436),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),

                              SizedBox(height: height * 0.04),

                              // Login button
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: provider.buttonVisible ? () => _handleLogin(context, provider) : null,
                                  borderRadius: BorderRadius.circular(16),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color.fromARGB(255, 21, 182, 168), Color(0xFF38ef7d)],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF14AAF0).withValues(alpha: 0.4),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: width * 0.045),
                                      alignment: Alignment.center,
                                      child: provider.buttonVisible
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.login_rounded,
                                                  color: Colors.white,
                                                  size: width * 0.055,
                                                ),
                                                SizedBox(width: width * 0.03),
                                                Text(
                                                  "Se connecter",
                                                  style: TextStyle(
                                                    fontSize: width * 0.045,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : SizedBox(
                                              width: width * 0.06,
                                              height: width * 0.06,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3,
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: height * 0.03),

                        // Change IP button
                        TextButton.icon(
                          onPressed: () {
                            ChangeIPDialog.showChangeDialog(context);
                          },
                          icon: Icon(
                            Icons.settings_ethernet_rounded,
                            color: Colors.white.withValues(alpha: 0.9),
                            size: width * 0.05,
                          ),
                          label: Text(
                            "Changer l'adresse IP et port",
                            style: TextStyle(
                              fontSize: width * 0.038,
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.02),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: width * 0.045, color: const Color(0xFF14AAF0)),
            SizedBox(width: width * 0.02),
            Text(
              label,
              style: TextStyle(
                fontSize: width * 0.04,
                color: const Color(0xFF2d3436),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: width * 0.02),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFf5f6fa),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF14AAF0).withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            style: TextStyle(
              fontSize: width * 0.04,
              color: const Color(0xFF2d3436),
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: width * 0.035,
              ),
              hintText: "Entrer $label",
              hintStyle: TextStyle(
                color: const Color(0xFF636e72).withValues(alpha: 0.5),
                fontSize: width * 0.038,
              ),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Widget child,
  }) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: width * 0.045, color: const Color(0xFF14AAF0)),
            SizedBox(width: width * 0.02),
            Text(
              label,
              style: TextStyle(
                fontSize: width * 0.04,
                color: const Color(0xFF2d3436),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: width * 0.02),
        Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          decoration: BoxDecoration(
            color: const Color(0xFFf5f6fa),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF14AAF0).withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ],
    );
  }

  Future<void> _handleLogin(BuildContext context, AuthViewModel provider) async {
    if (_passwordController.text.isEmpty) {
      Toast(
        context: context,
        title: 'Entrer mot de passe',
        style: ToastificationStyle.minimal,
        type: ToastificationType.warning,
      );
      return;
    }

    List<int> bytes = utf8.encode(_passwordController.text);
    Digest convertedBytes = md5.convert(bytes);
    String hashed = convertedBytes.toString().toUpperCase();

    if (hashed == provider.selectedUser!.USRPASSW) {
      if (provider.selectedUser!.USRETAT == 1) {
        if (provider.selectedUser!.USRTYPE == 2) {
          FocusScope.of(context).unfocus();
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const LoadData(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        } else {
          if (provider.selectedUser!.USRTYPE == 1) {
            await provider.verifyAdmin(context);
          } else {
            await provider.verifyStandard(context);
          }

          if (provider.loginStatusCode == 200) {
            FocusScope.of(context).unfocus();
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const LoadData(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          } else if (provider.loginStatusCode == 404) {
            Toast(
              context: context,
              title: 'Aucun accès au ${provider.selectedFolder!.DOSNOM}',
              style: ToastificationStyle.minimal,
              type: ToastificationType.warning,
            );
          } else if (provider.loginStatusCode == 500) {
            Toast(
              context: context,
              title: 'Impossible de se connecter au serveur. Vérifiez votre serveur',
              style: ToastificationStyle.minimal,
              type: ToastificationType.error,
            );
          }
        }
      } else {
        Toast(
          context: context,
          title: 'Votre compte est suspendu',
          style: ToastificationStyle.minimal,
          type: ToastificationType.error,
        );
      }
    } else {
      Toast(
        context: context,
        title: 'Mot de passe incorrect',
        style: ToastificationStyle.minimal,
        type: ToastificationType.error,
      );
    }
  }
}
