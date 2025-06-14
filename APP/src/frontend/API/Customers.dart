import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth.dart';

class CustomersApi {
  static const String baseUrl = 'http://54.165.66.148//api';

  // すべての顧客を取得
  static Future<List<dynamic>> getAll() async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/customers'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('顧客の取得に失敗しました');
    }
  }

  // 顧客を作成
  static Future<void> create(Map<String, dynamic> data) async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/customers'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 201) {
      throw Exception('顧客の作成に失敗しました');
    }
  }

  // 顧客を更新
  static Future<void> update(int id, Map<String, dynamic> data) async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/customers/$id'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('顧客の更新に失敗しました');
    }
  }

  // 顧客を削除
  static Future<void> delete(int id) async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/customers/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('顧客の削除に失敗しました');
    }
  }
}
