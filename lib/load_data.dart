import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/client_view_model.dart';
import 'package:gestion_stock/view_models/fournisseur_view_model.dart';
import 'package:gestion_stock/view_models/location_view_model.dart';
import 'package:gestion_stock/view_models/product_view_model.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:gestion_stock/view_models/transaction_view_model.dart';
import 'package:gestion_stock/views/home.dart';
import 'package:provider/provider.dart';

class LoadData extends StatefulWidget {
  const LoadData({super.key});

  @override
  State<StatefulWidget> createState() => LoadDataPage();
}

class LoadDataPage extends State<LoadData> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    getData();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(_rotationController);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void getData() async {
    await Provider.of<AuthViewModel>(context, listen: false).getRubriques(context).then((_) async {
      setState(() => _progress = 0.1);
      await Provider.of<ProductViewModel>(context, listen: false).getProductDetails(context);

      setState(() => _progress = 0.3);
      await Provider.of<LocationViewModel>(context, listen: false).getPays();
      setState(() => _progress = 0.4);
      await Provider.of<LocationViewModel>(context, listen: false).getTerritoires();
      setState(() => _progress = 0.5);
      await Provider.of<LocationViewModel>(context, listen: false).getVilles();
      setState(() => _progress = 0.6);
      setState(() => _progress = 0.7);
      await Provider.of<AuthViewModel>(context, listen: false).getNatures(context);
      setState(() => _progress = 0.75);
      await Provider.of<AuthViewModel>(context, listen: false).getCategories(context);
      setState(() => _progress = 0.8);
      await Provider.of<AuthViewModel>(context, listen: false).getSellSettings(context);
      setState(() => _progress = 0.85);
      await Provider.of<AuthViewModel>(context, listen: false).getbuySettings(context);
      await Provider.of<AuthViewModel>(context, listen: false).getgenSettings(context);
      await Provider.of<AuthViewModel>(context, listen: false).getCategoriesColor(context);
      setState(() => _progress = 0.9);
      await Provider.of<AuthViewModel>(context, listen: false).getCaisseSettings(context);
      await Provider.of<StockViewModel>(context, listen: false).getTarifs(context);
      setState(() => _progress = 0.95);
      await Provider.of<TransactionViewModel>(context, listen: false).getComptes(
        context,
      );
      await Provider.of<TransactionViewModel>(context, listen: false).getTransactions(context, isTodayOnly: true);

      setState(() => _progress = 1.0);
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const Home(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }).catchError((error) {
      print('load data page: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        body: SafeArea(
          child: Consumer6<AuthViewModel, LocationViewModel, ClientViewModel, StockViewModel, TransactionViewModel,
              ProductViewModel>(
            builder: (context, authProvider, locationProvider, clientProvider, stockProvider, transactionProvider,
                productProvider, child) {
              return Consumer<FournisseurViewModel>(
                builder: (context, fournisseurProvider, child) {
                  if (authProvider.exeStatusCode == 500 &&
                      authProvider.categoryStatusCode == 500 &&
                      locationProvider.statusCode == 500 &&
                      transactionProvider.statusCode == 500 &&
                      productProvider.statusCode == 500 &&
                      stockProvider.tarifStatusCode == 500 &&
                      authProvider.sellSettingsStatusCode == 500 &&
                      authProvider.buySettingsStatusCode == 500 &&
                      authProvider.caisseSettingsStatusCode == 500) {
                    return _buildErrorState(width, height);
                  }
                  if (authProvider.exeStatusCode == 0 ||
                      authProvider.categoryStatusCode == 0 ||
                      locationProvider.statusCode == 0 ||
                      transactionProvider.statusCode == 0 ||
                      productProvider.statusCode == 0 ||
                      stockProvider.tarifStatusCode == 0 ||
                      authProvider.sellSettingsStatusCode == 0 ||
                      authProvider.buySettingsStatusCode == 0 ||
                      authProvider.caisseSettingsStatusCode == 0) {
                    return _buildLoadingState(width, height);
                  } else {
                    return _buildLoadingState(width, height);
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // Widget _buildNoDataState(double width, double height) {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         RotationTransition(
  //           turns: _rotationAnimation,
  //           child: Container(
  //             padding: EdgeInsets.all(width * 0.08),
  //             decoration: BoxDecoration(
  //               shape: BoxShape.circle,
  //               color: Colors.white.withOpacity(0.2),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.white.withOpacity(0.3),
  //                   blurRadius: 30,
  //                   spreadRadius: 10,
  //                 ),
  //               ],
  //             ),
  //             child: Icon(
  //               Icons.cloud_download_rounded,
  //               size: width * 0.15,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ),
  //         SizedBox(height: height * 0.05),
  //         Container(
  //           width: width * 0.75,
  //           padding: EdgeInsets.symmetric(
  //             horizontal: width * 0.08,
  //             vertical: width * 0.06,
  //           ),
  //           decoration: BoxDecoration(
  //             color: Colors.white.withOpacity(0.15),
  //             borderRadius: BorderRadius.circular(20),
  //             border: Border.all(
  //               color: Colors.white.withOpacity(0.3),
  //               width: 1,
  //             ),
  //           ),
  //           child: Column(
  //             children: [
  //               Text(
  //                 'Acces refusé',
  //                 style: TextStyle(
  //                   fontSize: width * 0.06,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.red,
  //                 ),
  //               ),
  //               SizedBox(height: height * 0.02),
  //               Text(
  //                 'Veuillez reessayer',
  //                 style: TextStyle(
  //                   fontSize: width * 0.04,
  //                   color: Colors.red,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildLoadingState(double width, double height) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: _rotationAnimation,
            child: Container(
              padding: EdgeInsets.all(width * 0.08),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF009DE0).withValues(alpha: 0.2),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                Icons.cloud_download_rounded,
                size: width * 0.15,
                color: Color(0xFF009DE0),
              ),
            ),
          ),
          SizedBox(height: height * 0.05),
          Container(
            width: width * 0.75,
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.08,
              vertical: width * 0.06,
            ),
            decoration: BoxDecoration(
              color: Color(0xFF009DE0).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color(0xFF009DE0).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Chargement des données',
                  style: TextStyle(
                    fontSize: width * 0.045,
                    color: Color(0xFF009DE0),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: height * 0.025),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _progress,
                    minHeight: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF009DE0).withValues(alpha: 0.9),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.015),
                Text(
                  '${(_progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: width * 0.038,
                    color: Color(0xFF009DE0).withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(double width, double height) {
    return Center(
      child: Container(
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
          mainAxisSize: MainAxisSize.min,
          children: [
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
            SizedBox(height: height * 0.03),
            Text(
              'Erreur de chargement',
              style: TextStyle(
                fontSize: width * 0.055,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2d3436),
              ),
            ),
            SizedBox(height: height * 0.015),
            Text(
              'Impossible de se connecter au serveur',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width * 0.038,
                color: const Color(0xFF636e72),
                height: 1.5,
              ),
            ),
            SizedBox(height: height * 0.04),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() => _progress = 0.0);
                  getData();
                },
                borderRadius: BorderRadius.circular(16),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color.fromARGB(255, 21, 182, 168), Color(0xFF38ef7d)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF667eea).withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: width * 0.04,
                      horizontal: width * 0.06,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                          size: width * 0.055,
                        ),
                        SizedBox(width: width * 0.03),
                        Text(
                          'Réessayer',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
