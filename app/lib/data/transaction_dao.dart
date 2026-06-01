import 'package:sqflite/sqflite.dart';

import '../models/transaction_model.dart';
import 'database_helper.dart';

class TransactionDao {
  Future<int> insertTransaction(
    TransactionModel transaction,
  ) async {
    final db = await DatabaseHelper.instance.database;

    return db.insert(
      'transactions',
      transaction.toMap(),
    );
  }

  Future<int> upsertTransaction(
    TransactionModel transaction,
  ) async {
    final db = await DatabaseHelper.instance.database;

    return db.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TransactionModel>> getTransactionsByUser(
    String userId,
  ) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'transactions',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );

    return result
        .map((map) => TransactionModel.fromMap(map))
        .toList();
  }

  Future<int> updateTransaction(
    TransactionModel transaction,
  ) async {
    final db = await DatabaseHelper.instance.database;

    return db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ? AND userId = ?',
      whereArgs: [
        transaction.id,
        transaction.userId,
      ],
    );
  }

  Future<int> deleteTransaction({
    required int id,
    required String userId,
  }) async {
    final db = await DatabaseHelper.instance.database;

    return db.delete(
      'transactions',
      where: 'id = ? AND userId = ?',
      whereArgs: [
        id,
        userId,
      ],
    );
  }
}