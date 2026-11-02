// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// import '../../../view_models/statistic_view_model.dart';

// class MonthlyCompare extends StatelessWidget {
//   const MonthlyCompare({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     NumberFormat formatter =
//         NumberFormat.decimalPatternDigits(locale: 'en_us', decimalDigits: 2);
//     List<Color> colors = [
//       Colors.blue.shade900,
//       Colors.yellow.shade900,
//       Colors.green.shade900,
//       Colors.red.shade900,
//     ];
//     return Consumer<StatisticViewModel>(
//       builder: (context, statisticViewModel, child) {
//         //double max = statisticViewModel.monthlyTurnover?.map((element) => element.Y).reduce((a, b) => a > b ? a : b) ?? 0;
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Chiffre d'affaires années/mois",
//               style: TextStyle(
//                   fontWeight: FontWeight.bold, fontSize: width * 0.05),
//             ),
//             (statisticViewModel.compareByMonthStatusCode == 0)
//                 ? SizedBox(
//                     height: height * 0.25,
//                     child: const Center(child: CircularProgressIndicator()))
//                 : (statisticViewModel.compareByMonthStatusCode == 404)
//                     ? const Center(child: Text('Aucun statistique trouvé'))
//                     : (statisticViewModel.compareByMonthStatusCode == 500)
//                         ? Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Text(
//                                   'Impossible de se connecter au serveur'),
//                               SizedBox(
//                                 height: height * 0.02,
//                               ),
//                               ElevatedButton(
//                                 style: ButtonStyle(
//                                     padding:
//                                         WidgetStateProperty.all<EdgeInsets>(
//                                             EdgeInsets.zero)),
//                                 onPressed: () {
//                                   statisticViewModel.compareByMonth(context);
//                                 },
//                                 child: Container(
//                                     padding: EdgeInsets.all(width * 0.03),
//                                     decoration: BoxDecoration(
//                                         color: Theme.of(context)
//                                             .secondaryHeaderColor,
//                                         borderRadius: const BorderRadius.all(
//                                             Radius.circular(20))),
//                                     child: const Text(
//                                       'Essayer à nouveau',
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold),
//                                     )),
//                               ),
//                             ],
//                           )
//                         : Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(
//                                 height: width * 0.03,
//                               ),
//                               AspectRatio(
//                                 aspectRatio: width * 0.005,
//                                 child: LineChart(
//                                   LineChartData(
//                                       //maxY: max + max / 3,
//                                       borderData: FlBorderData(show: false),
//                                       gridData: FlGridData(
//                                           show: true,
//                                           drawVerticalLine: false,
//                                           getDrawingHorizontalLine: (value) {
//                                             return FlLine(
//                                                 color: Colors.black
//                                                     .withValues(alpha: 0.05));
//                                           }),
//                                       lineTouchData: LineTouchData(
//                                         touchTooltipData: LineTouchTooltipData(
//                                           fitInsideHorizontally: true,
//                                           fitInsideVertically: true,
//                                           tooltipMargin: width * 0.3,
//                                           getTooltipItems: (touchedSpots) {
//                                             return touchedSpots
//                                                 .map((touchedSpot) {
//                                               return LineTooltipItem(
//                                                   '${formatter.format(touchedSpot.y)} DA',
//                                                   TextStyle(
//                                                     color:
//                                                         touchedSpot.bar.color,
//                                                   ),
//                                                   textAlign: TextAlign.end);
//                                             }).toList();
//                                           },
//                                         ),
//                                       ),
//                                       titlesData: FlTitlesData(
//                                         show: true,
//                                         leftTitles: AxisTitles(
//                                             sideTitles: SideTitles(
//                                                 showTitles: true,
//                                                 getTitlesWidget:
//                                                     leftTitlesWidgets,
//                                                 reservedSize: width *
//                                                     0.15)), // Adjust based on content),),
//                                         bottomTitles: AxisTitles(
//                                           sideTitles: SideTitles(
//                                               showTitles: true,
//                                               getTitlesWidget:
//                                                   bottomTitlesWidgets,
//                                               reservedSize: width * 0.15),
//                                         ),
//                                         topTitles: AxisTitles(
//                                           sideTitles: SideTitles(
//                                               showTitles: false,
//                                               getTitlesWidget:
//                                                   bottomTitlesWidgets),
//                                         ),
//                                         rightTitles: AxisTitles(
//                                           sideTitles: SideTitles(
//                                               showTitles: false,
//                                               getTitlesWidget:
//                                                   bottomTitlesWidgets),
//                                         ),
//                                       ),
//                                       lineBarsData: (statisticViewModel
//                                                   .monthlyComparedTurnover !=
//                                               null)
//                                           ? statisticViewModel
//                                               .monthlyComparedTurnover!
//                                               .asMap()
//                                               .entries
//                                               .map<LineChartBarData>((entry) {
//                                               int index = entry.key;
//                                               var element = entry.value;
//                                               return LineChartBarData(
//                                                   color: colors[index],
//                                                   isCurved: true,
//                                                   barWidth: width * 0.01,
//                                                   dotData:
//                                                       FlDotData(show: false),
//                                                   belowBarData: BarAreaData(
//                                                       show: true,
//                                                       color: colors[entry.key]
//                                                           .withValues(
//                                                               alpha: 0.3)),
//                                                   spots: element['months']
//                                                           ?.map<FlSpot>(
//                                                               (element) {
//                                                         return FlSpot(element.X,
//                                                             element.Y);
//                                                       }).toList() ??
//                                                       []);
//                                             }).toList()
//                                           : []),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: width * 0.06,
//                                 child: Row(
//                                   children: (statisticViewModel
//                                               .monthlyComparedTurnover !=
//                                           null)
//                                       ? statisticViewModel
//                                           .monthlyComparedTurnover!
//                                           .asMap()
//                                           .entries
//                                           .map<Widget>((entry) {
//                                           return Expanded(
//                                               child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               Container(
//                                                 width: width * 0.02,
//                                                 height: width * 0.02,
//                                                 decoration: BoxDecoration(
//                                                     color: colors[entry.key],
//                                                     shape: BoxShape.circle),
//                                               ),
//                                               Text(
//                                                   ' ${statisticViewModel.monthlyComparedTurnover?[entry.key]['year']}')
//                                             ],
//                                           ));
//                                         }).toList()
//                                       : [],
//                                 ), /*GridView.builder(
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 4,
//                         childAspectRatio: height * 0.0065,
//                         crossAxisSpacing: 0,
//                         mainAxisSpacing: 0
//                       ),
//                       itemCount: statisticViewModel.monthlyComparedTurnover?.length,
//                       itemBuilder: (context, index){
//                         return Row(
//                           children: [
//                             Container(
//                               width: width * 0.02,
//                               height: width * 0.02,
//                               decoration: BoxDecoration(
//                                   color: colors[index],
//                                   shape: BoxShape.circle
//                               ),
//                             ),
//                             Text(' ${statisticViewModel.monthlyComparedTurnover?[index]['year']}')
//                           ],
//                         );
//                       })*/
//                               )
//                             ],
//                           )
//           ],
//         );
//       },
//     );
//   }

