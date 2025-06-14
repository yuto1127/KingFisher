import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth.dart';

class EventsApi {
  static const String baseUrl = 'http://54.165.66.148//api';

  // すべてのイベントを取得
  static Future<List<dynamic>> getAll() async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/events'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('イベントの取得に失敗しました');
    }
  }

  // イベントを作成
  static Future<void> create(Map<String, dynamic> data) async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/events'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 201) {
      throw Exception('イベントの作成に失敗しました');
    }
  }

  // イベントを更新
  static Future<void> update(int id, Map<String, dynamic> data) async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/events/$id'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('イベントの更新に失敗しました');
    }
  }

  // イベントを削除
  static Future<void> delete(int id) async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/events/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('イベントの削除に失敗しました');
    }
  }

  // イベントのユーザー情報を取得
  static Future<Map<String, dynamic>> getEventUser(int id) async {
    final headers = await AuthApi.getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/events/$id/user'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('イベントのユーザー情報の取得に失敗しました');
    }
  }
}
