import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/statistic_view_model.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:gestion_stock/views/statistics/sections/monthly_turnover.dart';
import 'package:gestion_stock/views/statistics/sections/turnover.dart';
import 'package:gestion_stock/views/statistics/sections/turnover_by_product.dart';
import 'package:provider/provider.dart';

import '../home.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<StatefulWidget> createState() => StatisticsPage();
}

class StatisticsPage extends State<Statistics> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Set<int> _loadedTabs = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);

    // Load only the first tab data initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTabData(0);
    });
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      _loadTabData(_tabController.index);
    }
  }

  void _loadTabData(int index, {bool forceGet = false}) {
    if (_loadedTabs.contains(index)) return;
    _loadedTabs.add(index);

    final statisticViewModel = Provider.of<StatisticViewModel>(context, listen: false);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final stockViewModel = Provider.of<StockViewModel>(context, listen: false);

    authViewModel.selectedExercice = authViewModel.initialExercice;

    switch (index) {
      case 0:
        // Turnover comparison
        statisticViewModel.compare(context);
        break;
      case 1:
        // Monthly turnover
        if (authViewModel.selectedExercice != null) {
          statisticViewModel.turnoverByMonth(context, authViewModel.selectedExercice!);
        }
        break;
      case 2:
        // Turnover by product
        stockViewModel.getStatisticProducts(context, forceGet: forceGet).then((value) {
          if (authViewModel.selectedExercice != null && stockViewModel.selectedStatisticProduct != null) {
            statisticViewModel.getTurnoverByProduct(
                context, authViewModel.selectedExercice!, stockViewModel.selectedStatisticProduct!);
          }
        });
        break;
    }
  }

  void _refreshCurrentTab() {
    final index = _tabController.index;
    _loadedTabs.remove(index);
    _loadTabData(index, forceGet: true);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (builder) => const Home()));
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F9FC),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: width * 0.4,
              floating: false,
              pinned: true,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Theme.of(context).secondaryHeaderColor,
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(width * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(width * 0.02),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.analytics_rounded,
                                      color: Colors.white,
                                      size: width * 0.07,
                                    ),
                                  ),
                                  SizedBox(width: width * 0.03),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Statistiques',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: width * 0.06,
                                        ),
                                      ),
                                      Text(
                                        'Analyse des performances',
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.8),
                                          fontSize: width * 0.035,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Material(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: _refreshCurrentTab,
                                  child: Padding(
                                    padding: EdgeInsets.all(width * 0.025),
                                    child: Icon(
                                      Icons.refresh_rounded,
                                      color: Colors.white,
                                      size: width * 0.06,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(width * 0.13),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Theme.of(context).secondaryHeaderColor,
                    unselectedLabelColor: Colors.grey[500],
                    indicatorColor: Theme.of(context).secondaryHeaderColor,
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.032,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: width * 0.032,
                    ),
                    tabs: [
                      Tab(
                        icon: Icon(Icons.bar_chart_rounded, size: width * 0.055),
                        text: 'Comparaison',
                      ),
                      Tab(
                        icon: Icon(Icons.show_chart_rounded, size: width * 0.055),
                        text: 'Mensuel',
                      ),
                      Tab(
                        icon: Icon(Icons.inventory_2_rounded, size: width * 0.055),
                        text: 'Par Article',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          body: Container(
            color: const Color(0xFFF4F9FC),
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: [
                // Tab 1: Turnover Comparison
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(width * 0.04),
                  child: const Turnover(),
                ),
                // Tab 2: Monthly Turnover
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(width * 0.04),
                  child: const MonthlyTurnover(),
                ),
                // Tab 3: Turnover by Product
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(width * 0.04),
                  child: TurnoverByProduct(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
