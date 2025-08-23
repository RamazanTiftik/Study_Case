import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:percon_case_project/pages/login_pages/login_page.dart';
import 'package:percon_case_project/pages/mainPages/home_screen.dart';
import 'package:percon_case_project/theme/app_theme.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Percon Case Project',
      navigatorKey: navigatorKey,
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(), // 🔥 LoginPage yerine AuthWrapper
    );
  }
}

// Kullanıcının oturum durumunu kontrol eden widget
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Kullanıcıyı dinler
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // yükleniyor
        } else if (snapshot.hasData) {
          return const HomeScreen(); // if currentUser not null, navigate to home page
        } else {
          return const LoginPage(); // if currentUser null, navigate to login page
        }
      },
    );
  }
}
