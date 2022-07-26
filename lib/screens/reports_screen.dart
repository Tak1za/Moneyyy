import 'package:flutter/material.dart';
import 'package:moneyyy/models/chart_data.dart';
import 'package:moneyyy/widgets/expense_value.dart';
import 'package:moneyyy/widgets/grouped_expenses.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ExpenseValue(),
          const Text(
            "Total spent this week",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(right: 20),
            height: 200,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                majorTickLines: const MajorTickLines(width: 0),
                axisLine: const AxisLine(width: 0),
              ),
              primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: 5000,
                interval: 2500,
                majorTickLines: const MajorTickLines(width: 0),
                axisLine: const AxisLine(width: 0),
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              enableAxisAnimation: true,
              enableSideBySideSeriesPlacement: true,
              series: <ChartSeries<ChartData, String>>[
                ColumnSeries(
                  dataSource: [
                    ChartData("Mon", 200),
                    ChartData("Tue", 800),
                    ChartData("Thu", 0),
                    ChartData("Fri", 0),
                    ChartData("Sat", 0),
                    ChartData("Sun", 0),
                  ],
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 50,
            child: const Text("Week, Month, Year selector goes here"),
          ),
          const SizedBox(
            height: 30,
          ),
          const GroupedExpenses(),
        ],
      ),
    );
  }
}
