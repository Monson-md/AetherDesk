/// Domain/presentation-facing error type.
///
/// The `presentation/` layer switches on this sealed type (exhaustively,
/// thanks to Dart 3 pattern matching) to decide what to show the user. It
/// never sees an [AppException] directly.
sealed class Failure {
  const Failure(this.message);

  final String message;
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error']);
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error']);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error']);
}

final class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation error']);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Unauthorized']);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Unknown error']);
}
