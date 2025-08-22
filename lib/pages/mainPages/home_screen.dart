import 'package:flutter/material.dart';
import 'package:percon_case_project/main.dart';
import 'package:percon_case_project/pages/login_pages/login_page.dart';
import 'package:percon_case_project/service/auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //auth service
    Auth authService = Auth();

    Future<void> appBarSignOut() async {
      await authService.signOut();
      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }

    //VIEW
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(onPressed: appBarSignOut, child: Text("Çıkış Yap")),
        ],
      ),
      body: Center(child: Text("Home Screen")),
    );
  }
}
