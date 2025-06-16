import 'package:flutter/material.dart';
import '../services/auth_api.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _token;

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    _token = await AuthApi.getToken();
    _isAuthenticated = _token != null;
    notifyListeners();
  }

  void login(String token) {
    _token = token;
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _token = null;
    _isAuthenticated = false;
    AuthApi.deleteToken();
    notifyListeners();
  }
}
