import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:moneyyy/helpers/date_helpers.dart';
import 'package:moneyyy/models/time_period_enum.dart';

import 'expense.dart';

class GroupedExpense {
  final Expense data;
  final String group;

  GroupedExpense({required this.data, required this.group});
}

List<GroupedExpense> getGroupedExpenses(
    QuerySnapshot<Object?> data, TimePeriod timePeriod) {
  List<GroupedExpense> groupedData = [];
  for (var doc in data.docs) {
    final nowDate = DateTime.now();
    final docDate = (doc['dateTime'] as Timestamp).toDate();
    final formattedDocDate = DateTime(docDate.year, docDate.month, docDate.day);
    final formattedNowDate = DateTime(nowDate.year, nowDate.month, nowDate.day);
    Duration toSubtract;

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
            days: formattedNowDate.difference(formattedFirstDateOfYear).inDays +
                1);
        break;
    }

    String group;
    if (formattedDocDate.isToday()) {
      group = "Today";
    } else if (formattedDocDate.isAfter(
      formattedNowDate.subtract(
        toSubtract,
      ),
    )) {
      if (formattedDocDate.isYesterday()) {
        group = "Yesterday";
      } else {
        group = DateFormat("MMMM d, yyyy").format(formattedDocDate);
      }
    } else {
      continue;
    }

    groupedData.add(
      GroupedExpense(
        data: Expense(
          id: doc.id,
          image: doc['image'],
          category: doc['category'],
          note: doc['note'],
          costRupees: doc['costRupees'],
          dateTime: (doc['dateTime'] as Timestamp).toDate(),
        ),
        group: group,
      ),
    );
  }

  return groupedData;
}
