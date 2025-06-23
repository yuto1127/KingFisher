import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // アプリ起動時に認証データを初期化（一度だけ実行）
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (authProvider.isLoading) {
            authProvider.initializeAuth();
          }
        });

        return MaterialApp.router(
          title: 'KingFisher',
          theme: ThemeData(
            primarySwatch: Colors.green,
            primaryColor: const Color(0xFF009a73),
          ),
          routerConfig: createRouter(authProvider),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ja', 'JP'),
          ],
        );
      },
    );
  }
}
