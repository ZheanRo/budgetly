import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/expense_item.dart';

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get user's expense collection
  CollectionReference get userExpenses {
    final uid = _auth.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenses');
  }

  // Add new expense
  Future<void> addExpense(ExpenseItem expense) async {
    await userExpenses.add(expense.toMap());
  }

  // Delete expense
  Future<void> deleteExpense(String id) async {
    await userExpenses.doc(id).delete();
  }

  // Fetch all expenses
  Future<List<ExpenseItem>> getExpenses() async {
    final snapshot =
        await userExpenses.orderBy('dateTime', descending: true).get();
    return snapshot.docs
        .map((doc) =>
            ExpenseItem.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }
}
