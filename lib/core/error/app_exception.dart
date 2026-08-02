/// Exceptions thrown by the data layer (datasources, repositories).
///
/// These are internal to `data/` and must never leak into `presentation/`.
/// A repository implementation catches them and converts each one into the
/// matching [Failure] via `error_handler.dart`, so the UI layer only ever
/// deals with [Failure], never raw exceptions.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class ServerException extends AppException {
  const ServerException([super.message = 'Server error']);
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error']);
}

final class CacheException extends AppException {
  const CacheException([super.message = 'Cache error']);
}

final class ValidationException extends AppException {
  const ValidationException([super.message = 'Validation error']);
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized']);
}
