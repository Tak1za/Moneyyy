import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneyyy/helpers/date_helpers.dart';
import 'package:page_transition/page_transition.dart';

import '../screens/add_expense_screen.dart';

class ExpenseSum extends StatelessWidget {
  const ExpenseSum({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> records = FirebaseFirestore.instance
        .collection("records")
        .orderBy('dateTime', descending: true)
        .snapshots();

    int sumOfExpenses = 0;

    final currencyFormat =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return FittedBox(
      fit: BoxFit.contain,
      child: Container(
        alignment: Alignment.center,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Spent this week",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: records,
              builder:
                  (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("0");
                }

                if (!snapshot.hasData) {
                  return Text(
                    currencyFormat.format(0),
                    style: const TextStyle(fontSize: 40),
                  );
                }

                final data = snapshot.requireData;
                int sum = 0;

                for (var element in data.docs) {
                  final nowDate = DateTime.now();
                  final elementDate =
                      (element['dateTime'] as Timestamp).toDate();
                  final formattedElementDate = DateTime(
                      elementDate.year, elementDate.month, elementDate.day);
                  final formattedNowDate =
                      DateTime(nowDate.year, nowDate.month, nowDate.day);

                  if (formattedElementDate.isToday() ||
                      formattedElementDate.isAfter(
                        formattedNowDate.subtract(
                          Duration(days: formattedNowDate.weekday),
                        ),
                      )) {
                    sum += element['costRupees'] as int;
                  }
                }

                sumOfExpenses = sum;

                return Text(
                  currencyFormat.format(sumOfExpenses),
                  style: const TextStyle(fontSize: 40),
                );
              },
            ),
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
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(5),
                child: const Text(
                  "Add Expense",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
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
