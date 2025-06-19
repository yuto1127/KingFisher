import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:html' as html;
import '../utils/network_utils.dart';
import '../models/registration_model.dart';
import '../models/login_model.dart';
import 'package:flutter/foundation.dart';

class AuthApi {
  static const String baseUrl = 'http://54.165.66.148/api';
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  // エラーメッセージのマッピング
  static const Map<String, String> _errorMessages = {
    'validation_error': '入力内容に誤りがあります',
    'invalid_credentials': 'メールアドレスまたはパスワードが正しくありません',
    'token_invalid': '認証情報が無効です',
    'token_expired': 'セッションの有効期限が切れました',
    'network_error': 'ネットワークエラーが発生しました',
    'server_error': 'サーバーエラーが発生しました',
    'timeout_error': 'サーバーへの接続がタイムアウトしました',
    'unknown_error': '予期せぬエラーが発生しました',
  };

  static const _storage = FlutterSecureStorage();

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

  // トークンを保存
  static Future<void> saveToken(String token) async {
    if (kIsWeb) {
      html.window.localStorage[tokenKey] = token;
    } else {
      await _storage.write(key: tokenKey, value: token);
    }
  }

  // トークンを取得
  static Future<String?> getToken() async {
    if (kIsWeb) {
      return html.window.localStorage[tokenKey];
    } else {
      return await _storage.read(key: tokenKey);
    }
  }

  // トークンを削除
  static Future<void> deleteToken() async {
    if (kIsWeb) {
      html.window.localStorage.remove(tokenKey);
    } else {
      await _storage.delete(key: tokenKey);
    }
    await deleteUserData();
  }

