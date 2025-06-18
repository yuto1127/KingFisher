import 'package:flutter/material.dart';
import 'router.dart';
import 'package:provider/provider.dart';
import 'providers/map_image_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/info_provider.dart';
import 'providers/icon_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MapImageProvider()),
        ChangeNotifierProvider(create: (_) => InfoProvider()),
        ChangeNotifierProvider(create: (_) => IconProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MapImageProvider()),
        ChangeNotifierProvider(create: (_) => InfoProvider()),
      ],
      child: Builder(
        builder: (context) {
          final authProvider = Provider.of<AuthProvider>(context);

          // アプリ起動時に認証データを初期化
          WidgetsBinding.instance.addPostFrameCallback((_) {
            authProvider.initializeAuth();
          });

          return MaterialApp.router(
            title: 'KingFisher',
            theme: ThemeData(
              primarySwatch: Colors.green,
              primaryColor: const Color(0xFF009a73),
            ),
            routerConfig: createRouter(authProvider),
          );
        },
      ),
    );
  }
}
