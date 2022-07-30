import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moneyyy/widgets/time_selector.dart';
import 'package:page_transition/page_transition.dart';

import '../models/time_period_enum.dart';
import '../widgets/expense_list.dart';
import '../widgets/expense_sum.dart';
import 'add_expense_screen.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({Key? key}) : super(key: key);

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final Stream<QuerySnapshot> records = FirebaseFirestore.instance
      .collection("records")
      .orderBy('dateTime', descending: true)
      .snapshots();

  var _timePeriod = TimePeriod.Week;

  void selectTimePeriod(TimePeriod timePeriod) {
    setState(() {
      _timePeriod = timePeriod;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dy > 0) {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.topToBottom,
              child: const AddExpenseScreen(),
            ),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ExpenseSum(_timePeriod),
          TimeSelector(_timePeriod, selectTimePeriod),
          ExpenseList(_timePeriod),
        ],
      ),
    );
  }
}
