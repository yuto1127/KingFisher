import 'package:flutter/material.dart';

class InfoItem {
  final String title;
  final String content;
  final String date;

  InfoItem({required this.title, required this.content, required this.date});
}

/// お知らせ一覧を管理するProvider（通知の追加や取得を担当）
class InfoProvider with ChangeNotifier {
  final List<InfoItem> _items = [
    InfoItem(
      title: 'システムメンテナンス',
      content: '2024年4月1日（月）の深夜2時から4時まで、システムメンテナンスを実施いたします。',
      date: '2024-03-25',
    ),
    InfoItem(
      title: '新機能リリース',
      content: 'QRコードスキャン機能が追加されました。',
      date: '2024-03-20',
    ),
  ];

  // 外部から読み取り専用でアクセス可能なgetter
  List<InfoItem> get items => List.unmodifiable(_items);

  /// お知らせを追加する関数
  void addInfo(String title, String content) {
    final now = DateTime.now();
    final formattedDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    _items.insert(
        0, InfoItem(title: title, content: content, date: formattedDate));
    notifyListeners(); //UIに変更を通知
  }
}
