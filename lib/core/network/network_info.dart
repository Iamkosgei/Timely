import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Abstract class for network info
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementation of network info
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl({required this.connectionChecker});

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
