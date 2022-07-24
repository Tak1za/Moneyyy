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
  var showSave = false;
  String amount = "";
  var selectedCategory = "Food";
  var selectedDate = DateFormat('MMMM d, yyyy').format(DateTime.now());

  void setSelectedCategory(ExpenseType e) {
    setState(() {
      selectedCategory = e.category;
    });
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      selectedDate = DateFormat('MMMM d, yyyy')
          .format(DateTime.parse(args.value.toString()));
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference records =
        FirebaseFirestore.instance.collection("records");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
          size: 17,
        ),
        elevation: 0,
        title: const Text(
          "Expense",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.white,
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
                    decoration: const InputDecoration(
                      hintText: "0",
                    ),
                    showCursor: false,
                    style: const TextStyle(
                      fontSize: 40,
                    ),
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
                              return SfDateRangePicker(
                                selectionMode:
                                    DateRangePickerSelectionMode.single,
                                onSelectionChanged: _onSelectionChanged,
                              );
                            });
                      },
                      child: Text(
                        selectedDate,
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
                        decoration: const InputDecoration(
                          hintText: "Add a note",
                        ),
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
                        const Text(
                          "Credit Card",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
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
                          setSelectedCategory: setSelectedCategory,
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
                                'dateTime': DateFormat('MMMM d, yyyy')
                                    .parse(selectedDate),
                              }).then((value) {
                                Navigator.of(context).pop();
                              }).catchError((error) =>
                                  print('Failed to add record: $error'));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(5),
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                ),
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
