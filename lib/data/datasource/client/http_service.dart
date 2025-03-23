import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:orgsync/domain/services/token_provider.dart';
import 'package:orgsync/infra/failure/failure.dart';

@lazySingleton
class HttpService {
  final Dio _dio;
  final TokenProvider _tokenProvider;

  HttpService(this._dio, this._tokenProvider) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!_isPublicRoute(options.path)) {
            final token = await _tokenProvider.getToken();
            if (token != null) {
              final jwt = jsonDecode(token) as Map<String, dynamic>;
              options.headers['Authorization'] = 'Bearer ${jwt['accessToken']}';
            }
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // if (error.response?.statusCode == 401) {
          //   await _tokenProvider.clearToken();
          //   //todo: login page
          // }
          handler.next(error);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (object) => debugPrint(object.toString()),
        ),
      );
    }
  }

  bool _isPublicRoute(String path) {
    const publicRoutes = ['/auth/login', '/auth/register'];
    return publicRoutes.any((route) => path.contains(route));
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }
}


//TODO: sistema de tratamento de erro: 

  // void _handleError(dynamic error) {
  //   if (error is DioException) {
  //     switch (error.type) {
  //       case DioExceptionType.connectionTimeout:
  //         throw Exception('Tempo de conexão excedido');
  //       case DioExceptionType.receiveTimeout:
  //         throw Exception('Tempo de resposta excedido');
  //       case DioExceptionType.badResponse:
  //         switch (error.response?.statusCode) {
  //           case 400:
  //             throw Exception('Requisição inválida');
  //           case 401:
  //             throw Exception('Não autorizado');
  //           case 403:
  //             throw Exception('Acesso negado');
  //           case 404:
  //             throw Exception('Recurso não encontrado');
  //           case 500:
  //             throw Exception('Erro interno do servidor');
  //           default:
  //             throw Exception('Erro desconhecido');
  //         }
  //       case DioExceptionType.cancel:
  //         throw Exception('Requisição cancelada');
  //       default:
  //         throw Exception('Erro de conexão');
  //     }
  //   }
  //   throw error;
  // }