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
  final newExpenseAmountController = TextEditingController();

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
            TextField(controller: newExpenseNameController),

            // expense amount
            TextField(controller: newExpenseAmountController),
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

// save
  void save() {
    //create exepnse item
    ExpenseItem newExpense = ExpenseItem(
      name: newExpenseNameController.text,
      amount: newExpenseAmountController.text,
      dateTime: DateTime.now(),
    );
    // add the new expense
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);

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
    newExpenseAmountController.clear();
    newExpenseNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.grey[300],
          floatingActionButton: FloatingActionButton(
            onPressed: addNewExpense,
            child: Icon(Icons.add),
          ),
          body: ListView(children: [
            // weekly summary
            ExpenseSummary(startOfWeek: value.startOfWeekDate()),
            // expense list
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.getAllExpenseList().length,
                itemBuilder: (context, index) => ExpenseTile(
                    name: value.getAllExpenseList()[index].name,
                    amount: value.getAllExpenseList()[index].amount,
                    dateTime: value.getAllExpenseList()[index].dateTime))
          ])),
    );
  }
}
