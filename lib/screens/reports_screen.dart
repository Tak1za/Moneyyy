import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneyyy/widgets/grouped_expenses.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currencyFormat.format(300),
            style: const TextStyle(
              fontSize: 40,
            ),
          ),
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
            height: 200,
            child: const Text("Chart goes here"),
          ),
          const GroupedExpenses(),
        ],
      ),
    );
  }
}