//   Widget bottomTitlesWidgets(double value, TitleMeta meta) {
//     Widget text;
//     TextStyle textStyle = TextStyle(color: Colors.black);
//     switch (value.toInt()) {
//       case 1:
//         text = Text('Jan', style: textStyle);
//         break;
//       case 2:
//         text = Text('Fév', style: textStyle);
//         break;
//       case 3:
//         text = Text('Mar', style: textStyle);
//         break;
//       case 4:
//         text = Text('Avr', style: textStyle);
//         break;
//       case 5:
//         text = Text('Mai', style: textStyle);
//         break;
//       case 6:
//         text = Text('Juin', style: textStyle);
//         break;
//       case 7:
//         text = Text('Juil', style: textStyle);
//         break;
//       case 8:
//         text = Text('Aou', style: textStyle);
//         break;
//       case 9:
//         text = Text('Sep', style: textStyle);
//         break;
//       case 10:
//         text = Text('Oct', style: textStyle);
//         break;
//       case 11:
//         text = Text('Nov', style: textStyle);
//         break;
//       default:
//         text = Text('Dec', style: textStyle);
//         break;
//     }
//     return SideTitleWidget(
//         meta: meta, child: RotatedBox(quarterTurns: -1, child: text));
//   }

//   Widget leftTitlesWidgets(double value, TitleMeta meta) {
//     Widget text;
//     TextStyle textStyle = TextStyle(color: Colors.black);
//     text = Text(NumberFormat.compact().format(value), style: textStyle);
//     return SideTitleWidget(meta: meta, child: text);
//   }
// }
