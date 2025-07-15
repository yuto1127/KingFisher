import 'dart:convert';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import '../utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthApi {
  static const String baseUrl = NetworkUtils.baseUrl;
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  /// トークン保存
  static Future<void> saveToken(String token) async {
    html.window.localStorage[tokenKey] = token;
    html.window.sessionStorage[tokenKey] = token;
  }

  /// トークン取得
  static Future<String?> getToken() async {
    String? token = html.window.localStorage[tokenKey];
    token ??= html.window.sessionStorage[tokenKey];
    return token;
  }

  /// トークン削除
  static Future<void> deleteToken() async {
    html.window.localStorage.remove(tokenKey);
    html.window.sessionStorage.remove(tokenKey);
  }

  /// ユーザーデータ保存
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final jsonData = jsonEncode(userData);
    html.window.localStorage[userKey] = jsonData;
    html.window.sessionStorage[userKey] = jsonData;
  }

  /// ユーザーデータ取得
  static Future<Map<String, dynamic>?> getUserData() async {
    String? jsonData = html.window.localStorage[userKey];
    jsonData ??= html.window.sessionStorage[userKey];
    if (jsonData != null) {
      return jsonDecode(jsonData);
    }
    return null;
  }

  /// ユーザーデータ削除
  static Future<void> deleteUserData() async {
    html.window.localStorage.remove(userKey);
    html.window.sessionStorage.remove(userKey);
  }

  /// ログインAPI
  static Future<Map<String, dynamic>> login(
      BuildContext context, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data['token'] != null) {
        await saveToken(data['token']);
      }
      if (data['user'] != null) {
        await saveUserData(data['user']);
      }
      if (context.mounted) {
        context.go('/');
      }
      return {'success': true, 'data': data};
    } else {
      final errorData = jsonDecode(utf8.decode(response.bodyBytes));
      return {'success': false, 'error': errorData['error'] ?? 'ログインに失敗しました'};
    }
  }

  /// ログアウトAPI
  static Future<void> logout() async {
    await deleteToken();
    await deleteUserData();
  }

  /// 認証付きヘッダーを取得
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    if (token == null) throw Exception('認証トークンがありません');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// バーコードでユーザー情報を取得
  static Future<Map<String, dynamic>> getUser(String barcode) async {
    final headers = await getAuthHeaders();
    final response = await http.get(
      Uri.parse('${NetworkUtils.baseUrl}/api/users/barcode/$barcode'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('ユーザー情報の取得に失敗しました: ${response.statusCode}');
    }
  }
}
