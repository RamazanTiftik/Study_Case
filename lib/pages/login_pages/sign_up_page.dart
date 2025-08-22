import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percon_case_project/pages/login_pages/login_page.dart';
import 'package:percon_case_project/service/auth.dart';
import 'package:percon_case_project/theme/app_theme.dart';
import 'package:percon_case_project/widgets/custom_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // email & password controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();

  // error message
  String? errorMessage;

  // auth service
  final Auth _authService = Auth();

  // register method (Email/Password)
  Future<void> createUser() async {
    // password check
    if (passwordController.text != passwordConfirmController.text) {
      setState(() {
        errorMessage = "Şifreler uyuşmuyor!";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage!),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      await _authService.createUser(
        email: emailController.text,
        password: passwordController.text,
      );

      // Login sayfasına yönlendir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });

      // Hata mesajı
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Kayıt Başarısız! $errorMessage"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 196, 217, 234),
        title: Text("Kayıt Ol"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // email text field
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                // password text field
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                // confirm password text field
                TextField(
                  controller: passwordConfirmController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                // error message
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),

                const SizedBox(height: 30),

                // sign up button
                CustomButton(
                  text: "Kayıt Ol",
                  onPressed: createUser,
                  backgroundColor: AppTheme.primaryColor,
                  borderRadius: 20,
                  height: 55,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
