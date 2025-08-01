import 'package:budgetly/bar%20graph/bar_data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MyBarGraph extends StatelessWidget {
  final double? maxY;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thuAmount;
  final double friAmount;
  final double satAmount;
  final double sunAmount;

  const MyBarGraph({
    super.key,
    required this.maxY,
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thuAmount,
    required this.friAmount,
    required this.satAmount,
    required this.sunAmount,
  });

  @override
  Widget build(BuildContext context) {
    // initialise bar data
    BarData myBarData = BarData(
      monAmount: monAmount,
      tueAmount: tueAmount,
      wedAmount: wedAmount,
      thuAmount: thuAmount,
      friAmount: friAmount,
      satAmount: satAmount,
      sunAmount: sunAmount,
    );
    myBarData.initialiseBarData();

    return BarChart(BarChartData(
      maxY: maxY,
      minY: 0,
      titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                String text;
                switch (value.toInt()) {
                  case 0:
                    text = 'M';
                    break;
                  case 1:
                    text = 'T';
                    break;
                  case 2:
                    text = 'W';
                    break;
                  case 3:
                    text = 'T';
                    break;
                  case 4:
                    text = 'F';
                    break;
                  case 5:
                    text = 'S';
                    break;
                  case 6:
                    text = 'S';
                    break;
                  default:
                    text = '';
                }
                return Text(
                  text,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                );
              },
            ),
          )),
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
      barGroups: myBarData.barData
          .map((data) => BarChartGroupData(x: data.x, barRods: [
                BarChartRodData(
                    toY: data.y,
                    color: Colors.grey[800],
                    width: 25,
                    borderRadius: BorderRadius.circular(4),
                    backDrawRodData: BackgroundBarChartRodData(
                        show: true, toY: maxY, color: Colors.grey[200]))
              ]))
          .toList(),
    ));
  }
}
