import 'package:flutter/material.dart';

class IconProvider extends ChangeNotifier {
  IconData _loginIcon = Icons.account_circle;

  IconData get loginIcon => _loginIcon;

  void setLoginIcon(IconData icon) {
    _loginIcon = icon;
    notifyListeners();
  }
} 