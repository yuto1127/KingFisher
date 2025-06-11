import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'pages/home_page.dart';
import 'pages/settings_page.dart';
import 'pages/information_page.dart';
import 'pages/map_page.dart';
import 'pages/qr_reader_page.dart';
import 'pages/admin_page.dart';
import 'pages/admin_content.dart';
import 'pages/admin_user.dart';
import 'pages/registration_page.dart';
import 'pages/login_page.dart';

// 認証が必要なルート
final _authenticatedRoutes = {
  '/',
  '/information',
  '/map',
  '/qr-reader',
  '/settings',
  '/admin',
  '/admin/content',
  '/admin/user',
};

GoRouter createRouter(AuthProvider authProvider) => GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final isAuthenticated = authProvider.isAuthenticated;
    final isAuthRoute = _authenticatedRoutes.contains(state.fullPath);
    final isLoginRoute = state.fullPath == '/login';
    final isRegisterRoute = state.fullPath == '/register';

    // 未ログインで認証が必要なルートにアクセスした場合
    if (!isAuthenticated && isAuthRoute) {
      return '/login';
    }

    // ログイン済みでログインページにアクセスした場合
    if (isAuthenticated && (isLoginRoute || isRegisterRoute)) {
      return '/';
    }

    return null;
  },
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(
      title: const Text('エラー'),
      backgroundColor: Color(0xFF009a73),
      foregroundColor: Colors.white,
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'ページが見つかりません',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/login'),
            child: const Text('ログインページに戻る'),
          ),
        ],
      ),
    ),
  ),
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegistrationPage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/information',
      builder: (context, state) => const InformationPage(),
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) => const MapPage(),
    ),
    GoRoute(
      path: '/qr-reader',
      builder: (context, state) => const QRReaderPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminPage(),
    ),
    GoRoute(
      path: '/admin/content',
      builder: (context, state) => const AdminContentPage(),
    ),
    GoRoute(
      path: '/admin/user',
      builder: (context, state) => const AdminUserPage(),
    ),
  ],
);
