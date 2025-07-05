import 'package:equatable/equatable.dart';

import '../../domain/entities/number_data.dart';

abstract class NumberState extends Equatable {
  const NumberState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class NumberInitial extends NumberState {
  const NumberInitial();
}

/// Loading state
class NumberLoading extends NumberState {
  final DateTime? lastFetchTime;
  final DateTime? lastPrimeTime;

  const NumberLoading({
    this.lastFetchTime,
    this.lastPrimeTime,
  });

  @override
  List<Object?> get props => [lastFetchTime, lastPrimeTime];
}

/// Number loaded state
class NumberLoaded extends NumberState {
  final NumberData numberData;
  final DateTime lastFetchTime;
  final DateTime? lastPrimeTime;

  const NumberLoaded({
    required this.numberData,
    required this.lastFetchTime,
    this.lastPrimeTime,
  });

  @override
  List<Object?> get props => [numberData, lastFetchTime, lastPrimeTime];
}

/// Prime number found state
class PrimeNumberFound extends NumberState {
  final NumberData numberData;
  final DateTime lastFetchTime;
  final DateTime? lastPrimeTime;
  final DateTime? previousPrimeTime;

  const PrimeNumberFound({
    required this.numberData,
    required this.lastFetchTime,
    this.lastPrimeTime,
    this.previousPrimeTime,
  });

  @override
  List<Object?> get props =>
      [numberData, lastFetchTime, lastPrimeTime, previousPrimeTime];
}

/// Error state
class NumberError extends NumberState {
  final String message;
  final DateTime? lastFetchTime;
  final DateTime? lastPrimeTime;

  const NumberError({
    required this.message,
    this.lastFetchTime,
    this.lastPrimeTime,
  });

  @override
  List<Object?> get props => [message, lastFetchTime, lastPrimeTime];
}
