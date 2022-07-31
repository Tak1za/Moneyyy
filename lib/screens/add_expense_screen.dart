import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneyyy/models/expense_type.dart';
import 'package:moneyyy/widgets/categories_modal.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({Key? key}) : super(key: key);

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final costController = TextEditingController();
  final noteController = TextEditingController();
  bool showSave = false;
  String amount = "";
  String selectedCategory = "Food";
  String selectedDate =
      DateFormat('MMMM d, yyyy h:mm a').format(DateTime.now());

  void _setSelectedCategory(ExpenseType e) {
    setState(() {
      selectedCategory = e.category;
    });
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      DateTime now = DateTime.now();
      DateTime selectedDateTime = DateTime.parse(args.value.toString());
      selectedDateTime = selectedDateTime.add(
        Duration(hours: now.hour, minutes: now.minute),
      );
      selectedDate = DateFormat('MMMM d, yyyy h:mm a').format(selectedDateTime);

      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference records =
        FirebaseFirestore.instance.collection("records");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
        title: Text(
          "Expense",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 200,
            child: Row(
              children: [
                const Text(
                  "₹",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 30,
                  ),
                ),
                Expanded(
                  child: TextField(
                    onChanged: (text) {
                      if (text != "") {
                        amount = text.toString();
                        setState(() {
                          showSave = true;
                        });
                      }
                    },
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    controller: costController,
                    decoration: InputDecoration(
                      hintText: "0",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    showCursor: false,
                    style: Theme.of(context).textTheme.displayLarge,
                    inputFormatters: [
                      CurrencyTextInputFormatter(
                        decimalDigits: 0,
                        symbol: '',
                        locale: 'en_IN',
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext ctx) {
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: SfDateRangePicker(
                                  onSelectionChanged: _onSelectionChanged,
                                  maxDate: DateTime.now(),
                                ),
                              );
                            });
                      },
                      child: Text(
                        DateFormat("MMMM d, yyyy").format(
                          DateFormat("MMMM d, yyyy h:mm a").parse(selectedDate),
                        ),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        controller: noteController,
                        decoration: InputDecoration(
                            hintText: "Add a note",
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ))),
                        showCursor: false,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Credit Card",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.arrow_right,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ),
                        CategoriesModal(
                          selectedCategory: selectedCategory,
                          setSelectedCategory: _setSelectedCategory,
                        ),
                      ],
                    ),
                    showSave
                        ? GestureDetector(
                            onTap: () {
                              int costRupees =
                                  int.parse(amount.split(',').join(''));
                              records.add({
                                'image':
                                    '${selectedCategory.toLowerCase()}.png',
                                'category': selectedCategory,
                                'note': noteController.text,
                                'costRupees': costRupees,
                                'dateTime': DateFormat('MMMM d, yyyy h:mm a')
                                    .parse(selectedDate),
                              }).then((value) {
                                Navigator.of(context).pop();
                              }).catchError((error) =>
                                  print('Failed to add record: $error'));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                "Save",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(fontSize: 12),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
