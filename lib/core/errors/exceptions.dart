import 'package:equatable/equatable.dart';

abstract class AppException extends Equatable implements Exception {
  const AppException({
    required this.message,
    required this.statusCode,
  });

  final String message;
  final String statusCode;

  @override
  List<Object> get props => [message, statusCode];
}

class ServerException extends AppException {
  const ServerException({
    required super.message,
    required super.statusCode,
  });
}

class CacheException extends AppException {
  const CacheException({
    required super.message,
    required super.statusCode,
  });
}

class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    required super.statusCode,
  });
}
