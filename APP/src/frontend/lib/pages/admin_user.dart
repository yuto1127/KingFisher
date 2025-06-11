import 'package:flutter/material.dart';
import '../layouts/main_layout.dart';
import 'dart:async';
import '../services/api_client.dart';  // APIクライアントをインポート

/// ユーザー管理ページ
/// 管理者がユーザー情報を管理するためのページ
class AdminUserPage extends StatefulWidget {
  const AdminUserPage({super.key});

  @override
  State<AdminUserPage> createState() => _AdminUserPageState();
}

class _AdminUserPageState extends State<AdminUserPage> {
  final TextEditingController _barcodeController = TextEditingController();
  final FocusNode _barcodeFocusNode = FocusNode();
  String? _lastScannedCode;
  String? _errorMessage;
  Timer? _scanTimeout;
  DateTime? _lastScanTime;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // フォーカスを自動的にバーコード入力フィールドに設定
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _barcodeFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _barcodeFocusNode.dispose();
    _scanTimeout?.cancel();
    super.dispose();
  }

  // エラーメッセージを表示
  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
    // 3秒後にエラーメッセージをクリア
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _errorMessage = null;
        });
      }
    });
  }

  // 重複スキャンをチェック（1秒以内の連続スキャンを防止）
  bool _isDuplicateScan() {
    if (_lastScanTime == null) return false;
    
    final now = DateTime.now();
    final difference = now.difference(_lastScanTime!);
    return difference.inSeconds < 1;
  }

  void _onBarcodeSubmitted(String value) async {
    if (value.isEmpty) return;
    
    // 処理中の場合は新しいスキャンを受け付けない
    if (_isProcessing) {
      _showError('前回のスキャンの処理中です。お待ちください。');
      _barcodeController.clear();
      return;
    }

    // 重複スキャンチェック
    if (_isDuplicateScan()) {
      _showError('連続してスキャンすることはできません。少し待ってから再試行してください。');
      _barcodeController.clear();
      return;
    }

    setState(() {
      _isProcessing = true;
      _lastScanTime = DateTime.now();
    });

    try {
      // タイムアウトタイマーを設定（5秒）
      _scanTimeout?.cancel();
      _scanTimeout = Timer(const Duration(seconds: 5), () {
        if (_isProcessing) {
          _showError('処理がタイムアウトしました。再度スキャンしてください。');
          setState(() {
            _isProcessing = false;
          });
        }
      });

      // APIを呼び出してユーザー情報を取得
      final userData = await ApiClient.getUser(value);
      
      setState(() {
        _lastScannedCode = value;
        _errorMessage = null;
        // TODO: 取得したユーザー情報を表示する処理を追加
      });

    } catch (e) {
      _showError('エラーが発生しました: ${e.toString()}');
    } finally {
      _scanTimeout?.cancel();
      setState(() {
        _isProcessing = false;
      });
      _barcodeController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: [
          AppBar(
            title: const Text('ユーザー管理'),
            backgroundColor: const Color(0xFF009a73),
            foregroundColor: Colors.white,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // バーコードスキャン領域
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'バーコードスキャン',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _barcodeController,
                            focusNode: _barcodeFocusNode,
                            decoration: InputDecoration(
                              hintText: 'バーコードをスキャンしてください',
                              border: const OutlineInputBorder(),
                              errorText: _errorMessage,
                              suffixIcon: _isProcessing
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : null,
                            ),
                            onSubmitted: _onBarcodeSubmitted,
                            enabled: !_isProcessing,
                          ),
                          if (_lastScannedCode != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              '最後にスキャンしたコード: $_lastScannedCode',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // ユーザー一覧のヘッダー
                  const Text(
                    'ユーザー一覧',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // ここにユーザー一覧のリストやテーブルを実装予定
                  Expanded(
                    child: Center(
                      child: Text('ユーザー一覧を表示予定'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 