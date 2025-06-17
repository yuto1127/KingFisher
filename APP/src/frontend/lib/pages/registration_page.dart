import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../layouts/main_layout.dart';
import '../models/registration_model.dart';
import '../services/users_api.dart';
import '../services/user_passes_api.dart';
import 'dart:html' as html;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _model = RegistrationModel();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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

  // バリデーションメッセージ
  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return '必須項目です';
    }
    return null;
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

  // 電話番号のバリデーション
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return '必須項目です';
    }
    if (!RegExp(r'^\d{10,11}$').hasMatch(value)) {
      return '有効な電話番号を入力してください（10-11桁の数字）';
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
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}').hasMatch(value)) {
      return 'パスワードは英字と数字を含む必要があります';
    }
    return null;
  }

  // 確認用パスワードのバリデーション
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return '必須項目です';
    }
    if (value != _passwordController.text) {
      return 'パスワードが一致しません';
    }
    return null;
  }

  // 郵便番号のバリデーション
  String? _validatePostalCode(String? value) {
    if (value == null || value.isEmpty) {
      return '必須項目です';
    }
    if (!RegExp(r'^\d{3}-\d{4}$').hasMatch(value)) {
      return '郵便番号は###-####形式で入力してください';
    }
    return null;
  }

  // 性別のバリデーション
  String? _validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return '必須項目です';
    }
    return null;
  }

  // 生年月日のバリデーション
  String? _validateBarthDay(String? value) {
    if (value == null || value.isEmpty) {
      return '必須項目です';
    }
    try {
      DateTime.parse(value);
    } catch (e) {
      return '有効な日付を入力してください';
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
      // ユーザー情報の登録
      final userData = {
        'name': _model.name,
        'gender': _model.gender,
        'barth_day': _model.barthDay?.toIso8601String(),
        'phone_number': _model.phoneNumber,
        'postal_code': _model.postalCode,
        'prefecture': _model.prefecture,
        'city': _model.city,
        'address_line1': _model.addressLine1,
        'address_line2': _model.addressLine2,
      };

      final createdUser = await UsersApi.create(userData);
      final userId = createdUser['id'];
      // ユーザーパスの登録
      // print('$userId, ${_model.email}, ${_model.password}');
      final userPassData = {
        'user_id': userId,
        'email': _model.email,
        'password': _model.password,
      };

      await UserPassesApi.create(userPassData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('会員登録が完了しました'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('#/login');
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
    return MainLayout(
      showBottomNav: false,
      child: Column(
        children: [
          AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.go('#/login');
              },
            ),
            title: const Text('会員登録'),
            backgroundColor: const Color(0xFF009a73),
            foregroundColor: Colors.white,
          ),
          Expanded(
            child: SingleChildScrollView(
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
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '基本情報',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                decoration: _getInputDecoration('お名前'),
                                validator: _validateRequired,
                                onSaved: (value) => _model.name = value ?? '',
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                decoration: _getInputDecoration('性別'),
                                value: _model.gender.isEmpty
                                    ? null
                                    : _model.gender,
                                items: const [
                                  DropdownMenuItem(
                                      value: '男性', child: Text('男性')),
                                  DropdownMenuItem(
                                      value: '女性', child: Text('女性')),
                                  DropdownMenuItem(
                                      value: 'その他', child: Text('その他')),
                                ],
                                validator: _validateGender,
                                onChanged: (value) {
                                  setState(() {
                                    _model.gender = value ?? '';
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                decoration:
                                    _getInputDecoration('生年月日（YYYY-MM-DD）'),
                                validator: _validateBarthDay,
                                onSaved: (value) {
                                  if (value != null && value.isNotEmpty) {
                                    _model.barthDay = DateTime.parse(value);
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                decoration: _getInputDecoration('メールアドレス'),
                                keyboardType: TextInputType.emailAddress,
                                validator: _validateEmail,
                                onSaved: (value) => _model.email = value ?? '',
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                decoration: _getInputDecoration('電話番号（ハイフンなし）'),
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: _validatePhone,
                                onSaved: (value) =>
                                    _model.phoneNumber = value ?? '',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '住所情報',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                decoration:
                                    _getInputDecoration('郵便番号（###-####）'),
                                validator: _validatePostalCode,
                                onSaved: (value) =>
                                    _model.postalCode = value ?? '',
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                decoration: _getInputDecoration('都道府県'),
                                validator: _validateRequired,
                                onSaved: (value) =>
                                    _model.prefecture = value ?? '',
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                decoration: _getInputDecoration('市区町村'),
                                validator: _validateRequired,
                                onSaved: (value) => _model.city = value ?? '',
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                decoration: _getInputDecoration('番地・建物名'),
                                validator: _validateRequired,
                                onSaved: (value) =>
                                    _model.addressLine1 = value ?? '',
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                decoration: _getInputDecoration('建物名・部屋番号（任意）'),
                                onSaved: (value) =>
                                    _model.addressLine2 = value ?? '',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'パスワード設定',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passwordController,
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
                              const SizedBox(height: 8),
                              const Text(
                                '※ パスワードは8文字以上で、英字と数字を含める必要があります',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _confirmPasswordController,
                                decoration: _getInputDecoration(
                                  'パスワード（確認）',
                                  suffixIcon: _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  onSuffixIconPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                                obscureText: _obscureConfirmPassword,
                                validator: _validateConfirmPassword,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF009a73),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text('登録する'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
