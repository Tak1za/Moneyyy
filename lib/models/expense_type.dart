class ExpenseType {
  final String category;
  final String categoryImage;

  ExpenseType(this.category, this.categoryImage);
}

List<ExpenseType> getExpenseTypes() {
  return [
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
}
