import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:percon_case_project/l10n/app_localizations.dart';
import 'package:percon_case_project/pages/login_pages/login_page.dart';
import 'package:percon_case_project/pages/mainPages/home_screen.dart';
import 'package:percon_case_project/providers/locale_provider.dart';
import 'package:percon_case_project/theme/app_theme.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
    return Consumer(
      builder: (context, ref, _) {
        final locale = ref.watch(localeProvider);

        return MaterialApp(
          title: 'Percon Case Project',
          navigatorKey: navigatorKey,
          theme: AppTheme.lightTheme,
          home: const AuthWrapper(),
          locale: locale, 
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}


class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); 
        } else if (snapshot.hasData) {
          return const HomeScreen(); // if currentUser not null, navigate to home page
        } else {
          return const LoginPage(); // if currentUser null, navigate to login page
        }
      },
    );
  }
}
