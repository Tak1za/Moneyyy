class Expense {
  final String id;
  final String image;
  final String category;
  final String note;
  final int costRupees;
  final DateTime dateTime;

  Expense({
    required this.id,
    required this.image,
    required this.category,
    required this.note,
    required this.costRupees,
    required this.dateTime,
  });
}
