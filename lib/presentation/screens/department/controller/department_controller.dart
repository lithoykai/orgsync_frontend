import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:orgsync/domain/entities/department_entity.dart';
import 'package:orgsync/domain/usecase/departments/create_department_usecase.dart';
import 'package:orgsync/domain/usecase/departments/delete_department_usecase.dart';
import 'package:orgsync/domain/usecase/departments/get_all_department_use_case.dart';
import 'package:orgsync/domain/usecase/departments/remove_user_department_usecase.dart';

@LazySingleton()
class DepartmentController extends ChangeNotifier {
  final GetAllDepartmentUseCase _getAllUseCase;
  final CreateDepartmentUsecase _createDepartmentUsecase;
  final RemoveUserDepartmentUsecase _removeUserDepartmentUsecase;
  final DeleteDepartmentUsecase _deleteDepartmentUsecase;

  DepartmentController({
    required GetAllDepartmentUseCase getAllUseCase,
    required CreateDepartmentUsecase createDepartmentUsecase,
    required RemoveUserDepartmentUsecase removeUserDepartmentUsecase,
    required DeleteDepartmentUsecase deleteDepartmentUsecase,
  }) : _getAllUseCase = getAllUseCase,
       _createDepartmentUsecase = createDepartmentUsecase,
       _removeUserDepartmentUsecase = removeUserDepartmentUsecase,
       _deleteDepartmentUsecase = deleteDepartmentUsecase;

  bool isDepartment = false;
  DepartmentState state = DepartmentIdle();
  List<DepartmentEntity> departments = List<DepartmentEntity>.of([]);

  void setList(List<DepartmentEntity> list) {
    departments = List<DepartmentEntity>.of(list);
    notifyListeners();
  }

  void updateList(DepartmentEntity entity) {
    final index = departments.indexWhere((d) => d.id == entity.id);
    if (index != -1) {
      departments[index] = entity;
      notifyListeners();
    }
  }

  void deleteFromList(DepartmentEntity entity) {
    departments.remove(entity);
    notifyListeners();
  }

  Future<void> getAllDepartment() async {
    final result = await _getAllUseCase.call();
    result.fold(
      (failure) {
        state = DepartmentError(failure.message);
        notifyListeners();
        throw failure;
      },
      (list) {
        setList(list);
        state = DepartmentIdle();
        notifyListeners();
      },
    );
  }

  Future<void> deleteDepartment(DepartmentEntity entity) async {
    final result = await _deleteDepartmentUsecase.call(entity.id);
    result.fold(
      (failure) {
        state = DepartmentError(failure.message);
        notifyListeners();
        throw failure;
      },
      (_) {
        deleteFromList(entity);
        state = DepartmentIdle();
        notifyListeners();
      },
    );
  }

  Future<void> removeUserInDepartment(int id, String userID) async {
    List<String> usersId = [userID];
    final result = await _removeUserDepartmentUsecase.call(id, usersId);
    result.fold(
      (failure) {
        state = DepartmentError(failure.message);
        notifyListeners();
        throw failure;
      },
      (item) {
        updateList(item);
        state = DepartmentIdle();
        notifyListeners();
      },
    );
  }

  Future<void> createDepartment(
    DepartmentEntity entity,
    List<String> users,
  ) async {
    final result = await _createDepartmentUsecase.call(entity, users);
    result.fold(
      (failure) {
        state = DepartmentError(failure.message);
        notifyListeners();
        throw failure;
      },
      (_) {
        getAllDepartment();
        state = DepartmentIdle();
        notifyListeners();
      },
    );
  }
}

abstract class DepartmentState {}

class DepartmentIdle extends DepartmentState {}

class DepartmentLoading extends DepartmentState {}

class DepartmentError extends DepartmentState {
  final String? message;

  DepartmentError(this.message);
}
