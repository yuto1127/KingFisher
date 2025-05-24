// Flutterの基本ウィジェットとマテリアルデザイン
import 'package:flutter/material.dart';
// ルーティング用のパッケージ
import 'package:go_router/go_router.dart';
// QRコード生成用のパッケージ
import 'package:qr_flutter/qr_flutter.dart';
// 共通レイアウト
import '../layouts/main_layout.dart';

/// アプリケーションのホームページ
/// メインのナビゲーションとQRコード表示機能を提供
class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
          ),
          // メインコンテンツエリア
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ページタイトル
                  const Text(
                    'ホームページ',
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(height: 20), // 垂直方向の余白
                  
                  // QRコード表示ウィジェット
                  const Text(
                    '会員QRコード',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20), // 垂直方向の余白
                  QrImageView(
                    data: 'QRコードを読み込んでくれてありがとう', // QRコードに埋め込むデータ
                    version: QrVersions.auto, // QRコードのバージョンを自動選択
                    size: 200.0, // QRコードのサイズ（ピクセル）
                  ),
                  const SizedBox(height: 20), // 垂直方向の余白

                  // 設定ページへのナビゲーションボタン
                  ElevatedButton(
                    onPressed: () {
                      // 設定ページへ遷移
                      context.go('/settings');
                    },
                    child: const Text('設定ページへ'),
                  ),
                  const SizedBox(height: 10), // ボタン間の余白

                  // プロフィールページへのナビゲーションボタン
                  ElevatedButton(
                    onPressed: () {
                      // プロフィールページへ遷移
                      context.go('/profile');
                    },
                    child: const Text('プロフィールページへ'),
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
