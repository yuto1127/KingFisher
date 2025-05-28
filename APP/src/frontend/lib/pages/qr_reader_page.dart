import 'package:flutter/material.dart';
import '../layouts/main_layout.dart';

class QRReaderPage extends StatelessWidget {
  const QRReaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: [
          AppBar(
            title: const Text('QRリーダー'),
            backgroundColor: Color(0xFF009a73),
            foregroundColor: Colors.white,
          ),
          Container(
            height: 300,
            color: Colors.black,
            child: const Center(
              child: Text(
                'QRコードスキャンエリア',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'スキャン履歴',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildHistoryCard(
                          title: 'メインホール',
                          time: '2024-03-25 14:30',
                          description: '多目的ホールの詳細情報を表示',
                        ),
                        const SizedBox(height: 12),
                        _buildHistoryCard(
                          title: '会議室A',
                          time: '2024-03-25 13:15',
                          description: '会議室の予約状況を確認',
                        ),
                        const SizedBox(height: 12),
                        _buildHistoryCard(
                          title: 'レストラン',
                          time: '2024-03-25 12:00',
                          description: '本日のメニューを表示',
                        ),
                      ],
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

  Widget _buildHistoryCard({
    required String title,
    required String time,
    required String description,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.history),
      ),
    );
  }
}
