import 'package:flutter/material.dart';

import '../data/transaction_dao.dart';
import '../models/transaction_model.dart';

class DashboardViewModel extends ChangeNotifier {
  final TransactionDao _transactionDao = TransactionDao();

  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get totalIncome => _transactions
      .where((transaction) => transaction.type == TransactionType.income)
      .fold(0, (sum, transaction) => sum + transaction.amount);

  double get totalExpense => _transactions
      .where((transaction) => transaction.type == TransactionType.expense)
      .fold(0, (sum, transaction) => sum + transaction.amount);

  double get balance => totalIncome - totalExpense;

  Map<String, double> get expensesByCategory {
    final Map<String, double> data = {};

    for (final transaction in _transactions) {
      if (transaction.type == TransactionType.expense) {
        data[transaction.category] =
            (data[transaction.category] ?? 0) + transaction.amount;
      }
    }

    return data;
  }

  Future<void> loadTransactions() async {
    _setLoading(true);

    try {
      _transactions = await _transactionDao.getTransactions();
      _errorMessage = null;
    } catch (error) {
      _errorMessage = 'Erro ao carregar transações';
    }

    _setLoading(false);
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _transactionDao.insertTransaction(transaction);
    await loadTransactions();
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    if (transaction.id == null) {
      return;
    }

    await _transactionDao.updateTransaction(transaction);
    await loadTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await _transactionDao.deleteTransaction(id);
    await loadTransactions();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}