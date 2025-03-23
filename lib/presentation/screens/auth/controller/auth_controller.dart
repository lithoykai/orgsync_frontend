import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:orgsync/domain/entities/user_entity.dart';
import 'package:orgsync/domain/services/token_provider.dart';
import 'package:orgsync/domain/usecase/user/authenticate_use_case.dart';
import 'package:orgsync/domain/usecase/user/get_current_user_usecase.dart';
import 'package:orgsync/infra/failure/failure.dart';

@singleton
class AuthController extends ChangeNotifier {
  final TokenProvider _tokenProvider;
  final AuthenticateUseCase _authenticateUseCase;
  final GetCurrentUserUsecase _getCurrentUserUsecase;

  AuthController({
    required TokenProvider tokenProvider,
    required AuthenticateUseCase authenticateUseCase,
    required GetCurrentUserUsecase getCurrentUserUsecase,
  }) : _tokenProvider = tokenProvider,
       _authenticateUseCase = authenticateUseCase,
       _getCurrentUserUsecase = getCurrentUserUsecase;

  bool isAuth = false;
  AuthState state = AuthIdle();
  UserEntity? currentUser;

  bool get isAdmin => currentUser?.roleId == 1;

  Future<void> authenticate({
    String? name,
    required String email,
    required String password,
  }) async {
    state = AuthLoading();
    notifyListeners();

    final response = await _authenticateUseCase.call(name, email, password);
    response.fold(
      (failure) {
        state = AuthError(failure.message);
        notifyListeners();
        throw failure;
      },
      (user) {
        currentUser = user;
        _setAuth(true);
        state = AuthIdle();
        notifyListeners();
      },
    );
  }

  Future<void> tryAutoLogin() async {
    if (isAuth && currentUser != null) return;

    final rawToken = await _tokenProvider.getToken();
    if (rawToken == null) {
      _logoutInternal();
      return;
    }

    final parsedToken = jsonDecode(rawToken);
    final expiryStr = parsedToken['expiresIn'];
    final expiryDate = DateTime.tryParse(expiryStr ?? '');

    if (expiryDate == null || expiryDate.isBefore(DateTime.now())) {
      _logoutInternal();
      return;
    }

    await _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    final result = await _getCurrentUserUsecase.call();
    result.fold((_) => _logoutInternal(), (user) {
      currentUser = user;
      _setAuth(true);
    });
  }

  void _setAuth(bool value) {
    isAuth = value;
    notifyListeners();
  }

  void _logoutInternal() {
    isAuth = false;
    currentUser = null;
    notifyListeners();
  }

  Future<void> logout() async {
    await _tokenProvider.clearToken();
    _logoutInternal();
  }
}

abstract class AuthState {}

class AuthIdle extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String? message;
  AuthError(this.message);
  @override
  String toString() => message ?? 'Erro de autenticação';
}
