import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/expense.dart';
import 'expense_row.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> records = FirebaseFirestore.instance
        .collection("records")
        .orderBy('dateTime', descending: true)
        .snapshots();

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
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  "Start adding your spends to view them here",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final data = snapshot.requireData;

          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              height: 20,
              indent: 30,
              endIndent: 30,
            ),
            itemCount: data.size,
            itemBuilder: (BuildContext ctx, int index) {
              return ExpenseRow(
                expense: Expense(
                  id: data.docs[index].id,
                  image: data.docs[index]['image'],
                  category: data.docs[index]['category'],
                  note: data.docs[index]['note'],
                  costRupees: data.docs[index]['costRupees'],
                  dateTime:
                      (data.docs[index]['dateTime'] as Timestamp).toDate(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
