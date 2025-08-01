import 'package:budgetly/models/expense_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get collection of expenses from database
  final CollectionReference expenses =
      FirebaseFirestore.instance.collection('expenses');

  // CREATE: add a new expense
  Future<String> addExpense(ExpenseItem expense) async {
    DocumentReference docRef = await expenses.add({
      'name': expense.name,
      'amount': expense.amount,
      'timestamp': expense.dateTime
    });
    return docRef.id;
  }

  // READ: get expenses from database
  Future<List<Map<String, dynamic>>> getExpenses() async {
    QuerySnapshot snapshot =
        await expenses.orderBy('timestamp', descending: true).get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        'name': data['name'],
        'amount': data['amount'],
        'timestamp': (data['timestamp'] as Timestamp).toDate(),
      };
    }).toList();
  }

  // Update: Update expensives given a expense id

  // Delete: delete spense given a expense id
  Future<void> deleteExpense(String docId) async {
    await expenses.doc(docId).delete();
  }
}
