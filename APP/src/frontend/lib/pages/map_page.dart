import 'package:flutter/material.dart';
import '../layouts/main_layout.dart';
import 'package:provider/provider.dart';
import '../providers/map_image_provider.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mapImageBytes = context.watch<MapImageProvider>().imageBytes;
    return MainLayout(
      child: Column(
        children: [
          AppBar(
            title: const Text('マップ'),
            backgroundColor: Color(0xFF009a73),
            foregroundColor: Colors.white,
          ),
          SizedBox(
            height: 200,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    insetPadding: EdgeInsets.zero, // 全画面化
                    backgroundColor: Colors.black,
                    child: Stack(
                      children: [
                        Center(
                          child: InteractiveViewer(
                            child: Image.memory(
                              mapImageBytes!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 24,
                          right: 24,
                          child: IconButton(
                            icon: Icon(Icons.close,
                                color: Colors.white, size: 30),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Container(
                color: Colors.grey[300],
                child: mapImageBytes != null
                    ? Image.memory(
                        mapImageBytes,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: 200,
                      )
                    : const Center(
                        child: Text(
                          'マップ表示エリア',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '施設一覧',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFacilityCard(
                      name: 'メインホール',
                      description: '多目的ホール（最大収容人数：500人）',
                      floor: '1階',
                    ),
                    const SizedBox(height: 12),
                    _buildFacilityCard(
                      name: '会議室A',
                      description: '小規模会議室（最大収容人数：20人）',
                      floor: '2階',
                    ),
                    const SizedBox(height: 12),
                    _buildFacilityCard(
                      name: 'レストラン',
                      description: 'カフェテリア形式のレストラン',
                      floor: '1階',
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

  Widget _buildFacilityCard({
    required String name,
    required String description,
    required String floor,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(
          name,
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
              floor,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
