import 'package:flutter/foundation.dart';
import '../models/lostitembox.dart';
import '../services/lost_items_api.dart';

class LostItemProvider with ChangeNotifier {
  List<LostItem> _lostItems = [];
  String _searchQuery = '';
  bool _isLoading = false;

  List<LostItem> get lostItems => _filteredLostItems;
  List<LostItem> get recentLostItems => _filteredLostItems.take(5).toList();
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  List<LostItem> get _filteredLostItems {
    if (_searchQuery.isEmpty) {
      return _lostItems;
    }
    return _lostItems
        .where((item) =>
            item.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  // APIからデータを読み込み
  Future<void> loadLostItems() async {
    _setLoading(true);
    try {
      final items = await LostItemsApi.getAllLostItems();
      _lostItems = items;
      notifyListeners();
    } catch (e) {
      // エラー時はローカルデータを使用
      _lostItems = LostItemBox.getAllLostItems();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // 最近の落とし物を読み込み
  Future<void> loadRecentLostItems({int limit = 5}) async {
    _setLoading(true);
    try {
      final items = await LostItemsApi.getRecentLostItems(limit: limit);
      _lostItems = items;
      notifyListeners();
    } catch (e) {
      // エラー時はローカルデータを使用
      _lostItems = LostItemBox.getRecentLostItems(limit: limit);
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // 検索クエリを設定
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // 検索をクリア
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // 検索を実行
  Future<void> searchLostItems(String query) async {
    _setLoading(true);
    try {
      final items = await LostItemsApi.searchLostItems(query);
      _lostItems = items;
      notifyListeners();
    } catch (e) {
      // エラー時はローカルデータで検索
      _lostItems = LostItemBox.searchLostItemsByTitle(query);
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // 新しい落とし物を追加
  Future<void> addLostItem(LostItem item) async {
    _setLoading(true);
    try {
      final success = await LostItemsApi.addLostItem(item);
      if (success) {
        // API成功時は再読み込み
        await loadLostItems();
      } else {
        // API失敗時はローカルに追加
        LostItemBox.addLostItem(item);
        _lostItems = LostItemBox.getAllLostItems();
        notifyListeners();
      }
    } catch (e) {
      // エラー時はローカルに追加
      LostItemBox.addLostItem(item);
      _lostItems = LostItemBox.getAllLostItems();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // 落とし物を更新
  Future<void> updateLostItem(LostItem item) async {
    _setLoading(true);
    try {
      final success = await LostItemsApi.updateLostItem(item);
      if (success) {
        // API成功時は再読み込み
        await loadLostItems();
      } else {
        // API失敗時はローカルで更新
        LostItemBox.removeLostItem(item.id);
        LostItemBox.addLostItem(item);
        _lostItems = LostItemBox.getAllLostItems();
        notifyListeners();
      }
    } catch (e) {
      // エラー時はローカルで更新
      LostItemBox.removeLostItem(item.id);
      LostItemBox.addLostItem(item);
      _lostItems = LostItemBox.getAllLostItems();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // 落とし物を削除
  Future<void> removeLostItem(String id) async {
    _setLoading(true);
    try {
      final success = await LostItemsApi.deleteLostItem(id);
      if (success) {
        // API成功時は再読み込み
        await loadLostItems();
      } else {
        // API失敗時はローカルで削除
        LostItemBox.removeLostItem(id);
        _lostItems = LostItemBox.getAllLostItems();
        notifyListeners();
      }
    } catch (e) {
      // エラー時はローカルで削除
      LostItemBox.removeLostItem(id);
      _lostItems = LostItemBox.getAllLostItems();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // ステータスを更新
  Future<void> updateLostItemStatus(String id, String newStatus) async {
    _setLoading(true);
    try {
      final success = await LostItemsApi.updateStatus(id, newStatus);
      if (success) {
        // API成功時は再読み込み
        await loadLostItems();
      } else {
        // API失敗時はローカルで更新
        LostItemBox.updateLostItemStatus(id, newStatus);
        _lostItems = LostItemBox.getAllLostItems();
        notifyListeners();
      }
    } catch (e) {
      // エラー時はローカルで更新
      LostItemBox.updateLostItemStatus(id, newStatus);
      _lostItems = LostItemBox.getAllLostItems();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // IDで落とし物を取得
  LostItem? getLostItemById(String id) {
    return LostItemBox.getLostItemById(id);
  }

  // ローディング状態を設定
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
} 