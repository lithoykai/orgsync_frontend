import 'package:flutter/material.dart';
import 'package:orgsync/di/injectable.dart';
import 'package:orgsync/presentation/screens/auth/controller/auth_controller.dart';
import 'package:orgsync/presentation/screens/dashboard_screen.dart';
import 'package:orgsync/presentation/screens/auth/login_screen.dart';

class AuthOrHomePage extends StatefulWidget {
  const AuthOrHomePage({super.key});

  @override
  State<AuthOrHomePage> createState() => _AuthOrHomePageState();
}

class _AuthOrHomePageState extends State<AuthOrHomePage> {
  final AuthController controller = getIt<AuthController>();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await controller.tryAutoLogin();
    if (mounted) setState(() => _initialized = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return controller.isAuth
            ? const DashboardScreen()
            : const LoginScreen();
      },
    );
  }
}
