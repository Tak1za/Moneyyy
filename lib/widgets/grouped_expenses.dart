import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneyyy/helpers/date_helpers.dart';
import 'package:moneyyy/models/expense_type.dart';

import '../models/grouped_categories_expenses.dart';

class GroupedExpenses extends StatelessWidget {
  const GroupedExpenses({Key? key}) : super(key: key);

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
        builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          if (!snapshot.hasData) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  "Start adding your spends for this week to view them",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final data = snapshot.requireData;

          List<GroupedCategoriesExpenses> groupedCategories = [];
          getExpenseTypes().forEach((ExpenseType expenseType) {
            int sum = 0;
            int entries = 0;
            for (var element in data.docs) {
              final nowDate = DateTime.now();
              final elementDate = (element['dateTime'] as Timestamp).toDate();
              final formattedElementDate = DateTime(
                  elementDate.year, elementDate.month, elementDate.day);
              final formattedNowDate =
                  DateTime(nowDate.year, nowDate.month, nowDate.day);

              if (formattedElementDate.isToday() ||
                  formattedElementDate.isAfter(
                    formattedNowDate.subtract(
                      Duration(days: formattedNowDate.weekday - 1),
                    ),
                  )) {
                if (element['category'] == expenseType.category) {
                  sum += element['costRupees'] as int;
                  entries++;
                }
              }
            }

            groupedCategories.add(
              GroupedCategoriesExpenses(
                image: expenseType.categoryImage,
                category: expenseType.category,
                entries: entries,
                sum: sum,
              ),
            );
          });

          groupedCategories.removeWhere(
              (GroupedCategoriesExpenses element) => element.entries == 0);

          if (groupedCategories.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  "Start adding your spends for this week to view them",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.separated(
            itemBuilder: (BuildContext ctx, int index) {
              return Row(
                children: [
                  Image.asset(
                    groupedCategories[index].image,
                    height: 30,
                    width: 30,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            groupedCategories[index].category,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${groupedCategories[index].entries} ${groupedCategories[index].entries > 1 ? 'entries' : 'entry'}",
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.cover,
                    child: Text(
                      currencyFormat.format(groupedCategories[index].sum),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      maxLines: 1,
                    ),
                  )
                ],
              );
            },
            separatorBuilder: (BuildContext ctx, int index) {
              return const Divider();
            },
            itemCount: groupedCategories.length,
          );
        },
      ),
    );
  }
}
