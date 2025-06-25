import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../layouts/main_layout.dart';
import 'package:go_router/go_router.dart';
import '../services/users_api.dart';
import '../providers/auth_provider.dart';

/// ユーザー管理ページ
/// 管理者がユーザー情報を管理するためのページ
class AdminUserPage extends StatefulWidget {
  const AdminUserPage({super.key});

  @override
  State<AdminUserPage> createState() => _AdminUserPageState();
}

class _AdminUserPageState extends State<AdminUserPage> {
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final users = await UsersApi.getAll();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'ユーザー一覧の取得に失敗しました: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF009a73),
                  child: Text(
                    user['name']?[0]?.toString().toUpperCase() ?? '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['name']?.toString() ?? '名前なし',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'ID: ${user['id']}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            if (user['gender'] != null) ...[
              _buildInfoRow('性別', user['gender'].toString()),
            ],
            if (user['phone_number'] != null) ...[
              _buildInfoRow('電話番号', user['phone_number'].toString()),
            ],
            if (user['postal_code'] != null) ...[
              _buildInfoRow('郵便番号', user['postal_code'].toString()),
            ],
            if (user['prefecture'] != null) ...[
              _buildInfoRow('都道府県', user['prefecture'].toString()),
            ],
            if (user['city'] != null) ...[
              _buildInfoRow('市区町村', user['city'].toString()),
            ],
            if (user['address_line1'] != null) ...[
              _buildInfoRow('住所', user['address_line1'].toString()),
            ],
            if (user['last_login_at'] != null) ...[
              _buildInfoRow('最終ログイン', user['last_login_at'].toString()),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: [
          AppBar(
            title: const Text('ユーザー管理'),
            backgroundColor: const Color(0xFF009a73),
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/admin'),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadUsers,
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ユーザー一覧のヘッダー
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ユーザー一覧',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_users.length}件',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // ユーザー一覧の表示
                  Expanded(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : _errorMessage != null
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _errorMessage!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: _loadUsers,
                                      child: const Text('再試行'),
                                    ),
                                  ],
                                ),
                              )
                            : _users.isEmpty
                                ? const Center(
                                    child: Text(
                                      'ユーザーが見つかりません',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                : RefreshIndicator(
                                    onRefresh: _loadUsers,
                                    child: ListView.builder(
                                      itemCount: _users.length,
                                      itemBuilder: (context, index) {
                                        return _buildUserCard(_users[index]);
                                      },
                                    ),
                                  ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
