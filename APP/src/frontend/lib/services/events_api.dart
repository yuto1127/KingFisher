import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_api.dart';

class EventsApi {
  static const String baseUrl = 'http://54.165.66.148/api';

  // エラーメッセージのマッピング
  static const Map<String, String> _errorMessages = {
    'validation_error': '入力内容に誤りがあります',
    'event_not_found': 'イベントが見つかりません',
    'network_error': 'ネットワークエラーが発生しました',
    'server_error': 'サーバーエラーが発生しました',
    'unknown_error': '予期せぬエラーが発生しました',
  };

  // エラーメッセージを取得
  static String _getErrorMessage(String code, String? detail) {
    return '${_errorMessages[code] ?? _errorMessages['unknown_error']}${detail != null ? ': $detail' : ''}';
  }

  // HTTPレスポンスのエラーハンドリング
  static Exception _handleErrorResponse(http.Response response) {
    try {
      final error = json.decode(response.body);
      final errorCode = error['error_code'] ?? 'unknown_error';
      final errorDetail = error['message'];
      return Exception(_getErrorMessage(errorCode, errorDetail));
    } catch (e) {
      return Exception(_errorMessages['server_error']!);
    }
  }

  // 日付データの処理
  static Map<String, dynamic> _processDateFields(Map<String, dynamic> data) {
    final processed = Map<String, dynamic>.from(data);
    if (processed['created_at'] != null) {
      processed['created_at'] = DateTime.parse(processed['created_at']);
    }
    if (processed['updated_at'] != null) {
      processed['updated_at'] = DateTime.parse(processed['updated_at']);
    }
    if (processed['start_date'] != null) {
      processed['start_date'] = DateTime.parse(processed['start_date']);
    }
    if (processed['end_date'] != null) {
      processed['end_date'] = DateTime.parse(processed['end_date']);
    }
    return processed;
  }

  // すべてのイベントを取得
  static Future<List<Map<String, dynamic>>> getAll() async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/events'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> events = jsonDecode(response.body);
        return events.map((event) => _processDateFields(event)).toList();
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['network_error']!);
    }
  }

  // イベントを作成
  static Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/events'),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        return _processDateFields(jsonDecode(response.body));
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['network_error']!);
    }
  }

  // イベントを更新
  static Future<Map<String, dynamic>> update(
      int id, Map<String, dynamic> data) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/events/$id'),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return _processDateFields(jsonDecode(response.body));
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['network_error']!);
    }
  }

  // イベントを削除
  static Future<void> delete(int id) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/events/$id'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['network_error']!);
    }
  }

  // イベントを検索
  static Future<List<Map<String, dynamic>>> search(String query) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/events/search?q=$query'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> events = jsonDecode(response.body);
        return events.map((event) => _processDateFields(event)).toList();
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['network_error']!);
    }
  }

  // 日付範囲でフィルタリング
  static Future<List<Map<String, dynamic>>> filterByDateRange(
      DateTime start, DateTime end) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.get(
        Uri.parse(
            '$baseUrl/events/date-range?start=${start.toIso8601String()}&end=${end.toIso8601String()}'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> events = jsonDecode(response.body);
        return events.map((event) => _processDateFields(event)).toList();
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['network_error']!);
    }
  }

  // 参加状況を取得
  static Future<List<Map<String, dynamic>>> getEntryStatuses(
      int eventId) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/events/$eventId/entries'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> entries = jsonDecode(response.body);
        return entries.map((entry) => _processDateFields(entry)).toList();
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['network_error']!);
    }
  }

  // 参加登録
  static Future<Map<String, dynamic>> registerEntry(
      int eventId, Map<String, dynamic> data) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/events/$eventId/entries'),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        return _processDateFields(jsonDecode(response.body));
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['network_error']!);
    }
  }

  // 参加キャンセル
  static Future<void> cancelEntry(int eventId, int entryId) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/events/$eventId/entries/$entryId'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['network_error']!);
    }
  }

  // イベントのユーザー情報を取得
  static Future<Map<String, dynamic>> getEventUser(int id) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/events/$id/user'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return _processDateFields(jsonDecode(response.body));
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['network_error']!);
    }
  }
}
