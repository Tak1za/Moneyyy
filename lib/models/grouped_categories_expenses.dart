import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moneyyy/helpers/date_helpers.dart';
import 'package:moneyyy/models/time_period_enum.dart';

import 'expense_type.dart';

class GroupedCategoriesExpenses {
  final String image;
  final String category;
  final int entries;
  final int sum;

  GroupedCategoriesExpenses({
    required this.image,
    required this.category,
    required this.entries,
    required this.sum,
  });
}

List<GroupedCategoriesExpenses> getGroupedCategoriesExpenses(
    QuerySnapshot<Object?> data, TimePeriod timePeriod) {
  List<GroupedCategoriesExpenses> groupedCategories = [];
  final nowDate = DateTime.now();
  final formattedNowDate = DateTime(nowDate.year, nowDate.month, nowDate.day);
  Duration toSubtract;

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

  getExpenseTypes().forEach((ExpenseType expenseType) {
    int sum = 0;
    int entries = 0;
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

  groupedCategories.removeWhere((element) => element.entries == 0);

  return groupedCategories;
}
