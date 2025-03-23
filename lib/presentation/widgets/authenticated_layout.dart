import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:orgsync/di/injectable.dart';
import 'package:orgsync/infra/constants/app_router.dart';
import 'package:orgsync/presentation/screens/auth/controller/auth_controller.dart';
import 'package:orgsync/presentation/widgets/web_side_menu.dart';

class AuthenticatedLayout extends StatefulWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;

  const AuthenticatedLayout({
    super.key,
    required this.child,
    required this.title,
    this.actions,
  });

  @override
  State<AuthenticatedLayout> createState() => _AuthenticatedLayoutState();
}

class _AuthenticatedLayoutState extends State<AuthenticatedLayout> {
  final AuthController authController = getIt<AuthController>();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await authController.tryAutoLogin();

    if (!authController.isAuth && mounted) {
      Navigator.of(context).pushReplacementNamed(AppRouter.authOrHome);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = kIsWeb && MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Row(
        children: [
          if (isWeb) WebSideMenu(),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: !isWeb ? true : false,

                title: Text(widget.title),
                centerTitle: !isWeb,
                actions: [
                  if (!isWeb)
                    IconButton(
                      icon: const Icon(Icons.person_outline),
                      onPressed: () {},
                    ),
                  if (widget.actions != null) ...widget.actions!,
                ],
              ),
              body: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
