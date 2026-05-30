import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthViewModel({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

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

    try {
      final user = await _authRepository.login(
        email: email,
        password: password,
      );

      if (user == null) {
        _errorMessage =
            'Login realizado no Firebase, mas usuário local não encontrado.';
        _setLoading(false);
        return false;
      }

      _currentUser = user;
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (error) {
      _errorMessage = _getFirebaseErrorMessage(error);
      _setLoading(false);
      return false;
    } catch (_) {
      _errorMessage = 'Erro inesperado ao fazer login.';
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final existingUser = await _authRepository.findByEmail(email);

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

      await _authRepository.register(user);

      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (error) {
      _errorMessage = _getFirebaseErrorMessage(error);
      _setLoading(false);
      return false;
    } catch (_) {
      _errorMessage = 'Erro inesperado ao cadastrar usuário.';
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();

    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _getFirebaseErrorMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'user-disabled':
        return 'Este usuário foi desativado.';
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'invalid-credential':
        return 'E-mail ou senha inválidos.';
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado no Firebase.';
      case 'weak-password':
        return 'A senha é muito fraca. Use pelo menos 6 caracteres.';
      case 'operation-not-allowed':
        return 'Login por e-mail e senha não está habilitado no Firebase.';
      case 'network-request-failed':
        return 'Erro de conexão. Verifique sua internet.';
      default:
        return 'Erro de autenticação: ${error.message ?? error.code}';
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}