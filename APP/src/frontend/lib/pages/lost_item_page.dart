import 'package:flutter/material.dart';
import '../layouts/main_layout.dart';

class LostItemPage extends StatelessWidget {
  const LostItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: [
          AppBar(
            title: const Text('落とし物管理'),
            backgroundColor: Color(0xFF009a73),
            foregroundColor: Colors.white,
          ),
          Container(
            height: 180,
            color: Color(0xFFf5f5f5),
            child: const Center(
              child: Text(
                '落とし物の登録・管理ができます',
                style: TextStyle(
                  color: Color(0xFF009a73),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
                    '最近の落とし物',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildLostItemCard(
                          title: '黒い財布',
                          time: '2024-06-17 10:00',
                          description: '受付で預かっています',
                        ),
                        const SizedBox(height: 12),
                        _buildLostItemCard(
                          title: '青い傘',
                          time: '2024-06-16 15:30',
                          description: 'ロビーで発見されました',
                        ),
                        const SizedBox(height: 12),
                        _buildLostItemCard(
                          title: 'スマートフォン',
                          time: '2024-06-15 18:20',
                          description: 'スタッフルームで保管中',
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

  Widget _buildLostItemCard({
    required String title,
    required String time,
    required String description,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.umbrella, color: Color(0xFF009a73)),
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
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
