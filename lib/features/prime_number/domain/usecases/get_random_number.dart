import 'package:dartz/dartz.dart';

import '../../../../core/failures/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/number_repository.dart';

/// Get random number use case
class GetRandomNumber implements UseCaseNoParams<int> {
  final NumberRepository repository;

  GetRandomNumber({required this.repository});

  @override
  Future<Either<Failure, int>> call() async {
    return await repository.getRandomNumber();
  }
}
