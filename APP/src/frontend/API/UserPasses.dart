import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth.dart';

class UserPassesApi {
  static const String baseUrl = 'http://54.165.66.148//api';

  // すべてのユーザーパスを取得
  static Future<List<dynamic>> getAll() async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/user-passes'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('ユーザーパスの取得に失敗しました');
    }
  }

  // ユーザーパスを作成
  static Future<void> create(Map<String, dynamic> data) async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/user-passes'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 201) {
      throw Exception('ユーザーパスの作成に失敗しました');
    }
  }

  // ユーザーパスを更新
  static Future<void> update(int id, Map<String, dynamic> data) async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/user-passes/$id'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('ユーザーパスの更新に失敗しました');
    }
  }

  // ユーザーパスを削除
  static Future<void> delete(int id) async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/user-passes/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('ユーザーパスの削除に失敗しました');
    }
  }
}
