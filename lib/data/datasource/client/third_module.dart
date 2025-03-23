import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:orgsync/infra/constants/endpoints.dart';

@module
abstract class RegisterModule{ 
  @factoryMethod
  Dio dio() => Dio(BaseOptions(
        baseUrl: Endpoints.BASE_URL,
       
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));
}