import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/number_local_data_source.dart';
import '../../data/models/number_model.dart';
import '../../domain/usecases/check_prime.dart';
import '../../domain/usecases/get_random_number.dart';
import 'number_state.dart';

class NumberCubit extends Cubit<NumberState> {
  final GetRandomNumber getRandomNumber;
  final CheckPrime checkPrime;
  final NumberLocalDataSource localDataSource;

  Timer? _autoFetchTimer;
  NumberModel? _lastPrimeNumber;
  DateTime? _lastFetchTime;

  NumberCubit({
    required this.getRandomNumber,
    required this.checkPrime,
    required this.localDataSource,
  }) : super(const NumberInitial()) {
    _initializeAndStartFetching();
  }

  @override
  Future<void> close() {
    _autoFetchTimer?.cancel();
    return super.close();
  }

  /// Initialize by getting last numbers and starting auto fetch
  void _initializeAndStartFetching() async {
    await _loadLastNumbers();
    startAutoFetch();
  }

  /// Load last number and last prime number
  Future<void> _loadLastNumbers() async {
    try {
      final lastNumber = await localDataSource.getLastNumber();
      _lastPrimeNumber = await localDataSource.getLastPrimeNumber();

      if (lastNumber != null) {
        _lastFetchTime = lastNumber.timestamp;

        if (lastNumber.isPrime) {
          emit(PrimeNumberFound(
            numberData: lastNumber,
            lastFetchTime: _lastFetchTime!,
            lastPrimeTime: _lastPrimeNumber?.timestamp,
          ));
        } else {
          emit(NumberLoaded(
            numberData: lastNumber,
            lastFetchTime: _lastFetchTime!,
            lastPrimeTime: _lastPrimeNumber?.timestamp,
          ));
        }
      } else {
        emit(const NumberInitial());
      }
    } catch (e) {
      emit(NumberError(
        message: 'Failed to load last numbers: $e',
        lastFetchTime: _lastFetchTime,
        lastPrimeTime: _lastPrimeNumber?.timestamp,
      ));
    }
  }

  /// Get last cached number
  Future<void> getLastNumber() async {
    try {
      final lastNumber = await localDataSource.getLastNumber();
      if (lastNumber != null) {
        _lastFetchTime = lastNumber.timestamp;

        if (lastNumber.isPrime) {
          emit(PrimeNumberFound(
            numberData: lastNumber,
            lastFetchTime: _lastFetchTime!,
            lastPrimeTime: _lastPrimeNumber?.timestamp,
          ));
        } else {
          emit(NumberLoaded(
            numberData: lastNumber,
            lastFetchTime: _lastFetchTime!,
            lastPrimeTime: _lastPrimeNumber?.timestamp,
          ));
        }
      } else {
        emit(const NumberInitial());
      }
    } catch (e) {
      emit(NumberError(
        message: 'Failed to get last number: $e',
        lastFetchTime: _lastFetchTime,
        lastPrimeTime: _lastPrimeNumber?.timestamp,
      ));
    }
  }

  /// Start automatic fetching every 10 seconds
  void startAutoFetch() {
    _autoFetchTimer?.cancel();

    _autoFetchTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchRandomNumber();
    });

    // Immediately fetch the first number
    _fetchRandomNumber();
  }

  /// Fetch random number and check if it's prime
  Future<void> _fetchRandomNumber() async {
    emit(NumberLoading(
      lastFetchTime: _lastFetchTime,
      lastPrimeTime: _lastPrimeNumber?.timestamp,
    ));

    final result = await getRandomNumber();

    await result.fold(
      (failure) async => emit(NumberError(
        message: failure.message,
        lastFetchTime: _lastFetchTime,
        lastPrimeTime: _lastPrimeNumber?.timestamp,
      )),
      (number) async {
        // Check if number is prime
        final primeResult = await checkPrime(CheckPrimeParams(number: number));

        await primeResult.fold(
          (failure) async => emit(NumberError(
            message: failure.message,
            lastFetchTime: _lastFetchTime,
            lastPrimeTime: _lastPrimeNumber?.timestamp,
          )),
          (isPrime) async {
            final numberData = NumberModel(
              number: number,
              timestamp: DateTime.now(),
              isPrime: isPrime,
            );

            _lastFetchTime = numberData.timestamp;

            // Cache the number
            try {
              await localDataSource.cacheNumber(numberData);
            } catch (e) {
              // Continue even if caching fails
            }

            // Handle prime number found
            if (isPrime) {
              // Cache this as the new last prime number
              try {
                await localDataSource.cacheLastPrimeNumber(numberData);
                _lastPrimeNumber = numberData;
              } catch (e) {
                // Continue even if caching fails
              }

              // Emit prime found state
              emit(PrimeNumberFound(
                numberData: numberData,
                lastFetchTime: _lastFetchTime!,
                lastPrimeTime: _lastPrimeNumber?.timestamp,
              ));
            } else {
              // For non-prime numbers, show time since last prime
              emit(NumberLoaded(
                numberData: numberData,
                lastFetchTime: _lastFetchTime!,
                lastPrimeTime: _lastPrimeNumber?.timestamp,
              ));
            }
          },
        );
      },
    );
  }
}
