import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../layouts/main_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
        children: [
          AppBar(
            title: const Text('ホーム'),
            backgroundColor: Color(0xFF009a73),
            foregroundColor: Colors.white,
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'ホームページ',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // 設定ページへ遷移
                      context.go('/settings');
                    },
                    child: const Text('設定ページへ'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // プロフィールページへ遷移
                      context.go('/profile');
                    },
                    child: const Text('プロフィールページへ'),
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
