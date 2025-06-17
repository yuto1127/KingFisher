import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _token;

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;

  void login(String token) {
    _token = token;
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _token = null;
    _isAuthenticated = false;
    notifyListeners();
  }
} 