import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneyyy/widgets/expense_value.dart';
import 'package:moneyyy/widgets/grouped_expenses.dart';

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
            height: 200,
            child: const Text("Chart goes here"),
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
