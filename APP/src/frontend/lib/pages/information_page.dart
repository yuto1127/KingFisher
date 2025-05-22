import 'package:flutter/material.dart';
import '../layouts/main_layout.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: [
          AppBar(
            title: const Text('インフォメーション'),
            backgroundColor: Color(0xFF009a73),
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
                    _buildInfoCard(
                      title: 'システムメンテナンス',
                      content: '2024年4月1日（月）の深夜2時から4時まで、システムメンテナンスを実施いたします。',
                      date: '2024-03-25',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      title: '新機能リリース',
                      content:
                          'QRコードスキャン機能が追加されました。施設内のQRコードをスキャンして詳細情報を確認できます。',
                      date: '2024-03-20',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      title: 'イベント開催',
                      content: '4月15日に新施設オープン記念イベントを開催します。詳細はマップページでご確認ください。',
                      date: '2024-03-15',
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
