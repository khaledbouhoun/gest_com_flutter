import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/commande_entate_view_model.dart';
import 'package:gestion_stock/view_models/facture_entate_view_model.dart';
import 'package:gestion_stock/view_models/license_view_model.dart';
import 'package:gestion_stock/view_models/reception_entate_view_model.dart';
import 'package:gestion_stock/view_models/transaction_view_model.dart';
import 'package:gestion_stock/views/caisse/caisse.dart';
import 'package:gestion_stock/views/client/clients.dart';
import 'package:gestion_stock/views/command/commandes.dart';
import 'package:gestion_stock/views/facture_entate/factures.dart';
import 'package:gestion_stock/views/fournisseur/fournisseurs.dart';
import 'package:gestion_stock/views/reception_entate/receptions.dart';
import 'package:gestion_stock/views/statistics/statistics.dart';
import 'package:gestion_stock/views/stock/stock.dart';
import 'package:gestion_stock/widgets/animatednumberscroll.dart';
import 'package:gestion_stock/widgets/logout_dialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Provider.of<LicenseViewModel>(
      context,
      listen: false,
    ).checkSecurityOnEntry(context);
    _initializeProviders();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Provider.of<LicenseViewModel>(
        context,
        listen: false,
      ).checkSecurityOnEntry(context);
    }
  }

  Future<void> _initializeProviders() async {
    debugPrint('-- Initializing providers --');

    final authProvider = Provider.of<AuthViewModel>(context, listen: false);

    final factureProvider = Provider.of<FactureEntateViewModel>(context, listen: false);

    final commandeProvider = Provider.of<CommandeEntateViewModel>(context, listen: false);

    final receptionProvider = Provider.of<ReceptionEntateViewModel>(context, listen: false);

    final transactionProvider = Provider.of<TransactionViewModel>(context, listen: false);

    final exerciceYear = authProvider.initialExercice!.EXENO!;

    /// ---------------- Facture & Commande ----------------
    final sellInterval = authProvider.sellSettings?.PRMBLINTERVDATE;
    final sellPeriod = resolvePeriod(
      intervalType: sellInterval!.toInt(),
      exerciceYear: exerciceYear,
    );

    factureProvider
      ..startDate = sellPeriod.start
      ..endDate = sellPeriod.end;

    commandeProvider
      ..startDate = sellPeriod.start
      ..endDate = sellPeriod.end;

    /// ---------------- Reception ----------------
    receptionProvider
      ..startDate = DateTime(exerciceYear, 1, 1)
      ..endDate = DateTime(exerciceYear, 12, 31)
      ..selectedType = receptionProvider.types.first;

    /// ---------------- Transaction ----------------
    final caisseInterval = authProvider.caisseSettings?.PRMJRDINTERVDATE;

    final transactionPeriod = resolvePeriod(
      intervalType: caisseInterval!.toInt(),
      exerciceYear: exerciceYear,
    );

    transactionProvider
      ..startDate = transactionPeriod.start
      ..endDate = transactionPeriod.end;

    await transactionProvider.getTransactions(context, isTodayOnly: true);
    debugPrint('-- Providers initialized successfully --');
  }

  _DatePeriod resolvePeriod({
    required int? intervalType,
    required int exerciceYear,
  }) {
    final now = DateTime.now().year == exerciceYear ? DateTime.now() : DateTime(exerciceYear, 12, 31);

    switch (intervalType) {
      /// سنة كاملة
      case 0:
        return _DatePeriod(
          start: DateTime(exerciceYear, 1, 1),
          end: DateTime(exerciceYear, 12, 31),
        );

      /// شهر جاري
      case 1:
        final firstDayNextMonth = DateTime(exerciceYear, now.month + 1, 1);

        return _DatePeriod(
          start: DateTime(exerciceYear, now.month, 1),
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

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AuthViewModel>(context, listen: false);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F9FC),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await _initializeProviders();
            },
            color: const Color(0xFF14AAF0),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: Padding(
                padding: EdgeInsets.all(width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Logo and Logout
                    _buildHeader(context, provider, width),

                    SizedBox(height: height * 0.03),

                    // User Info Card
                    _buildUserInfoCard(context, provider, width),

                    SizedBox(height: height * 0.03),

                    // Modules Section Title
                    Text(
                      'Modules',
                      style: TextStyle(
                        fontSize: width * 0.06,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2d3436),
                        letterSpacing: 0.5,
                      ),
                    ),

                    SizedBox(height: height * 0.02),

                    // Modules Grid
                    _buildModulesGrid(context, provider, width),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AuthViewModel provider, double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo
        Container(
          width: width * 0.7,
          padding: EdgeInsets.all(width * 0.03),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF14AAF0).withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Gest",
                  style: TextStyle(
                    fontSize: width * 0.08,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF14AAF0),
                  ),
                ),
                TextSpan(
                  text: "Com",
                  style: TextStyle(
                    fontSize: width * 0.08,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2d3436),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Logout Button
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFff6b6b), Color(0xFFee5a6f)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFff6b6b).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                LogOutDialog.show(context);
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: EdgeInsets.all(width * 0.03),
                child: Icon(
                  Icons.power_settings_new_rounded,
                  color: Colors.white,
                  size: width * 0.06,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfoCard(BuildContext context, AuthViewModel provider, double width) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child:
          // User Icon and Info
          Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(width * 0.04),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF14AAF0), Color(0xFF0E7AC4)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF14AAF0).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: width * 0.04,
                  ),
                ),
                SizedBox(width: width * 0.05),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Utilisateur',
                      style: TextStyle(
                        fontSize: width * 0.035,
                        color: const Color(0xFF636e72),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: width * 0.01),
                    Text(
                      provider.selectedUser!.USRLOGIN,
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: const Color(0xFF2d3436),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: width * 0.05,
              children: [
                // Divider
                Container(
                  height: width * 0.15,
                  width: 2,
                  color: const Color(0xFFdfe6e9),
                ),
                Column(
                  children: [
                    Text(
                      'Exercice',
                      style: TextStyle(
                        fontSize: width * 0.035,
                        color: const Color(0xFF636e72),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: width * 0.01),
                    Text(
                      provider.initialExercice!.EXENO.toString(),
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: const Color(0xFF14AAF0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModulesGrid(BuildContext context, AuthViewModel provider, double width) {
    final modules = [
      {
        'title': 'Caisse',
        'icon': Icons.point_of_sale_rounded,
        'gradient': [
          const Color(0xFF7B61FF), // Soft purple
          const Color(0xFF5A4FCF), // Moderate indigo
        ],
        'destination': const Caisse(),
        'trs': '07',
        'res': '05',
      },
      {
        'title': 'Livraisons',
        'icon': Icons.local_shipping_rounded,
        'gradient': [
          const Color(0xFF03A9F4), // Cyan blue
          const Color(0xFF4FC3F7), // Light cyan
        ],
        'destination': const Factures(),
        'trs': '03',
        'res': '04',
      },
      {
        'title': 'Réceptions',
        'icon': Icons.inbox_rounded,
        'gradient': [
          const Color(0xFFFF9800), // Orange
          const Color(0xFFFFB74D), // Light orange
        ],
        'destination': const Receptions(),
        'trs': '02',
        'res': '03',
      },
      {
        'title': 'Commandes',
        'icon': Icons.shopping_cart_rounded,
        'gradient': [
          const Color.fromRGBO(134, 28, 255, 1), // Gray
          const Color.fromRGBO(134, 28, 255, 1), // Light gray
        ],
        'destination': const Commandes(),
        'trs': '03',
        'res': '03',
      },
      {
        'title': 'Articles',
        'icon': Icons.inventory_2_rounded,
        'gradient': [
          const Color(0xFF4CAF50), // Green
          const Color(0xFF81C784), // Light green
        ],
        'destination': const Stock(),
        'trs': '01',
        'res': '01',
      },
      {
        'title': 'Clients',
        'icon': Icons.people_rounded,
        'gradient': [
          const Color(0xFFF06292), // Pink
          const Color(0xFFF48FB1), // Light pink
        ],
        'destination': const Clients(),
        'trs': '03',
        'res': '01',
      },
      {
        'title': 'Fournisseurs',
        'icon': Icons.business_rounded,
        'gradient': [
          const Color(0xFF607D8B), // Blue gray
          const Color(0xFF90A4AE), // Light blue gray
        ],
        'destination': const Fournisseurs(),
        'trs': '02',
        'res': '01',
      },
      {
        'title': 'Statistiques',
        'icon': Icons.bar_chart_rounded,
        'gradient': [
          const Color(0xFF2196F3), // Blue
          const Color(0xFF64B5F6), // Light blue
        ],
        'destination': const Statistics(),
        'trs': '03',
        'res': '31',
      },
    ];

    return Column(
      children: [
        _buildCaisseCard(
          context,
          modules.first['title'] as String,
          modules.first['icon'] as IconData,
          modules.first['gradient'] as List<Color>,
          modules.first['destination'] as Widget,
          provider,
          width,
          modules.first['trs'] as String,
          modules.first['res'] as String,
          provider.selectedUser!.USRTYPE != 0,
        ),
        SizedBox(height: 30),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: width * 0.04,
            mainAxisSpacing: width * 0.04,
            childAspectRatio: 1.1,
          ),
          itemCount: modules.length - 1,
          itemBuilder: (context, index) {
            final module = modules[index + 1];

            return _buildModuleCard(
              context,
              module['title'] as String,
              module['icon'] as IconData,
              module['gradient'] as List<Color>,
              module['destination'] as Widget,
              provider,
              width,
              module['trs'] as String,
              module['res'] as String,
            );
          },
        )
      ],
    );
  }

  Widget _buildModuleCard(
    BuildContext context,
    String title,
    IconData icon,
    List<Color> gradientColors,
    Widget destination,
    AuthViewModel provider,
    double width,
    String trs,
    String res,
  ) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        bool hasAccess = false;

        if (provider.selectedUser!.USRTYPE == 0) {
          // Normal user → allowed ONLY if permission exists
          hasAccess = provider.accessList
                  ?.any((access) => access.URSTRS == trs && access.URSRES == res && access.URSDRO == '01') ??
              false;
        } else if (provider.selectedUser!.USRTYPE == 1) {
          // Restricted user → allowed ONLY if permission does NOT exist
          hasAccess = !(provider.accessList
                  ?.any((access) => access.URSTRS == trs && access.URSRES == res && access.URSDRO == '01') ??
              false);
        } else {
          // Admin or others → always allowed
          hasAccess = true;
        }

        if (hasAccess) {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );

          if (result != null) {
            _initializeProviders();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(milliseconds: 500),
              content: Text('Accès refusé à $title'),
              backgroundColor: const Color(0xFFff6b6b),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(width * 0.03),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(width * 0.03),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors[0].withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: width * 0.1,
                ),
              ),
              SizedBox(height: width * 0.03),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width * 0.038,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2d3436),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaisseCard(
    BuildContext context,
    String title,
    IconData icon,
    List<Color> gradientColors,
    Widget destination,
    AuthViewModel provider,
    double width,
    String trs,
    String res,
    bool isAdmin,
  ) {
    return Consumer<TransactionViewModel>(
      builder: (context, transactionProvider, child) {
        final formatter = NumberFormat('#,##0.00', "fr");

        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            // Check access permissions
            bool hasAccess = false;

            if (provider.selectedUser!.USRTYPE == 0) {
              // Regular user - needs explicit access
              hasAccess = provider.accessList
                      ?.any((access) => access.URSTRS == trs && access.URSRES == res && access.URSDRO == '01') ??
                  false;
            } else if (provider.selectedUser!.USRTYPE == 1) {
              // Restricted user - check if NOT in access list (blacklist)
              hasAccess = !(provider.accessList
                      ?.any((access) => access.URSTRS == trs && access.URSRES == res && access.URSDRO == '01') ??
                  false);
            } else {
              // Admin or other type - full access
              hasAccess = true;
            }

            if (hasAccess) {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => destination),
              );

              if (result != null) {
                _initializeProviders();
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(milliseconds: 500),
                  content: Text('Accès refusé à $title'),
                  backgroundColor: const Color(0xFFff6b6b),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Container(
              width: width,
              padding: EdgeInsets.all(width * 0.04),
              child: Row(
                children: [
                  // Icon Section
                  Container(
                    padding: EdgeInsets.all(width * 0.04),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: gradientColors[0].withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: width * 0.08,
                    ),
                  ),

                  SizedBox(width: width * 0.04),

                  // Divider
                  Container(
                    height: width * 0.15,
                    width: 1,
                    color: const Color(0xFFdfe6e9),
                  ),

                  SizedBox(width: width * 0.04),

                  // Transaction Data Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2d3436),
                            letterSpacing: 0.3,
                          ),
                        ),

                        SizedBox(height: width * 0.02),

                        // Debit (Income)
                        if (isAdmin) ...[
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(width * 0.01),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00b894).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  Icons.arrow_upward_rounded,
                                  color: const Color(0xFF00b894),
                                  size: width * 0.035,
                                ),
                              ),
                              SizedBox(width: width * 0.02),
                              AnimatedNumberText(
                                value: transactionProvider.totalDebitToday,
                                style: TextStyle(
                                  fontSize: width * 0.035,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF00b894),
                                ),
                                formatter: (value) => formatter.format(value),
                              ),
                              Text(
                                ' DA',
                                style: TextStyle(
                                  fontSize: width * 0.035,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF00b894),
                                ),
                              ),
                              // Text(
                              //   '${formatter.format(transactionProvider.totalDebitToday)} DA',
                              //   style: TextStyle(
                              //     fontSize: width * 0.035,
                              //     fontWeight: FontWeight.bold,
                              //     color: const Color(0xFF00b894),
                              //   ),
                              // ),
                            ],
                          ),

                          SizedBox(height: width * 0.015),

                          // Credit (Expense)
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(width * 0.01),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFff6b6b).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  Icons.arrow_downward_rounded,
                                  color: const Color(0xFFff6b6b),
                                  size: width * 0.035,
                                ),
                              ),
                              SizedBox(width: width * 0.02),
                              AnimatedNumberText(
                                value: transactionProvider.totalCreditToday,
                                style: TextStyle(
                                  fontSize: width * 0.035,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFff6b6b),
                                ),
                                formatter: (value) => formatter.format(value),
                              ),
                              Text(
                                ' DA',
                                style: TextStyle(
                                  fontSize: width * 0.035,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFff6b6b),
                                ),
                              ),
                              // Text(
                              //   '${formatter.format(transactionProvider.totalCreditToday)} DA',
                              //   style: TextStyle(
                              //     fontSize: width * 0.035,
                              //     fontWeight: FontWeight.bold,
                              //     color: const Color(0xFFff6b6b),
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                        SizedBox(height: width * 0.015),

                        // Total Balance
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                            vertical: width * 0.015,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF667eea).withValues(alpha: 0.1),
                                const Color(0xFF764ba2).withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Total: ',
                                style: TextStyle(
                                  fontSize: width * 0.032,
                                  color: const Color(0xFF636e72),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              AnimatedNumberText(
                                value: transactionProvider.totalDebitToday - transactionProvider.totalCreditToday,
                                style: TextStyle(
                                  fontSize: width * 0.035,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF667eea),
                                ),
                                formatter: (value) => formatter.format(value),
                              ),
                              // Text(
                              //   '${formatter.format(transactionProvider.totalDebitToday - transactionProvider.totalCreditToday)} DA',
                              //   style: TextStyle(
                              //     fontSize: width * 0.035,
                              //     fontWeight: FontWeight.bold,
                              //     color: const Color(0xFF667eea),
                              //   ),
                              // ),
                            ],
                          ),
                        ),

                        SizedBox(height: width * 0.02),
                        // Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Aujourd'hui: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF667eea),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
