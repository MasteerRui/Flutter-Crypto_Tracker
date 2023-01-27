import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CoinChart extends StatefulWidget {
  CoinChart({
    super.key,
    required this.color,
    required this.pricechart,
  });

  final Color color;
  final List<double> pricechart;

  @override
  State<CoinChart> createState() => _CoinChartState();
}

class _CoinChartState extends State<CoinChart> {
  List<FlSpot> spots = [];

  void getStops() {
    spots.clear();
    for (int i = 0; i < widget.pricechart.length; i++) {
      spots.add(FlSpot(i.toDouble(), widget.pricechart[i]));
    }
  }

  @override
  void initState() {
    getStops();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      lineChartData,
      // Controls how long chart animates to new data set
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get lineChartData => LineChartData(
        lineTouchData: lineTouchData, // Customize touch points
        gridData: gridData, // Customize grid
        titlesData: titlesData, // Customize axis labels
        borderData: borderData, // Customize border
        lineBarsData: [
          lineChartBarData,
        ],
      );

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.black.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(show: false);

  LineChartBarData get lineChartBarData => LineChartBarData(
        isCurved: true,
        color: widget.color,
        barWidth: 1,
        dotData: FlDotData(show: false),
        spots: spots,
        belowBarData: BarAreaData(
          show: true,
          color: Colors.transparent,
        ),
      );
}
