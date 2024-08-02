import 'package:ex2_expense_tracker/models/expenseModel.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ex2_expense_tracker/providers/expense_provider.dart';

class AddExpenseForm extends ConsumerStatefulWidget {
  const AddExpenseForm({super.key});

  @override
  ConsumerState<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends ConsumerState<AddExpenseForm> {
  final formatter = DateFormat.yMd();
  final _formKey = GlobalKey<FormState>();
  String _expenseName = '';
  double? _expenseValue;
  String _expenseCategory = Category.food.name;
  DateTime? _pickedDate;
  final now = DateTime.now();

  MaterialColor? getCategoryColor(Category cat) {
    if (cat == Category.food) {
      return Colors.red;
    }
    if (cat == Category.work) {
      return Colors.blue;
    }
    if (cat == Category.leisure) {
      return Colors.orange;
    }
    if (cat == Category.travel) {
      return Colors.green;
    }
    return null;
  }

  Future<void> _onCalendarTap() async {
    
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1, now.month, now.day),
      lastDate: now,
      initialDate: now,
    );
    setState(() {
      _pickedDate = pickedDate;
    });
  }

  void _onCancelTap(){
    Navigator.pop(context);
  }
  void _onSaveExpenseTap(){
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      _pickedDate ??= now;
        ref.read(expenseProvider.notifier).addExpense(_expenseName, _expenseValue!, _pickedDate!, _expenseCategory);
        Navigator.pop(context);
        return;
      /*  Expense Data Management
      - Backend Database for each user through sqflite
      - when Expenses screen is initiated data is retreived from the backend and displayed on the Expenses list 

      */
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      // width: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'please enter a valid name';
                }
              },
              onSaved: (newValue) {
                _expenseName = newValue!;
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      prefix: Text('\$ '),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          double.tryParse(value.trim()) == null ||
                          double.parse(value.trim()) <= 0) {
                        return 'please enter a valid number';
                      }
                    },
                    onSaved: (newValue) {
                      _expenseValue = double.parse(newValue!);
                    },
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _pickedDate != null
                            ? formatter.format(_pickedDate!)
                            : 'No picked Date yet.',
                      ),
                      IconButton(
                        onPressed: _onCalendarTap,
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    value: _expenseCategory,
                    items: [
                      for (var item in Category.values)
                        DropdownMenuItem(
                            value: item.name,
                            child: Row(children: [
                              Container(
                                height: 14,
                                width: 14,
                                color: getCategoryColor(item),
                              ),
                              const SizedBox(
                                width: 14,
                              ),
                              Text(item.name)
                            ]))
                      // child: Text(item.name),)
                    ],
                    onChanged: (value) {
                      // setState(() {
                      _expenseCategory = value!;
                      // });
                    },
                  ),
                ),
                TextButton(onPressed: _onCancelTap, child: const Text('Cancel')),
                ElevatedButton(onPressed: _onSaveExpenseTap, child: const Text('Save Expense'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
