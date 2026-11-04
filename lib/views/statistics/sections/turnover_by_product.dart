import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gestion_stock/models/exercice.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../view_models/auth_view_model.dart';
import '../../../view_models/statistic_view_model.dart';

// ignore: must_be_immutable
class TurnoverByProduct extends StatelessWidget {
  TurnoverByProduct({super.key});

  static const List<String> _months = ['', 'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
  NumberFormat fmt = NumberFormat.decimalPatternDigits(locale: 'fr_FR', decimalDigits: 2);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Consumer3<AuthViewModel, StatisticViewModel, StockViewModel>(
      builder: (context, authVM, statVM, stockVM, child) {
        double max = 0, total = 0;
        final data = statVM.monthlyTurnoverByProduct;
        if (data != null && data.isNotEmpty) {
          max = data.map((e) => e.Y).reduce((a, b) => a > b ? a : b);
          total = data.fold(0, (sum, e) => sum + e.Y);
        }

        return Column(children: [
          // Header Card
          _buildHeader(context, width, authVM, statVM, stockVM, total),
          SizedBox(height: width * 0.04),
          // Product Selector
          _buildProductSelector(context, width, authVM, statVM, stockVM),
          SizedBox(height: width * 0.04),
          // Chart Card
          Container(
            padding: EdgeInsets.all(width * 0.04),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.deepPurple.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8))]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                    padding: EdgeInsets.all(width * 0.025),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.deepPurple[600]!, Colors.deepPurple[400]!]),
                        borderRadius: BorderRadius.circular(12)),
                    child: Icon(Icons.inventory_2_rounded, color: Colors.white, size: width * 0.05)),
                SizedBox(width: width * 0.03),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Performance Article", style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.045, color: Colors.black87)),
                  Text("Évolution mensuelle des ventes", style: TextStyle(fontSize: width * 0.032, color: Colors.grey[600])),
                ]),
              ]),
              SizedBox(height: width * 0.05),
              _buildContent(context, width, height, authVM, statVM, stockVM, fmt, max),
            ]),
          ),
        ]);
      },
    );
  }

  Widget _buildHeader(BuildContext ctx, double w, AuthViewModel authVM, StatisticViewModel statVM, StockViewModel stockVM, double total) {
    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.deepPurple[600]!, Colors.deepPurple[400]!]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.deepPurple.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 6))]),
      child: Row(children: [
        Container(
            padding: EdgeInsets.all(w * 0.03),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(14)),
            child: Icon(Icons.shopping_bag_rounded, color: Colors.white, size: w * 0.08)),
        SizedBox(width: w * 0.04),
        Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Total Article", style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: w * 0.035)),
          Text("${fmt.format(total)} DA", style: TextStyle(color: Colors.white, fontSize: w * 0.05, fontWeight: FontWeight.bold)),
        ])),
        Container(
          padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: w * 0.01),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Exercice>(
              value: statVM.selectedExercicemonthlyTurnoverByProduct,
              isDense: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.deepPurple[600]),
              style: TextStyle(color: Colors.deepPurple[700], fontWeight: FontWeight.bold, fontSize: w * 0.04),
              onChanged: (e) {
                if (e != null) {
                  statVM.selectedExercicemonthlyTurnoverByProduct = e;
                  statVM.notifyListeners();
                  if (stockVM.selectedStatisticProduct != null) {
                    statVM.getTurnoverByProduct(ctx, e, stockVM.selectedStatisticProduct!);
                  }
                }
              },
              items: authVM.exercices?.map((e) => DropdownMenuItem(value: e, child: Text(e.EXENO.toString()))).toList(),
            ),
          ),
        ),
        // GestureDetector(
        //   onTap: () => _showExercicePicker(ctx, authVM, statVM, stockVM),
        //   child: Container(
        //     padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: w * 0.015),
        //     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        //     child: Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Text(
        //           authVM.selectedExercice?.EXENO.toString() ?? "Année",
        //           style: TextStyle(color: Colors.deepPurple[700], fontWeight: FontWeight.bold, fontSize: w * 0.04),
        //         ),
        //         SizedBox(width: w * 0.01),
        //         Icon(Icons.keyboard_arrow_down_rounded, color: Colors.deepPurple[600], size: w * 0.05),
        //       ],
        //     ),
        //   ),
        // ),
      ]),
    );
  }

  void _showExercicePicker(BuildContext context, AuthViewModel authVM, StatisticViewModel statVM, StockViewModel stockVM) {
    if (authVM.exercices == null || authVM.exercices!.isEmpty) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Sélectionner l'exercice", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepPurple[800])),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: authVM.exercices!.length,
                itemBuilder: (context, index) {
                  final e = authVM.exercices![index];
                  final isSelected = authVM.selectedExercice == e;
                  return ListTile(
                    title: Text(e.EXENO.toString(),
                        style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.deepPurple[600] : Colors.black87)),
                    trailing: isSelected ? Icon(Icons.check_circle_rounded, color: Colors.deepPurple[600]) : null,
                    onTap: () {
                      authVM.selectedExercice = e;
                      authVM.notify();
                      if (stockVM.selectedStatisticProduct != null) {
                        statVM.getTurnoverByProduct(context, e, stockVM.selectedStatisticProduct!);
                      }
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProductSelector(BuildContext ctx, double w, AuthViewModel authVM, StatisticViewModel statVM, StockViewModel stockVM) {
    return GestureDetector(
      onTap: () => _showProductSearch(ctx, w, authVM, statVM, stockVM),
      child: Container(
        padding: EdgeInsets.all(w * 0.035),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.deepPurple.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 4))]),
        child: Row(children: [
          Container(
              padding: EdgeInsets.all(w * 0.02),
              decoration: BoxDecoration(color: Colors.deepPurple[50], borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.search_rounded, color: Colors.deepPurple[600], size: w * 0.05)),
          SizedBox(width: w * 0.03),
          Expanded(
            child: Text(
              stockVM.selectedStatisticProduct?.ARTNOM ?? "Sélectionner un Article",
              style: TextStyle(
                  color: stockVM.selectedStatisticProduct == null ? Colors.grey[500] : Colors.black87,
                  fontSize: w * 0.035,
                  fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(Icons.keyboard_arrow_down_rounded, color: Colors.deepPurple[600]),
        ]),
      ),
    );
  }

  void _showProductSearch(BuildContext context, double w, AuthViewModel authVM, StatisticViewModel statVM, StockViewModel stockVM) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ProductSearchSheet(
        w: w,
        products: stockVM.statisticProducts,
        selectedProduct: stockVM.selectedStatisticProduct,
        onSelected: (p) {
          stockVM.selectedStatisticProduct = p;
          stockVM.notify();
          if (authVM.selectedExercice != null) {
            statVM.getTurnoverByProduct(context, authVM.selectedExercice!, p);
          }
        },
      ),
    );
  }

  Widget _buildContent(
      BuildContext ctx, double w, double h, AuthViewModel authVM, StatisticViewModel statVM, StockViewModel stockVM, NumberFormat fmt, double max) {
    if (statVM.turnoverByProductStatusCode == 0) {
      return SizedBox(height: h * 0.25, child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.deepPurple[600]))));
    }
    if (statVM.turnoverByProductStatusCode == 404) {
      return SizedBox(
          height: h * 0.25,
          child: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                padding: EdgeInsets.all(w * 0.04),
                decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                child: Icon(Icons.inventory_2_outlined, size: w * 0.12, color: Colors.grey[400])),
            SizedBox(height: h * 0.02),
            Text('Aucune donnée trouvée', style: TextStyle(color: Colors.grey[700], fontSize: w * 0.04, fontWeight: FontWeight.w600)),
            SizedBox(height: h * 0.01),
            Text('Sélectionnez un autre Article', style: TextStyle(color: Colors.grey[500], fontSize: w * 0.032)),
          ])));
    }
    if (statVM.turnoverByProductStatusCode == 500) {
      return SizedBox(
          height: h * 0.25,
          child: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                padding: EdgeInsets.all(w * 0.04),
                decoration: BoxDecoration(color: Colors.red[50], shape: BoxShape.circle),
                child: Icon(Icons.cloud_off_rounded, size: w * 0.12, color: Colors.red[400])),
            SizedBox(height: h * 0.02),
            Text('Impossible de se connecter', style: TextStyle(color: Colors.grey[700], fontSize: w * 0.04, fontWeight: FontWeight.w600)),
            SizedBox(height: h * 0.02),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: w * 0.03),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  if (authVM.selectedExercice != null && stockVM.selectedStatisticProduct != null) {
                    statVM.getTurnoverByProduct(ctx, authVM.selectedExercice!, stockVM.selectedStatisticProduct!);
                  }
                },
                icon: Icon(Icons.refresh_rounded, size: w * 0.045),
                label: const Text('Réessayer')),
          ])));
    }

    final data = statVM.monthlyTurnoverByProduct;
    if (data == null || data.isEmpty) return const SizedBox.shrink();

    return AspectRatio(
        aspectRatio: 1.4,
        child: LineChart(
            LineChartData(
              maxY: max + max / 3,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: max > 0 ? max / 4 : 1,
                  getDrawingHorizontalLine: (v) => FlLine(color: Colors.grey.withValues(alpha: 0.15), strokeWidth: 1, dashArray: [5, 5])),
              lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
                      getTooltipItems: (spots) => spots.map((s) {
                            final m = s.x.toInt();
                            return LineTooltipItem('${m >= 1 && m <= 12 ? _months[m] : ""}\n${fmt.format(s.y)} DA',
                                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
                          }).toList())),
              titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: w * 0.12,
                          interval: max > 0 ? max / 4 : 1,
                          getTitlesWidget: (v, m) => SideTitleWidget(
                              meta: m, child: Text(NumberFormat.compact().format(v), style: TextStyle(color: Colors.grey[600], fontSize: 11))))),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: w * 0.12,
                          getTitlesWidget: (v, m) {
                            final i = v.toInt();
                            if (i < 1 || i > 12) return const SizedBox.shrink();
                            return SideTitleWidget(
                                meta: m,
                                child: RotatedBox(
                                    quarterTurns: -1,
                                    child: Text(_months[i], style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600, fontSize: 11))));
                          })),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false))),
              lineBarsData: [
                LineChartBarData(
                    isCurved: true,
                    curveSmoothness: 0.35,
                    gradient: LinearGradient(colors: [Colors.deepPurple[600]!, Colors.deepPurple[400]!]),
                    barWidth: 3,
                    dotData: FlDotData(
                        show: true,
                        getDotPainter: (s, p, b, i) =>
                            FlDotCirclePainter(radius: 4, color: Colors.white, strokeWidth: 2, strokeColor: Colors.deepPurple[600]!)),
                    belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.deepPurple[400]!.withValues(alpha: 0.3), Colors.deepPurple[400]!.withValues(alpha: 0.05)])),
                    spots: data.map((e) => FlSpot(e.X, e.Y)).toList())
              ],
            ),
            duration: const Duration(milliseconds: 300)));
  }
}

