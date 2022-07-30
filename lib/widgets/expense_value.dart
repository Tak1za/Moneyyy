import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneyyy/models/expense.dart';
import 'package:moneyyy/models/time_period_enum.dart';

class ExpenseValue extends StatelessWidget {
  final Stream<QuerySnapshot<Object?>> records;
  final TimePeriod timePeriod;

  const ExpenseValue(this.records, this.timePeriod, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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

        sumOfExpenses = getSumOfExpenses(data, timePeriod);

        return Text(
          currencyFormat.format(sumOfExpenses),
          style: const TextStyle(fontSize: 40),
        );
      },
    );
  }
}
