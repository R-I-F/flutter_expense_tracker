import 'package:ex2_expense_tracker/providers/expense_provider.dart';
import 'package:ex2_expense_tracker/widgets/chart_bars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ex2_expense_tracker/models/expenseModel.dart';

class Chart extends ConsumerStatefulWidget {
  const Chart({super.key});

  @override
  ConsumerState<Chart> createState() => _ChartState();
}

class _ChartState extends ConsumerState<Chart> {
  @override
  Widget build(BuildContext context) {
    List<ExpenseModel> expenseList = ref.watch(expenseProvider);

    List<ExpenseBucket> expenseBuckets = [];

    double? maxBucketCost;

    if (expenseList.isNotEmpty) {
      expenseBuckets = [
        ExpenseBucket.forCategory(
            allExpenses: expenseList, expenseCategory: Category.food),
        ExpenseBucket.forCategory(
            allExpenses: expenseList, expenseCategory: Category.work),
        ExpenseBucket.forCategory(
            allExpenses: expenseList, expenseCategory: Category.leisure),
        ExpenseBucket.forCategory(
            allExpenses: expenseList, expenseCategory: Category.travel),
      ];

      for (var bucket in expenseBuckets) {
        if (maxBucketCost == null || bucket.totalExpense > maxBucketCost) {
          maxBucketCost = bucket.totalExpense;
        }
      }
    }

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            height: 150,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: expenseBuckets.isNotEmpty
                    ? expenseBuckets.map((bucket) {
                      return ChartBars(ratio: bucket.totalExpense / maxBucketCost!);
                    }).toList()
                    : [const Text('No expenses added yet')]),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.lunch_dining),
              Icon(Icons.work),
              Icon(Icons.movie),
              Icon(Icons.flight),
            ],
          )
        ],
      ),
    );
  }
}