class _ProductSearchSheet extends StatefulWidget {
  final double w;
  final List<StatisticProductModel> products;
  final StatisticProductModel? selectedProduct;
  final Function(StatisticProductModel) onSelected;

  const _ProductSearchSheet({
    required this.w,
    required this.products,
    this.selectedProduct,
    required this.onSelected,
  });

  @override
  State<_ProductSearchSheet> createState() => _ProductSearchSheetState();
}

class _ProductSearchSheetState extends State<_ProductSearchSheet> {
  late List<StatisticProductModel> filteredProducts;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredProducts = widget.products;
  }

  void _filter(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = widget.products;
      } else {
        final parts = query.toLowerCase().trim().split(' ').where((e) => e.isNotEmpty).toList();

        filteredProducts = widget.products.where((product) {
          final name = '${product.ARTNO!.toLowerCase()} ${product.ARTNOM?.toLowerCase()}';
          return parts.every((part) => name.contains(part));
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Color(0xFFF4F9FC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Choisir un Article", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.deepPurple[800])),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _searchController,
              onChanged: _filter,
              decoration: InputDecoration(
                hintText: "Rechercher un Article...",
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text("Aucun Article trouvé", style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final p = filteredProducts[index];
                      final isSelected = widget.selectedProduct == p;
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                        child: Material(
                          color: isSelected ? Colors.deepPurple[50] : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () {
                              widget.onSelected(p);
                              Navigator.pop(context);
                            },
                            child: ListTile(
                              title: Text(
                                p.ARTNOM ?? '',
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? Colors.deepPurple[700] : Colors.black87,
                                ),
                              ),
                              subtitle: Text(
                                p.ARTNO ?? '',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                              trailing: isSelected
                                  ? Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.deepPurple[600],
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
