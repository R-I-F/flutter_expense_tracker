import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum Category { food, work, leisure, travel }

const uuid = Uuid();

class ExpenseModel {
  ExpenseModel(
      {required this.title,
      required this.cost,
      required this.category,
      required this.date,
      String? insertedId
      }) : id = insertedId?? uuid.v4();

  IconData? get categoryIcon{
    if (category == Category.food) {
      return Icons.lunch_dining;
    }
    if (category == Category.work) {
      return Icons.work;
    }
    if (category == Category.leisure) {
      return Icons.movie;
    }
    if (category == Category.travel) {
      return Icons.flight;
    }
  }



  final String title;
  final double cost;
  final Category category;
  final DateTime date;
  final String id;
}

class ExpenseBucket {
  const ExpenseBucket({required this.expenses , required this.expenseCategory});
  ExpenseBucket.forCategory({required List<ExpenseModel> allExpenses ,required this.expenseCategory}) : 
  expenses = allExpenses.where((expense)=>expense.category == expenseCategory).toList();

  double get totalExpense {
    double sum = 0.0;
    for(var exp in expenses){
      sum += exp.cost;
    }
    return sum;
  } 

  final List<ExpenseModel> expenses; 
  final Category expenseCategory;
}
