import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  static const String baseUrl = 'http://localhost:8000/api'; // 開発環境用のURL

  // ユーザー情報を取得
  static Future<Map<String, dynamic>> getUser(String barcode) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$barcode'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
} 