import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../layouts/main_layout.dart';
import '../models/registration_model.dart';
import '../utils/network_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// 郵便番号用のカスタムフォーマッター
class _PostalCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 数字以外を除去
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // 7桁を超える場合は切り詰める
    final limitedText = text.length > 7 ? text.substring(0, 7) : text;

    return newValue.copyWith(
      text: limitedText,
      selection: TextSelection.collapsed(offset: limitedText.length),
    );
  }
}

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
  final _postalCodeController = TextEditingController();
  final _prefectureController = TextEditingController();
  final _cityController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoadingAddress = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _postalCodeController.dispose();
    _prefectureController.dispose();
    _cityController.dispose();
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

  // メールアドレスの重複チェック
  Future<String?> _validateEmailUnique(String? value) async {
    if (value == null || value.isEmpty) {
      return '必須項目です';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return '有効なメールアドレスを入力してください';
    }

    // 統合APIでバリデーションを行うため、ここでは基本的な形式チェックのみ
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
    if (!RegExp(r'^\d{7}$').hasMatch(value)) {
      return '郵便番号は7桁の数字で入力してください';
    }
    return null;
  }

  // 郵便番号から住所を取得
  Future<void> _fetchAddressFromPostalCode(String postalCode) async {
    if (postalCode.length != 7) return; // 7桁でない場合は処理しない

    setState(() {
      _isLoadingAddress = true;
    });

    try {
      // 郵便番号検索API（郵便番号データ配信サービス）
      final response = await http.get(
        Uri.parse(
            'https://zipcloud.ibsnet.co.jp/api/search?zipcode=$postalCode'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 200 &&
            data['results'] != null &&
            data['results'].isNotEmpty) {
          final result = data['results'][0];
          final address1 = result['address1'] ?? ''; // 都道府県
          final address2 = result['address2'] ?? ''; // 市区町村
          final address3 = result['address3'] ?? ''; // 町域

          setState(() {
            _prefectureController.text = address1;
            _cityController.text = address2;
            _model.prefecture = address1;
            _model.city = address2;
          });
        }
      }
    } catch (e) {
      // エラーが発生してもユーザーに通知しない（静かに失敗）
      print('郵便番号検索エラー: $e');
    } finally {
      setState(() {
        _isLoadingAddress = false;
      });
    }
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
    if (_model.barthDay == null) {
      return '生年月日を選択してください';
    }
    return null;
  }

  // フォーム送信
  Future<void> _submitForm() async {
    // 生年月日のバリデーション
    if (_model.barthDay == null) {
      setState(() {
        _errorMessage = '生年月日を選択してください';
      });
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 統合登録APIを使用
      final registrationData = {
        'name': _model.name,
        'gender': _model.gender,
        'barth_day': _model.barthDay?.toIso8601String(),
        'phone_number': _model.phoneNumber,
        'email': _model.email,
        'password': _model.password,
        'postal_code': _model.postalCode,
        'prefecture': _model.prefecture,
        'city': _model.city,
        'address_line1': _model.addressLine1,
        'address_line2': _model.addressLine2,
      };

      final response = await http.post(
        Uri.parse('${NetworkUtils.baseUrl}/api/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(registrationData),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? '会員登録が完了しました'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('#/login');
        }
      } else {
        final errorData = jsonDecode(response.body);
        String errorMessage = '会員登録に失敗しました';

        if (errorData['errors'] != null) {
          final errors = errorData['errors'] as Map<String, dynamic>;
          errorMessage = errors.values.first
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '');
        } else if (errorData['error'] != null) {
          errorMessage = errorData['error'];
        }

        setState(() {
          _errorMessage = errorMessage;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'ネットワークエラーが発生しました: ${e.toString()}';
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
                              InkWell(
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now().subtract(
                                        const Duration(days: 6570)), // 18歳
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                    locale: const Locale('ja', 'JP'), // 日本語ロケール
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary:
                                                Color(0xFF009a73), // プライマリカラー
                                            onPrimary: Colors.white,
                                            surface: Colors.white,
                                            onSurface: Colors.black,
                                          ),
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  const Color(0xFF009a73),
                                            ),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _model.barthDay = picked;
                                    });
                                  }
                                },
                                child: InputDecorator(
                                  decoration: _getInputDecoration('生年月日'),
                                  child: Text(
                                    _model.barthDay != null
                                        ? '${_model.barthDay!.year}年${_model.barthDay!.month}月${_model.barthDay!.day}日'
                                        : '生年月日を選択してください',
                                    style: TextStyle(
                                      color: _model.barthDay != null
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
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
                                controller: _postalCodeController,
                                decoration:
                                    _getInputDecoration('郵便番号（7桁の数字）').copyWith(
                                  suffixIcon: _isLoadingAddress
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(7),
                                  _PostalCodeFormatter(),
                                ],
                                validator: _validatePostalCode,
                                onChanged: (value) {
                                  if (value.length == 7) {
                                    // 7桁になったら検索
                                    _fetchAddressFromPostalCode(value);
                                  }
                                },
                                onSaved: (value) =>
                                    _model.postalCode = value ?? '',
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _prefectureController,
                                decoration: _getInputDecoration('都道府県'),
                                validator: _validateRequired,
                                onChanged: (value) => _model.prefecture = value,
                                onSaved: (value) =>
                                    _model.prefecture = value ?? '',
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _cityController,
                                decoration: _getInputDecoration('市区町村'),
                                validator: _validateRequired,
                                onChanged: (value) => _model.city = value,
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
