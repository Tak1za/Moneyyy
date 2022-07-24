import 'package:flutter/material.dart';

import '../models/expense_type.dart';

class CategoriesModal extends StatefulWidget {
  final String selectedCategory;
  final void Function(ExpenseType e) setSelectedCategory;
  const CategoriesModal({
    Key? key,
    required this.selectedCategory,
    required this.setSelectedCategory,
  }) : super(key: key);

  @override
  State<CategoriesModal> createState() => _CategoriesModalState();
}

class _CategoriesModalState extends State<CategoriesModal> {
  final _expenseTypes = [
    ExpenseType("Food", "assets/images/food.png"),
    ExpenseType("Accessories", "assets/images/accessories.png"),
    ExpenseType("Cab", "assets/images/cab.png"),
    ExpenseType("Clothing", "assets/images/clothing.png"),
    ExpenseType("Coffee", "assets/images/coffee.png"),
    ExpenseType("Drinks", "assets/images/drinks.png"),
    ExpenseType("Entertainment", "assets/images/entertainment.png"),
    ExpenseType("Flight", "assets/images/flight.png"),
    ExpenseType("Fruit", "assets/images/fruit.png"),
    ExpenseType("Gift", "assets/images/gift.png"),
    ExpenseType("Medicine", "assets/images/medicine.png"),
    ExpenseType("Snacks", "assets/images/snacks.png"),
    ExpenseType("Subscription", "assets/images/subscription.png"),
    ExpenseType("Tech", "assets/images/tech.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext ctx) {
            return Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "CATEGORIES",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  shrinkWrap: true,
                  children: _expenseTypes.map((e) {
                    return GestureDetector(
                      onTap: () {
                        widget.setSelectedCategory(e);
                        Navigator.of(ctx).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              e.categoryImage,
                              height: 30,
                              width: 30,
                            ),
                            Text(
                              e.category,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        );
      },
      child: Row(
        children: [
          Image.asset(
            "assets/images/${widget.selectedCategory.toLowerCase()}.png",
            height: 20,
            width: 20,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            widget.selectedCategory,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
