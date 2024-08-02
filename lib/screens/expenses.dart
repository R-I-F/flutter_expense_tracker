import 'package:ex2_expense_tracker/widgets/add_expense_form.dart';
import 'package:ex2_expense_tracker/widgets/chart.dart';
import 'package:ex2_expense_tracker/widgets/expenses_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ex2_expense_tracker/providers/expense_provider.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() {
    return _ExpensesScreenState();
  }
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {

  late Future<void> loadExpensesFromMem;

  void _onAdd() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // useSafeArea: true,
      builder: (context) {
        return const AddExpenseForm();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    loadExpensesFromMem = ref.read(expenseProvider.notifier).loadExpense();
    // ref.read(expenseProvider.notifier).deleteDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Expenses tracker'),
        actions: [
          IconButton(
            onPressed: _onAdd,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          const Chart(), 
          FutureBuilder(
            future: loadExpensesFromMem,
            builder: (ctx, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return const CircularProgressIndicator();
              }
              return const ExpensesList();
            }
          )],
      ),
    );
  }
}
