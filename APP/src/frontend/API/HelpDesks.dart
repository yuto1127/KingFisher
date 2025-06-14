import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth.dart';

class HelpDesksApi {
  static const String baseUrl = 'http://54.165.66.148//api';

  // すべてのヘルプデスクを取得
  static Future<List<dynamic>> getAll() async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/help-desks'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('ヘルプデスクの取得に失敗しました');
    }
  }

  // ヘルプデスクを作成
  static Future<void> create(Map<String, dynamic> data) async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/help-desks'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 201) {
      throw Exception('ヘルプデスクの作成に失敗しました');
    }
  }

  // ヘルプデスクを更新
  static Future<void> update(int id, Map<String, dynamic> data) async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/help-desks/$id'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('ヘルプデスクの更新に失敗しました');
    }
  }

  // ヘルプデスクを削除
  static Future<void> delete(int id) async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/help-desks/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('ヘルプデスクの削除に失敗しました');
    }
  }
}
