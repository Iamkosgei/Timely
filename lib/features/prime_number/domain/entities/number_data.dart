import 'package:equatable/equatable.dart';

/// Number data entity
class NumberData extends Equatable {
  final int number;
  final DateTime timestamp;
  final bool isPrime;

  const NumberData({
    required this.number,
    required this.timestamp,
    required this.isPrime,
  });

  @override
  List<Object?> get props => [number, timestamp, isPrime];
}
