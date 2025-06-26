import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'router.dart';
import 'package:provider/provider.dart';
import 'providers/map_image_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/info_provider.dart';
import 'providers/icon_provider.dart';
import 'utils/browser_utils.dart';
import 'utils/browser_test_utils.dart';
import 'utils/mobile_utils.dart';

void main() {
  // ブラウザ設定を適用
  BrowserUtils.applyBrowserSettings();

  // モバイルデバイス対応を初期化
  if (kIsWeb) {
    MobileUtils.applyMobileOptimizations();
  }

  // デバッグモードでブラウザ情報をログ出力
  if (kDebugMode) {
    BrowserTestUtils.logDebugInfo();
    if (kIsWeb) {
      MobileUtils.logMobileDebugInfo();
    }
  }

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
          builder: (context, child) {
            // ブラウザ警告メッセージを表示
            final warningMessage = BrowserUtils.getBrowserWarningMessage();
            if (warningMessage != null) {
              return _BrowserWarningOverlay(
                message: warningMessage,
                child: child!,
              );
            }
            return child!;
          },
        );
      },
    );
  }
}

/// ブラウザ警告を表示するオーバーレイ
class _BrowserWarningOverlay extends StatelessWidget {
  final String message;
  final Widget child;

  const _BrowserWarningOverlay({
    required this.message,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.orange.shade100,
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.orange.shade800, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Colors.orange.shade800,
                      fontSize: 12,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close,
                      color: Colors.orange.shade800, size: 20),
                  onPressed: () {
                    // 警告を閉じる処理（必要に応じて実装）
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
