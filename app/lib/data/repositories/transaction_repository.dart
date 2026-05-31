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
      _syncSaveTransaction(uid, savedTransaction);
    }

    return localId;
  }

  Future<List<TransactionModel>> getTransactions() async {
    final localTransactions = await _transactionDao.getTransactions();

    final uid = _firebaseAuthService.currentFirebaseUser?.uid;

    if (uid != null) {
      _syncRemoteTransactions(uid);
    }

    return localTransactions;
  }

  Future<int> updateTransaction(TransactionModel transaction) async {
    final result = await _transactionDao.updateTransaction(transaction);

    final uid = _firebaseAuthService.currentFirebaseUser?.uid;

    if (uid != null && transaction.id != null) {
      _syncSaveTransaction(uid, transaction);
    }

    return result;
  }

  Future<int> deleteTransaction(int id) async {
    final result = await _transactionDao.deleteTransaction(id);

    final uid = _firebaseAuthService.currentFirebaseUser?.uid;

    if (uid != null) {
      _syncDeleteTransaction(uid, id);
    }

    return result;
  }

  Future<void> _syncSaveTransaction(
    String uid,
    TransactionModel transaction,
  ) async {
    try {
      await _firestoreService.saveTransaction(
        uid: uid,
        transaction: transaction,
      );
    } catch (_) {
      // Offline: mantém salvo no SQLite.
      // A sincronização remota pode ser feita quando voltar online.
    }
  }

  Future<void> _syncDeleteTransaction(
    String uid,
    int transactionId,
  ) async {
    try {
      await _firestoreService.deleteTransaction(
        uid: uid,
        transactionId: transactionId,
      );
    } catch (_) {
      // Offline: remove localmente e ignora falha remota temporária.
    }
  }

  Future<void> _syncRemoteTransactions(String uid) async {
    try {
      final remoteTransactions =
          await _firestoreService.getTransactions(uid: uid);

      for (final transaction in remoteTransactions) {
        if (transaction.id != null) {
          await _transactionDao.upsertTransaction(transaction);
        }
      }
    } catch (_) {
      // Offline: usa apenas SQLite.
    }
  }
}