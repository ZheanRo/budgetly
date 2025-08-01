import 'package:budgetly/models/expense_item.dart';
import 'package:budgetly/datetime/date_time_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExpenseData extends ChangeNotifier {
  final List<ExpenseItem> _overallExpenseList = [];
  bool _hasFetched = false; // Prevent multiple fetches

  List<ExpenseItem> getAllExpenseList() {
    return _overallExpenseList;
  }

  // FETCH from Firestore
  Future<void> fetchExpenses() async {
    if (_hasFetched) return;
    _hasFetched = true;

    // Wait briefly to ensure FirebaseAuth has time to resolve currentUser
    await Future.delayed(const Duration(milliseconds: 100));
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;
    final expensesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenses');

    final snapshot =
        await expensesRef.orderBy('timestamp', descending: true).get();

    _overallExpenseList.clear(); // Clear old data
    for (var doc in snapshot.docs) {
      final data = doc.data();
      _overallExpenseList.add(
        ExpenseItem(
          id: doc.id,
          name: data['name'] ?? '',
          amount: data['amount'] ?? '0.00',
          dateTime: (data['timestamp'] as Timestamp).toDate(),
        ),
      );
    }

    notifyListeners();
  }

  // RESET fetch flag (use after logout if needed)
  void resetFetchedFlag() {
    _hasFetched = false;
  }

  // ADD
  Future<void> addNewExpense(ExpenseItem newExpense) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;
    final expensesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenses');

    final docRef = await expensesRef.add({
      'name': newExpense.name,
      'amount': newExpense.amount,
      'timestamp': newExpense.dateTime,
    });

    _overallExpenseList.add(
      ExpenseItem(
        id: docRef.id,
        name: newExpense.name,
        amount: newExpense.amount,
        dateTime: newExpense.dateTime,
      ),
    );

    notifyListeners();
  }

  // DELETE
  Future<void> deleteExpense(ExpenseItem expense) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || expense.id == null) return;

    final uid = user.uid;
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .doc(expense.id);

    await docRef.delete();
    _overallExpenseList.removeWhere((e) => e.id == expense.id);

    notifyListeners();
  }

  // Day Name
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun5';
      default:
        return '';
    }
  }

  // Start of Week
  DateTime startOfWeekDate() {
    final today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Mon') {
        return today.subtract(Duration(days: i));
      }
    }
    return today; // fallback
  }

  // Daily Expense Summary
  Map<String, double> calculateDailyExpenseSummary() {
    final Map<String, double> dailyExpenseSummary = {};

    for (var expense in _overallExpenseList) {
      final date = convertDateTimeToString(expense.dateTime);
      final amount = double.tryParse(expense.amount) ?? 0.0;

      if (dailyExpenseSummary.containsKey(date)) {
        dailyExpenseSummary[date] = dailyExpenseSummary[date]! + amount;
      } else {
        dailyExpenseSummary[date] = amount;
      }
    }

    return dailyExpenseSummary;
  }
}
