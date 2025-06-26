// Flutterの基本ウィジェットとマテリアルデザイン
import 'package:flutter/material.dart';
// ルーティング用のパッケージ
import 'package:go_router/go_router.dart';
// 共通レイアウト
import '../layouts/main_layout.dart';
// コンテンツ管理ページ

/// アプリケーションの管理者ページ
/// 管理者向けの機能と設定を提供
class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: [
          // アプリバー（上部のナビゲーションバー）
          AppBar(
            title: const Text('管理者ページ'),
            backgroundColor: const Color(0xFF009a73), // 緑色のテーマカラー
            foregroundColor: Colors.white, // テキストを白色に
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/'),
            ),
          ),
          // メインコンテンツエリア
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 3, // 3列のグリッド
                mainAxisSpacing: 16.0, // 縦方向の間隔
                crossAxisSpacing: 16.0, // 横方向の間隔
                children: [
                  _buildAdminButton(
                    icon: Icons.store,
                    label: '模擬店\n管理',
                    onPressed: () {
                      // 模擬店管理機能
                    },
                  ),
                  _buildAdminButton(
                    icon: Icons.people,
                    label: 'ユーザー\n管理',
                    onPressed: () {
                      context.go('/admin/user');
                    },
                  ),
                  _buildAdminButton(
                    icon: Icons.content_copy,
                    label: 'コンテンツ\n管理',
                    onPressed: () {
                      context.go('/admin/content');
                    },
                  ),
                  _buildAdminButton(
                    icon: Icons.login,
                    label: '入退室\n管理',
                    onPressed: () {
                      context.go('/admin/entry-status');
                    },
                  ),
                  _buildAdminButton(
                    icon: Icons.settings,
                    label: 'システム\n設定',
                    onPressed: () {
                      // システム設定機能
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF009a73),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32.0),
          const SizedBox(height: 8.0),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12.0),
          ),
        ],
      ),
    );
  }
}
