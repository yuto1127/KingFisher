import 'package:flutter/material.dart';
import 'router.dart';
import 'package:provider/provider.dart';
import 'providers/map_image_provider.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MapImageProvider()),
      ],
      child: Builder(
        builder: (context) {
          final authProvider = Provider.of<AuthProvider>(context);
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
