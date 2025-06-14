import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/utils/network_utils.dart';

class AuthApi {
  static const String baseUrl = 'http://54.165.66.148//api';
  static const String tokenKey = 'auth_token';

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

  // トークンを保存
  static Future<void> saveToken(String token) async {
    await _storage.write(key: tokenKey, value: token);
  }

  // トークンを取得
  static Future<String?> getToken() async {
    return await _storage.read(key: tokenKey);
  }

  // トークンを削除
  static Future<void> deleteToken() async {
    await _storage.delete(key: tokenKey);
  }

  // ネットワーク接続を確認
  static Future<void> _checkConnection() async {
    if (!await NetworkUtils.isConnected()) {
      throw Exception('インターネット接続がありません。接続を確認してください。');
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
          throw Exception('サーバーへの接続がタイムアウトしました。');
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] == null) {
          throw Exception('認証トークンが取得できませんでした。');
        }
        await saveToken(data['token']);
        return data;
      } else if (response.statusCode == 401) {
        throw Exception('メールアドレスまたはパスワードが正しくありません。');
      } else if (response.statusCode == 422) {
        final errors = jsonDecode(response.body)['errors'];
        throw Exception(errors.values.first.first ?? '入力内容に誤りがあります。');
      } else {
        throw Exception('ログインに失敗しました。(${response.statusCode})');
      }
    } on http.ClientException catch (e) {
      throw Exception('サーバーに接続できません。(${e.message})');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('予期せぬエラーが発生しました。');
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
          throw Exception('サーバーへの接続がタイムアウトしました。');
        },
      );

      if (response.statusCode == 200) {
        await deleteToken();
      } else if (response.statusCode == 401) {
        await deleteToken(); // トークンが無効な場合は削除
        throw Exception('セッションが切れました。再度ログインしてください。');
      } else {
        throw Exception('ログアウトに失敗しました。(${response.statusCode})');
      }
    } on http.ClientException catch (e) {
      throw Exception('サーバーに接続できません。(${e.message})');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('予期せぬエラーが発生しました。');
    }
  }

  // 認証済みリクエスト用のヘッダーを取得
  static Future<Map<String, String>> getAuthHeaders() async {
    try {
      await _checkConnection();

      final token = await getToken();
      if (token == null) {
        throw Exception('認証情報が見つかりません。再度ログインしてください。');
      }

      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('認証ヘッダーの取得に失敗しました。');
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
          throw Exception('サーバーへの接続がタイムアウトしました。');
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
