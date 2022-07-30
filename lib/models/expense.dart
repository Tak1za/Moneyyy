import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moneyyy/helpers/date_helpers.dart';
import 'package:moneyyy/models/time_period_enum.dart';

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

int getSumOfExpenses(QuerySnapshot<Object?> data, TimePeriod timePeriod) {
  int sum = 0;
  Duration toSubtract;
  final nowDate = DateTime.now();
  final formattedNowDate = DateTime(nowDate.year, nowDate.month, nowDate.day);

  switch (timePeriod) {
    case TimePeriod.Week:
      toSubtract = Duration(days: formattedNowDate.weekday);
      break;
    case TimePeriod.Month:
      toSubtract = Duration(days: formattedNowDate.day);
      break;
    case TimePeriod.Year:
      final formattedFirstDateOfYear = DateTime(nowDate.year, 1, 1);
      toSubtract = Duration(
          days:
              formattedNowDate.difference(formattedFirstDateOfYear).inDays + 1);
      break;
  }

  for (var element in data.docs) {
    final elementDate = (element['dateTime'] as Timestamp).toDate();
    final formattedElementDate =
        DateTime(elementDate.year, elementDate.month, elementDate.day);

    if (formattedElementDate.isToday() ||
        formattedElementDate.isAfter(
          formattedNowDate.subtract(
            toSubtract,
          ),
        )) {
      sum += element['costRupees'] as int;
    }
  }

  return sum;
}
