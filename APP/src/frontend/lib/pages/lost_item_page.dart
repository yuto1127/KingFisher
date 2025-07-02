import 'package:flutter/material.dart';
import '../layouts/main_layout.dart';
import '../models/lostitembox.dart';

class LostItemPage extends StatelessWidget {
  const LostItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: [
          AppBar(
            title: const Text('落とし物管理'),
            backgroundColor: const Color(0xFF009a73),
            foregroundColor: Colors.white,

          ),
          Container(
            height: 180,
            color: const Color(0xFFf5f5f5),
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
                    child: ListView.builder(
                      itemCount: LostItemBox.getRecentLostItems().length,
                      itemBuilder: (context, index) {
                        final item = LostItemBox.getRecentLostItems()[index];
                        return Column(
                          children: [
                            _buildLostItemCard(item: item),
                            if (index < LostItemBox.getRecentLostItems().length - 1)
                              const SizedBox(height: 12),
                          ],
                        );
                      },
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



  Widget _buildLostItemCard({required LostItem item}) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(item.icon, color: const Color(0xFF009a73)),
        title: Text(
          item.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.description),
            const SizedBox(height: 4),
            Text(
              item.time,
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
