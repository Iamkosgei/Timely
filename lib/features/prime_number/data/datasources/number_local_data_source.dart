import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../models/number_model.dart';

/// Number local data source interface
abstract class NumberLocalDataSource {
  Future<NumberModel?> getLastNumber();
  Future<void> cacheNumber(NumberModel numberModel);
  Future<NumberModel?> getLastPrimeNumber();
  Future<void> cacheLastPrimeNumber(NumberModel primeNumber);
}

/// Implementation of number local data source
class NumberLocalDataSourceImpl implements NumberLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NumberModel?> getLastNumber() async {
    try {
      final jsonString = sharedPreferences.getString(
        AppConstants.lastNumberKey,
      );
      if (jsonString != null) {
        final jsonMap = json.decode(jsonString);
        return NumberModel.fromJson(jsonMap);
      }
      return null;
    } catch (e) {
      throw CacheException(message: 'Failed to get last number');
    }
  }

  @override
  Future<void> cacheNumber(NumberModel numberModel) async {
    try {
      final jsonString = json.encode(numberModel.toJson());
      await sharedPreferences.setString(AppConstants.lastNumberKey, jsonString);
    } catch (e) {
      throw CacheException(message: 'Failed to cache number');
    }
  }

  @override
  Future<NumberModel?> getLastPrimeNumber() async {
    try {
      final jsonString = sharedPreferences.getString(
        AppConstants.lastPrimeNumberKey,
      );
      if (jsonString != null) {
        final jsonMap = json.decode(jsonString);
        return NumberModel.fromJson(jsonMap);
      }
      return null;
    } catch (e) {
      throw CacheException(message: 'Failed to get last prime number');
    }
  }

  @override
  Future<void> cacheLastPrimeNumber(NumberModel primeNumber) async {
    try {
      final jsonString = json.encode(primeNumber.toJson());
      await sharedPreferences.setString(
        AppConstants.lastPrimeNumberKey,
        jsonString,
      );
    } catch (e) {
      throw CacheException(message: 'Failed to cache last prime number');
    }
  }
}
