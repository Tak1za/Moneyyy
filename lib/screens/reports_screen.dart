import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneyyy/helpers/date_helpers.dart';
import 'package:moneyyy/widgets/expense_value.dart';
import 'package:moneyyy/widgets/grouped_expenses.dart';

import '../models/time_period_enum.dart';
import '../widgets/chart.dart';
import '../widgets/time_selector.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final Stream<QuerySnapshot> records = FirebaseFirestore.instance
      .collection("records")
      .orderBy('dateTime', descending: true)
      .snapshots();

  final currencyFormat =
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  TimePeriod _timePeriod = TimePeriod.Today;
  int _selectedFilterIndex = -1;
  bool _oneSelected = false;
  String spentText = "";

  void _selectTimePeriod(TimePeriod timePeriod) {
    setState(() {
      _timePeriod = timePeriod;
    });
  }

  void _setSelectedFilterIndex(int index) {
    setState(() {
      _oneSelected = !_oneSelected;
      _selectedFilterIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_timePeriod != TimePeriod.Today) {
      if (_oneSelected && _timePeriod == TimePeriod.Year) {
        spentText =
            "Total spent in ${DateTime.now().getMonth(_selectedFilterIndex + 1, true)}";
      } else if (_oneSelected && _timePeriod == TimePeriod.Month) {
        spentText =
            "Total spent on ${DateTime.now().getWeekday(_selectedFilterIndex + 1, true)}'s";
      } else if (_oneSelected) {
        spentText =
            "Total spent on ${DateTime.now().getWeekday(_selectedFilterIndex + 1, true)}";
      } else {
        spentText = "Total spent this ${_timePeriod.name.toLowerCase()}";
      }
    } else {
      spentText = "Total spent ${_timePeriod.name.toLowerCase()}";
    }
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpenseValue(
              records, _timePeriod, _selectedFilterIndex, _oneSelected),
          Text(
            spentText,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Chart(records, _timePeriod, _setSelectedFilterIndex),
          TimeSelector(_timePeriod, _selectTimePeriod),
          GroupedExpenses(_timePeriod, _selectedFilterIndex, _oneSelected),
        ],
      ),
    );
  }
}
