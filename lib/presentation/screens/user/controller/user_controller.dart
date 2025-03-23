import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:orgsync/domain/entities/user_entity.dart';
import 'package:orgsync/domain/usecase/user/delete_user_usecase.dart';
import 'package:orgsync/domain/usecase/user/get_all_users_use_case.dart';
import 'package:orgsync/domain/usecase/user/update_user_usecase.dart';

@lazySingleton
class UserController extends ChangeNotifier {
  GetAllUsersUseCase _getAllUseCase;
  UpdateUserUsecase _updateUser;
  DeleteUserUsecase _deleteUserUsecase;

  UserController({
    required GetAllUsersUseCase getAllUseCase,
    required UpdateUserUsecase updateUser,
    required DeleteUserUsecase deleteUseCase,
  }) : _getAllUseCase = getAllUseCase,
       _updateUser = updateUser,
       _deleteUserUsecase = deleteUseCase;

  List<UserEntity> users = [];
  UserState state = UserIdle();

  setUsers(List<UserEntity> users) {
    this.users = users;
    notifyListeners();
  }

  Future<void> getAllUsers() async {
    state = UserLoading();
    notifyListeners();

    final response = await _getAllUseCase.call();
    response.fold(
      (failure) {
        state = UserError(failure.message);
        notifyListeners();
        throw failure;
      },
      (users) {
        setUsers(users);
        state = UserIdle();
        notifyListeners();
      },
    );
  }

  Future<void> updateUser(
    String id,
    String name,
    String email,
    String? password,
    int? departmentid,
  ) async {
    state = UserLoading();
    notifyListeners();

    final response = await _updateUser.call(
      id,
      name,
      email,
      password,
      departmentid,
    );
    response.fold(
      (failure) {
        state = UserError(failure.message);
        notifyListeners();
        throw failure;
      },
      (_) {
        state = UserIdle();
        notifyListeners();
      },
    );
  }

  Future<void> deleteUser(String id) async {
    state = UserLoading();
    notifyListeners();

    final response = await _deleteUserUsecase.call(id);
    response.fold(
      (failure) {
        state = UserError(failure.message);
        notifyListeners();
        throw failure;
      },
      (_) {
        getAllUsers();
        state = UserIdle();
        notifyListeners();
      },
    );
  }
}

abstract class UserState {}

class UserLoading extends UserState {}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}

class UserIdle extends UserState {}
