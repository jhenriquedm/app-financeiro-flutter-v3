import '../../models/user_model.dart';
import '../../services/firebase_auth_service.dart';
import '../../services/firestore_service.dart';
import '../user_dao.dart';

class AuthRepository {
  final UserDao _userDao;
  final FirebaseAuthService _firebaseAuthService;
  final FirestoreService _firestoreService;

  AuthRepository({
    required UserDao userDao,
    required FirebaseAuthService firebaseAuthService,
    required FirestoreService firestoreService,
  })  : _userDao = userDao,
        _firebaseAuthService =
            firebaseAuthService,
        _firestoreService =
            firestoreService;

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    await _firebaseAuthService.login(
      email: email,
      password: password,
    );

    return _userDao.findByEmail(
      email.trim(),
    );
  }

  Future<UserModel?> findByEmail(
    String email,
  ) {
    return _userDao.findByEmail(
      email.trim(),
    );
  }

  Future<int> register(
    UserModel user,
  ) async {
    /// 1. Cria usuário no Firebase Auth
    final credential =
        await _firebaseAuthService.register(
      email: user.email,
      password: user.password,
    );

    final uid = credential.user?.uid;

    if (uid == null) {
      throw Exception(
        'Erro ao obter UID do Firebase.',
      );
    }

    /// 2. Salva usuário no SQLite
    final localId =
        await _userDao.insertUser(user);

    /// 3. Salva usuário no Firestore
    await _firestoreService.saveUser(
      uid: uid,
      user: user,
    );

    return localId;
  }

  Future<void> logout() {
    return _firebaseAuthService.logout();
  }
}