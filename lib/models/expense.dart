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

int getSumOfExpenses(QuerySnapshot<Object?> data, TimePeriod timePeriod,
    int selectedFilterIndex, bool oneSelected) {
  int sum = 0;
  Duration toSubtract;
  final nowDate = DateTime.now();
  final formattedNowDate = DateTime(nowDate.year, nowDate.month, nowDate.day);

  switch (timePeriod) {
    case TimePeriod.Today:
      toSubtract = const Duration(days: -1);
      break;
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
      if (selectedFilterIndex == -1 || !oneSelected) {
        sum += element['costRupees'] as int;
      } else {
        switch (timePeriod) {
          case TimePeriod.Month:
          case TimePeriod.Week:
            if (formattedElementDate.weekday == selectedFilterIndex + 1) {
              sum += element['costRupees'] as int;
            }
            break;
          case TimePeriod.Year:
            if (formattedElementDate.month == selectedFilterIndex + 1) {
              sum += element['costRupees'] as int;
            }
            break;
          default:
            break;
        }
      }
    }
  }

  return sum;
}
