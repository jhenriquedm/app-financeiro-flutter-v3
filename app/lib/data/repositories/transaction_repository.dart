import '../../models/transaction_model.dart';
import '../../services/firebase_auth_service.dart';
import '../../services/firestore_service.dart';
import '../transaction_dao.dart';

class TransactionRepository {
  final TransactionDao _transactionDao;
  final FirebaseAuthService _firebaseAuthService;
  final FirestoreService _firestoreService;

  TransactionRepository({
    required TransactionDao transactionDao,
    required FirebaseAuthService firebaseAuthService,
    required FirestoreService firestoreService,
  })  : _transactionDao = transactionDao,
        _firebaseAuthService = firebaseAuthService,
        _firestoreService = firestoreService;

  Future<int> addTransaction(TransactionModel transaction) async {
    final localId = await _transactionDao.insertTransaction(transaction);

    final savedTransaction = transaction.copyWith(id: localId);

    final uid = _firebaseAuthService.currentFirebaseUser?.uid;

    if (uid != null) {
      await _firestoreService.saveTransaction(
        uid: uid,
        transaction: savedTransaction,
      );
    }

    return localId;
  }

  Future<List<TransactionModel>> getTransactions() async {
    final uid = _firebaseAuthService.currentFirebaseUser?.uid;

    if (uid != null) {
      try {
        final remoteTransactions =
            await _firestoreService.getTransactions(uid: uid);

        for (final transaction in remoteTransactions) {
          if (transaction.id != null) {
            await _transactionDao.upsertTransaction(transaction);
          }
        }
      } catch (_) {
        // Se estiver sem internet ou Firebase falhar,
        // mantém funcionamento offline com SQLite.
      }
    }

    return _transactionDao.getTransactions();
  }

  Future<int> updateTransaction(TransactionModel transaction) async {
    final result = await _transactionDao.updateTransaction(transaction);

    final uid = _firebaseAuthService.currentFirebaseUser?.uid;

    if (uid != null && transaction.id != null) {
      await _firestoreService.saveTransaction(
        uid: uid,
        transaction: transaction,
      );
    }

    return result;
  }

  Future<int> deleteTransaction(int id) async {
    final result = await _transactionDao.deleteTransaction(id);

    final uid = _firebaseAuthService.currentFirebaseUser?.uid;

    if (uid != null) {
      await _firestoreService.deleteTransaction(
        uid: uid,
        transactionId: id,
      );
    }

    return result;
  }
}