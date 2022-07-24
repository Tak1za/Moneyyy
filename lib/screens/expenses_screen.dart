import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../widgets/expense_list.dart';
import '../widgets/expense_sum.dart';
import 'add_expense_screen.dart';

class ExpensesScreen extends StatelessWidget {
  ExpensesScreen({Key? key}) : super(key: key);

  final Stream<QuerySnapshot> records = FirebaseFirestore.instance
      .collection("records")
      .orderBy('dateTime', descending: true)
      .snapshots();

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
        children: const [
          ExpenseSum(),
          ExpenseList(),
        ],
      ),
    );
  }
}
