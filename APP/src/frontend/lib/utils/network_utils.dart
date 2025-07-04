import 'package:http/http.dart' as http;

class NetworkUtils {
  static const String baseUrl = 'https://cid-kingfisher.jp/';
  
  static Future<bool> isConnected() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/ping'),
          )
          .timeout(const Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
