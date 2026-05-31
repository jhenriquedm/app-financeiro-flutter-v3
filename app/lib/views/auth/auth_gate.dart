import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';
import '../dashboard/dashboard_view.dart';
import 'login_view.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  bool _isCheckingSession = true;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final success =
          await ref.read(authProvider).restoreSession();

      if (!mounted) return;

      setState(() {
        _isCheckingSession = false;
      });

      if (success) {
        await ref
            .read(dashboardProvider)
            .loadTransactions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingSession) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final authVm = ref.watch(authProvider);

    if (authVm.isAuthenticated) {
      return const DashboardView();
    }

    return const LoginView();
  }
}