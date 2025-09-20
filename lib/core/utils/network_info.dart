import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _c;
  NetworkInfoImpl(this._c);

  @override
  Future<bool> get isConnected async {
    final result = await _c.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}