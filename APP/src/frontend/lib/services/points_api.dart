import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../utils/network_utils.dart';
import 'auth_api.dart';

class PointsApi {
  static const String baseUrl = NetworkUtils.baseUrl;

  /// ユーザーのポイントを取得
  static Future<Map<String, dynamic>> getUserPoints() async {
    try {
      final token = await AuthApi.getToken();
      if (token == null) {
        throw Exception('認証トークンがありません');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/points/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'success': true,
          'points': data['points'],
          'message': data['message'],
        };
      } else {
        final errorData = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'success': false,
          'error': errorData['error'] ?? 'ポイントの取得に失敗しました',
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('getUserPoints error: $e');
      }
      return {
        'success': false,
        'error': 'ネットワークエラーが発生しました: $e',
      };
    }
  }

  /// ポイント履歴を取得
  static Future<Map<String, dynamic>> getPointHistory({int limit = 10}) async {
    try {
      final token = await AuthApi.getToken();
      if (token == null) {
        throw Exception('認証トークンがありません');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/points/history?limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'success': true,
          'history': data['history'],
          'message': data['message'],
        };
      } else {
        final errorData = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'success': false,
          'error': errorData['error'] ?? 'ポイント履歴の取得に失敗しました',
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('getPointHistory error: $e');
      }
      return {
        'success': false,
        'error': 'ネットワークエラーが発生しました: $e',
      };
    }
  }

  /// ポイントを追加（管理者用）
  static Future<Map<String, dynamic>> addPoints({
    required int userId,
    required int points,
    String description = '',
  }) async {
    try {
      final token = await AuthApi.getToken();
      if (token == null) {
        throw Exception('認証トークンがありません');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/points/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_id': userId,
          'points': points,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        final errorData = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'success': false,
          'error': errorData['error'] ?? 'ポイントの追加に失敗しました',
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('addPoints error: $e');
      }
      return {
        'success': false,
        'error': 'ネットワークエラーが発生しました: $e',
      };
    }
  }

  /// ポイントを使用（管理者用）
  static Future<Map<String, dynamic>> usePoints({
    required int userId,
    required int points,
    String description = '',
  }) async {
    try {
      final token = await AuthApi.getToken();
      if (token == null) {
        throw Exception('認証トークンがありません');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/points/use'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_id': userId,
          'points': points,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        final errorData = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'success': false,
          'error': errorData['error'] ?? 'ポイントの使用に失敗しました',
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('usePoints error: $e');
      }
      return {
        'success': false,
        'error': 'ネットワークエラーが発生しました: $e',
      };
    }
  }
}
