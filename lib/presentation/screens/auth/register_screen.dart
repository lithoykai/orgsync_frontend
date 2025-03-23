import 'package:flutter/material.dart';
import 'package:orgsync/di/injectable.dart';
import 'package:orgsync/infra/constants/app_router.dart';
import 'package:orgsync/presentation/screens/auth/controller/auth_controller.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final controller = getIt<AuthController>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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

  onSubmitted() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();

    controller.authenticate(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Criar Conta',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  CustomTextField(
                    label: 'Nome',
                    controller: nameController,
                    focusNode: nameFocus,
                    validator: (name) {
                      String _name = name ?? '';
                      if (_name.isEmpty) {
                        return 'Nome inválido';
                      } else if (_name.length < 3) {
                        return 'Nome muito curto';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'E-mail',
                    controller: emailController,
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
                    label: 'Senha',
                    isPassword: true,
                    controller: passwordController,
                    focusNode: passwordFocus,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(text: 'Cadastrar', onPressed: onSubmitted),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed:
                        () => Navigator.of(
                          context,
                        ).pushReplacementNamed(AppRouter.loginPage),
                    child: const Text('Já tem uma conta? Entre aqui'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
