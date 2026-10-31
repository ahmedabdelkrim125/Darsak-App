import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  NetworkInfo({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Future<bool> get isConnected async {
    return _hasConnection(await _connectivity.checkConnectivity());
  }

  Stream<bool> get onChanged {
    return _connectivity.onConnectivityChanged.map(_hasConnection).distinct();
  }

  static bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }
}
