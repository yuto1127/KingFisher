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
// ポイントAPI
import '../services/points_api.dart';

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

  // ポイント関連の状態
  int _userPoints = 0;
  bool _isLoadingPoints = false;
  String? _pointsError;

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
  void initState() {
    super.initState();
    _loadUserPoints();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  /// ユーザーのポイントを読み込み
  Future<void> _loadUserPoints() async {
    setState(() {
      _isLoadingPoints = true;
      _pointsError = null;
    });

    try {
      final result = await PointsApi.getUserPoints();
      if (result['success']) {
        setState(() {
          _userPoints = result['points'] ?? 0;
          _isLoadingPoints = false;
        });
      } else {
        setState(() {
          _pointsError = result['error'];
          _isLoadingPoints = false;
        });
      }
    } catch (e) {
      setState(() {
        _pointsError = 'ポイントの取得に失敗しました: $e';
        _isLoadingPoints = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: [
          // アプリバー（上部のナビゲーションバー）
          AppBar(
            title: const Text('ホーム'),
            backgroundColor: const Color(0xFF009a73), // 緑色のテーマカラー
            foregroundColor: Colors.white, // テキストを白色に
            actions: [
              // 管理者ページへの遷移ボタン
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  // デバッグモードの場合は現在の設定を維持
                  if (kDebugMode) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextButton(
                        onPressed: _handleAdminClick,
                        child: const Text(''),
                      ),
                    );
                  }

                  // 本番モードではrole_idが1の場合のみボタンを表示
                  if (authProvider.roleId == 1) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextButton(
                        onPressed: () => context.go('/admin'),
                        child: const Text('管理者'),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF009a73),
                        ),
                      ),
                    );
                  }

                  // role_idが1でない場合は何も表示しない
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          // メインコンテンツエリア
          Expanded(
            child: SingleChildScrollView(
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
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        // ユーザーIDを取得、nullの場合はデフォルト値を表示
                        final userId =
                            authProvider.userId?.toString() ?? 'No_Data';
                        return QrImageView(
                          data: userId, // ローカルストレージのuser_data内のidの値
                          version: QrVersions.auto, // QRコードのバージョンを自動選択
                          size: 200.0, // QRコードのサイズ（ピクセル）
                        );
                      },
                    ),
                    const SizedBox(height: 20), // 垂直方向の余白

                    // ポイント表示カード
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text(
                              '現在のポイント',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (_isLoadingPoints)
                              const CircularProgressIndicator()
                            else if (_pointsError != null)
                              Text(
                                _pointsError!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              )
                            else
                              Text(
                                '$_userPoints pt',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF009a73),
                                ),
                              ),
                          ],
                        ),
                      ),
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
                                  Text(
                                      'ユーザーID: ${authProvider.userId ?? 'N/A'}'),
                                  Text(
                                      'ユーザー名: ${authProvider.userName ?? 'N/A'}'),
                                  Text(
                                      'メールアドレス: ${authProvider.userEmail ?? 'N/A'}'),
                                  Text(
                                      'ロールID: ${authProvider.roleId ?? 'N/A'}'),
                                  Text(
                                      'ロール名: ${authProvider.roleName ?? 'N/A'}'),
                                  Text(
                                      'ロールタイプ: ${authProvider.roleType ?? 'N/A'}'),
                                  Text(
                                      '認証状態: ${authProvider.isAuthenticated ? 'ログイン中' : '未ログイン'}'),
                                  if (authProvider.userData != null) ...[
                                    const SizedBox(height: 8),
                                    const Text(
                                      'ユーザーデータ:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
