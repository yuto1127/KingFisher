import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_api.dart';

class UserPassesApi {
  static const String baseUrl = 'https://cid-kingfisher.jp/';
  // エラーメッセージのマッピング
  static const Map<String, String> _errorMessages = {
    'validation_error': '入力内容に誤りがあります',
    'user_pass_not_found': 'ユーザーパスが見つかりません',
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

  // すべてのユーザーパスを取得
  static Future<List<Map<String, dynamic>>> getAll() async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/user-passes'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> passes = jsonDecode(response.body);
        return passes.map((pass) => Map<String, dynamic>.from(pass)).toList();
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['network_error']!);
    }
  }

  // ユーザーパスを作成
  static Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    try {
      // final headers = await AuthApi.getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/user-passes'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        return Map<String, dynamic>.from(jsonDecode(response.body));
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['network_error']!);
    }
  }

  // ユーザーパスを更新
  static Future<Map<String, dynamic>> update(
      int id, Map<String, dynamic> data) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/user-passes/$id'),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(jsonDecode(response.body));
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['network_error']!);
    }
  }

  // ユーザーパスを削除
  static Future<void> delete(int id) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/user-passes/$id'),
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

  // パスワードによる検索
  static Future<Map<String, dynamic>> findByPassword(String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user-passes/find-by-password'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'password': password}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      throw Exception('パスワードによる検索中にエラーが発生しました: $e');
    }
  }

  // メールアドレスの重複チェック
  static Future<bool> checkEmailExists(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user-passes/check-email'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['exists'] ?? false;
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      throw Exception('メールアドレスの重複チェック中にエラーが発生しました: $e');
    }
  }
}
