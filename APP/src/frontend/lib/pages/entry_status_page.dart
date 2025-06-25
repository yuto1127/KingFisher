import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../layouts/main_layout.dart';
import 'dart:async';
import '../services/auth_api.dart';
import '../services/entry_statuses_api.dart';

/// 入退室管理ページ
/// 管理者が入退室状況を管理するためのページ
class EntryStatusPage extends StatefulWidget {
  const EntryStatusPage({super.key});

  @override
  State<EntryStatusPage> createState() => _EntryStatusPageState();
}

class _EntryStatusPageState extends State<EntryStatusPage> {
  final TextEditingController _barcodeController = TextEditingController();
  final FocusNode _barcodeFocusNode = FocusNode();
  String? _lastScannedCode;
  String? _errorMessage;
  String? _successMessage;
  Timer? _scanTimeout;
  DateTime? _lastScanTime;
  bool _isProcessing = false;
  List<Map<String, dynamic>> _entryStatuses = [];
  bool _isLoading = true;

  // 追加: スキャンしたユーザー情報と入退室情報
  Map<String, dynamic>? _scannedUser;
  Map<String, dynamic>? _scannedEntryStatus;

  @override
  void initState() {
    super.initState();
    // フォーカスを自動的にバーコード入力フィールドに設定
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _barcodeFocusNode.requestFocus();
    });
    _loadEntryStatuses();
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _barcodeFocusNode.dispose();
    _scanTimeout?.cancel();
    super.dispose();
  }

  // 入退室状況を読み込む
  Future<void> _loadEntryStatuses() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final statuses = await EntryStatusesApi.getEntryStatuses();
      setState(() {
        _entryStatuses = statuses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('入退室状況の読み込みに失敗しました: ${e.toString()}');
    }
  }

  // エラーメッセージを表示
  void _showError(String message) {
    setState(() {
      _errorMessage = message;
      _successMessage = null;
    });
    // 3秒後にエラーメッセージをクリア
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _errorMessage = null;
        });
      }
      // エラー後も次フレームでフォーカスを戻す
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_barcodeFocusNode);
      });
    });
  }

  // 成功メッセージを表示
  void _showSuccess(String message) {
    setState(() {
      _successMessage = message;
      _errorMessage = null;
    });
    // 3秒後に成功メッセージをクリア
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _successMessage = null;
        });
      }
      // 成功後も次フレームでフォーカスを戻す
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_barcodeFocusNode);
      });
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
    if (value.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_barcodeFocusNode);
      });
      return;
    }

    if (_isProcessing) {
      _showError('前回のスキャンの処理中です。お待ちください。');
      _barcodeController.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_barcodeFocusNode);
      });
      return;
    }

    if (_isDuplicateScan()) {
      _showError('連続してスキャンすることはできません。少し待ってから再試行してください。');
      _barcodeController.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_barcodeFocusNode);
      });
      return;
    }

    setState(() {
      _isProcessing = true;
      _lastScanTime = DateTime.now();
    });

    try {
      _scanTimeout?.cancel();
      _scanTimeout = Timer(const Duration(seconds: 5), () {
        if (_isProcessing) {
          _showError('処理がタイムアウトしました。再度スキャンしてください。');
          setState(() {
            _isProcessing = false;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            FocusScope.of(context).requestFocus(_barcodeFocusNode);
          });
        }
      });

      // ユーザー情報を取得
      final userData = await AuthApi.getUser(value);
      Map<String, dynamic>? entryStatusData;

      if (userData != null) {
        // 入退室状況を切り替え
        final result = await EntryStatusesApi.toggleEntryStatus(userData['id']);
        // 最新の入退室状況を取得
        entryStatusData = await EntryStatusesApi.getUserEntryStatus(userData['id']);

        setState(() {
          _lastScannedCode = value;
          _successMessage = '${userData['name']}さんの${result['message']}';
          _scannedUser = userData;
          _scannedEntryStatus = entryStatusData;
        });

        await _loadEntryStatuses();
      } else {
        setState(() {
          _scannedUser = null;
          _scannedEntryStatus = null;
        });
        _showError('ユーザーが見つかりません');
      }
    } catch (e) {
      setState(() {
        _scannedUser = null;
        _scannedEntryStatus = null;
      });
      _showError('エラーが発生しました: ${e.toString()}');
    } finally {
      _scanTimeout?.cancel();
      setState(() {
        _isProcessing = false;
      });
      _barcodeController.clear();
      // スキャン後も次フレームでフォーカスを戻す
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_barcodeFocusNode);
      });
    }
  }

  // ステータスに応じた色を取得
  Color _getStatusColor(String status) {
    switch (status) {
      case 'entry':
        return Colors.green;
      case 'exit':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // ステータスに応じたテキストを取得
  String _getStatusText(String status) {
    switch (status) {
      case 'entry':
        return '入室中';
      case 'exit':
        return '退室中';
      default:
        return '不明';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(_barcodeFocusNode);
      },
      child: MainLayout(
        child: Column(
          children: [
            AppBar(
              title: const Text('入退室管理'),
              backgroundColor: const Color(0xFF009a73),
              foregroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/admin'),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadEntryStatuses,
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
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
                              if (_successMessage != null) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Text(
                                    _successMessage!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                ),
                              ],
                              // 追加: スキャンしたユーザー情報と入退室情報の表示
                              if (_scannedUser != null && _scannedEntryStatus != null) ...[
                                const SizedBox(height: 16),
                                const Divider(),
                                Text(
                                  'ユーザー情報',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text('名前: ${_scannedUser!['name'] ?? '不明'}'),
                                Text('電話番号: '
                                  // phone, tel, telephoneの順で表示
                                  '${_scannedUser!['phone_number'] ?? '不明'}'),
                                const SizedBox(height: 8),
                                Text(
                                  '入退室状況',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text('ステータス: ${_getStatusText(_scannedEntryStatus!['status'] ?? 'unknown')}'),
                                Text('入室時刻: ${_scannedEntryStatus!['entry_at'] != null ? _scannedEntryStatus!['entry_at'].toString().replaceFirst("T", " ").substring(0, 19) : '---'}'),
                                Text('退室時刻: ${_scannedEntryStatus!['exit_at'] != null ? _scannedEntryStatus!['exit_at'].toString().replaceFirst("T", " ").substring(0, 19) : '---'}'),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 入退室状況のヘッダー
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '入退室状況',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_isLoading)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // 入退室状況のリスト
                      Container(
                        height: 300, // 必要に応じて調整
                        child: Builder(
                          builder: (context) {
                            // user_idごとに最新のデータだけを残す
                            final Map<int, Map<String, dynamic>> latestByUser = {};
                            for (final entry in _entryStatuses) {
                              final userId = entry['user_id'];
                              if (!latestByUser.containsKey(userId) ||
                                  DateTime.parse(entry['updated_at']).isAfter(DateTime.parse(latestByUser[userId]!['updated_at']))) {
                                latestByUser[userId] = entry;
                              }
                            }
                            final latestEntryStatuses = latestByUser.values.toList();

                            if (_isLoading) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (latestEntryStatuses.isEmpty) {
                              return const Center(
                                child: Text(
                                  '入退室記録がありません',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            } else {
                              return ListView.builder(
                                itemCount: latestEntryStatuses.length,
                                itemBuilder: (context, index) {
                                  final entryStatus = latestEntryStatuses[index];
                                  final status = entryStatus['status'] ?? 'unknown';
                                  final entryAt = entryStatus['entry_at'] != null
                                      ? DateTime.parse(entryStatus['entry_at'])
                                      : null;
                                  final exitAt = entryStatus['exit_at'] != null
                                      ? DateTime.parse(entryStatus['exit_at'])
                                      : null;
                                  final updatedAt = entryStatus['updated_at'] != null
                                      ? DateTime.parse(entryStatus['updated_at'])
                                      : null;

                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 8.0),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: _getStatusColor(status),
                                        child: Icon(
                                          status == 'entry'
                                              ? Icons.login
                                              : Icons.logout,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(
                                        'ユーザーID: ${entryStatus['user_id']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ステータス: ${_getStatusText(status)}',
                                            style: TextStyle(
                                              color: _getStatusColor(status),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (entryAt != null)
                                            Text(
                                              '入室時刻: ${entryAt.toLocal().toString().substring(0, 19)}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          if (exitAt != null)
                                            Text(
                                              '退室時刻: ${exitAt.toLocal().toString().substring(0, 19)}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          if (updatedAt != null)
                                            Text(
                                              '更新時刻: ${updatedAt.toLocal().toString().substring(0, 19)}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
