import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_logger.dart';

/// Number remote data source interface
abstract class NumberRemoteDataSource {
  Future<int> getRandomNumber();
}

/// Implementation of number remote data source
class NumberRemoteDataSourceImpl implements NumberRemoteDataSource {
  final Dio dio;
  static const String _apiUrl =
      'https://www.randomnumberapi.com/api/v1.0/random';

  NumberRemoteDataSourceImpl({required this.dio});

  @override
  Future<int> getRandomNumber() async {
    try {
      // Log API request
      AppLogger.apiRequest(
        url: _apiUrl,
        method: 'GET',
        headers: {'Content-Type': 'application/json'},
      );

      final response = await dio.get(
        _apiUrl,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        if (data.isNotEmpty) {
          final randomNumber = data[0] as int;

          // Log successful API response
          AppLogger.apiResponse(
            url: _apiUrl,
            statusCode: response.statusCode!,
            response: data,
          );

          return randomNumber;
        } else {
          AppLogger.apiResponse(
            url: _apiUrl,
            statusCode: response.statusCode!,
            error: 'Empty response from API',
          );
          throw ServerException(message: 'Empty response from API');
        }
      } else {
        AppLogger.apiResponse(
          url: _apiUrl,
          statusCode: response.statusCode ?? 0,
          error: 'Failed to get random number',
        );
        throw ServerException(message: 'Failed to get random number');
      }
    } on DioException catch (e) {
      AppLogger.apiResponse(
        url: _apiUrl,
        statusCode: e.response?.statusCode ?? 0,
        error: e.message ?? 'Network error',
      );
      throw NetworkException(message: e.message ?? 'Network error');
    } catch (e) {
      AppLogger.apiResponse(
        url: _apiUrl,
        statusCode: 0,
        error: 'Unexpected error: $e',
      );
      throw ServerException(message: 'Unexpected error: $e');
    }
  }
}
