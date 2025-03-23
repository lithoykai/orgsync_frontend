abstract class Failure {
  String get message;

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  final String? msg;
  final int? statusCode;

  ServerFailure({this.msg, this.statusCode});

  @override
  String get message => msg ?? 'Erro no servidor.';
}

class AppFailure extends Failure {
  final String? msg;

  AppFailure({this.msg});

  @override
  String get message => msg ?? 'Erro inesperado.';
}
