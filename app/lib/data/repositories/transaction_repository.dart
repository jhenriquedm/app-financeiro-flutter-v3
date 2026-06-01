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

  String? get _uid =>
      _firebaseAuthService.currentFirebaseUser?.uid;

  Future<int> addTransaction(
    TransactionModel transaction,
  ) async {
    final uid = _uid;

    if (uid == null) {
      throw Exception('Usuário não autenticado.');
    }

    final transactionWithUser = transaction.copyWith(
      userId: uid,
    );

    final localId = await _transactionDao.insertTransaction(
      transactionWithUser,
    );

    final savedTransaction = transactionWithUser.copyWith(
      id: localId,
    );

    _syncSaveTransaction(uid, savedTransaction);

    return localId;
  }

  Future<List<TransactionModel>> getTransactions() async {
    final uid = _uid;

    if (uid == null) {
      return [];
    }

    try {
      final remoteTransactions =
          await _firestoreService.getTransactions(uid: uid);

      for (final transaction in remoteTransactions) {
        if (transaction.id != null) {
          final transactionWithUser =
              transaction.copyWith(userId: uid);

          await _transactionDao.upsertTransaction(
            transactionWithUser,
          );
        }
      }
    } catch (_) {
      // Se estiver offline ou o Firestore falhar,
      // usa os dados locais do SQLite.
    }

    return _transactionDao.getTransactionsByUser(uid);
  }

  Future<int> updateTransaction(
    TransactionModel transaction,
  ) async {
    final uid = _uid;

    if (uid == null || transaction.id == null) {
      throw Exception('Usuário não autenticado.');
    }

    final transactionWithUser = transaction.copyWith(
      userId: uid,
    );

    final result = await _transactionDao.updateTransaction(
      transactionWithUser,
    );

    _syncSaveTransaction(uid, transactionWithUser);

    return result;
  }

  Future<int> deleteTransaction(int id) async {
    final uid = _uid;

    if (uid == null) {
      throw Exception('Usuário não autenticado.');
    }

    final result = await _transactionDao.deleteTransaction(
      id: id,
      userId: uid,
    );

    _syncDeleteTransaction(uid, id);

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
}