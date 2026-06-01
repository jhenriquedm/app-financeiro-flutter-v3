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
    await _firebaseAuthService.login(
      email: email,
      password: password,
    );

    final firebaseUser =
        _firebaseAuthService.currentFirebaseUser;

    UserModel? localUser = await _userDao.findByEmail(
      email.trim(),
    );

    if (localUser == null) {
      UserModel? firestoreUser;

      if (firebaseUser != null) {
        try {
          firestoreUser = await _firestoreService.getUser(
            uid: firebaseUser.uid,
          );
        } catch (_) {
          firestoreUser = null;
        }
      }

      localUser = UserModel(
        name: firestoreUser?.name.isNotEmpty == true
            ? firestoreUser!.name
            : email.split('@').first,
        email: firestoreUser?.email.isNotEmpty == true
            ? firestoreUser!.email
            : email.trim(),
        password: password.trim(),
      );

      await _userDao.insertUser(localUser);

      localUser = await _userDao.findByEmail(
        localUser.email,
      );
    }

    return localUser;
  }

  Future<UserModel?> restoreSession() async {
    final firebaseUser =
        _firebaseAuthService.currentFirebaseUser;

    if (firebaseUser == null || firebaseUser.email == null) {
      return null;
    }

    UserModel? localUser = await _userDao.findByEmail(
      firebaseUser.email!,
    );

    if (localUser == null) {
      UserModel? firestoreUser;

      try {
        firestoreUser = await _firestoreService.getUser(
          uid: firebaseUser.uid,
        );
      } catch (_) {
        firestoreUser = null;
      }

      localUser = UserModel(
        name: firestoreUser?.name.isNotEmpty == true
            ? firestoreUser!.name
            : firebaseUser.email!.split('@').first,
        email: firestoreUser?.email.isNotEmpty == true
            ? firestoreUser!.email
            : firebaseUser.email!,
        password: '',
      );

      await _userDao.insertUser(localUser);

      localUser = await _userDao.findByEmail(
        localUser.email,
      );
    }

    return localUser;
  }

  Future<UserModel?> findByEmail(String email) {
    return _userDao.findByEmail(
      email.trim(),
    );
  }

  Future<int> register(UserModel user) async {
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

    return _userDao.insertUser(user);
  }

  Future<void> logout() {
    return _firebaseAuthService.logout();
  }
}