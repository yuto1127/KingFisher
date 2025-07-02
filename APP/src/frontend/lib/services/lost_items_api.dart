import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/lostitembox.dart';
import 'auth_api.dart';

class LostItemsApi {
  static const String baseUrl = 'http://localhost:8000/api'; // バックエンドのURL

  // 認証トークンを取得
  static Future<String?> _getAuthToken() async {
    return await AuthApi.getToken();
  }

  // 全ての落とし物を取得
  static Future<List<LostItem>> getAllLostItems() async {
    try {
      final token = await _getAuthToken();
      final response = await http.get(
        Uri.parse('$baseUrl/lost-items'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => LostItem.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load lost items: ${response.statusCode}');
      }
    } catch (e) {
      // エラー時はローカルデータを返す
      return LostItemBox.getAllLostItems();
    }
  }

  // 最近の落とし物を取得
  static Future<List<LostItem>> getRecentLostItems({int limit = 5}) async {
    try {
      final token = await _getAuthToken();
      final response = await http.get(
        Uri.parse('$baseUrl/lost-items/recent?limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => LostItem.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recent lost items: ${response.statusCode}');
      }
    } catch (e) {
      // エラー時はローカルデータを返す
      return LostItemBox.getRecentLostItems(limit: limit);
    }
  }

  // 落とし物を検索
  static Future<List<LostItem>> searchLostItems(String query) async {
    try {
      final token = await _getAuthToken();
      final response = await http.get(
        Uri.parse('$baseUrl/lost-items/search?q=${Uri.encodeComponent(query)}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => LostItem.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search lost items: ${response.statusCode}');
      }
    } catch (e) {
      // エラー時はローカルデータで検索
      return LostItemBox.searchLostItemsByTitle(query);
    }
  }

  // 落とし物を追加
  static Future<bool> addLostItem(LostItem item) async {
    try {
      final token = await _getAuthToken();
      final response = await http.post(
        Uri.parse('$baseUrl/lost-items'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'title': item.title,
          'description': item.description,
          'location': item.location,
          'status': item.status,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      // エラー時はローカルに追加
      LostItemBox.addLostItem(item);
      return false;
    }
  }

  // 落とし物を更新
  static Future<bool> updateLostItem(LostItem item) async {
    try {
      final token = await _getAuthToken();
      final response = await http.put(
        Uri.parse('$baseUrl/lost-items/${item.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'title': item.title,
          'description': item.description,
          'location': item.location,
          'status': item.status,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      // エラー時はローカルで更新
      LostItemBox.removeLostItem(item.id);
      LostItemBox.addLostItem(item);
      return false;
    }
  }

  // 落とし物を削除
  static Future<bool> deleteLostItem(String id) async {
    try {
      final token = await _getAuthToken();
      final response = await http.delete(
        Uri.parse('$baseUrl/lost-items/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      // エラー時はローカルで削除
      LostItemBox.removeLostItem(id);
      return false;
    }
  }

  // ステータスを更新
  static Future<bool> updateStatus(String id, String status) async {
    try {
      final token = await _getAuthToken();
      final response = await http.patch(
        Uri.parse('$baseUrl/lost-items/$id/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'status': status}),
      );

      return response.statusCode == 200;
    } catch (e) {
      // エラー時はローカルで更新
      LostItemBox.updateLostItemStatus(id, status);
      return false;
    }
  }

  // 定期的にデータを同期
  static Future<void> syncData() async {
    try {
      final serverItems = await getAllLostItems();
      // ローカルデータをサーバーデータで更新
      // 実装は必要に応じて追加
    } catch (e) {
      // 同期エラー時の処理
    }
  }
} 