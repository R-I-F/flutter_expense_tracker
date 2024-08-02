import 'package:ex2_expense_tracker/models/expenseModel.dart';
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
    print(data);

    print('populating');
    state = data.map((row) {

      String categoryName = row['category'] as String;
      String dateHolder = row['date'] as String;


      final id = row['id'] as String;
      print(id);
      final name = row['name'] as String;
      print(name);
      final amount = (row['amount'] as num).toDouble();
      print(amount);
      final cat = Category.values.firstWhere((item)=>categoryName == item.name);
      print(cat);
      final date = formatter.parse(dateHolder);
      print(date);
      return ExpenseModel(
          insertedId: id,
          title: name,
          cost: amount,
          category: cat,
          date: date);
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
void deleteDatabase() async {
  final db = await _getDatabase();
  await db.delete('expenses_list');
}
}


final expenseProvider =
    StateNotifierProvider<ExpenseProviderNotifier, List<ExpenseModel>>(
        (ref) => ExpenseProviderNotifier());
