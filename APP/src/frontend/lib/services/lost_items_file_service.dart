import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/lostitembox.dart';

class LostItemsFileService {
  static const String _fileName = 'lost_items.json';
  static const String _assetPath = 'assets/data/lost_items.json';

  // ローカルファイルからデータを読み込み
  static Future<List<LostItem>> loadFromLocalFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_fileName');
      
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final jsonList = json.decode(jsonString) as List;
        return jsonList.map((json) => LostItem.fromJson(json)).toList();
      } else {
        // ファイルが存在しない場合はアセットから読み込み
        return await loadFromAsset();
      }
    } catch (e) {
      // エラー時はアセットから読み込み
      return await loadFromAsset();
    }
  }

  // アセットからデータを読み込み
  static Future<List<LostItem>> loadFromAsset() async {
    try {
      final jsonString = await rootBundle.loadString(_assetPath);
      final jsonList = json.decode(jsonString) as List;
      return jsonList.map((json) => LostItem.fromJson(json)).toList();
    } catch (e) {
      // アセットも読み込めない場合は空のリスト
      return [];
    }
  }

  // ローカルファイルにデータを保存
  static Future<void> saveToLocalFile(List<LostItem> items) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_fileName');
      
      final jsonList = items.map((item) => item.toJson()).toList();
      final jsonString = json.encode(jsonList);
      
      await file.writeAsString(jsonString);
    } catch (e) {
      // エラー時の処理
      print('Failed to save lost items: $e');
    }
  }

  // 新しいアイテムを追加
  static Future<void> addItem(LostItem item) async {
    final items = await loadFromLocalFile();
    items.add(item);
    await saveToLocalFile(items);
  }

  // アイテムを更新
  static Future<void> updateItem(LostItem item) async {
    final items = await loadFromLocalFile();
    final index = items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      items[index] = item;
      await saveToLocalFile(items);
    }
  }

  // アイテムを削除
  static Future<void> deleteItem(String id) async {
    final items = await loadFromLocalFile();
    items.removeWhere((item) => item.id == id);
    await saveToLocalFile(items);
  }

  // データをリセット（アセットから再読み込み）
  static Future<void> resetToAsset() async {
    final items = await loadFromAsset();
    await saveToLocalFile(items);
  }
} 