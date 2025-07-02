import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../layouts/main_layout.dart';
import '../models/lostitembox.dart';
import '../providers/lost_item_provider.dart';

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
                    child: Consumer<LostItemProvider>(
                      builder: (context, provider, child) {
                        // 初回読み込み
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (provider.lostItems.isEmpty && !provider.isLoading) {
                            provider.loadRecentLostItems();
                          }
                        });
                        
                        if (provider.isLoading) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Color(0xFF009a73),
                                ),
                                SizedBox(height: 16),
                                Text('データを読み込み中...'),
                              ],
                            ),
                          );
                        }
                        
                        final recentItems = provider.recentLostItems;
                        
                        if (recentItems.isEmpty) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inventory_outlined,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  '落とし物がありません',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        
                        return ListView.builder(
                          itemCount: recentItems.length,
                          itemBuilder: (context, index) {
                            final item = recentItems[index];
                            return Column(
                              children: [
                                _buildLostItemCard(item: item),
                                if (index < recentItems.length - 1)
                                  const SizedBox(height: 12),
                              ],
                            );
                          },
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
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  item.location,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  item.time,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getStatusColor(item.status),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item.status,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '保管中':
        return Colors.orange;
      case '返却済み':
        return Colors.green;
      case '廃棄':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
