import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestion_stock/ask_first.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/client_view_model.dart';
import 'package:gestion_stock/view_models/commande_detail_view_model.dart';
import 'package:gestion_stock/view_models/commande_entate_view_model.dart';
import 'package:gestion_stock/view_models/facture_deatail_view_model.dart';
import 'package:gestion_stock/view_models/facture_entate_view_model.dart';
import 'package:gestion_stock/view_models/fournisseur_view_model.dart';
import 'package:gestion_stock/view_models/license_view_model.dart';
import 'package:gestion_stock/view_models/location_view_model.dart';
import 'package:gestion_stock/view_models/product_view_model.dart';
import 'package:gestion_stock/view_models/reception_detail_view_model.dart';
import 'package:gestion_stock/view_models/reception_entate_view_model.dart';
import 'package:gestion_stock/view_models/statistic_view_model.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:gestion_stock/view_models/transaction_view_model.dart';
import 'package:gestion_stock/views/license_activation_page.dart';
import 'package:gestion_stock/widgets/toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

Future<void> main() async {
  // 🔥 MUST be first
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Now safe to use platform channels
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // 🧠 Initialize your core dependencies
  final authViewModel = AuthViewModel();
  final stockViewModel = StockViewModel(authViewModel);
  final licenseViewModel = LicenseViewModel(authViewModel);

  await authViewModel.getDeviceInfo();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authViewModel),
        ChangeNotifierProvider(create: (_) => stockViewModel),
        ChangeNotifierProvider(create: (_) => licenseViewModel),
        ChangeNotifierProvider(create: (_) => ProductViewModel(stockViewModel, authViewModel)),
        ChangeNotifierProvider(create: (_) => ClientViewModel(authViewModel)),
        ChangeNotifierProvider(create: (_) => LocationViewModel(authViewModel)),
        ChangeNotifierProvider(create: (_) => FournisseurViewModel(authViewModel)),
        ChangeNotifierProvider(create: (_) => FactureEntateViewModel(authViewModel)),
        ChangeNotifierProvider(create: (_) => FactureDetailViewModel(authViewModel)),
        ChangeNotifierProvider(create: (_) => TransactionViewModel(authViewModel)),
        ChangeNotifierProvider(create: (_) => ReceptionEntateViewModel(authViewModel)),
        ChangeNotifierProvider(create: (_) => ReceptionDetailViewModel(authViewModel)),
        ChangeNotifierProvider(create: (_) => StatisticViewModel(authViewModel)),
        ChangeNotifierProvider(create: (_) => CommandeEntateViewModel(authViewModel)),
        ChangeNotifierProvider(create: (_) => CommandeDetailViewModel(authViewModel)),
      ],
      child: ToastificationWrapper(
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestcom App',
      theme: ThemeData(
        // fontFamily: 'Poppins',
        primaryColor: const Color.fromARGB(255, 244, 249, 252),
        secondaryHeaderColor: const Color(0xFF009DE0),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF009DE0)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<CheckResult> _activationFuture;

  @override
  void initState() {
    super.initState();
    getIPAddress();
    final licenseViewModel = Provider.of<LicenseViewModel>(context, listen: false);
    _activationFuture = licenseViewModel.checkActivationStatus();
  }

  @override
  Widget build(BuildContext context) {
    final licenseViewModel = context.watch<LicenseViewModel>();
    return FutureBuilder<CheckResult>(
      future: _activationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !licenseViewModel.isActivated) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (licenseViewModel.isActivated) {
          return const AskFirst();
        }

        return const LicenseActivationPage();
      },
    );
  }

  Future<void> getIPAddress() async {
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? connectionType = prefs.getString('connection_type') ?? 'ip';
    String? serverUrl = prefs.getString('server_url') ?? '';
    String? ip = prefs.getString('ipaddress');
    String? port = prefs.getString('port');
    if (ip == null || port == null) {
      ip = '192.168.1.1';
      port = '8282';
      prefs.setString('ipaddress', ip);
      prefs.setString('port', port);
    }
    authProvider.connectionType = connectionType;
    authProvider.serverUrl = serverUrl;
    authProvider.ipaddress = ip;
    authProvider.port = port;

    String toastMessage = (connectionType == 'url' && serverUrl.isNotEmpty)
        ? 'URL: ${authProvider.baseUrl}'
        : 'Adresse ip: ${authProvider.ipaddress}\nPort: ${authProvider.port}';

    if (!mounted) return;

    Toast(
        context: context,
        title: toastMessage,
        style: ToastificationStyle.minimal,
        type: ToastificationType.info,
        duration: 4);
  }
}
