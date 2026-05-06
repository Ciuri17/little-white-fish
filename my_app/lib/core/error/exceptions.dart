/// Custom exceptions for the application

/// Server/API related exceptions
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => message;
}

/// Cache/Local storage exceptions
class CacheException implements Exception {
  final String message;

  CacheException(this.message);

  @override
  String toString() => message;
}

/// Game logic exceptions
class GameException implements Exception {
  final String message;

  GameException(this.message);

  @override
  String toString() => message;
}

/// Network connectivity exceptions
class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => message;
}
