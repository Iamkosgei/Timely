import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../failures/failures.dart';

/// Base use case class
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case with no parameters
abstract class UseCaseNoParams<Type> {
  Future<Either<Failure, Type>> call();
}

/// No parameters class
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
