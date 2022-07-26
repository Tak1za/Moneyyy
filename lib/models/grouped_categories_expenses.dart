import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moneyyy/helpers/date_helpers.dart';

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
    QuerySnapshot<Object?> data) {
  List<GroupedCategoriesExpenses> groupedCategories = [];
  getExpenseTypes().forEach((ExpenseType expenseType) {
    int sum = 0;
    int entries = 0;
    for (var element in data.docs) {
      final nowDate = DateTime.now();
      final elementDate = (element['dateTime'] as Timestamp).toDate();
      final formattedElementDate =
          DateTime(elementDate.year, elementDate.month, elementDate.day);
      final formattedNowDate =
          DateTime(nowDate.year, nowDate.month, nowDate.day);

      if (formattedElementDate.isToday() ||
          formattedElementDate.isAfter(
            formattedNowDate.subtract(
              Duration(days: formattedNowDate.weekday),
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
