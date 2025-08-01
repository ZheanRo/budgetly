import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get collection of expenses from database
  final CollectionReference expenses =
      FirebaseFirestore.instance.collection('expenses');

  // CREATE: add a new expense
  Future<void> addExpense(String expense) {
    return expenses.add({'expense': expense, 'timestamp': Timestamp.now()});
  }
  // READ: get notes from database

  // Update: Update expensives given a expense id

  // Delete: delete spense given a expense id
}
