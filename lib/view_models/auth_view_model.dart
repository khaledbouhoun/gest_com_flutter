import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_stock/devicehelper.dart';
import 'package:gestion_stock/models/access.dart';
import 'package:gestion_stock/models/buysettings.dart';
import 'package:gestion_stock/models/caisse_settings.dart';
import 'package:gestion_stock/models/folder.dart';
import 'package:gestion_stock/models/gensettings.dart';
import 'package:gestion_stock/models/nature.dart';
import 'package:gestion_stock/models/rubrique.dart';
import 'package:gestion_stock/models/tiers_category.dart';
import 'package:gestion_stock/models/user.dart';
import 'package:gestion_stock/widgets/http_extensions.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/exercice.dart';
import '../models/sell_settings.dart';

enum ApplicationType { none, general, consultation }

class AuthViewModel extends ChangeNotifier {
  final Future<SharedPreferences> _prefsFuture = SharedPreferences.getInstance();

  String? token; // أضف هذا المتغير
  String ipaddress = '';
  String port = '';

  Future<ApplicationType> get typeApp async {
    final prefs = await _prefsFuture;
    // final index = prefs.getInt('type_app') ?? 0;
    final index = prefs.getInt('type_app') ?? 1;

    return ApplicationType.values[index];
  }

  // دالة لتحديث التوكن بعد تسجيل الدخول من Laravel
  void updateToken(String newToken) {
    token = newToken;
    notify();
  }

  String get baseUrl => "http://$ipaddress:$port";

  String get licenseUrl => 'https://licenseactivation.softel.dz/api';

  DeviceInfo? deviceInfo;

  List<User>? users;
  User? selectedUser;

  List<Folder>? folders;
  Folder? selectedFolder;

  int statusCode = 0;
  int exeStatusCode = 0;
  int loginStatusCode = 0;
  int categoryStatusCode = 0;
  int sellSettingsStatusCode = 0;
  int caisseSettingsStatusCode = 0;
  int buySettingsStatusCode = 0;
  bool hide = true;
  bool buttonVisible = true;

  List<Exercice>? exercices = []; //list of all available exercices
  Exercice? selectedExercice; //the exercice that was chosen by the user on each section(stock, clients, ...)
  Exercice? initialExercice; //the exercice that was chosen by the user on login page to be the default one

  List<Access>? accessList;
  List<Rubrique> rubriques = [];

  List<Nature> natures = [];

  List<TiersCategory> categories = [];

  SellSettings? sellSettings;
  GenSettings? genSettings;
  BuySettings? buySettings;
  String catgClr = '00';

  CaisseSettings? caisseSettings;

  // list rubriques
  List<RubriqueLIst> rubriquesCaisse = [];
  List<RubriqueLIst> stkFamills = [];
  List<RubriqueLIst> stkDepots = [];

  List<RubriqueLIst> stkJournaux = [];
  List<RubriqueLIst> vteJournaux = [];
  List<RubriqueLIst> vteTarifs = [];
  List<RubriqueLIst> achtJournaux = [];
  List<RubriqueLIst> catgClients = [];

  List<RubriqueLIst> clientsTerritoires = [];
  List<RubriqueLIst> catgFournisseurs = [];

  List<RubriqueLIst> comptes = [];

  void notify() {
    Future.microtask(() => notifyListeners());
  }

  Future<void> getDeviceInfo() async {
    deviceInfo = await DeviceHelper.getDeviceInfo();
  }

  _DatePeriod resolvePeriod() {
    final now = DateTime.now().year == initialExercice!.EXENO! ? DateTime.now() : DateTime(initialExercice!.EXENO!, 12, 31);

    switch (sellSettings?.PRMBLINTERVDATE) {
      /// سنة كاملة
      case 0:
        return _DatePeriod(
          start: DateTime(initialExercice!.EXENO!, 1, 1),
          end: DateTime(initialExercice!.EXENO!, 12, 31),
        );

      /// شهر جاري
      case 1:
        final firstDayNextMonth = DateTime(initialExercice!.EXENO!, now.month + 1, 1);

        return _DatePeriod(
          start: DateTime(initialExercice!.EXENO!, now.month, 1),
          end: firstDayNextMonth.subtract(const Duration(days: 1)),
        );

      /// أسبوع (السبت → الخميس)
      case 2:
        final daysToPreviousSaturday = (now.weekday + 1) % 7;
        final start = now.subtract(Duration(days: daysToPreviousSaturday));

        var daysToNextThursday = (DateTime.thursday - now.weekday + 7) % 7;
        if (daysToNextThursday == 0) daysToNextThursday = 7;

        final end = now.add(Duration(days: daysToNextThursday));

        return _DatePeriod(start: start, end: end);

      /// اليوم
      case 3:
      default:
        return _DatePeriod(start: now, end: now);
    }
  }

