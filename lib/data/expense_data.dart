import 'package:budgetly/datetime/date_time_helper.dart';
import 'package:budgetly/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:budgetly/services/firestore.dart';

class ExpenseData extends ChangeNotifier {
  // initialise Firestore
  FirestoreService db = FirestoreService();

// list of ALL expenses
  List<ExpenseItem> overallExpenseList = [];

// get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

// add new expense
  void addNewExpense(ExpenseItem tempExpense) async {
    String docId = await db.addExpense(tempExpense);

    ExpenseItem fullExpense = ExpenseItem(
        id: docId,
        name: tempExpense.name,
        amount: tempExpense.amount,
        dateTime: tempExpense.dateTime);
    overallExpenseList.add(fullExpense);
    notifyListeners();
  }

// delete expense
  void deleteExpense(ExpenseItem expense) async {
    overallExpenseList.remove(expense);
    notifyListeners();
    await db.deleteExpense(expense.id);
  }

  // Fetch from Firestore on startup
  Future<void> loadExpensesFromFirestore() async {
    final firestoreData = await db.getExpenses();
    overallExpenseList = firestoreData.map((item) {
      return ExpenseItem(
        id: item['id'],
        name: item['name'],
        amount: item['amount'],
        dateTime: item['timestamp'],
      );
    }).toList();
    notifyListeners();
  }

// get day of the week from a dateTime object
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thur';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

// get the date for the start of the week (Monday)
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    // get todays date
    DateTime today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Mon') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }

/* 

convert overall list of expenses into a daily expense summary 

e.g. overallExpsenseList = 

[
[food, 2025 / 01 / 30 , $10 ],
[hat, 2025 / 01 / 30, $15 ], 
[


Daily expense summary = [ 

 [2025/01/30: $25 ],
 [2025/01/31: $1],


]

*/
  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {
      // date (yyyymmdd) : amountTotalForDay
    };

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }
    return dailyExpenseSummary;
  }
}
