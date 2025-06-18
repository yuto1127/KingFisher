import 'package:http/http.dart' as http;

class NetworkUtils {
  static Future<bool> isConnected() async {
    try {
      final response = await http
          .get(
            Uri.parse('http://54.165.66.148/api/ping'),
          )
          .timeout(const Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
