import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:moneyyy/models/grouped_expense.dart';
import 'package:moneyyy/models/time_period_enum.dart';

import '../models/expense.dart';
import 'expense_row.dart';

class ExpenseList extends StatelessWidget {
  final TimePeriod timePeriod;

  const ExpenseList(this.timePeriod, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> records = FirebaseFirestore.instance
        .collection("records")
        .orderBy('dateTime', descending: false)
        .snapshots();
    final NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: records,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          if (!snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  "Start adding your spends for this week to view them",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final data = snapshot.requireData;

          List<GroupedExpense> groupedData =
              getGroupedExpenses(data, timePeriod);

          if (groupedData.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  "Start adding your spends for this week to view them",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return GroupedListView(
            elements: groupedData,
            groupBy: (GroupedExpense element) {
              return element.group;
            },
            groupComparator: (String value1, String value2) {
              DateTime? v1DateTime;
              DateTime? v2DateTime;

              if (value1 == "Today") {
                v1DateTime = DateTime.now();
              }
              if (value2 == "Today") {
                v2DateTime = DateTime.now();
              }
              if (value1 == "Yesterday") {
                v1DateTime = DateTime.now().subtract(const Duration(days: 1));
              }
              if (value2 == "Yesterday") {
                v2DateTime = DateTime.now().subtract(const Duration(days: 1));
              }

              v1DateTime ??=
                  DateFormat("MMMM d, yyyy").parse(value1.toString());
              v2DateTime ??=
                  DateFormat("MMMM d, yyyy").parse(value2.toString());

              return v1DateTime.compareTo(v2DateTime);
            },
            order: GroupedListOrder.DESC,
            groupSeparatorBuilder: ((String value) {
              var sum = 0;
              groupedData
                  .where(
                    (element) => element.group == value,
                  )
                  .forEach(
                    (element) => sum += element.data.costRupees,
                  );
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      currencyFormat.format(sum),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                    )
                  ],
                ),
              );
            }),
            itemBuilder: ((context, GroupedExpense element) {
              return ExpenseRow(
                expense: Expense(
                  id: element.data.id,
                  image: element.data.image,
                  category: element.data.category,
                  note: element.data.note,
                  costRupees: element.data.costRupees,
                  dateTime: element.data.dateTime,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