  Future getUsersAndFolders(BuildContext context) async {
    try {
      statusCode = 0;
      notify();
      http.Response response = await "/getuserandfolder".authPost(context, null);
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        users = User.listFromJson(data['users']);
        folders = Folder.listFromJson(data['folders']);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? user = prefs.getString('user');
        String? folder = prefs.getString('folder');
        if (user == null) {
          selectedUser = (users != null && users!.isNotEmpty) ? users!.first : null;
          if (selectedUser != null) prefs.setString('user', selectedUser!.USRNO);
        } else {
          try {
            User? savedUser = users?.firstWhere((element) => element.USRNO == user);
            selectedUser = savedUser ?? ((users != null && users!.isNotEmpty) ? users!.first : null);
            if (selectedUser != null) prefs.setString('user', selectedUser!.USRNO);
          } catch (e) {
            selectedUser = (users != null && users!.isNotEmpty) ? users!.first : null;
            if (selectedUser != null) prefs.setString('user', selectedUser!.USRNO);
          }
        }
        if (folder == null) {
          selectedFolder = (folders != null && folders!.isNotEmpty) ? folders!.first : null;
          if (selectedFolder != null) prefs.setString('folder', selectedFolder!.DOSNO);
        } else {
          try {
            Folder? savedFolder = folders?.firstWhere((element) => element.DOSNO == folder);
            selectedFolder = savedFolder ?? ((folders != null && folders!.isNotEmpty) ? folders!.first : null);
            if (selectedFolder != null) prefs.setString('folder', selectedFolder!.DOSNO);
          } catch (e) {
            selectedFolder = (folders != null && folders!.isNotEmpty) ? folders!.first : null;
            if (selectedFolder != null) prefs.setString('folder', selectedFolder!.DOSNO);
          }
        }
        getExercices(context);
      } else if (response.statusCode == 404) {
        statusCode = 404;
        users = [];
        folders = [];
      }
      notify();
    } catch (err) {
      print(err);
      statusCode = 500;
      notify();
    }
  }

  //get exercices
  Future getExercices(BuildContext context) async {
    try {
      exeStatusCode = 0;
      notify();
      http.Response response =
          // await http.post(Uri.parse('http://$ipaddress:$port/auth/get_folder_exercices'), body: {'path': selectedFolder!.DOSBDD});
          await "/get_folder_exercices".authPost(context, {'path': selectedFolder!.DOSBDD});
      exeStatusCode = response.statusCode;
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        exercices = Exercice.exercicesFromJson(data['exercices']);
        initialExercice = exercices!.isNotEmpty ? exercices!.first : null;
        selectedExercice = initialExercice;
      } else if (response.statusCode == 404) {
        exeStatusCode = 404;
        exercices = [];
        initialExercice = null;
        selectedExercice = null;
      }
      notify();
    } catch (err) {
      exeStatusCode = 500;
      notify();
    }
  }

  //verify admin access to folder
  Future verifyAdmin(BuildContext context) async {
    try {
      loginStatusCode = 0;
      buttonVisible = !buttonVisible;
      notify();
      http.Response response = await "/verify_admin?user=${selectedUser!.USRNO}&folder=${selectedFolder!.DOSNO}".authPost(context, null);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        accessList = Access.listFromJson(data['access']);
      } else if (response.statusCode == 404) {
        loginStatusCode = 404;
        accessList = [];
      }
      loginStatusCode = response.statusCode;
      buttonVisible = !buttonVisible;
      notify();
    } catch (err) {
      buttonVisible = !buttonVisible;
      loginStatusCode = 500;
      notify();
    }
  }

  //verify standard user access to folder
  Future verifyStandard(BuildContext context) async {
    try {
      loginStatusCode = 0;
      buttonVisible = !buttonVisible;
      notify();
      http.Response response = await "/verify_standard?user=${selectedUser!.USRNO}&folder=${selectedFolder!.DOSNO}".authPost(context, null);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        accessList = Access.listFromJson(data['access']);
      } else if (response.statusCode == 404) {
        loginStatusCode = 404;
        accessList = [];
      }
      loginStatusCode = response.statusCode;
      buttonVisible = !buttonVisible;
      notify();
    } catch (err) {
      buttonVisible = !buttonVisible;
      loginStatusCode = 500;
      notify();
    }
  }

  bool verifyAccess(String resourcetype, String resource, String droit) {
    if (selectedUser!.USRTYPE == 0) {
      return accessList!.where((element) => element.URSTRS == resourcetype && element.URSRES == resource && element.URSDRO == droit).length == 1;
    } else if (selectedUser!.USRTYPE == 1) {
      return accessList!.where((element) => element.URSTRS == resourcetype && element.URSRES == resource && element.URSDRO == droit).isEmpty;
    } else {
      return true;
    }
  }

  //get rubriques
  Future getRubriques(BuildContext context) async {
    try {
      exeStatusCode = 0;
      notify();
      http.Response response = await "/get_rubriques?user=${selectedUser!.USRNO}&folder=${selectedFolder!.DOSNO}".authPost(context, null);
      exeStatusCode = response.statusCode;
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        rubriques = Rubrique.listFromJson(data['rubriques']);
        gnrateRubriques();
      } else if (response.statusCode == 404) {
        rubriques = [];
      }
      notify();
    } catch (err) {
      print('rub $err');
      exeStatusCode = 500;
      notify();
    }
  }

  void gnrateRubriques() {
    rubriquesCaisse = rubriques
        .where((r) => r.USBTRS == '07' && r.USBTRB == '02')
        .map((r) => RubriqueLIst(rubrique: r.USBRUB, read: r.USBREAD == 2, write: r.USBWRITE == 2))
        .toList();
    stkFamills = rubriques
        .where((r) => r.USBTRS == '01' && r.USBTRB == '02')
        .map((r) => RubriqueLIst(rubrique: r.USBRUB, read: r.USBREAD == 2, write: r.USBWRITE == 2))
        .toList();
    stkDepots = rubriques
        .where((r) => r.USBTRS == '01' && r.USBTRB == '01')
        .map((r) => RubriqueLIst(rubrique: r.USBRUB, read: r.USBREAD == 2, write: r.USBWRITE == 2))
        .toList();

    vteTarifs = rubriques
        .where((r) => r.USBTRS == '03' && r.USBTRB == '01')
        .map((r) => RubriqueLIst(rubrique: r.USBRUB, read: r.USBREAD == 2, write: r.USBWRITE == 2))
        .toList();
    stkJournaux = rubriques
        .where((r) => r.USBTRS == '01' && r.USBTRB == '03')
        .map((r) => RubriqueLIst(rubrique: r.USBRUB, read: r.USBREAD == 2, write: r.USBWRITE == 2))
        .toList();

    achtJournaux = rubriques
        .where((r) => r.USBTRS == '02' && r.USBTRB == '02')
        .map((r) => RubriqueLIst(rubrique: r.USBRUB, read: r.USBREAD == 2, write: r.USBWRITE == 2))
        .toList();
    catgFournisseurs = rubriques
        .where((r) => r.USBTRS == '02' && r.USBTRB == '01')
        .map((r) => RubriqueLIst(rubrique: r.USBRUB, read: r.USBREAD == 2, write: r.USBWRITE == 2))
        .toList();

    vteJournaux = rubriques
        .where((r) => r.USBTRS == '03' && r.USBTRB == '03')
        .map((r) => RubriqueLIst(rubrique: r.USBRUB, read: r.USBREAD == 2, write: r.USBWRITE == 2))
        .toList();
    catgClients = rubriques
        .where((r) => r.USBTRS == '03' && r.USBTRB == '02')
        .map((r) => RubriqueLIst(rubrique: r.USBRUB, read: r.USBREAD == 2, write: r.USBWRITE == 2))
        .toList();
    clientsTerritoires = rubriques
        .where((r) => r.USBTRS == '03' && r.USBTRB == '04')
        .map((r) => RubriqueLIst(rubrique: r.USBRUB, read: r.USBREAD == 2, write: r.USBWRITE == 2))
        .toList();

    comptes = rubriques
        .where((r) => r.USBTRS == '07' && r.USBTRB == '01')
        .map((r) => RubriqueLIst(rubrique: r.USBRUB, read: r.USBREAD == 2, write: r.USBWRITE == 2))
        .toList();

    print(
        'stkFamills: ${stkFamills.length}, stkDepots: ${stkDepots.length}, stkJournaux: ${stkJournaux.length}, achtJournaux: ${achtJournaux.length}, catgFournisseurs: ${catgFournisseurs.length}, vteJournaux: ${vteJournaux.length}, catgClients: ${catgClients.length}, clientsTerritoires: ${clientsTerritoires.length}');
  }

  //get natures
  Future getNatures(BuildContext context) async {
    try {
      exeStatusCode = 0;
      notify();
      http.Response response =
          // await http.post(Uri.parse('http://$ipaddress:$port/client/get_natures'), body: {'path': selectedFolder?.DOSBDD});
          await "/get_natures".authPost(context, {'path': selectedFolder?.DOSBDD});
      exeStatusCode = response.statusCode;
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        natures = Nature.listFromJson(data['natures']);
      } else if (response.statusCode == 404) {
        natures = [];
      }
      notify();
    } catch (err) {
      print('nat $err');
      exeStatusCode = 500;
      notify();
    }
  }

  //get categories
  Future getCategories(BuildContext context) async {
    try {
      categoryStatusCode = 0;
      notify();
      http.Response response = await "/get_categories".authPost(context, {'path': selectedFolder?.DOSBDD});
      categoryStatusCode = response.statusCode;
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        categories = TiersCategory.listFromJson(data['categories']);
      } else if (response.statusCode == 404) {
        categories = [];
      }
      notify();
    } catch (err) {
      print('cat $err');
      categoryStatusCode = 500;
      notify();
    }
  }

  //get sell settings
  Future getSellSettings(BuildContext context) async {
    try {
      sellSettingsStatusCode = 0;
      notify();
      http.Response response = await "/get_sell_settings".authPost(context, {'path': selectedFolder?.DOSBDD});
      sellSettingsStatusCode = response.statusCode;
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        sellSettings = SellSettings.fromJson(data['settings']);
      } else if (response.statusCode == 404) {
        sellSettings = null;
      }
      notify();
    } catch (err) {
      print('sett $err');
      sellSettingsStatusCode = 500;
      notify();
    }
  }

  Future getbuySettings(BuildContext context) async {
    try {
      buySettingsStatusCode = 0;
      notify();
      http.Response response = await "/Get_Buy_Settings".authPost(context, {'path': selectedFolder?.DOSBDD});
      buySettingsStatusCode = response.statusCode;
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        buySettings = BuySettings.fromJson(data['settings']);
      } else if (response.statusCode == 404) {
        buySettings = null;
      }
      notify();
    } catch (err) {
      print('sett $err');
      buySettingsStatusCode = 500;
      notify();
    }
  }

  Future getgenSettings(BuildContext context) async {
    try {
      buySettingsStatusCode = 0;
      notify();
      http.Response response = await "/Gen_Settings".authPost(context, {'path': selectedFolder?.DOSBDD});
      buySettingsStatusCode = response.statusCode;
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        genSettings = GenSettings.fromJson(data['gen_settings']);
      } else if (response.statusCode == 404) {
        genSettings = null;
      }
      notify();
    } catch (err) {
      print('sett $err');
      buySettingsStatusCode = 500;
      notify();
    }
  }

  Future getCategoriesColor(BuildContext context) async {
    try {
      buySettingsStatusCode = 0;
      notify();
      http.Response response = await "/Categoesi_Color".authPost(context, {'path': selectedFolder?.DOSBDD});
      buySettingsStatusCode = response.statusCode;
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        catgClr = data['CategoesiColor']['PCCNO'] ?? '00';
      } else if (response.statusCode == 404) {
        catgClr = '00';
      }
      notify();
    } catch (err) {
      print('sett $err');
      buySettingsStatusCode = 500;
      notify();
    }
  }

  //get sell settings
  Future getCaisseSettings(BuildContext context) async {
    try {
      caisseSettingsStatusCode = 0;
      notify();
      http.Response response = await "/get_caisse_settings".authPost(context, {'path': selectedFolder?.DOSBDD});
      caisseSettingsStatusCode = response.statusCode;
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        caisseSettings = CaisseSettings.fromJson(data['settings']);
      } else if (response.statusCode == 404) {
        caisseSettings = null;
      }
      notify();
    } catch (err) {
      print('sett $err');
      caisseSettingsStatusCode = 500;
      notify();
    }
  }

  Future<List<Map<String, String>>> getDepots(BuildContext context) async {
    try {
      caisseSettingsStatusCode = 0;
      notify();

      final response = await "/get_depots".authPost(
        context,
        {
          'path': selectedFolder?.DOSBDD,
        },
      );

      caisseSettingsStatusCode = response.statusCode;

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        debugPrint('getDepots data: $data');

        final List<dynamic>? depots = data['Depots'];

        if (depots != null) {
          return depots.map<Map<String, String>>((item) {
            return {
              'dptno': item['dptno'].toString(),
              'dptnom': item['dptnom'].toString(),
            };
          }).toList();
        }
      }

      return [];
    } catch (e, stackTrace) {
      caisseSettingsStatusCode = 500;

      debugPrint('getDepots error: $e');
      debugPrintStack(stackTrace: stackTrace);

      return [];
    } finally {
      notify();
    }
  }

  // Hepls function

  String? getDepotsWrite() {
    return rubriques.where((r) => r.USBTRS == '01' && r.USBTRB == '01' && r.USBWRITE == 2 && r.USBDEFAULT == 1).map((r) => r.USBRUB).firstOrNull;
  }

  String getDepotsDefault(List<Map<String, String>> depots) {
    String? depotDefault = sellSettings!.PRMDEPOTDEFAUTAB;

    switch (selectedUser!.USRTYPE) {
      case 0:
        depotDefault = rubriques.where((r) => r.USBTRS == '01' && r.USBTRB == '01' && r.USBDEFAULT == 1).map((r) => r.USBRUB).firstOrNull ??
            sellSettings!.PRMDEPOTDEFAUTAB!;

        break;
      case 1:
        Rubrique? depot = rubriques.where((r) => r.USBTRS == '01' && r.USBTRB == '01' && r.USBRUB == sellSettings!.PRMDEPOTDEFAUTAB).firstOrNull;
        if (depot != null) {
          depotDefault = depots.where((d) => depotDefault != d['dptno']).firstOrNull?['dptno'] ?? sellSettings!.PRMDEPOTDEFAUTAB!;
        } else {
          depotDefault = sellSettings!.PRMDEPOTDEFAUTAB!;
        }
        break;

      default:
        depotDefault = sellSettings!.PRMDEPOTDEFAUTAB!;
    }

    return depotDefault;
  }

  String getTarifPerDefault() {
    bool admin = selectedUser!.USRTYPE == 2;
    return admin
        ? sellSettings!.PRMTARIFDEFAUTAB!
        : rubriques.where((r) => r.USBTRS == '03' && r.USBTRB == '01' && r.USBDEFAULT == 1).map((r) => r.USBRUB).firstOrNull ??
            sellSettings!.PRMTARIFDEFAUTAB!;
  }
}

class _DatePeriod {
  final DateTime start;
  final DateTime end;

  const _DatePeriod({
    required this.start,
    required this.end,
  });
}

class RubriqueLIst {
  String rubrique;
  bool read;
  bool write;

  RubriqueLIst({required this.rubrique, required this.read, required this.write});
}
