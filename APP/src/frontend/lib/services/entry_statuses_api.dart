import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/network_utils.dart';
import 'auth_api.dart';

class EntryStatusesApi {
  /// 入退室状況を作成
  static Future<Map<String, dynamic>?> createEntryStatus(
      Map<String, dynamic> data) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.post(
        Uri.parse('${NetworkUtils.baseUrl}/api/entry-statuses'),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to create entry status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// 入退室状況一覧を取得
  static Future<List<Map<String, dynamic>>> getEntryStatuses() async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.get(
        Uri.parse('${NetworkUtils.baseUrl}/api/entry-statuses'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to get entry statuses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// 特定のユーザーの入退室状況を取得
  static Future<List<Map<String, dynamic>>> getEntryStatusesByUser(
      int userId) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.get(
        Uri.parse('${NetworkUtils.baseUrl}/api/entry-statuses?user_id=$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception(
            'Failed to get entry statuses for user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// 入退室状況を更新
  static Future<Map<String, dynamic>?> updateEntryStatus(
      int id, Map<String, dynamic> data) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.put(
        Uri.parse('${NetworkUtils.baseUrl}/api/entry-statuses/$id'),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to update entry status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// 入退室状況を削除
  static Future<bool> deleteEntryStatus(int id) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.delete(
        Uri.parse('${NetworkUtils.baseUrl}/api/entry-statuses/$id'),
        headers: headers,
      );

      return response.statusCode == 204;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// バーコードスキャンによる入退室処理（入室/退室の切り替え）
  static Future<Map<String, dynamic>> toggleEntryStatus(int userId) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.post(
        Uri.parse('${NetworkUtils.baseUrl}/api/entry-statuses/toggle'),
        headers: headers,
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to toggle entry status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// 特定ユーザーの最新の入退室状況を取得
  static Future<Map<String, dynamic>?> getUserEntryStatus(int userId) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.get(
        Uri.parse('${NetworkUtils.baseUrl}/api/entry-statuses/user/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception(
            'Failed to get user entry status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
