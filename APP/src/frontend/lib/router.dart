import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages/home_page.dart';
import 'pages/settings_page.dart';
import 'pages/information_page.dart';
import 'pages/map_page.dart';
import 'pages/qr_reader_page.dart';

final router = GoRouter(
  initialLocation: '/',
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
            onPressed: () => context.go('/'),
            child: const Text('ホームに戻る'),
          ),
        ],
      ),
    ),
  ),
  routes: [
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
  ],
);
