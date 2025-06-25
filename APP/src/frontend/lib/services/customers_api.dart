import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_api.dart';

class CustomersApi {
  // static const String baseUrl = 'http://54.165.66.148/api';
  static const String baseUrl = 'https://cid-kingfisher.jp/api';

  // エラーメッセージのマッピング
  static const Map<String, String> _errorMessages = {
    'validation_error': '入力内容に誤りがあります',
    'customer_not_found': '顧客が見つかりません',
    'network_error': 'ネットワークエラーが発生しました',
    'server_error': 'サーバーエラーが発生しました',
    'unknown_error': '予期せぬエラーが発生しました',
  };

  // エラーメッセージを取得
  static String _getErrorMessage(String code, String? detail) {
    return '${_errorMessages[code] ?? _errorMessages['unknown_error']}${detail != null ? ': $detail' : ''}';
  }

  // HTTPレスポンスのエラーハンドリング
  static Exception _handleErrorResponse(http.Response response) {
    try {
      final error = json.decode(response.body);
      final errorCode = error['error_code'] ?? 'unknown_error';
      final errorDetail = error['message'];
      return Exception(_getErrorMessage(errorCode, errorDetail));
    } catch (e) {
      return Exception(_errorMessages['server_error']!);
    }
  }

  // 日付データの処理
  static Map<String, dynamic> _processDateFields(Map<String, dynamic> data) {
    final processed = Map<String, dynamic>.from(data);
    if (processed['created_at'] != null) {
      processed['created_at'] = DateTime.parse(processed['created_at']);
    }
    if (processed['updated_at'] != null) {
      processed['updated_at'] = DateTime.parse(processed['updated_at']);
    }
    return processed;
  }

  // すべての顧客を取得
  static Future<List<Map<String, dynamic>>> getAll() async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/customers'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> customers = jsonDecode(response.body);
        return customers
            .map((customer) => _processDateFields(customer))
            .toList();
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['network_error']!);
    }
  }

  // 顧客を作成
  static Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/customers'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        return _processDateFields(jsonDecode(response.body));
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['network_error']!);
    }
  }

  // 顧客を更新
  static Future<Map<String, dynamic>> update(
      int id, Map<String, dynamic> data) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/customers/$id'),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return _processDateFields(jsonDecode(response.body));
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['network_error']!);
    }
  }

  // 顧客を削除
  static Future<void> delete(int id) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/customers/$id'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['network_error']!);
    }
  }

  // 顧客を検索
  static Future<List<Map<String, dynamic>>> search(String query) async {
    try {
      final headers = await AuthApi.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/customers/search?q=$query'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> customers = jsonDecode(response.body);
        return customers
            .map((customer) => _processDateFields(customer))
            .toList();
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(_errorMessages['network_error']!);
    }
  }
}
