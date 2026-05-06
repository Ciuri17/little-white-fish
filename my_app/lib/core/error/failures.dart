import 'package:equatable/equatable.dart';

/// Base class for all failures
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Server/API failure
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(
    String message, {
    this.statusCode,
  }) : super(message);

  @override
  List<Object> get props => [message, statusCode ?? 0];
}

/// Cache/Local storage failure
class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

/// Game logic failure
class GameFailure extends Failure {
  const GameFailure(String message) : super(message);
}

/// Network connectivity failure
class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

/// Generic/Unknown failure
class UnknownFailure extends Failure {
  const UnknownFailure(String message) : super(message);
}
