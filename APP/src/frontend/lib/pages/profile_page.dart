import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../layouts/main_layout.dart';
import '../providers/auth_provider.dart';
import '../services/users_api.dart';
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

// 性別のマッピング
const genderMap = {
  'male': '男性',
  'female': '女性',
  'other': 'その他',
  '男性': 'male',
  '女性': 'female',
  'その他': 'other',
};

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  bool _isLoading = false;
  bool _isLoadingAddress = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _prefectureController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  String? _selectedGender;
  DateTime? _selectedBirthDay;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final authProvider = context.read<AuthProvider>();
    final userData = authProvider.userData;

    if (userData != null) {
      _nameController.text = userData['name']?.toString() ?? '';
      // 電話番号からハイフンを除去して表示
      final phoneNumber = userData['phone_number']?.toString() ?? '';
      _phoneController.text = phoneNumber.replaceAll('-', '');
      // 郵便番号からハイフンを除去して表示
      final postalCode = userData['postal_code']?.toString() ?? '';
      _postalCodeController.text = postalCode.replaceAll('-', '');
      _prefectureController.text = userData['prefecture']?.toString() ?? '';
      _cityController.text = userData['city']?.toString() ?? '';
      _addressController.text = userData['address_line1']?.toString() ?? '';

      // 生年月日の初期化
      if (userData['barth_day'] != null) {
        try {
          _selectedBirthDay = DateTime.parse(userData['barth_day'].toString());
        } catch (e) {
          _selectedBirthDay = null;
        }
      }

      // 性別を英語の値で初期化
      final gender = userData['gender']?.toString();
      if (gender == 'male' || gender == '男性') {
        _selectedGender = 'male';
      } else if (gender == 'female' || gender == '女性') {
        _selectedGender = 'female';
      } else if (gender == 'other' || gender == 'その他') {
        _selectedGender = 'other';
      } else {
        _selectedGender = null; // 不明な値の場合はnull
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _postalCodeController.dispose();
    _prefectureController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveUserData() async {
    // 生年月日のバリデーション
    if (_selectedBirthDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('生年月日を選択してください'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final userId = authProvider.userId;

      if (userId == null) {
        throw Exception('ユーザーIDが取得できません');
      }

      final updateData = {
        'name': _nameController.text.trim(),
        'phone_number': _phoneController.text.trim().replaceAll('-', ''),
        'postal_code': _postalCodeController.text.trim().replaceAll('-', ''),
        'prefecture': _prefectureController.text.trim(),
        'city': _cityController.text.trim(),
        'address_line1': _addressController.text.trim(),
        'barth_day': _selectedBirthDay != null
            ? "--"
                .replaceFirst(
                    '', _selectedBirthDay!.year.toString().padLeft(4, '0'))
                .replaceFirst(
                    '', _selectedBirthDay!.month.toString().padLeft(2, '0'))
                .replaceFirst(
                    '', _selectedBirthDay!.day.toString().padLeft(2, '0'))
            : null,
        if (_selectedGender != null) 'gender': _selectedGender, // 英語の値で送信
      };

      await UsersApi.updateUser(userId, updateData);

      // 成功メッセージを表示
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ユーザー情報を更新しました。ログアウトします。'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // 少し待ってからログアウト
      await Future.delayed(const Duration(seconds: 2));

      // ログアウトしてログインページに遷移
      if (mounted) {
        await authProvider.logout();
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('更新に失敗しました: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isEditing = false;
        });
      }
    }
  }

  void _cancelEdit() {
    _initializeControllers();
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('プロフィール'),
          actions: [
            if (!_isEditing)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
                tooltip: '編集',
              ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _showLogoutDialog(context),
              tooltip: 'ログアウト',
            ),
          ],
        ),
        body: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            final userData = authProvider.userData;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ユーザー情報カード
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'ユーザー情報',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (_isEditing)
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed:
                                            _isLoading ? null : _cancelEdit,
                                        child: const Text('キャンセル'),
                                      ),
                                      ElevatedButton(
                                        onPressed:
                                            _isLoading ? null : _saveUserData,
                                        child: _isLoading
                                            ? const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : const Text('保存'),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (userData != null) ...[
                              if (_isEditing) ...[
                                _buildEditForm(),
                              ] else ...[
                                _buildInfoRow(
                                    'メールアドレス', authProvider.userEmail ?? '不明'),
                                _buildInfoRow(
                                    '名前', authProvider.userName ?? '不明'),
                                _buildInfoRow('ユーザーID',
                                    authProvider.userId?.toString() ?? '不明'),
                                _buildInfoRow(
                                    'ロール名', authProvider.roleName ?? '不明'),
                                _buildInfoRow(
                                    'ロールタイプ', authProvider.roleType ?? '不明'),
                                _buildInfoRow(
                                    '作成日', userData['created_at'] ?? '不明'),
                                if (userData['gender'] != null)
                                  _buildInfoRow(
                                      '性別',
                                      genderMap[
                                              userData['gender'].toString()] ??
                                          userData['gender'].toString()),
                                if (userData['barth_day'] != null)
                                  _buildInfoRow(
                                      '生年月日',
                                      _formatBirthDay(
                                          userData['barth_day'].toString())),
                                if (userData['phone_number'] != null)
                                  _buildInfoRow(
                                      '電話番号',
                                      userData['phone_number']
                                          .toString()
                                          .replaceAll('-', '')),
                                if (userData['postal_code'] != null)
                                  _buildInfoRow(
                                      '郵便番号',
                                      userData['postal_code']
                                          .toString()
                                          .replaceAll('-', '')),
                                if (userData['prefecture'] != null)
                                  _buildInfoRow('都道府県',
                                      userData['prefecture'].toString()),
                                if (userData['city'] != null)
                                  _buildInfoRow(
                                      '市区町村', userData['city'].toString()),
                                if (userData['address_line1'] != null)
                                  _buildInfoRow('住所',
                                      userData['address_line1'].toString()),
                              ],
                            ] else ...[
                              const Text('ユーザー情報を読み込み中...'),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // アクションカード
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'アクション',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              leading: const Icon(Icons.settings),
                              title: const Text('設定'),
                              onTap: () {
                                // 設定ページへの遷移
                                context.go('/settings');
                              },
                            ),
                            ListTile(
                              leading:
                                  const Icon(Icons.logout, color: Colors.red),
                              title: const Text('ログアウト',
                                  style: TextStyle(color: Colors.red)),
                              onTap: () => _showLogoutDialog(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // 基本情報カード
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
                    controller: _nameController,
                    decoration: _getInputDecoration('お名前'),
                    validator: _validateRequired,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: _getInputDecoration('性別'),
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('男性')),
                      DropdownMenuItem(value: 'female', child: Text('女性')),
                      DropdownMenuItem(value: 'other', child: Text('その他')),
                    ],
                    validator: _validateGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedBirthDay ??
                            DateTime.now()
                                .subtract(const Duration(days: 6570)), // 18歳
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        locale: const Locale('ja', 'JP'), // 日本語ロケール
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF009a73), // プライマリカラー
                                onPrimary: Colors.white,
                                surface: Colors.white,
                                onSurface: Colors.black,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF009a73),
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedBirthDay = picked;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: _getInputDecoration('生年月日'),
                      child: Text(
                        _selectedBirthDay != null
                            ? '${_selectedBirthDay!.year}年${_selectedBirthDay!.month}月${_selectedBirthDay!.day}日'
                            : '生年月日を選択してください',
                        style: TextStyle(
                          color: _selectedBirthDay != null
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: _getInputDecoration('電話番号（ハイフンなし）'),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: _validatePhone,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 住所情報カード
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
                    decoration: _getInputDecoration('郵便番号（7桁の数字）').copyWith(
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
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _prefectureController,
                    decoration: _getInputDecoration('都道府県'),
                    validator: _validateRequired,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cityController,
                    decoration: _getInputDecoration('市区町村'),
                    validator: _validateRequired,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: _getInputDecoration('番地・建物名'),
                    validator: _validateRequired,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ログアウト'),
          content: const Text('ログアウトしますか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await Provider.of<AuthProvider>(context, listen: false)
                      .logout();
                  if (context.mounted) {
                    context.go('/login');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('ログアウトエラー: $e')),
                    );
                  }
                }
              },
              child: const Text('ログアウト', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
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

          setState(() {
            _prefectureController.text = address1;
            _cityController.text = address2;
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

  // 性別のバリデーション
  String? _validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return '必須項目です';
    }
    return null;
  }

  // 生年月日のバリデーション
  String? _validateBirthDay(String? value) {
    if (_selectedBirthDay == null) {
      return '生年月日を選択してください';
    }
    return null;
  }

  String _formatBirthDay(String barthDay) {
    try {
      final date = DateTime.parse(barthDay);
      return '${date.year}年${date.month}月${date.day}日';
    } catch (e) {
      return '生年月日を選択してください';
    }
  }
}
