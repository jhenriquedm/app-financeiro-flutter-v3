import '../models/transaction_model.dart';
import 'database_helper.dart';

class TransactionDao {
  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await DatabaseHelper.instance.database;

    return db.insert(
      'transactions',
      transaction.toMap(),
    );
  }

  Future<List<TransactionModel>> getTransactions() async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'transactions',
      orderBy: 'date DESC',
    );

    return result.map((map) => TransactionModel.fromMap(map)).toList();
  }

  Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await DatabaseHelper.instance.database;

    return db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final db = await DatabaseHelper.instance.database;

    return db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}