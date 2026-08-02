import 'package:aetherdesk/core/error/app_exception.dart';
import 'package:aetherdesk/core/error/failure.dart';

/// Converts a caught [AppException] (or any other error) into the matching
/// [Failure], so repository implementations have one consistent place to do
/// this translation instead of repeating switch statements everywhere.
Failure mapExceptionToFailure(Object error) {
  return switch (error) {
    ServerException(:final message) => ServerFailure(message),
    NetworkException(:final message) => NetworkFailure(message),
    CacheException(:final message) => CacheFailure(message),
    ValidationException(:final message) => ValidationFailure(message),
    UnauthorizedException(:final message) => UnauthorizedFailure(message),
    _ => const UnknownFailure(),
  };
}
