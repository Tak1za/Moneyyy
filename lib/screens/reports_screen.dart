import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneyyy/models/chart_data.dart';
import 'package:moneyyy/widgets/expense_value.dart';
import 'package:moneyyy/widgets/grouped_expenses.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../widgets/chart.dart';

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
          Chart(records),
          SizedBox(
            height: 70,
            child: Center(
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Week",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Month",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Year",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const GroupedExpenses(),
        ],
      ),
    );
  }
}
