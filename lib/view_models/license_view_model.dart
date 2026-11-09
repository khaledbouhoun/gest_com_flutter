import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
// استيراد ملفات مشروعك
import 'package:gestion_stock/ask_first.dart';
import 'package:gestion_stock/flutter_scure_storage.dart';
import 'package:gestion_stock/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_view_model.dart';

// تعريف حالات الفحص خارج الكلاس ليسهل الوصول إليها
enum CheckResult { success, noInternet, serverError, invalidLicense }

class LicenseViewModel extends ChangeNotifier {
  final AuthViewModel authViewModel;

  LicenseViewModel(this.authViewModel);
  void notify() {
    Future.microtask(() => notifyListeners());
  }

  String? _licenseKey;
  bool _isLoading = false;
  bool _isLoadingDelete = false;
  String? _errorMessage;
  bool _isActivated = false;
  bool _isDialogOpen = false; // لمنع تكرار فتح الـ Dialog

  String? get licenseKey => _licenseKey;
  bool get isLoading => _isLoading;
  bool get isLoadingDelete => _isLoadingDelete;
  String? get errorMessage => _errorMessage;
  bool get isActivated => _isActivated;

  CheckResult checkResult = CheckResult.success;

  Future<CheckResult> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return CheckResult.success;
      }
      return CheckResult.noInternet;
    } catch (_) {
      return CheckResult.noInternet;
    }
  }

  Future<CheckResult> checkActivationStatus() async {
    final prefs = await SharedPreferences.getInstance();

    final licenseKey = await SecureStorageService.getUserKey();

    if (licenseKey == null) {
      _isActivated = false;
      _licenseKey = null;
      await prefs.setBool('is_activated', false);
      notify();
      return CheckResult.invalidLicense;
    }

    final lastCheckStr = prefs.getString('last_sync_date');

    // ⛔ ALWAYS force server check if no cache
    if (lastCheckStr == null) {
      return await _onlineCheckAndSync(prefs, licenseKey);
    }

    final lastCheckDate = formatApiDate(lastCheckStr);
    final isExpired = DateTime.now().difference(lastCheckDate).inHours >= 24;

    // ⛔ expired → must verify server
    if (isExpired) {
      return await _onlineCheckAndSync(prefs, licenseKey);
    }

    // ⚠️ IMPORTANT: still verify lightweight server ping occasionally
    final isStillValid = prefs.getBool('is_activated') ?? false;

    if (!isStillValid) {
      return await _onlineCheckAndSync(prefs, licenseKey);
    }
    _isActivated = true;
    _licenseKey = licenseKey;
    notify();
    return CheckResult.success;
  }

  Future<CheckResult> _onlineCheckAndSync(
    SharedPreferences prefs,
    String licenseKey,
  ) async {
    final result = await performOnlineCheck(licenseKey);

    if (result == CheckResult.success) {
      _isActivated = true;
      _licenseKey = licenseKey;
      await prefs.setBool('is_activated', true);
      await prefs.setString(
        'last_sync_date',
        DateTime.now().toIso8601String(),
      );
      notify();
    } else if (result == CheckResult.invalidLicense) {
      _isActivated = false;
      _licenseKey = null;
      await prefs.setBool('is_activated', false);
      notify();
    } else {
      // In case of noInternet or serverError:
      // If the app was already activated previously, do not revoke the license.
      final wasActivated = prefs.getBool('is_activated') ?? false;
      if (wasActivated) {
        _isActivated = true;
        _licenseKey = licenseKey;
        notify();
      }
    }

    return result;
  }

  Future<CheckResult> performOnlineCheck(String key) async {
    try {
      checkResult = await checkInternet();
      if (checkResult != CheckResult.success) return checkResult;

      final response = await http
          .post(
            Uri.parse('${authViewModel.licenseUrl}/check'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'license_key': key,
              'device_id': authViewModel.deviceInfo?.deviceId,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == false) {
          return CheckResult.invalidLicense;
        }
        final prefs = await SharedPreferences.getInstance();

        if (data['license'] != null && data['license']['last_sync_date'] != null) {
          DateTime localDate = formatApiDate(data['license']['last_sync_date']);

          await prefs.setString('last_sync_date', localDate.toIso8601String());
        }
        return CheckResult.success;
      } else if (response.statusCode >= 500) {
        return CheckResult.serverError;
      } else {
        return CheckResult.invalidLicense;
      }
    } on TimeoutException {
      return CheckResult.serverError;
    } catch (e) {
      debugPrint("Online check failed: $e");
      return CheckResult.serverError;
    }
  }

  bool isLicenseKeyValid(String key) {
    if (key.isEmpty) return false;
    String cleanedKey = key.replaceAll('-', '');
    if (cleanedKey.length < 16) return false;
    final regex = RegExp(r'^[A-Z0-9]{4}(-[A-Z0-9]{4}){3}$');
    return regex.hasMatch(key);
  }

  Future<bool> activateLicense(String key) async {
    if (!isLicenseKeyValid(key)) {
      _errorMessage = 'Veuillez entrer une clé de licence valide.';
      notify();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notify();

    try {
      checkResult = await checkInternet();
      if (checkResult != CheckResult.success) {
        _errorMessage = 'Pas de connexion Internet.';
        _isLoading = false;
        notify();
        return false;
      }

      final url = Uri.parse('${authViewModel.licenseUrl}/activate');
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'license_key': key,
              'device_id': authViewModel.deviceInfo?.deviceId,
              'device_model': authViewModel.deviceInfo?.deviceName,
              'app_id': 1, //gestcom
            }),
          )
          .timeout(const Duration(seconds: 10));
      print(response.body);

      final data = jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
          if (data['success'] == true) {
            _isActivated = true;
            _licenseKey = key;

            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('is_activated', true);
            await SecureStorageService.saveUserKey(key);

            if (data['license'] != null && data['license']['last_sync_date'] != null) {
              DateTime localDate = formatApiDate(
                data['license']['last_sync_date'],
              );

              await prefs.setString(
                'last_sync_date',
                localDate.toIso8601String(),
              );
            }

            if (data['subscription'] != null && data['subscription']['id'] != null) {
              await prefs.setInt('subscription_id', data['subscription']['id']);
            }
            if (data['subscription'] != null && data['subscription']['type_app'] != null) {
              await prefs.setInt('type_app', data['subscription']['type_app']);
            }

            _isLoading = false;
            notify();
            return true;
          }
          break;
        case 401:
          _errorMessage = 'Cette clé de licence est invalide.';
          break;
        case 403:
          _errorMessage = data['error'] ?? 'Cette licence est expirée ou actuellement indisponible.';
          break;
        case 422:
          _errorMessage = 'Les données envoyées sont invalides. Vérifiez les paramètres de l\'appareil.';
          break;
        case 500:
          _errorMessage = 'Erreur interne du serveur. Veuillez contacter le support technique.';
          break;
        default:
          _errorMessage = 'Une erreur inattendue s\'est Articlee (${response.statusCode}).';
      }
    } on SocketException {
      _errorMessage = 'Impossible d\'accéder au serveur. Vérifiez l\'IP et le Firewall.';
    } on TimeoutException {
      _errorMessage = 'Délai de connexion dépassé. Le serveur est trop lent.';
    } catch (e) {
      _errorMessage = 'Une erreur inconnue s\'est Articlee : $e';
    } finally {
      _isLoading = false;
      debugPrint(_errorMessage);
      notify();
    }

    return false;
  }

  // delete licence
  Future<bool> deleteLicense() async {
    _isLoadingDelete = true;
    notify();

    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.delete(
        Uri.parse('${authViewModel.licenseUrl}/deactivate'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'subscription_id': prefs.getInt('subscription_id'),
          'device_id': authViewModel.deviceInfo?.deviceId,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 404) {
        _isActivated = false;
        _licenseKey = null;
        await prefs.remove('is_activated');
        await prefs.remove('license_key');
        await prefs.remove('last_sync_date');
        await prefs.remove('subscription_id');
        await prefs.remove('type_app');
        await SecureStorageService.clearAll();
        return true;
      } else {
        _errorMessage = 'Erreur ${response.statusCode} lors de la suppression de la licence.';
        notify();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erreur ${e.toString()} lors de la suppression de la licence.';
      debugPrint('Error deleting license: $e');
    } finally {
      _isLoadingDelete = false;
      notify();
    }
    return false;
  }

  void checkSecurityOnEntry(BuildContext context) async {
    CheckResult status = await checkActivationStatus();
    if (status != CheckResult.success) {
      showSessionExpiredDialog(context, initialError: status);
    }
  }

  void showSessionExpiredDialog(
    BuildContext context, {
    CheckResult? initialError,
  }) {
    if (_isDialogOpen) return;

    _isDialogOpen = true;

    bool isloading = false;

    String dialogMessage = '';
    if (initialError == CheckResult.noInternet) {
      dialogMessage = 'Pas de connexion Internet. Vérifiez vos paramètres réseau.';
    }
    if (initialError == CheckResult.invalidLicense) {
      dialogMessage = 'Votre licence est invalide ou expirée.';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              bool isnoInternetErorr = initialError == CheckResult.noInternet;
              IconData headerIcon = isnoInternetErorr ? Icons.wifi_off_rounded : Icons.security_rounded;
              Color themeColor = isnoInternetErorr ? Colors.red.shade700 : Colors.blue.shade700;

              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                titlePadding: EdgeInsets.zero,
                title: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: themeColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(headerIcon, color: Colors.white, size: 40),
                      const SizedBox(height: 10),
                      Text(
                        isnoInternetErorr ? 'Erreur de connexion' : 'Alerte de sécurité',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                content: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    dialogMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: isloading
                              ? Padding(
                                  padding: EdgeInsetsGeometry.all(10),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Réessayer'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isloading ? Colors.grey : themeColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            if (!isloading) {
                              setDialogState(() => isloading = true);

                              try {
                                final result = await checkActivationStatus();

                                if (result == CheckResult.success) {
                                  setDialogState(() => isloading = false);
                                  Navigator.of(context).pop();
                                }
                              } finally {
                                setDialogState(() => isloading = false);
                              }
                            } else {
                              return;
                            }
                          },
                        ),
                        TextButton(
                          child: Text(
                            initialError == CheckResult.invalidLicense
                                ? 'Reinitialiser l\'activation'
                                : 'Reinitialiser les données',
                            style: TextStyle(color: Colors.grey),
                          ),
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.remove('last_sync_date');

                            if (context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (builder) => initialError == CheckResult.invalidLicense
                                      ? const MyHomePage()
                                      : const AskFirst(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    ).then((_) => _isDialogOpen = false);
  }

  void clearError() {
    _errorMessage = null;
    notify();
  }

  DateTime formatApiDate(String apiDate) {
    try {
      DateTime parsed = DateTime.parse(apiDate.trim().replaceAll(' ', 'T'));
      return parsed.toLocal();
    } catch (_) {
      return DateTime.now();
    }
  }

  Future<void> clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
