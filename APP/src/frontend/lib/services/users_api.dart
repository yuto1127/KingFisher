import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_api.dart';

class UsersApi {
  static const String baseUrl = 'http://54.165.66.148/api';

  // エラーメッセージのマッピング
  static const Map<String, String> _errorMessages = {
    'validation_error': '入力内容に誤りがあります',
    'email_already_exists': 'このメールアドレスは既に登録されています',
    'user_not_found': 'ユーザーが見つかりません',
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
    if (processed['barth_day'] != null) {
      processed['barth_day'] = DateTime.parse(processed['barth_day']);
    }
    if (processed['last_login_at'] != null) {
      processed['last_login_at'] = DateTime.parse(processed['last_login_at']);
    }
    return processed;
  }

  // すべてのユーザーを取得
  static Future<List<Map<String, dynamic>>> getAll() async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/users'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        return users.map((user) => _processDateFields(user)).toList();
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['network_error']!);
    }
  }

  // ユーザーを作成
  static Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
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

  // ユーザーを更新
  static Future<Map<String, dynamic>> update(
      int id, Map<String, dynamic> data) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/users/$id'),
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

  // ユーザーを削除
  static Future<void> delete(int id) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/users/$id'),
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

  // バーコードでユーザーを検索
  static Future<Map<String, dynamic>> findByBarcode(String barcode) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/users/barcode/$barcode'),
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

  // メールアドレスでユーザーを検索
  static Future<Map<String, dynamic>> findByEmail(String email) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/users/email/$email'),
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
