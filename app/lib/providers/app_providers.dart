import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../data/repositories/auth_repository.dart';
import '../data/repositories/transaction_repository.dart';
import '../data/transaction_dao.dart';
import '../data/user_dao.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_service.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/dashboard_viewmodel.dart';

/// ===============================
/// DAO Providers
/// ===============================

final userDaoProvider = Provider<UserDao>((ref) {
  return UserDao();
});

final transactionDaoProvider = Provider<TransactionDao>((ref) {
  return TransactionDao();
});

/// ===============================
/// Services Providers
/// ===============================

final firebaseAuthServiceProvider =
    Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

final firestoreServiceProvider =
    Provider<FirestoreService>((ref) {
  return FirestoreService();
});

/// ===============================
/// Repository Providers
/// ===============================

final authRepositoryProvider =
    Provider<AuthRepository>((ref) {
  return AuthRepository(
    userDao: ref.read(userDaoProvider),
    firebaseAuthService:
        ref.read(firebaseAuthServiceProvider),
    firestoreService:
        ref.read(firestoreServiceProvider),
  );
});

final transactionRepositoryProvider =
    Provider<TransactionRepository>((ref) {
  return TransactionRepository(
    transactionDao:
        ref.read(transactionDaoProvider),
  );
});

/// ===============================
/// ViewModel Providers
/// ===============================

final authProvider =
    ChangeNotifierProvider<AuthViewModel>(
  (ref) {
    return AuthViewModel(
      authRepository:
          ref.read(authRepositoryProvider),
    );
  },
);

final dashboardProvider =
    ChangeNotifierProvider<
        DashboardViewModel>(
  (ref) {
    return DashboardViewModel(
      transactionRepository: ref.read(
        transactionRepositoryProvider,
      ),
    );
  },
);