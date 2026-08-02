import 'package:aetherdesk/core/error/failure.dart';

/// Lightweight `Either`-style wrapper returned by repositories and usecases,
/// so failures are part of the function signature instead of being thrown
/// and possibly forgotten. Deliberately hand-rolled (no `dartz`/`fpdart`
/// dependency) — Dart 3 sealed classes and pattern matching cover this
/// use case without extra packages.
///
/// Usage:
/// ```dart
/// final result = await repository.getSomething();
/// switch (result) {
///   case Success(:final value) => print(value),
///   case Error(:final failure) => print(failure.message),
/// }
/// ```
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

final class Error<T> extends Result<T> {
  const Error(this.failure);

  final Failure failure;
}
