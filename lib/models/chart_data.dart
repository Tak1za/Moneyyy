import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moneyyy/helpers/date_helpers.dart';
import 'package:moneyyy/models/grouped_expense.dart';

import 'expense.dart';
import 'time_period_enum.dart';

class ChartData {
  final String x;
  final int y;

  ChartData(this.x, this.y);
}

List<ChartData> getChartData(
    QuerySnapshot<Object?> data, TimePeriod timePeriod) {
  List<ChartData> chartData = [];
  List<GroupedExpense> groupedData = [];
  final nowDate = DateTime.now();
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
          days:
              formattedNowDate.difference(formattedFirstDateOfYear).inDays + 1);
      break;
  }

  for (var doc in data.docs) {
    final docDate = (doc['dateTime'] as Timestamp).toDate();
    final formattedDocDate = DateTime(docDate.year, docDate.month, docDate.day);

    String group;
    if (formattedDocDate.isAfter(
      formattedNowDate.subtract(
        toSubtract,
      ),
    )) {
      if (timePeriod == TimePeriod.Year) {
        group = formattedDocDate.getMonth(formattedDocDate.month);
      } else {
        group = formattedDocDate.getWeekday(formattedDocDate.weekday);
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

  if (timePeriod == TimePeriod.Year) {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    for (var month in months) {
      int sum = 0;
      groupedData
          .where((element) => element.group == month)
          .forEach((element) => sum += element.data.costRupees);

      chartData.add(ChartData(month, sum));
    }
  } else {
    List<String> weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    for (var weekday in weekdays) {
      int sum = 0;
      groupedData
          .where((element) => element.group == weekday)
          .forEach((element) => sum += element.data.costRupees);

      chartData.add(ChartData(weekday, sum));
    }
  }

  return chartData;
}
