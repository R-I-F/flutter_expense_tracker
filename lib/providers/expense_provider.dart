import 'package:ex2_expense_tracker/models/expenseModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class ExpenseProviderNotifier extends StateNotifier<List<ExpenseModel>> {
  ExpenseProviderNotifier() : super([]);

  Future<Database> _getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final dbFilePath = path.join(dbPath, 'expenses.db');
    final db =
        await sql.openDatabase(dbFilePath, version: 1, onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE expenses_list(id TEXT PRIMARY KEY, name TEXT, amount REAL , date TEXT, category TEXT)');
    });
    return db;
  }

  Future<void> loadExpense() async {
    final db = await _getDatabase();
    final data = await db.query('expenses_list');
    if (data.isEmpty) {
      return;
    }

    state = data.map((row) {
      String categoryName = row['category'] as String;
      String dateHolder = row['date'] as String;
      final id = row['id'] as String;
      final name = row['name'] as String;
      final amount = (row['amount'] as num).toDouble();
      final cat =
          Category.values.firstWhere((item) => categoryName == item.name);
      final date = formatter.parse(dateHolder);
      return ExpenseModel(
          insertedId: id, title: name, cost: amount, category: cat, date: date);
    }).toList();
  }

  void addExpense(String name, double amount, DateTime expenseDate,
      String expenseCategory) async {
    final Category category = Category.values.firstWhere((cat) {
      return cat.name == expenseCategory;
    });

    final db = await _getDatabase();
    ExpenseModel expense = ExpenseModel(
        title: name, cost: amount, category: category, date: expenseDate);
    db.insert('expenses_list', {
      'id': expense.id,
      'name': name,
      'amount': amount,
      'date': formatter.format(expenseDate),
      'category': expenseCategory
    });

    state = [
      ...state,
      ExpenseModel(
          title: name, cost: amount, category: category, date: expenseDate)
    ];
    return;
  }

  void deleteExpense(String id, BuildContext context) async {
    final expense = state.firstWhere((item) => item.id == id);
    final expenseIndex =
        state.indexOf(expense);

    state = state.where((item) => item.id != id).toList();
    ScaffoldMessenger.of(context).clearSnackBars();
    final isItemDeleted =  await ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
            'You just Deleted an expense, do you wish to restore it ?'),
        action: SnackBarAction(label: 'Restore', onPressed: (){
          List newList = [...state];
          newList.insert(expenseIndex, expense);
          state = [...newList];
        }),
        duration: const Duration(seconds: 1),
      ),
    ).closed.then((result)=>result != SnackBarClosedReason.action);
    
    if(!isItemDeleted){ return ; }
    try{
      final db = await _getDatabase();
      await db.delete('expenses_list', where: 'id = ?', whereArgs: [id]);
    } catch(err){
      print(err);
    }

  }

  void deleteDatabase() async {
    final db = await _getDatabase();
    await db.delete('expenses_list');
  }
}

final expenseProvider =
    StateNotifierProvider<ExpenseProviderNotifier, List<ExpenseModel>>(
        (ref) => ExpenseProviderNotifier());
