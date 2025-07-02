import 'package:flutter/foundation.dart';
import '../models/lostitembox.dart';

class LostItemProvider with ChangeNotifier {
  List<LostItem> _lostItems = [];
  String _searchQuery = '';

  List<LostItem> get lostItems => _filteredLostItems;
  List<LostItem> get recentLostItems => _filteredLostItems.take(5).toList();
  String get searchQuery => _searchQuery;

  List<LostItem> get _filteredLostItems {
    if (_searchQuery.isEmpty) {
      return _lostItems;
    }
    return _lostItems
        .where((item) =>
            item.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void loadLostItems() {
    _lostItems = LostItemBox.getAllLostItems();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  void addLostItem(LostItem item) {
    LostItemBox.addLostItem(item);
    loadLostItems(); // 再読み込みして画面更新
  }

  void updateLostItem(LostItem item) {
    // 既存のアイテムを削除して新しいアイテムを追加
    LostItemBox.removeLostItem(item.id);
    LostItemBox.addLostItem(item);
    loadLostItems();
  }

  void removeLostItem(String id) {
    LostItemBox.removeLostItem(id);
    loadLostItems();
  }

  void updateLostItemStatus(String id, String newStatus) {
    LostItemBox.updateLostItemStatus(id, newStatus);
    loadLostItems();
  }

  LostItem? getLostItemById(String id) {
    return LostItemBox.getLostItemById(id);
  }
} 