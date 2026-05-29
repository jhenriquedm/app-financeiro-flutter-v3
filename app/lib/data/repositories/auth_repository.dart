import '../../models/user_model.dart';
import '../user_dao.dart';

class AuthRepository {
  final UserDao _userDao;

  AuthRepository({
    required UserDao userDao,
  }) : _userDao = userDao;

  Future<UserModel?> login({
    required String email,
    required String password,
  }) {
    return _userDao.login(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<UserModel?> findByEmail(String email) {
    return _userDao.findByEmail(email.trim());
  }

  Future<int> register(UserModel user) {
    return _userDao.insertUser(user);
  }
}