import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../layouts/main_layout.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: [
          AppBar(
            title: const Text('設定'),
            backgroundColor: const Color(0xFF009a73),
            foregroundColor: Colors.white,
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '設定ページ',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // ホームページへ戻る
                      context.go('/');
                    },
                    child: const Text('ホームへ戻る'),
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
