import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/failures/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/repositories/number_repository.dart';
import '../datasources/number_remote_data_source.dart';

class NumberRepositoryImpl implements NumberRepository {
  final NumberRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NumberRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, int>> getRandomNumber() async {
    if (await networkInfo.isConnected) {
      try {
        final randomNumber = await remoteDataSource.getRandomNumber();
        return Right(randomNumber);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return const Left(
          GeneralFailure(message: AppConstants.generalFailureMessage),
        );
      }
    } else {
      return const Left(
          NetworkFailure(message: AppConstants.networkFailureMessage));
    }
  }
}
