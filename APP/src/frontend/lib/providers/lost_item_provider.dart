import 'package:flutter/foundation.dart';
import '../models/lostitembox.dart';
import '../services/lost_items_api.dart';

class LostItemProvider with ChangeNotifier {
  List<LostItem> _lostItems = [];
  String _searchQuery = '';
  bool _isLoading = false;
  String _error = '';

  List<LostItem> get lostItems => _filteredLostItems;
  List<LostItem> get recentLostItems => _filteredLostItems.take(5).toList();
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String get error => _error;

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
    _clearError();
    try {
      final items = await LostItemsApi.getAllLostItems();
      _lostItems = items;
      notifyListeners();
    } catch (e) {
      _setError('データの読み込みに失敗しました: $e');
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
    _clearError();
    try {
      final items = await LostItemsApi.getRecentLostItems(limit: limit);
      _lostItems = items;
      notifyListeners();
    } catch (e) {
      _setError('データの読み込みに失敗しました: $e');
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
    _clearError();
    try {
      final items = await LostItemsApi.searchLostItems(query);
      _lostItems = items;
      notifyListeners();
    } catch (e) {
      _setError('検索に失敗しました: $e');
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
    _clearError();
    try {
      final success = await LostItemsApi.addLostItem(item);
      if (success) {
        // API成功時は再読み込み
        await loadLostItems();
      } else {
        throw Exception('APIからの応答が不正です');
      }
    } catch (e) {
      _setError('追加に失敗しました: $e');
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
    _clearError();
    try {
      final success = await LostItemsApi.updateLostItem(item);
      if (success) {
        // API成功時は再読み込み
        await loadLostItems();
      } else {
        throw Exception('APIからの応答が不正です');
      }
    } catch (e) {
      _setError('更新に失敗しました: $e');
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
    _clearError();
    try {
      final success = await LostItemsApi.deleteLostItem(id);
      if (success) {
        // API成功時は再読み込み
        await loadLostItems();
      } else {
        throw Exception('APIからの応答が不正です');
      }
    } catch (e) {
      _setError('削除に失敗しました: $e');
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
    _clearError();
    try {
      final success = await LostItemsApi.updateStatus(id, newStatus);
      if (success) {
        // API成功時は再読み込み
        await loadLostItems();
      } else {
        throw Exception('APIからの応答が不正です');
      }
    } catch (e) {
      _setError('ステータス更新に失敗しました: $e');
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

  // エラーを設定
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  // エラーをクリア
  void _clearError() {
    _error = '';
    notifyListeners();
  }
} 