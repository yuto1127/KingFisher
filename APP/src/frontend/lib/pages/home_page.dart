// Flutterの基本ウィジェットとマテリアルデザイン
import 'package:flutter/material.dart';
// ルーティング用のパッケージ
import 'package:go_router/go_router.dart';
// QRコード生成用のパッケージ
import 'package:qr_flutter/qr_flutter.dart';
// 共通レイアウト
import '../layouts/main_layout.dart';
// 認証プロバイダー
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:flutter/foundation.dart';

/// アプリケーションのホームページ
/// メインのナビゲーションとQRコード表示機能を提供
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _adminClickCount = 0;
  static const int _requiredClicks = 10;
  final _passwordController = TextEditingController();
  static const String _adminPassword = 'cid'; // 管理者パスワード

  void _handleAdminClick() {
    setState(() {
      _adminClickCount++;
      if (_adminClickCount >= _requiredClicks) {
        _showPasswordDialog();
        _adminClickCount = 0;
      }
    });
  }

  void _showPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('管理者認証'),
        content: TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'パスワード',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _passwordController.clear();
            },
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              if (_passwordController.text == _adminPassword) {
                Navigator.pop(context);
                _passwordController.clear();
                context.go('/admin');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('パスワードが正しくありません'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('認証'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: [
          // アプリバー（上部のナビゲーションバー）
          AppBar(
            title: const Text('ホーム'),
            backgroundColor: Color(0xFF009a73), // 緑色のテーマカラー
            foregroundColor: Colors.white, // テキストを白色に
            actions: [
              // 管理者ページへの遷移ボタン
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextButton(
                  onPressed: _handleAdminClick,
                  child: const Text(''),
                ),
              ),
            ],
          ),
          // メインコンテンツエリア
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ページタイトル
                  // Text(
                  //   'ホームページ',
                  //   style: TextStyle(fontSize: 30),
                  // ),
                  //SizedBox(height: 20), // 垂直方向の余白

                  // QRコード表示ウィジェット
                  const Text(
                    '会員QRコード',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20), // 垂直方向の余白
                  QrImageView(
                    data: '210000000', // QRコードに埋め込むデータ
                    version: QrVersions.auto, // QRコードのバージョンを自動選択
                    size: 200.0, // QRコードのサイズ（ピクセル）
                  ),
                  const SizedBox(height: 20), // 垂直方向の余白

                  // デバッグ情報表示（開発時のみ）
                  if (kDebugMode) ...[
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return Card(
                          margin: const EdgeInsets.all(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'デバッグ情報',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('ユーザーID: ${authProvider.userId ?? 'N/A'}'),
                                Text('ユーザー名: ${authProvider.userName ?? 'N/A'}'),
                                Text('ロールID: ${authProvider.roleId ?? 'N/A'}'),
                                Text('ロール名: ${authProvider.roleName ?? 'N/A'}'),
                                Text('ロールタイプ: ${authProvider.roleType ?? 'N/A'}'),
                                Text('認証状態: ${authProvider.isAuthenticated ? 'ログイン中' : '未ログイン'}'),
                                if (authProvider.userData != null) ...[
                                  const SizedBox(height: 8),
                                  const Text(
                                    'ユーザーデータ:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(authProvider.userData.toString()),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],

                  // 会員登録ページへのナビゲーションボタン
                  // ElevatedButton(
                  //   onPressed: () {
                  //     context.go('/register');
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: const Color(0xFF009a73),
                  //     foregroundColor: Colors.white,
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 32,
                  //       vertical: 16,
                  //     ),
                  //   ),
                  //   child: const Text(
                  //     '新規会員登録',
                  //     style: TextStyle(fontSize: 16),
                  //   ),
                  // ),
                  // const SizedBox(height: 20),

                  // 設定ページへのナビゲーションボタン
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // 設定ページへ遷移
                  //     context.go('/settings');
                  //   },
                  //   child: const Text('設定ページへ'),
                  // ),
                  // const SizedBox(height: 10), // ボタン間の余白

                  // // プロフィールページへのナビゲーションボタン
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // プロフィールページへ遷移
                  //     context.go('/profile');
                  //   },
                  //   child: const Text('プロフィールページへ'),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
