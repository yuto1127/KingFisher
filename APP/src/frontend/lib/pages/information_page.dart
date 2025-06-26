import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../layouts/main_layout.dart';
import '../providers/info_provider.dart';

/// インフォメーションページ（お知らせを表示）
class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // プロバイダから最新のお知らせを取得
    final infoList = context.watch<InfoProvider>().items;

    return MainLayout(
      child: Column(
        children: [
          AppBar(
            title: const Text('インフォメーション'),
            backgroundColor: const Color(0xFF009a73),
            foregroundColor: Colors.white,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '最新情報',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // お知らせ一覧をループで表示
                    for (final info in infoList)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildInfoCard(
                          title: info.title,
                          content: info.content,
                          date: info.date,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// お知らせカードを作成するウィジェット
  Widget _buildInfoCard({
    required String title,
    required String content,
    required String date,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              date,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
