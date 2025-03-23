import 'package:flutter/material.dart';
import 'package:orgsync/di/injectable.dart';
import 'package:orgsync/infra/constants/app_router.dart';
import 'package:orgsync/presentation/screens/auth/controller/auth_controller.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

enum AuthMode { login, register }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthMode _authMode = AuthMode.login;
  bool _isLogin() => _authMode == AuthMode.login;
  var formKey = GlobalKey<FormState>();

  //Controllers and Focus
  final AuthController controller = getIt<AuthController>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode nameFocus = FocusNode();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    nameFocus.dispose();
    super.dispose();
  }

  _submit() async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    formKey.currentState?.save();

    try {
      await controller.authenticate(
        name: _isLogin() ? null : nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder:
            (dialogContext) => AlertDialog(
              title: const Text('Erro'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Fechar'),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          if (controller.state is AuthLoading)
            return const Center(child: CircularProgressIndicator());
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'OrgSync',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        _isLogin() ? 'Entrar' : 'Criar Conta',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        crossFadeState:
                            _isLogin()
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                        firstChild: Column(
                          children: [
                            CustomTextField(
                              label: 'Nome',
                              controller: nameController,
                              focusNode: nameFocus,
                              validator: (name) {
                                final _name = name ?? '';
                                if (_name.isEmpty && !_isLogin()) {
                                  return 'Nome inválido';
                                } else if (_name.length < 3 && !_isLogin()) {
                                  return 'Nome muito curto';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                        secondChild: const SizedBox.shrink(),
                      ),
                      CustomTextField(
                        controller: emailController,
                        label: 'E-mail',
                        validator: (email) {
                          String _email = email ?? '';
                          if (_email.isEmpty || !_email.contains('@')) {
                            return 'E-mail inválido';
                          }
                          return null;
                        },
                        focusNode: emailFocus,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: passwordController,
                        label: 'Senha',
                        isPassword: true,
                        focusNode: passwordFocus,
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: _isLogin() ? 'Entrar' : 'Cadastrar',
                        onPressed: _submit,
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed:
                            () => {
                              setState(() {
                                _authMode =
                                    _isLogin()
                                        ? AuthMode.register
                                        : AuthMode.login;
                                _isLogin() ? nameController.clear() : null;
                              }),
                            },
                        child: Text(
                          _isLogin()
                              ? 'Não tem uma conta? Registre-se'
                              : 'Já tem uma conta? Entre aqui',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
