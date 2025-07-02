import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../layouts/main_layout.dart';
import '../models/lostitembox.dart';
import '../providers/lost_item_provider.dart';

class AdminLostItemPage extends StatefulWidget {
  const AdminLostItemPage({super.key});

  @override
  State<AdminLostItemPage> createState() => _AdminLostItemPageState();
}

class _AdminLostItemPageState extends State<AdminLostItemPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 初回読み込み
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LostItemProvider>().loadLostItems();
    });
  }

  void _showAddLostItemDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    String selectedStatus = '保管中';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('落とし物を追加'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'タイトル',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: '説明',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: '発見場所',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'ステータス',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: '保管中', child: Text('保管中')),
                    DropdownMenuItem(value: '返却済み', child: Text('返却済み')),
                    DropdownMenuItem(value: '廃棄', child: Text('廃棄')),
                  ],
                  onChanged: (value) {
                    selectedStatus = value!;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                                     final newItem = LostItem(
                     id: DateTime.now().millisecondsSinceEpoch.toString(),
                     title: titleController.text,
                     description: descriptionController.text,
                     time: DateTime.now().toString().substring(0, 19),
                     location: locationController.text,
                     status: selectedStatus,
                     icon: LostItem.getIconFromTitle(titleController.text),
                   );
                  context.read<LostItemProvider>().addLostItem(newItem);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('落とし物を追加しました')),
                  );
                }
              },
              child: const Text('追加'),
            ),
          ],
        );
      },
    );
  }

  void _showEditLostItemDialog(LostItem item) {
    final TextEditingController titleController = TextEditingController(text: item.title);
    final TextEditingController descriptionController = TextEditingController(text: item.description);
    final TextEditingController locationController = TextEditingController(text: item.location);
    String selectedStatus = item.status;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('落とし物を編集'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'タイトル',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: '説明',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: '発見場所',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'ステータス',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: '保管中', child: Text('保管中')),
                    DropdownMenuItem(value: '返却済み', child: Text('返却済み')),
                    DropdownMenuItem(value: '廃棄', child: Text('廃棄')),
                  ],
                  onChanged: (value) {
                    selectedStatus = value!;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                                     final updatedItem = LostItem(
                     id: item.id,
                     title: titleController.text,
                     description: descriptionController.text,
                     time: item.time,
                     location: locationController.text,
                     status: selectedStatus,
                     icon: LostItem.getIconFromTitle(titleController.text),
                   );
                  context.read<LostItemProvider>().updateLostItem(updatedItem);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('落とし物を更新しました')),
                  );
                }
              },
              child: const Text('更新'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(LostItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('削除確認'),
          content: Text('「${item.title}」を削除しますか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<LostItemProvider>().removeLostItem(item.id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('落とし物を削除しました')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('削除'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: [
          AppBar(
            title: const Text('落とし物管理'),
            backgroundColor: const Color(0xFF009a73),
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/admin'),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _showAddLostItemDialog,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: '落とし物を検索',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Consumer<LostItemProvider>(
                  builder: (context, provider, child) {
                    if (provider.searchQuery.isNotEmpty) {
                      return IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          provider.clearSearch();
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                context.read<LostItemProvider>().setSearchQuery(value);
              },
            ),
          ),
          Expanded(
            child: Consumer<LostItemProvider>(
              builder: (context, provider, child) {
                final lostItems = provider.lostItems;
                return lostItems.isEmpty
                    ? const Center(
                        child: Text(
                          '落とし物が見つかりません',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: lostItems.length,
                        itemBuilder: (context, index) {
                          final item = lostItems[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: ListTile(
                              leading: Icon(item.icon, color: const Color(0xFF009a73)),
                              title: Text(
                                item.title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
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
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) {
                                  switch (value) {
                                    case 'edit':
                                      _showEditLostItemDialog(item);
                                      break;
                                    case 'delete':
                                      _showDeleteConfirmation(item);
                                      break;
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit),
                                        SizedBox(width: 8),
                                        Text('編集'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('削除', style: TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
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