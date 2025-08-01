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
//text controllers
  final newExpenseNameController = TextEditingController();
  final newExpensePoundController = TextEditingController();
  final newExpensePenceController = TextEditingController();

// add new expense
  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add new expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // expense name
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(hintText: "Expense name"),
            ),

            Row(
              children: [
                // pounds
                Expanded(
                  child: TextField(
                    controller: newExpensePoundController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "Pounds"),
                  ),
                ),

                // pence
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
          // save button
          MaterialButton(
            onPressed: save,
            child: Text('Save'),
          ),

          // cancel button

          MaterialButton(onPressed: cancel, child: Text('Cancel'))
        ],
      ),
    );
  }

// delete expense
  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

// save
  void save() {
    // only save expense if all fields are filled
    if (newExpenseNameController.text.isNotEmpty &&
        newExpensePoundController.text.isNotEmpty &&
        newExpensePenceController.text.isNotEmpty) {
      //put dollars and cents together
      String amount =
          '${newExpensePoundController.text}.${newExpensePenceController.text}';

      //create exepnse item
      ExpenseItem newExpense = ExpenseItem(
        id: 'pending',
        name: newExpenseNameController.text,
        amount: amount,
        dateTime: DateTime.now(),
      );
      // add the new expense
      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);
    }

    Navigator.pop(context);
    clear();
  }

// cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

// clear controllers
  void clear() {
    newExpensePoundController.clear();
    newExpenseNameController.clear();
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
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          body: ListView(children: [
            // weekly summary
            ExpenseSummary(startOfWeek: value.startOfWeekDate()),

            const SizedBox(height: 20),
            // expense list
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.getAllExpenseList().length,
                itemBuilder: (context, index) => ExpenseTile(
                    name: value.getAllExpenseList()[index].name,
                    amount: value.getAllExpenseList()[index].amount,
                    dateTime: value.getAllExpenseList()[index].dateTime,
                    deleteTapped: (p0) =>
                        deleteExpense(value.getAllExpenseList()[index])))
          ])),
    );
  }
}
