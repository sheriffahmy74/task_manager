import 'package:fpdart/fpdart.dart';

import '../errors/failures.dart';

extension EitherExt<T> on Either<Failure, T> {
  bool get isSuccess => isRight();
  bool get isFailure => isLeft();

  T? getOrNull() => fold((_) => null, (value) => value);

  Failure? getFailureOrNull() => fold((failure) => failure, (_) => null);
}
