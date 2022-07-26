import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moneyyy/models/time_period_enum.dart';
import 'package:moneyyy/widgets/expense_value.dart';
import 'package:page_transition/page_transition.dart';

import '../screens/add_expense_screen.dart';

class ExpenseSum extends StatelessWidget {
  final TimePeriod timePeriod;

  const ExpenseSum(this.timePeriod, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> records = FirebaseFirestore.instance
        .collection("records")
        .orderBy('dateTime', descending: true)
        .snapshots();

    return FittedBox(
      fit: BoxFit.contain,
      child: Container(
        alignment: Alignment.center,
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Spent ${timePeriod != TimePeriod.Today ? 'this' : ''} ${timePeriod.name.toLowerCase()}",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            ExpenseValue(records, timePeriod, -1, false),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.topToBottom,
                    child: const AddExpenseScreen(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(5),
                child: Text(
                  "Add Expense",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
