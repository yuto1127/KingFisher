import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth.dart';

class EntryStatusesApi {
  static const String baseUrl = 'http://54.165.66.148//api';

  // すべての入場ステータスを取得
  static Future<List<dynamic>> getAll() async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/entry-statuses'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('入場ステータスの取得に失敗しました');
    }
  }

  // 入場ステータスを作成
  static Future<void> create(Map<String, dynamic> data) async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/entry-statuses'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 201) {
      throw Exception('入場ステータスの作成に失敗しました');
    }
  }

  // 入場ステータスを更新
  static Future<void> update(int id, Map<String, dynamic> data) async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/entry-statuses/$id'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('入場ステータスの更新に失敗しました');
    }
  }

  // 入場ステータスを削除
  static Future<void> delete(int id) async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/entry-statuses/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('入場ステータスの削除に失敗しました');
    }
  }
}
