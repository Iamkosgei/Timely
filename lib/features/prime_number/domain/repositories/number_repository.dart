import 'package:dartz/dartz.dart';

import '../../../../core/failures/failures.dart';

/// Number repository interface
abstract class NumberRepository {
  Future<Either<Failure, int>> getRandomNumber();
}
