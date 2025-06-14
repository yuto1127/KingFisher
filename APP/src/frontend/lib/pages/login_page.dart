import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart' show kDebugMode; // デバッグモード判定用
import 'package:provider/provider.dart';
import '../models/login_model.dart';
import '../services/auth_api.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _model = LoginModel();
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  // 入力フィールドのデコレーション
  InputDecoration _getInputDecoration(String label,
      {IconData? suffixIcon, VoidCallback? onSuffixIconPressed}) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffixIcon != null
          ? IconButton(
              icon: Icon(suffixIcon),
              onPressed: onSuffixIconPressed,
            )
          : null,
    );
  }

  // メールアドレスのバリデーション
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '必須項目です';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return '有効なメールアドレスを入力してください';
    }
    return null;
  }

  // パスワードのバリデーション
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '必須項目です';
    }
    if (value.length < 8) {
      return 'パスワードは8文字以上である必要があります';
    }
    return null;
  }

  // フォーム送信
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // AuthApiを使用してログイン
      final response = await AuthApi.login(_model.email, _model.password);

      if (mounted) {
        // ログイン成功時にAuthProviderの状態を更新
        Provider.of<AuthProvider>(context, listen: false)
            .login(response['token']);

        // ログイン成功後、ホームページに遷移
        context.go('/');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF009a73), Color(0xFF006B4F)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ロゴまたはアプリ名
                    const Icon(
                      Icons.account_circle,
                      size: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'KingFisher',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // ログインフォーム
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (_errorMessage != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              TextFormField(
                                decoration: _getInputDecoration('メールアドレス'),
                                keyboardType: TextInputType.emailAddress,
                                validator: _validateEmail,
                                onSaved: (value) => _model.email = value ?? '',
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                decoration: _getInputDecoration(
                                  'パスワード',
                                  suffixIcon: _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  onSuffixIconPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                obscureText: _obscurePassword,
                                validator: _validatePassword,
                                onSaved: (value) =>
                                    _model.password = value ?? '',
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: _isLoading ? null : _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF009a73),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : const Text('ログイン'),
                              ),
                              // デバッグモードの場合のみスキップボタンを表示
                              if (kDebugMode) ...[
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: () {
                                    // デバッグ用の仮のトークンを設定
                                    Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .login('debug_token');
                                    context.go('/');
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.grey,
                                  ),
                                  child: const Text(
                                    '[DEBUG] ログインをスキップ',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 新規登録リンク
                    TextButton(
                      onPressed: () => context.go('/register'),
                      child: const Text(
                        '新規会員登録はこちら',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
