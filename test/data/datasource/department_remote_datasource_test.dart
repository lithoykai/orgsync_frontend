// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:orgsync/data/datasource/client/http_service.dart';
// import 'package:orgsync/data/datasource/department_remote_datasource.dart';
// import 'package:orgsync/data/datasource/department_remote_datasource_impl.dart';
// import 'package:orgsync/data/models/department_model.dart';

// import 'package:dio/dio.dart';

// import 'department_remote_datasource_test.mocks.dart';

// @GenerateMocks([HttpService])
// void main() {
//   late DepartmentRemoteDatasource datasource;
//    late MockHttpService mockHttp;

//   setUp(() {
//     mockHttp = MockHttpService();
//     datasource = DepartmentRemoteDatasourceImpl(httpService: mockHttp);
//   });

//   group('DepartmentRemoteDatasourceImpl', () {
//     test('getDepartments returns list of DepartmentModel', () async {
//       when(mockHttp.get(any)).thenAnswer(
//         (_) async => Response(
//           requestOptions: RequestOptions(path: ''),
//           data: [
//             {"id": 1, "name": "Test", "description": "Desc", "enabled": true}
//           ],
//         ),
//       );

//       final result = await datasource.getDepartments();
//       expect(result, isA<List<DepartmentModel>>());
//       expect(result.first.name, 'Test');
//     });

//     test('getDepartment returns single DepartmentModel', () async {
//       when(mockHttp.get(any)).thenAnswer(
//         (_) async => Response(
//           requestOptions: RequestOptions(path: ''),
//           data: {"id": 1, "name": "Test", "description": "Desc", "enabled": true},
//         ),
//       );

//       final result = await datasource.getDepartment(1);
//       expect(result, isA<DepartmentModel>());
//       expect(result.name, 'Test');
//     });

//     test('createDepartment sends post request', () async {
//       when(mockHttp.post(any, data: anyNamed('data')))
//           .thenAnswer((_) async => Response(requestOptions: RequestOptions(path: ''), data: null));

//       await datasource.createDepartment(
//         DepartmentModel(id: null, name: 'New', description: 'Desc', enabled: true),
//         ['uuid1'],
//       );

//       verify(mockHttp.post(any, data: anyNamed('data'))).called(1);
//     });

//     test('updateDepartment returns updated DepartmentModel', () async {
//       final department = DepartmentModel(id: 1, name: 'Edit', description: 'Desc', enabled: true);
//       when(mockHttp.put(any, data: anyNamed('data'))).thenAnswer(
//         (_) async => Response(
//           requestOptions: RequestOptions(path: ''),
//           data: department.toJson(),
//         ),
//       );

//       final result = await datasource.updateDepartment(department);
//       expect(result.name, 'Edit');
//     });

//     test('deleteDepartment calls delete on http service', () async {
//       when(mockHttp.delete(any)).thenAnswer(
//         (_) async => Response(requestOptions: RequestOptions(path: ''), data: null),
//       );

//       await datasource.deleteDepartment(1);
//       verify(mockHttp.delete(any)).called(1);
//     });

//     test('addUsersInDepartment returns updated DepartmentModel', () async {
//       final data = {"id": 1, "name": "Dept", "description": "Desc", "enabled": true};
//       when(mockHttp.post(any, data: anyNamed('data'))).thenAnswer(
//         (_) async => Response(requestOptions: RequestOptions(path: ''), data: data),
//       );

//       final result = await datasource.addUsersInDepartment(1, ['uuid1']);
//       expect(result.name, 'Dept');
//     });

//     test('removeUserInDepartment returns updated DepartmentModel', () async {
//       final data = {"id": 1, "name": "Dept", "description": "Desc", "enabled": true};
//       when(mockHttp.put(any, data: anyNamed('data'))).thenAnswer(
//         (_) async => Response(requestOptions: RequestOptions(path: ''), data: data),
//       );

//       final result = await datasource.removeUserInDepartment(1, ['uuid1']);
//       expect(result.name, 'Dept');
//     });
//   });
// }
