import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final bool showBottomNav;

  const MainLayout({
    super.key,
    required this.child,
    this.showBottomNav = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: showBottomNav
          ? BottomNavigationBar(
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
                  icon: Icon(Icons.qr_code),
                  label: '会員証',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.umbrella),
                  label: '落とし物',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'プロフィール',
                ),
              ],
              selectedItemColor: Color(0xFF009a73),
            )
          : null,
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/information')) return 0;
    if (location.startsWith('/map')) return 1;
    if (location.startsWith('/lost-item')) return 3;
    if (location.startsWith('/profile')) return 4;
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
        context.go('/lost-item');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }
}
