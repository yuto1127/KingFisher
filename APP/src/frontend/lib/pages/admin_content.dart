import 'package:flutter/material.dart';
import 'package:frontend/providers/info_provider.dart';
import '../layouts/main_layout.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:provider/provider.dart';
import '../providers/map_image_provider.dart';
import 'package:go_router/go_router.dart';

class AdminContentPage extends StatefulWidget {
  const AdminContentPage({super.key});

  @override
  State<AdminContentPage> createState() => _AdminContentPageState();
}

class _AdminContentPageState extends State<AdminContentPage> {
  Uint8List? _mapImageBytes;

  Future<void> _pickMapImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _mapImageBytes = bytes;
      });
      // Providerにも保存
      context.read<MapImageProvider>().setImage(bytes);

      // InfoProviderにお知らせを追加
      context.read<InfoProvider>().addInfo(
            'マップ画像更新',
            '新しいマップ画像がアップロードされました。',
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: [
          AppBar(
            title: const Text('コンテンツ管理'),
            backgroundColor: Color(0xFF009a73),
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/admin'),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text(
                  'コンテンツ一覧',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildContentCard(
                  title: 'お知らせ',
                  description: 'お知らせの追加・編集・削除',
                  icon: Icons.announcement,
                ),
                const SizedBox(height: 12),
                _buildContentCard(
                  title: 'イベント',
                  description: 'イベント情報の管理',
                  icon: Icons.event,
                ),
                const SizedBox(height: 12),
                _buildMapCard(),
                const SizedBox(height: 12),
                _buildContentCard(
                  title: 'メニュー',
                  description: 'レストランのメニュー管理',
                  icon: Icons.restaurant_menu,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(
                Icons.business,
                color: Color(0xFF009a73),
                size: 32,
              ),
              title: const Text(
                'マップ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('施設の詳細情報の編集'),
            ),
            if (_mapImageBytes != null) ...[
              const SizedBox(height: 8),
              Center(
                child: Image.memory(
                  _mapImageBytes!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Center(
              child: ElevatedButton.icon(
                onPressed: _pickMapImage,
                icon: const Icon(Icons.upload_file),
                label: const Text('画像をアップロード'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF009a73),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(
          icon,
          color: Color(0xFF009a73),
          size: 32,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // 各コンテンツの編集画面への遷移処理
        },
      ),
    );
  }
}
