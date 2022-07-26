import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneyyy/models/expense.dart';

class ExpenseValue extends StatelessWidget {
  const ExpenseValue({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> records = FirebaseFirestore.instance
        .collection("records")
        .orderBy('dateTime', descending: true)
        .snapshots();

    int sumOfExpenses = 0;

    final currencyFormat =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return StreamBuilder<QuerySnapshot>(
      stream: records,
      builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
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

        sumOfExpenses = getSumOfExpenses(data);

        return Text(
          currencyFormat.format(sumOfExpenses),
          style: const TextStyle(fontSize: 40),
        );
      },
    );
  }
}
