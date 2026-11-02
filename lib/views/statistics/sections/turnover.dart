import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../view_models/statistic_view_model.dart';

class Turnover extends StatelessWidget {
  const Turnover({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    NumberFormat formatter = NumberFormat.decimalPatternDigits(locale: 'fr_FR', decimalDigits: 2);

    return Consumer<StatisticViewModel>(
      builder: (context, statisticViewModel, child) {
        final comparedTurnovers = statisticViewModel.comparedTurnovers;
        double max = 0;
        if (comparedTurnovers != null && comparedTurnovers.isNotEmpty) {
          max = comparedTurnovers.map((element) => element.Y).reduce((a, b) => a > b ? a : b);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            _buildHeaderCard(context, width),
            SizedBox(height: width * 0.04),

            // Chart Card
            Container(
              padding: EdgeInsets.all(width * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(width * 0.025),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).secondaryHeaderColor,
                              Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.bar_chart_rounded,
                          color: Colors.white,
                          size: width * 0.05,
                        ),
                      ),
                      SizedBox(width: width * 0.03),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Chiffre d'affaires",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.045,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "Comparaison annuelle",
                              style: TextStyle(
                                fontSize: width * 0.032,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: width * 0.05),
                  _buildChartContent(
                    context,
                    width,
                    height,
                    statisticViewModel,
                    formatter,
                    max,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeaderCard(BuildContext context, double width) {
    return Consumer<StatisticViewModel>(
      builder: (context, statisticViewModel, child) {
        final turnovers = statisticViewModel.comparedTurnovers;
        double totalTurnover = 0;
        if (turnovers != null && turnovers.isNotEmpty) {
          totalTurnover = turnovers.fold(0, (sum, item) => sum + item.Y);
        }

        return Container(
          padding: EdgeInsets.all(width * 0.04),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).secondaryHeaderColor,
                Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(width * 0.03),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.trending_up_rounded,
                  color: Colors.white,
                  size: width * 0.08,
                ),
              ),
              SizedBox(width: width * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total des années",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: width * 0.035,
                      ),
                    ),
                    SizedBox(height: width * 0.01),
                    Text(
                      "${NumberFormat.decimalPattern('fr_FR').format(totalTurnover)} DA",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.055,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChartContent(
    BuildContext context,
    double width,
    double height,
    StatisticViewModel statisticViewModel,
    NumberFormat formatter,
    double max,
  ) {
    if (statisticViewModel.statusCode == 0) {
      return _buildLoadingState(context, width, height);
    }

    if (statisticViewModel.statusCode == 404) {
      return _buildEmptyState(context, width, height);
    }

    if (statisticViewModel.statusCode == 500) {
      return _buildErrorState(context, width, height, statisticViewModel);
    }

    return _buildChart(context, width, statisticViewModel, formatter, max);
  }

  Widget _buildLoadingState(BuildContext context, double width, double height) {
    return SizedBox(
      height: height * 0.25,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: width * 0.12,
              height: width * 0.12,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
            SizedBox(height: width * 0.04),
            Text(
              'Chargement des données...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: width * 0.035,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, double width, double height) {
    return SizedBox(
      height: height * 0.25,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(width * 0.04),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.analytics_outlined,
                size: width * 0.12,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: height * 0.02),
            Text(
              'Aucune statistique trouvée',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: width * 0.04,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: height * 0.01),
            Text(
              'Essayez de raffraîchir les données',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: width * 0.032,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    double width,
    double height,
    StatisticViewModel statisticViewModel,
  ) {
    return SizedBox(
      height: height * 0.25,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(width * 0.04),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                size: width * 0.12,
                color: Colors.red[400],
              ),
            ),
            SizedBox(height: height * 0.02),
            Text(
              'Impossible de se connecter',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: width * 0.04,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: height * 0.02),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).secondaryHeaderColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.06,
                  vertical: width * 0.03,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () => statisticViewModel.compare(context),
              icon: Icon(Icons.refresh_rounded, size: width * 0.045),
              label: Text(
                'Réessayer',
                style: TextStyle(
                  fontSize: width * 0.035,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(
    BuildContext context,
    double width,
    StatisticViewModel statisticViewModel,
    NumberFormat formatter,
    double max,
  ) {
    final turnovers = statisticViewModel.comparedTurnovers;
    if (turnovers == null || turnovers.isEmpty) {
      return const SizedBox.shrink();
    }

    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          maxY: max + max / 3,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: max > 0 ? max / 4 : 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withValues(alpha: 0.15),
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipPadding: EdgeInsets.all(width * 0.02),
              tooltipMargin: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${formatter.format(rod.toY)} DA',
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.032,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: leftTitlesWidgets,
                reservedSize: width * 0.12,
                interval: max > 0 ? max / 4 : 1,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: bottomTitlesWidgets,
                reservedSize: width * 0.08,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          barGroups: turnovers.map<BarChartGroupData>((element) {
            return BarChartGroupData(
              x: element.X.toInt(),
              barRods: [
                BarChartRodData(
                  width: width * 0.06,
                  toY: element.Y,
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Theme.of(context).secondaryHeaderColor,
                      Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        swapAnimationDuration: const Duration(milliseconds: 300),
        swapAnimationCurve: Curves.easeInOut,
      ),
    );
  }

  Widget bottomTitlesWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      meta: meta,
      child: Text(
        value.toInt().toString(),
        style: TextStyle(
          color: Colors.grey[700],
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget leftTitlesWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      meta: meta,
      child: Text(
        NumberFormat.compact().format(value),
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 11,
        ),
      ),
    );
  }
}
