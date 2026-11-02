import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/exercice.dart';
import '../../../view_models/auth_view_model.dart';
import '../../../view_models/statistic_view_model.dart';

class MonthlyTurnover extends StatelessWidget {
  const MonthlyTurnover({super.key});

  static const List<String> _months = [
    '',
    'Jan',
    'Fév',
    'Mar',
    'Avr',
    'Mai',
    'Juin',
    'Juil',
    'Aoû',
    'Sep',
    'Oct',
    'Nov',
    'Déc'
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    NumberFormat fmt = NumberFormat.decimalPatternDigits(locale: 'fr_FR', decimalDigits: 2);

    return Consumer2<AuthViewModel, StatisticViewModel>(
      builder: (context, authVM, statVM, child) {
        double max = 0, total = 0;
        final data = statVM.monthlyTurnover;
        if (data != null && data.isNotEmpty) {
          max = data.map((e) => e.Y).reduce((a, b) => a > b ? a : b);
          total = data.fold(0, (sum, e) => sum + e.Y);
        }

        return Column(children: [
          // Header
          Container(
            padding: EdgeInsets.all(width * 0.04),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.teal[600]!, Colors.teal[400]!]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.teal.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 6))
              ],
            ),
            child: Row(children: [
              Container(
                padding: EdgeInsets.all(width * 0.03),
                decoration:
                    BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(14)),
                child: Icon(Icons.date_range_rounded, color: Colors.white, size: width * 0.08),
              ),
              SizedBox(width: width * 0.04),
              Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Total annuel",
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: width * 0.035)),
                Text("${fmt.format(total)} DA",
                    style: TextStyle(color: Colors.white, fontSize: width * 0.05, fontWeight: FontWeight.bold)),
              ])),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: width * 0.01),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Exercice>(
                    value: authVM.selectedExercice,
                    isDense: true,
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.teal[600]),
                    style: TextStyle(color: Colors.teal[700], fontWeight: FontWeight.bold, fontSize: width * 0.04),
                    onChanged: (e) {
                      if (e != null) {
                        authVM.selectedExercice = e;
                        authVM.notifyListeners();
                        statVM.turnoverByMonth(context, e);
                      }
                    },
                    items: authVM.exercices
                        ?.map((e) => DropdownMenuItem(value: e, child: Text(e.EXENO.toString())))
                        .toList(),
                  ),
                ),
              ),
            ]),
          ),
          SizedBox(height: width * 0.04),
          // Chart Card
          Container(
            padding: EdgeInsets.all(width * 0.04),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.teal.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8))
              ],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                    padding: EdgeInsets.all(width * 0.025),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.teal[600]!, Colors.teal[400]!]),
                        borderRadius: BorderRadius.circular(12)),
                    child: Icon(Icons.show_chart_rounded, color: Colors.white, size: width * 0.05)),
                SizedBox(width: width * 0.03),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Évolution mensuelle",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.045, color: Colors.black87)),
                  Text("Chiffre d'affaires par mois",
                      style: TextStyle(fontSize: width * 0.032, color: Colors.grey[600])),
                ]),
              ]),
              SizedBox(height: width * 0.05),
              _buildContent(context, width, height, authVM, statVM, fmt, max),
            ]),
          ),
        ]);
      },
    );
  }

  Widget _buildContent(BuildContext ctx, double w, double h, AuthViewModel authVM, StatisticViewModel statVM,
      NumberFormat fmt, double max) {
    if (statVM.turnoverByMonthStatusCode == 0)
      return SizedBox(
          height: h * 0.25,
          child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.teal[600]))));
    if (statVM.turnoverByMonthStatusCode == 404)
      return SizedBox(
          height: h * 0.25,
          child: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                padding: EdgeInsets.all(w * 0.04),
                decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                child: Icon(Icons.show_chart_rounded, size: w * 0.12, color: Colors.grey[400])),
            SizedBox(height: h * 0.02),
            Text('Aucune statistique trouvée',
                style: TextStyle(color: Colors.grey[700], fontSize: w * 0.04, fontWeight: FontWeight.w600)),
          ])));
    if (statVM.turnoverByMonthStatusCode == 500)
      return SizedBox(
          height: h * 0.25,
          child: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                padding: EdgeInsets.all(w * 0.04),
                decoration: BoxDecoration(color: Colors.red[50], shape: BoxShape.circle),
                child: Icon(Icons.cloud_off_rounded, size: w * 0.12, color: Colors.red[400])),
            SizedBox(height: h * 0.02),
            Text('Impossible de se connecter',
                style: TextStyle(color: Colors.grey[700], fontSize: w * 0.04, fontWeight: FontWeight.w600)),
            SizedBox(height: h * 0.02),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: w * 0.03),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  if (authVM.selectedExercice != null) statVM.turnoverByMonth(ctx, authVM.selectedExercice!);
                },
                icon: Icon(Icons.refresh_rounded, size: w * 0.045),
                label: Text('Réessayer')),
          ])));

    final data = statVM.monthlyTurnover;
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
                  getDrawingHorizontalLine: (v) =>
                      FlLine(color: Colors.grey.withValues(alpha: 0.15), strokeWidth: 1, dashArray: [5, 5])),
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
                              meta: m,
                              child: Text(NumberFormat.compact().format(v),
                                  style: TextStyle(color: Colors.grey[600], fontSize: 11))))),
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
                                    child: Text(_months[i],
                                        style: TextStyle(
                                            color: Colors.grey[700], fontWeight: FontWeight.w600, fontSize: 11))));
                          })),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false))),
              lineBarsData: [
                LineChartBarData(
                    isCurved: true,
                    curveSmoothness: 0.35,
                    gradient: LinearGradient(colors: [Colors.teal[600]!, Colors.teal[400]!]),
                    barWidth: 3,
                    dotData: FlDotData(
                        show: true,
                        getDotPainter: (s, p, b, i) => FlDotCirclePainter(
                            radius: 4, color: Colors.white, strokeWidth: 2, strokeColor: Colors.teal[600]!)),
                    belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                          Colors.teal[400]!.withValues(alpha: 0.3),
                          Colors.teal[400]!.withValues(alpha: 0.05)
                        ])),
                    spots: data.map((e) => FlSpot(e.X, e.Y)).toList())
              ],
            ),
            duration: const Duration(milliseconds: 300)));
  }
}
