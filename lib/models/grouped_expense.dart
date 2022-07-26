import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:moneyyy/helpers/date_helpers.dart';

import 'expense.dart';

class GroupedExpense {
  final Expense data;
  final String group;

  GroupedExpense({required this.data, required this.group});
}

List<GroupedExpense> getGroupedExpenses(QuerySnapshot<Object?> data) {
  List<GroupedExpense> groupedData = [];
  for (var element in data.docs) {
    final nowDate = DateTime.now();
    final elementDate = (element['dateTime'] as Timestamp).toDate();
    final formattedElementDate =
        DateTime(elementDate.year, elementDate.month, elementDate.day);
    final formattedNowDate = DateTime(nowDate.year, nowDate.month, nowDate.day);

    String group;
    if (formattedElementDate.isToday()) {
      group = "Today";
    } else if (formattedElementDate.isAfter(
      formattedNowDate.subtract(
        Duration(days: formattedNowDate.weekday),
      ),
    )) {
      if (formattedElementDate.isYesterday()) {
        group = "Yesterday";
      } else {
        group = DateFormat("MMMM d, yyyy").format(formattedElementDate);
      }
    } else {
      continue;
    }

    groupedData.add(
      GroupedExpense(
        data: Expense(
          id: element.id,
          image: element['image'],
          category: element['category'],
          note: element['note'],
          costRupees: element['costRupees'],
          dateTime: (element['dateTime'] as Timestamp).toDate(),
        ),
        group: group,
      ),
    );
  }

  return groupedData;
}
