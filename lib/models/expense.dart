import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moneyyy/helpers/date_helpers.dart';

class Expense {
  final String id;
  final String image;
  final String category;
  final String note;
  final int costRupees;
  final DateTime dateTime;

  Expense({
    required this.id,
    required this.image,
    required this.category,
    required this.note,
    required this.costRupees,
    required this.dateTime,
  });
}

int getSumOfExpenses(QuerySnapshot<Object?> data) {
  int sum = 0;

  for (var element in data.docs) {
    final nowDate = DateTime.now();
    final elementDate = (element['dateTime'] as Timestamp).toDate();
    final formattedElementDate =
        DateTime(elementDate.year, elementDate.month, elementDate.day);
    final formattedNowDate = DateTime(nowDate.year, nowDate.month, nowDate.day);

    if (formattedElementDate.isToday() ||
        formattedElementDate.isAfter(
          formattedNowDate.subtract(
            Duration(days: formattedNowDate.weekday),
          ),
        )) {
      sum += element['costRupees'] as int;
    }
  }

  return sum;
}