  // ユーザーデータを保存
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    if (kIsWeb) {
      html.window.localStorage[userKey] = jsonEncode(userData);
    } else {
      await _storage.write(key: userKey, value: jsonEncode(userData));
    }
  }

  // ユーザーデータを取得
  static Future<Map<String, dynamic>?> getUserData() async {
    String? data;
    if (kIsWeb) {
      data = html.window.localStorage[userKey];
    } else {
      data = await _storage.read(key: userKey);
    }
    if (data == null) return null;
    return _processDateFields(jsonDecode(data));
  }

  // ユーザーデータを削除
  static Future<void> deleteUserData() async {
    if (kIsWeb) {
      html.window.localStorage.remove(userKey);
    } else {
      await _storage.delete(key: userKey);
    }
  }

  // ネットワーク接続を確認
  static Future<void> _checkConnection() async {
    if (!await NetworkUtils.isConnected()) {
      throw Exception(_errorMessages['network_error']!);
    }
  }

  // 認証状態を確認
  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  // ユーザー情報を取得（バーコード指定）
  static Future<Map<String, dynamic>> getUser(String barcode) async {
    try {
      await _checkConnection();

      final response = await http.get(
        Uri.parse('$baseUrl/users/$barcode'),
        headers: {'Accept': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception(_errorMessages['timeout_error']!);
        },
      );

      if (response.statusCode == 200) {
        return _processDateFields(json.decode(response.body));
      } else {
        throw _handleErrorResponse(response);
      }
    } on http.ClientException catch (e) {
      throw Exception(_errorMessages['network_error']!);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['unknown_error']!);
    }
  }

  // 会員登録
  static Future<Map<String, dynamic>> registerUser(
      RegistrationModel user) async {
    try {
      await _checkConnection();

      final response = await http
          .post(
        Uri.parse('$baseUrl/users'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(user.toJson()),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception(_errorMessages['timeout_error']!);
        },
      );

      if (response.statusCode == 201) {
        return _processDateFields(json.decode(response.body));
      } else {
        throw _handleErrorResponse(response);
      }
    } on http.ClientException catch (e) {
      throw Exception(_errorMessages['network_error']!);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['unknown_error']!);
    }
  }

  // ログイン（LoginModel使用）
  static Future<Map<String, dynamic>> loginWithModel(
      LoginModel credentials) async {
    return await login(credentials.email, credentials.password);
  }

  // ログイン
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      await _checkConnection();

      final response = await http
          .post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception(_errorMessages['timeout_error']!);
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['token'] == null) {
          throw Exception(_errorMessages['server_error']!);
        }

        // トークンとユーザーデータを保存
        await saveToken(data['token']);

        if (data['user'] != null) {
          await saveUserData(data['user']);
        }

        return _processDateFields(data);
      } else if (response.statusCode == 422) {
        // バリデーションエラーの詳細を表示
        final error = json.decode(response.body);

        if (error['errors'] != null) {
          final errors = error['errors'] as Map<String, dynamic>;
          final errorMessages = <String>[];

          // エラーフィールドごとにメッセージを整理
          if (errors['email'] != null) {
            final emailErrors = errors['email'] as List;
            errorMessages.addAll(emailErrors.cast<String>());
          }

          if (errors['password'] != null) {
            final passwordErrors = errors['password'] as List;
            errorMessages.addAll(passwordErrors.cast<String>());
          }

          // その他のエラーも含める
          errors.forEach((field, messages) {
            if (field != 'email' && field != 'password' && messages is List) {
              errorMessages.addAll(messages.cast<String>());
            }
          });

          throw Exception(errorMessages.join(', '));
        } else if (error['debug'] != null) {
          // デバッグ情報を含むエラーメッセージ
          final debug = error['debug'] as Map<String, dynamic>;
          final debugInfo =
              debug.entries.map((e) => '${e.key}: ${e.value}').join(', ');
          throw Exception('${error['message']} (Debug: $debugInfo)');
        } else {
          throw Exception(error['message'] ?? '入力内容に誤りがあります');
        }
      } else {
        throw _handleErrorResponse(response);
      }
    } on http.ClientException catch (e) {
      // CORSエラーの詳細を確認
      if (e.toString().contains('CORS') || e.toString().contains('blocked')) {
        throw Exception('CORSエラー: サーバーとの接続がブロックされています。サーバーが起動しているか確認してください。');
      }
      throw Exception(_errorMessages['network_error']!);
    } catch (e) {
      if (e is FormatException) {
        throw Exception('サーバーからの応答が不正です');
      }
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['unknown_error']!);
    }
  }

  // ログアウト
  static Future<void> logout() async {
    try {
      await _checkConnection();

      final token = await getToken();
      if (token == null) return;

      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception(_errorMessages['timeout_error']!);
        },
      );

      if (response.statusCode == 200 || response.statusCode == 401) {
        // ローカルストレージからデータを削除
        await deleteToken();
        await deleteUserData();
      } else {
        throw _handleErrorResponse(response);
      }
    } on http.ClientException catch (e) {
      // エラーが発生してもローカルストレージはクリア
      await deleteToken();
      await deleteUserData();
      throw Exception(_errorMessages['network_error']!);
    } catch (e) {
      // エラーが発生してもローカルストレージはクリア
      await deleteToken();
      await deleteUserData();
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['unknown_error']!);
    }
  }

  // 認証済みリクエスト用のヘッダーを取得
  static Future<Map<String, String>> getAuthHeaders() async {
    try {
      await _checkConnection();

      final token = await getToken();
      if (token == null) {
        throw Exception(_errorMessages['token_invalid']!);
      }

      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['unknown_error']!);
    }
  }

  // トークンの有効性を確認
  static Future<bool> validateToken() async {
    try {
      await _checkConnection();

      final token = await getToken();
      if (token == null) return false;

      final response = await http.get(
        Uri.parse('$baseUrl/user'), // ユーザー情報を取得するエンドポイント
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception(_errorMessages['timeout_error']!);
        },
      );

      if (response.statusCode == 200) {
        // ユーザーデータを更新
        final userData = jsonDecode(response.body);
        await saveUserData(userData);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // パスワードリセットリクエスト
  static Future<void> requestPasswordReset(String email) async {
    try {
      await _checkConnection();

      final response = await http
          .post(
        Uri.parse('$baseUrl/password/reset'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception(_errorMessages['timeout_error']!);
        },
      );

      if (response.statusCode != 200) {
        throw _handleErrorResponse(response);
      }
    } on http.ClientException catch (e) {
      throw Exception(_errorMessages['network_error']!);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['unknown_error']!);
    }
  }
}
