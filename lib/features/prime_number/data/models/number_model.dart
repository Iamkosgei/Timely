import '../../domain/entities/number_data.dart';

/// Number model for data layer
class NumberModel extends NumberData {
  const NumberModel({
    required super.number,
    required super.timestamp,
    required super.isPrime,
  });

  /// Factory constructor from API response
  factory NumberModel.fromApiResponse(int number) {
    return NumberModel(
      number: number,
      timestamp: DateTime.now(),
      isPrime: false, // Will be calculated separately
    );
  }

  /// Create with prime status
  NumberModel withPrimeStatus(bool isPrime) {
    return NumberModel(number: number, timestamp: timestamp, isPrime: isPrime);
  }

  /// Convert to JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'timestamp': timestamp.toIso8601String(),
      'isPrime': isPrime,
    };
  }

  /// Factory constructor from JSON
  factory NumberModel.fromJson(Map<String, dynamic> json) {
    return NumberModel(
      number: json['number'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isPrime: json['isPrime'] as bool,
    );
  }
}
