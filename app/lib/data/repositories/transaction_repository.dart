import '../../models/transaction_model.dart';
import '../transaction_dao.dart';

class TransactionRepository {
  final TransactionDao _transactionDao;

  TransactionRepository({
    required TransactionDao transactionDao,
  }) : _transactionDao = transactionDao;

  Future<int> addTransaction(TransactionModel transaction) {
    return _transactionDao.insertTransaction(transaction);
  }

  Future<List<TransactionModel>> getTransactions() {
    return _transactionDao.getTransactions();
  }

  Future<int> updateTransaction(TransactionModel transaction) {
    return _transactionDao.updateTransaction(transaction);
  }

  Future<int> deleteTransaction(int id) {
    return _transactionDao.deleteTransaction(id);
  }
}