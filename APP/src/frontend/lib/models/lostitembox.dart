import 'package:flutter/material.dart';

class LostItem {
  final String id;
  final String title;
  final String description;
  final String time;
  final String location;
  final String status;
  final IconData icon;

  LostItem({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.location,
    required this.status,
    required this.icon,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': time,
      'location': location,
      'status': status,
    };
  }

  factory LostItem.fromJson(Map<String, dynamic> json) {
    return LostItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      time: json['time'] ?? '',
      location: json['location'] ?? '',
      status: json['status'] ?? '',
      icon: getIconFromTitle(json['title'] ?? ''),
    );
  }

  static IconData getIconFromTitle(String title) {
    if (title.contains('財布') || title.contains('wallet')) {
      return Icons.account_balance_wallet;
    } else if (title.contains('傘') || title.contains('umbrella')) {
      return Icons.umbrella;
    } else if (title.contains('スマートフォン') || title.contains('phone')) {
      return Icons.phone_android;
    } else if (title.contains('鍵') || title.contains('key')) {
      return Icons.key;
    } else if (title.contains('眼鏡') || title.contains('glasses')) {
      return Icons.remove_red_eye;
    } else if (title.contains('バッグ') || title.contains('bag')) {
      return Icons.work;
    } else {
      return Icons.inventory;
    }
  }
}

class LostItemBox {
  static final List<LostItem> _lostItems = [
    LostItem(
      id: '1',
      title: '黒い財布',
      description: '受付で預かっています',
      time: '2024-06-17 10:00',
      location: '受付',
      status: '保管中',
      icon: Icons.account_balance_wallet,
    ),
    LostItem(
      id: '2',
      title: '青い傘',
      description: 'ロビーで発見されました',
      time: '2024-06-16 15:30',
      location: 'ロビー',
      status: '保管中',
      icon: Icons.umbrella,
    ),
    LostItem(
      id: '3',
      title: 'スマートフォン',
      description: 'スタッフルームで保管中',
      time: '2024-06-15 18:20',
      location: 'スタッフルーム',
      status: '保管中',
      icon: Icons.phone_android,
    ),
    LostItem(
      id: '4',
      title: '鍵',
      description: '駐車場で発見されました',
      time: '2024-06-14 12:45',
      location: '駐車場',
      status: '保管中',
      icon: Icons.key,
    ),
    LostItem(
      id: '5',
      title: '眼鏡',
      description: '会議室で見つかりました',
      time: '2024-06-13 16:10',
      location: '会議室',
      status: '保管中',
      icon: Icons.remove_red_eye,
    ),
  ];

  // 全ての落とし物を取得
  static List<LostItem> getAllLostItems() {
    return List.from(_lostItems);
  }

  // 最近の落とし物を取得（最新の5件）
  static List<LostItem> getRecentLostItems({int limit = 5}) {
    final List<LostItem> sortedItems = List<LostItem>.from(_lostItems);
    sortedItems.sort((a, b) => b.time.compareTo(a.time));
    return sortedItems.take(limit).toList();
  }

  // IDで落とし物を検索
  static LostItem? getLostItemById(String id) {
    try {
      return _lostItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  // タイトルで落とし物を検索
  static List<LostItem> searchLostItemsByTitle(String query) {
    return _lostItems
        .where((item) =>
            item.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // 新しい落とし物を追加
  static void addLostItem(LostItem item) {
    _lostItems.add(item);
  }

  // 落とし物を削除
  static bool removeLostItem(String id) {
    final index = _lostItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _lostItems.removeAt(index);
      return true;
    }
    return false;
  }

  // 落とし物のステータスを更新
  static bool updateLostItemStatus(String id, String newStatus) {
    final index = _lostItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      final item = _lostItems[index];
      _lostItems[index] = LostItem(
        id: item.id,
        title: item.title,
        description: item.description,
        time: item.time,
        location: item.location,
        status: newStatus,
        icon: item.icon,
      );
      return true;
    }
    return false;
  }
} 