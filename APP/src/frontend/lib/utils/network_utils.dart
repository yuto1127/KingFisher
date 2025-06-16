import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtils {
  static Future<bool> isConnected() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) return false;

      // 実際のインターネット接続を確認
      final result = await InternetAddress.lookup('54.165.66.148');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Stream<ConnectivityResult> get connectionStream =>
      Connectivity().onConnectivityChanged;
}
