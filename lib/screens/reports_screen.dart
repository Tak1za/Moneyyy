import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneyyy/widgets/expense_value.dart';
import 'package:moneyyy/widgets/grouped_expenses.dart';

import '../models/time_period_enum.dart';
import '../widgets/chart.dart';
import '../widgets/time_selector.dart';

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

  var _timePeriod = TimePeriod.Week;

  void selectTimePeriod(TimePeriod timePeriod) {
    setState(() {
      _timePeriod = timePeriod;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpenseValue(records, _timePeriod),
          Text(
            "Total spent this ${_timePeriod.name.toLowerCase()}",
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Chart(records, _timePeriod),
          TimeSelector(_timePeriod, selectTimePeriod),
          GroupedExpenses(_timePeriod),
        ],
      ),
    );
  }
}
