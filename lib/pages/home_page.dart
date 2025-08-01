import 'package:budgetly/components/expense_summary.dart';
import 'package:budgetly/components/expense_tile.dart';
import 'package:budgetly/data/expense_data.dart';
import 'package:budgetly/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newExpenseNameController = TextEditingController();
  final newExpensePoundController = TextEditingController();
  final newExpensePenceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Ensure context is available before calling provider
    Future.delayed(Duration.zero, () {
      Provider.of<ExpenseData>(context, listen: false).fetchExpenses();
    });
  }

  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add new expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(hintText: "Expense name"),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: newExpensePoundController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "Pounds"),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: newExpensePenceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "Pence"),
                  ),
                ),
              ],
            )
          ],
        ),
        actions: [
          MaterialButton(onPressed: save, child: Text('Save')),
          MaterialButton(onPressed: cancel, child: Text('Cancel')),
        ],
      ),
    );
  }

  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  void save() {
    if (newExpenseNameController.text.isNotEmpty &&
        newExpensePoundController.text.isNotEmpty &&
        newExpensePenceController.text.isNotEmpty) {
      String amount =
          '${newExpensePoundController.text}.${newExpensePenceController.text}';

      ExpenseItem newExpense = ExpenseItem(
        id: 'pending',
        name: newExpenseNameController.text,
        amount: amount,
        dateTime: DateTime.now(),
      );

      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);
    }

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newExpenseNameController.clear();
    newExpensePoundController.clear();
    newExpensePenceController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          backgroundColor: Colors.black,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: ListView(
          children: [
            ExpenseSummary(startOfWeek: value.startOfWeekDate()),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.getAllExpenseList().length,
              itemBuilder: (context, index) {
                final expense = value.getAllExpenseList()[index];
                return ExpenseTile(
                  name: expense.name,
                  amount: expense.amount,
                  dateTime: expense.dateTime,
                  deleteTapped: (context) => deleteExpense(expense),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
