import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/dashboard_viewmodel.dart';

final authProvider = Provider<AuthViewModel>((ref) {
  final authViewModel = AuthViewModel();

  ref.onDispose(() {
    authViewModel.dispose();
  });

  return authViewModel;
});

final dashboardProvider = Provider<DashboardViewModel>((ref) {
  final dashboardViewModel = DashboardViewModel();

  ref.onDispose(() {
    dashboardViewModel.dispose();
  });

  return dashboardViewModel;
});