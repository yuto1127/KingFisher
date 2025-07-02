import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../layouts/main_layout.dart';
import '../models/lostitembox.dart';

class AdminLostItemPage extends StatefulWidget {
  const AdminLostItemPage({super.key});

  @override
  State<AdminLostItemPage> createState() => _AdminLostItemPageState();
}

class _AdminLostItemPageState extends State<AdminLostItemPage> {
  List<LostItem> _lostItems = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadLostItems();
  }

  void _loadLostItems() {
    setState(() {
      if (_searchQuery.isEmpty) {
        _lostItems = LostItemBox.getAllLostItems();
      } else {
        _lostItems = LostItemBox.searchLostItemsByTitle(_searchQuery);
      }
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
                  LostItemBox.addLostItem(newItem);
                  _loadLostItems();
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
                  // 既存のアイテムを削除して新しいアイテムを追加
                  LostItemBox.removeLostItem(item.id);
                  LostItemBox.addLostItem(updatedItem);
                  _loadLostItems();
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
                LostItemBox.removeLostItem(item.id);
                _loadLostItems();
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
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                          _loadLostItems();
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _loadLostItems();
              },
            ),
          ),
          Expanded(
            child: _lostItems.isEmpty
                ? const Center(
                    child: Text(
                      '落とし物が見つかりません',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _lostItems.length,
                    itemBuilder: (context, index) {
                      final item = _lostItems[index];
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