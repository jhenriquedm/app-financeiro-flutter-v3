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
        _firebaseAuthService = firebaseAuthService,
        _firestoreService = firestoreService;

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    // Login Firebase
    await _firebaseAuthService.login(
      email: email,
      password: password,
    );

    // Busca no SQLite
    UserModel? localUser =
        await _userDao.findByEmail(
      email.trim(),
    );

    // Se não existir localmente,
    // cria automaticamente
    if (localUser == null) {
      localUser = UserModel(
        name: email.split('@').first,
        email: email.trim(),
        password: password.trim(),
      );

      await _userDao.insertUser(
        localUser,
      );

      localUser =
          await _userDao.findByEmail(
        email.trim(),
      );
    }

    return localUser;
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
    final credential =
        await _firebaseAuthService.register(
      email: user.email,
      password: user.password,
    );

    final uid = credential.user?.uid;

    if (uid != null) {
      await _firestoreService.saveUser(
        uid: uid,
        user: user,
      );
    }

    return _userDao.insertUser(
      user,
    );
  }

  Future<void> logout() {
    return _firebaseAuthService.logout();
  }
}