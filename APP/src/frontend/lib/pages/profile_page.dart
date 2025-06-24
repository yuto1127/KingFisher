import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../layouts/main_layout.dart';
import '../providers/auth_provider.dart';
import '../services/users_api.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _prefectureController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  String? _selectedGender;

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
      _phoneController.text = userData['phone_number']?.toString() ?? '';
      _postalCodeController.text = userData['postal_code']?.toString() ?? '';
      _prefectureController.text = userData['prefecture']?.toString() ?? '';
      _cityController.text = userData['city']?.toString() ?? '';
      _addressController.text = userData['address_line1']?.toString() ?? '';

      // 性別を英語の値で初期化
      final gender = userData['gender']?.toString();
      if (gender == 'male' || gender == '女性') {
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
        'phone_number': _phoneController.text.trim(),
        'postal_code': _postalCodeController.text.trim(),
        'prefecture': _prefectureController.text.trim(),
        'city': _cityController.text.trim(),
        'address_line1': _addressController.text.trim(),
        if (_selectedGender != null) 'gender': _selectedGender,
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
                                if (userData['phone_number'] != null)
                                  _buildInfoRow('電話番号',
                                      userData['phone_number'].toString()),
                                if (userData['postal_code'] != null)
                                  _buildInfoRow('郵便番号',
                                      userData['postal_code'].toString()),
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
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: '名前',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '名前を入力してください';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: const InputDecoration(
              labelText: '性別',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'male', child: Text('男性')),
              DropdownMenuItem(value: 'female', child: Text('女性')),
              DropdownMenuItem(value: 'other', child: Text('その他')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: '電話番号',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _postalCodeController,
            decoration: const InputDecoration(
              labelText: '郵便番号',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _prefectureController,
            decoration: const InputDecoration(
              labelText: '都道府県',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cityController,
            decoration: const InputDecoration(
              labelText: '市区町村',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: '住所',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
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
}
