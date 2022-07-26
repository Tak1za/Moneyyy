import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moneyyy/helpers/date_helpers.dart';
import 'package:moneyyy/models/grouped_expense.dart';

import 'expense.dart';

class ChartData {
  final String x;
  final int y;

  ChartData(this.x, this.y);
}

List<ChartData> getChartDataForWeek(QuerySnapshot<Object?> data) {
  List<ChartData> chartData = [];
  List<GroupedExpense> groupedData = [];
  for (var element in data.docs) {
    final nowDate = DateTime.now();
    final elementDate = (element['dateTime'] as Timestamp).toDate();
    final formattedElementDate =
        DateTime(elementDate.year, elementDate.month, elementDate.day);
    final formattedNowDate = DateTime(nowDate.year, nowDate.month, nowDate.day);

    String group;
    if (formattedElementDate.isToday()) {
      group = DateTime.now().getWeekday(DateTime.now().weekday);
    } else if (formattedElementDate.isAfter(
      formattedNowDate.subtract(
        Duration(days: formattedNowDate.weekday),
      ),
    )) {
      if (formattedElementDate.isYesterday()) {
        group = DateTime.now().getWeekday(
          DateTime.now()
              .subtract(
                const Duration(days: 1),
              )
              .weekday,
        );
      } else {
        group = formattedElementDate.getWeekday(formattedElementDate.weekday);
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

  List<String> weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  for (var weekday in weekdays) {
    int sum = 0;
    groupedData
        .where((element) => element.group == weekday)
        .forEach((element) => sum += element.data.costRupees);

    chartData.add(ChartData(weekday, sum));
  }

  return chartData;
}
