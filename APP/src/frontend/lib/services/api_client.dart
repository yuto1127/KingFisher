import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/registration_model.dart';
import '../models/login_model.dart';

class ApiClient {
  static const String baseUrl = 'http://54.165.66.148/api'; // 開発環境用のURL

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

  // 会員登録
  static Future<Map<String, dynamic>> registerUser(RegistrationModel user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to register user');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ログイン
  static Future<Map<String, dynamic>> login(LoginModel credentials) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(credentials.toJson()),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'ログインに失敗しました');
      }
    } catch (e) {
      throw Exception('ネットワークエラー: $e');
    }
  }
} 