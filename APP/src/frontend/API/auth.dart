import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/utils/network_utils.dart';

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

  // 安全なストレージのインスタンスを作成
  static const _storage = FlutterSecureStorage(
    // iOSのキーチェーン設定
    aOptions: AndroidOptions(
      encryptedSharedPreferences:
          true, // Android 6.0以上で暗号化されたSharedPreferencesを使用
    ),
    // AndroidのKeyStore設定
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock, // デバイスの初回アンロック後にアクセス可能
    ),
  );

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
    await _storage.write(key: tokenKey, value: token);
  }

  // ユーザーデータを保存
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _storage.write(key: userKey, value: jsonEncode(userData));
  }

  // トークンを取得
  static Future<String?> getToken() async {
    return await _storage.read(key: tokenKey);
  }

  // ユーザーデータを取得
  static Future<Map<String, dynamic>?> getUserData() async {
    final data = await _storage.read(key: userKey);
    if (data == null) return null;
    return _processDateFields(jsonDecode(data));
  }

  // トークンとユーザーデータを削除
  static Future<void> deleteToken() async {
    await Future.wait([
      _storage.delete(key: tokenKey),
      _storage.delete(key: userKey),
    ]);
  }

  // ネットワーク接続を確認
  static Future<void> _checkConnection() async {
    if (!await NetworkUtils.isConnected()) {
      throw Exception(_errorMessages['network_error']!);
    }
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

      if (response.statusCode == 200) {
        await deleteToken();
      } else if (response.statusCode == 401) {
        await deleteToken();
        throw Exception(_errorMessages['token_expired']!);
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
