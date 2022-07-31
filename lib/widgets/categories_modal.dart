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
                Text(
                  "CATEGORIES",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                  children: getExpenseTypes().map((e) {
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
                              style: Theme.of(context).textTheme.titleSmall,
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
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
