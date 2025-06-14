import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth.dart';

class RolesApi {
  static const String baseUrl = 'http://54.165.66.148//api';

  // すべてのロールを取得
  static Future<List<dynamic>> getAll() async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/roles'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('ロールの取得に失敗しました');
    }
  }

  // ロールを作成
  static Future<void> create(Map<String, dynamic> data) async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/roles'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 201) {
      throw Exception('ロールの作成に失敗しました');
    }
  }

  // ロールを更新
  static Future<void> update(int id, Map<String, dynamic> data) async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/roles/$id'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('ロールの更新に失敗しました');
    }
  }

  // ロールを削除
  static Future<void> delete(int id) async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/roles/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('ロールの削除に失敗しました');
    }
  }
}
