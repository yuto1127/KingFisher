import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/registration_model.dart';
import '../models/login_model.dart';

class ApiClient {
  static const String baseUrl = 'http://54.165.66.148/api'; // 開発環境用のURL

  // エラーメッセージのマッピング
  static const Map<String, String> _errorMessages = {
    'validation_error': '入力内容に誤りがあります',
    'email_already_exists': 'このメールアドレスは既に登録されています',
    'invalid_credentials': 'メールアドレスまたはパスワードが正しくありません',
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

  // ユーザー情報を取得
  static Future<Map<String, dynamic>> getUser(String barcode) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$barcode'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // 日付文字列をDateTimeに変換
        if (data['barth_day'] != null) {
          data['barth_day'] = DateTime.parse(data['barth_day']);
        }
        if (data['last_login_at'] != null) {
          data['last_login_at'] = DateTime.parse(data['last_login_at']);
        }
        return data;
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['network_error']!);
    }
  }

  // 会員登録
  static Future<Map<String, dynamic>> registerUser(
      RegistrationModel user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        // 日付文字列をDateTimeに変換
        if (data['barth_day'] != null) {
          data['barth_day'] = DateTime.parse(data['barth_day']);
        }
        return data;
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['network_error']!);
    }
  }

  // ログイン
  static Future<Map<String, dynamic>> login(LoginModel credentials) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(credentials.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // トークンの存在確認
        if (data['token'] == null) {
          throw Exception(_errorMessages['server_error']!);
        }
        return data;
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['network_error']!);
    }
  }

  // ユーザー情報の更新
  static Future<Map<String, dynamic>> updateUser(
      String barcode, Map<String, dynamic> userData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/$barcode'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // 日付文字列をDateTimeに変換
        if (data['barth_day'] != null) {
          data['barth_day'] = DateTime.parse(data['barth_day']);
        }
        if (data['last_login_at'] != null) {
          data['last_login_at'] = DateTime.parse(data['last_login_at']);
        }
        return data;
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['network_error']!);
    }
  }
}
