import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static late final Logger _logger;

  /// Initialize the logger
  static void init() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 80,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      level: kDebugMode ? Level.debug : Level.off,
    );
  }

  /// Log API requests
  static void apiRequest({
    required String url,
    required String method,
    Map<String, dynamic>? headers,
    dynamic body,
  }) {
    if (!kDebugMode) return;

    _logger.d(
      '🌐 API Request\n'
      '   Method: $method\n'
      '   URL: $url\n'
      '   Headers: ${headers?.toString() ?? 'None'}\n'
      '   Body: ${body?.toString() ?? 'None'}',
    );
  }

  /// Log API responses
  static void apiResponse({
    required String url,
    required int statusCode,
    dynamic response,
    String? error,
  }) {
    if (!kDebugMode) return;

    if (error != null) {
      _logger.e(
        '❌ API Error\n'
        '   URL: $url\n'
        '   Status: $statusCode\n'
        '   Error: $error',
      );
    } else {
      _logger.i(
        '✅ API Response\n'
        '   URL: $url\n'
        '   Status: $statusCode\n'
        '   Response: ${response?.toString() ?? 'Empty'}',
      );
    }
  }

  /// Log prime number checking
  static void primeCheck({
    required int number,
    required bool isPrime,
    required Duration processingTime,
  }) {
    if (!kDebugMode) return;

    final emoji = isPrime ? '🔢' : '➖';
    final status = isPrime ? 'PRIME' : 'NOT PRIME';

    _logger.i(
      '$emoji Prime Check\n'
      '   Number: $number\n'
      '   Result: $status\n'
      '   Processing time: ${processingTime.inMilliseconds}ms',
    );
  }

  /// Log general information
  static void info(String message) {
    if (!kDebugMode) return;
    _logger.i(message);
  }

  /// Log warnings
  static void warning(String message) {
    if (!kDebugMode) return;
    _logger.w(message);
  }

  /// Log errors
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (!kDebugMode) return;
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log debug messages
  static void debug(String message) {
    if (!kDebugMode) return;
    _logger.d(message);
  }
}
