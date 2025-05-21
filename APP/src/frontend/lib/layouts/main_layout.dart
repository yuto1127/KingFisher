import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'インフォ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'マップ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'QR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: '設定',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/information')) return 0;
    if (location.startsWith('/map')) return 1;
    if (location.startsWith('/qr-reader')) return 3;
    if (location.startsWith('/settings')) return 4;
    return 2; // ホームページ
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/information');
        break;
      case 1:
        context.go('/map');
        break;
      case 2:
        context.go('/');
        break;
      case 3:
        context.go('/qr-reader');
        break;
      case 4:
        context.go('/settings');
        break;
    }
  }
}
