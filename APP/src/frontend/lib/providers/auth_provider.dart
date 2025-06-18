import 'package:flutter/material.dart';
import '../services/auth_api.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _token;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;

  // アプリ起動時にローカルストレージからデータを復元
  Future<void> initializeAuth() async {
    try {
      _isLoading = true;
      notifyListeners();

      // ローカルストレージからトークンとユーザーデータを取得
      final token = await AuthApi.getToken();
      final userData = await AuthApi.getUserData();

      if (token != null && userData != null) {
        _token = token;
        _userData = userData;
        _isAuthenticated = true;
        print('Auth restored from local storage: ${userData['email']}');
      } else {
        _isAuthenticated = false;
        print('No auth data found in local storage');
      }
    } catch (e) {
      print('Error initializing auth: $e');
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ログイン処理
  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await AuthApi.login(email, password);

      if (response['token'] != null) {
        _token = response['token'];
        _userData = response['user'];
        _isAuthenticated = true;

        // ローカルストレージへの保存はAuthApiで既に実行済み
        print('Login successful: ${_userData?['email']}');
      } else {
        throw Exception('トークンが取得できませんでした');
      }
    } catch (e) {
      _isAuthenticated = false;
      _token = null;
      _userData = null;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ログアウト処理
  Future<void> logout() async {
    try {
      await AuthApi.logout();
    } catch (e) {
      print('Logout error: $e');
      // エラーが発生してもローカルストレージはクリアされる
    } finally {
      _token = null;
      _userData = null;
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  // ユーザーデータを更新
  void updateUserData(Map<String, dynamic> userData) {
    _userData = userData;
    notifyListeners();
  }

  // 認証状態をクリア（エラー時など）
  void clearAuth() {
    _token = null;
    _userData = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  // デバッグ用：ログインをスキップ
  void debugLogin() {
    _token = 'debug_token';
    _userData = {'email': 'debug@example.com', 'name': 'Debug User'};
    _isAuthenticated = true;
    notifyListeners();
  }
}
