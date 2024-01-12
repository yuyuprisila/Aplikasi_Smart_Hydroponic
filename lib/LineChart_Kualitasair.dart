import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/chart_kualitasair.dart';

// ignore: must_be_immutable
class LineChartKualitasWidget extends StatelessWidget {
  final List<KualitasChart> points;
  LineChartKualitasWidget(this.points, {Key? key}) : super(key: key);

  Color mixColors(Color color1, Color color2, double ratio) {
    return Color.lerp(color1, color2, ratio) ?? Colors.transparent;
  }  

  List<Color> gradientColors = [
    // Color.fromARGB(255, 28, 88, 10),
    // Color.fromARGB(255, 138, 176, 12)
  ];
  double ratio = 0.50;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 5,
      child: LineChart(LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,// sesuaikan interval horizontal jika diperlukan
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.white,
              strokeWidth: 1,
            );
          },
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.white,
              strokeWidth: 1,
            );
          },
        ),

        lineBarsData: [
          LineChartBarData(
            spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
            isCurved: true,
            barWidth: 4,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.white
              // color: Colors.amberAccent[700]
              // color: mixColors(gradientColors[0], gradientColors[1], ratio).withOpacity(0.5),
            ),
            dotData: FlDotData(show: true),
            color: Colors.yellow[700]
            // color: Colors.white
          ),
        ],
      )),
    );
  }
}