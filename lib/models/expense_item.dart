class ExpenseItem {
  final String id; // Firestore doc ID
  final String name;
  final String amount;
  final DateTime dateTime;

  ExpenseItem({
    required this.id,
    required this.name,
    required this.amount,
    required this.dateTime,
  });
}
