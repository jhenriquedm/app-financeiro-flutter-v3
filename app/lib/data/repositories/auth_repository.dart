import '../../models/user_model.dart';
import '../../services/firebase_auth_service.dart';
import '../user_dao.dart';

class AuthRepository {
  final UserDao _userDao;
  final FirebaseAuthService _firebaseAuthService;

  AuthRepository({
    required UserDao userDao,
    required FirebaseAuthService firebaseAuthService,
  })  : _userDao = userDao,
        _firebaseAuthService =
            firebaseAuthService;

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
    await _firebaseAuthService.register(
      email: user.email,
      password: user.password,
    );

    return _userDao.insertUser(user);
  }

  Future<void> logout() {
    return _firebaseAuthService.logout();
  }
}