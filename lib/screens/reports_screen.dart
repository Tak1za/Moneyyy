import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final Stream<QuerySnapshot> records = FirebaseFirestore.instance
      .collection("records")
      .orderBy('dateTime', descending: true)
      .snapshots();

  final currencyFormat =
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpenseValue(records),
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
            child: StreamBuilder<QuerySnapshot>(
                stream: records,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("0");
                  }

                  if (!snapshot.hasData) {
                    return const Text(
                      "Start adding spends to view your report",
                      style: TextStyle(fontSize: 40),
                    );
                  }

                  final data = snapshot.requireData;

                  final List<ChartData> chartData = getChartDataForWeek(data);

                  int maxValue = -1;
                  for (var c in chartData) {
                    if (c.y > maxValue) {
                      maxValue = c.y;
                    }
                  }

                  return SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                      majorTickLines: const MajorTickLines(width: 0),
                      axisLine: const AxisLine(width: 0),
                    ),
                    primaryYAxis: NumericAxis(
                      minimum: 0,
                      maximum: maxValue.toDouble(),
                      interval: maxValue.toDouble() / 2,
                      majorTickLines: const MajorTickLines(width: 2),
                      majorGridLines: const MajorGridLines(width: 0),
                      axisLine: const AxisLine(width: 0),
                    ),
                    plotAreaBorderWidth: 0,
                    tooltipBehavior: TooltipBehavior(enable: true),
                    enableAxisAnimation: true,
                    enableSideBySideSeriesPlacement: true,
                    series: <ChartSeries<ChartData, String>>[
                      ColumnSeries(
                        dataSource: chartData,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ],
                  );
                }),
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
