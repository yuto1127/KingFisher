// Flutterの基本ウィジェットとマテリアルデザイン
import 'package:flutter/material.dart';
// ルーティング用のパッケージ
import 'package:go_router/go_router.dart';
// 共通レイアウト
import '../layouts/main_layout.dart';

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
            backgroundColor: Color(0xFF009a73), // 緑色のテーマカラー
            foregroundColor: Colors.white, // テキストを白色に
            actions: [
              // 管理者QRページへの遷移ボタン
              IconButton(
                icon: const Icon(Icons.qr_code),
                onPressed: () {
                  context.go('/admin-qr');
                },
                tooltip: '管理者QR',
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
                  const Text(
                    '管理者ページ',
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(height: 20), // 垂直方向の余白

                  // 管理者機能のボタン群
                  ElevatedButton(
                    onPressed: () {
                      // ユーザー管理機能
                    },
                    child: const Text('ユーザー管理'),
                  ),
                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      // コンテンツ管理機能
                    },
                    child: const Text('コンテンツ管理'),
                  ),
                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      // システム設定機能
                    },
                    child: const Text('システム設定'),
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