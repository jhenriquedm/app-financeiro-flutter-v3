import 'package:flutter/material.dart';

import '../data/user_dao.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final UserDao _userDao = UserDao();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    final user = await _userDao.login(
      email: email.trim(),
      password: password.trim(),
    );

    if (user == null) {
      _errorMessage = 'E-mail ou senha inválidos';
      _setLoading(false);
      return false;
    }

    _currentUser = user;
    _setLoading(false);
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    final existingUser = await _userDao.findByEmail(email.trim());

    if (existingUser != null) {
      _errorMessage = 'Este e-mail já está cadastrado';
      _setLoading(false);
      return false;
    }

    final user = UserModel(
      name: name.trim(),
      email: email.trim(),
      password: password.trim(),
    );

    await _userDao.insertUser(user);

    _setLoading(false);
    return true;
  }

  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}