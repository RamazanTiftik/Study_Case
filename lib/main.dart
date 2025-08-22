import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:percon_case_project/pages/login_pages/login_page.dart';
import 'package:percon_case_project/theme/app_theme.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Percon Case Project',
      navigatorKey: navigatorKey,
      theme: AppTheme.lightTheme,
      home: const LoginPage(),
    );
  }
}
