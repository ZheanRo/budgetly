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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  static ExpenseItem fromMap(String id, Map<String, dynamic> map) {
    return ExpenseItem(
      id: id,
      name: map['name'],
      amount: map['amount'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}
