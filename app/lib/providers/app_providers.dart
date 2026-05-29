import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../data/repositories/auth_repository.dart';
import '../data/repositories/transaction_repository.dart';
import '../data/transaction_dao.dart';
import '../data/user_dao.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/dashboard_viewmodel.dart';

final userDaoProvider = Provider<UserDao>((ref) {
  return UserDao();
});

final transactionDaoProvider = Provider<TransactionDao>((ref) {
  return TransactionDao();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    userDao: ref.read(userDaoProvider),
  );
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository(
    transactionDao: ref.read(transactionDaoProvider),
  );
});

final authProvider = ChangeNotifierProvider<AuthViewModel>((ref) {
  return AuthViewModel(
    authRepository: ref.read(authRepositoryProvider),
  );
});

final dashboardProvider = ChangeNotifierProvider<DashboardViewModel>((ref) {
  return DashboardViewModel(
    transactionRepository: ref.read(transactionRepositoryProvider),
  );
});