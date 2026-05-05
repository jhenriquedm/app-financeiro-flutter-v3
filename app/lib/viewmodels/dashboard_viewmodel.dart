import '../models/transaction_model.dart';

class DashboardViewModel {
  final List<TransactionModel> transactions = [
    TransactionModel(
      title: 'Salário',
      amount: 3000,
      type: TransactionType.income,
      category: 'Salário',
    ),
    TransactionModel(
      title: 'Mercado',
      amount: 200,
      type: TransactionType.expense,
      category: 'Alimentação',
    ),
    TransactionModel(
      title: 'Netflix',
      amount: 50,
      type: TransactionType.expense,
      category: 'Lazer',
    ),
  ];

  double get totalIncome => transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalExpense => transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  Map<String, double> get expensesByCategory {
    final Map<String, double> data = {};

    for (var t in transactions) {
      if (t.type == TransactionType.expense) {
        data[t.category] = (data[t.category] ?? 0) + t.amount;
      }
    }

    return data;
  }
}