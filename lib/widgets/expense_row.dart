import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneyyy/models/expense.dart';

class ExpenseRow extends StatelessWidget {
  final Expense expense;

  const ExpenseRow({
    Key? key,
    required this.expense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    CollectionReference records =
        FirebaseFirestore.instance.collection("records");

    return Dismissible(
      key: Key(expense.id),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart ||
            direction == DismissDirection.startToEnd) {}
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart ||
            direction == DismissDirection.startToEnd) {
          return await showDialog(
            context: context,
            builder: (BuildContext ctx) {
              return AlertDialog(
                title: const Text("Confirm"),
                content:
                    const Text("Are you sure you wish to delete this item?"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        records
                            .doc(expense.id)
                            .delete()
                            .then((value) => Navigator.of(context).pop())
                            .catchError((error) =>
                                print("could not delete expense: $error"));
                      },
                      child: const Text("DELETE")),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("CANCEL"),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Row(
          children: [
            Image.asset(
              "assets/images/${expense.image}",
              height: 30,
              width: 30,
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: expense.note != ""
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expense.category,
                            style: Theme.of(context).textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            expense.note,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.grey,
                                ),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      )
                    : Text(
                        expense.category,
                        style: Theme.of(context).textTheme.titleLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
            ),
            FittedBox(
              fit: BoxFit.cover,
              child: Text(
                currencyFormat.format(expense.costRupees),
                style: Theme.of(context).textTheme.titleLarge,
                maxLines: 1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
