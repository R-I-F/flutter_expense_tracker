import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:ex2_expense_tracker/providers/expense_provider.dart';


class ExpensesList extends ConsumerStatefulWidget {
  const ExpensesList({super.key});

  @override
  ConsumerState<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends ConsumerState<ExpensesList> {
  final formatter = DateFormat.yMd();
  @override
  Widget build(BuildContext context) {
  final expenseData = ref.watch(expenseProvider);
  print(expenseData);
    return Expanded(
      child: ListView.builder(
        itemCount: expenseData.length,
        itemBuilder: (ctx, index) {
          final dateString = formatter.format(expenseData[index].date);
          return Card(
            margin: const EdgeInsets.all(8),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(expenseData[index].title, style: Theme.of(context).textTheme.titleMedium,),
                    Text('\$${expenseData[index].cost.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyMedium)
                  ]),
                  const Spacer(),
                  Text(dateString, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(width: 10,),
                  Icon(expenseData[index].categoryIcon),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
