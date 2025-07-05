import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/failures/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';

/// Check if number is prime use case
class CheckPrime implements UseCase<bool, CheckPrimeParams> {
  CheckPrime();

  @override
  Future<Either<Failure, bool>> call(CheckPrimeParams params) async {
    try {
      final stopwatch = Stopwatch()..start();
      final isPrime = _isPrime(params.number);
      stopwatch.stop();

      // Log prime check result
      AppLogger.primeCheck(
        number: params.number,
        isPrime: isPrime,
        processingTime: stopwatch.elapsed,
      );

      return Right(isPrime);
    } catch (e) {
      AppLogger.error('Error checking prime for ${params.number}', e);
      return Left(GeneralFailure(message: 'Error checking prime: $e'));
    }
  }

  /// Check if a number is prime
  bool _isPrime(int number) {
    if (number < 2) return false;
    if (number == 2) return true;
    if (number % 2 == 0) return false;

    for (int i = 3; i * i <= number; i += 2) {
      if (number % i == 0) return false;
    }

    return true;
  }
}

/// Parameters for check prime use case
class CheckPrimeParams extends Equatable {
  final int number;

  const CheckPrimeParams({required this.number});

  @override
  List<Object?> get props => [number];
}
