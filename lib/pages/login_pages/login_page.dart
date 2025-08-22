import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percon_case_project/pages/login_pages/sign_up_page.dart';
import 'package:percon_case_project/pages/mainPages/home_screen.dart';
import 'package:percon_case_project/service/auth.dart';
import 'package:percon_case_project/theme/app_theme.dart';
import 'package:percon_case_project/widgets/custom_button.dart';
import 'package:percon_case_project/widgets/custom_toast_message.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // auth service
  final Auth _authService = Auth();

  // error message
  String? errorMessage;

  // sign in method
  Future<void> signIn() async {
    try {
      await _authService.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });

      showToast(context, "Giriş Başarısız! ${e.message}", false);
    }
  }

  // reset password
  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email: email);

      if (!mounted) return;

      showToast(
        context,
        "Şifre sıfırlama linki e-posta adresinize gönderildi.",
        true,
      );
    } on FirebaseAuthException catch (e) {
      showToast(context, "Hata: ${e.message}", false);
    }
  }

  // google sign-in
  Future<void> signInWithGoogle() async {
    try {
      final userCredential = await _authService.signInWithGoogle();
      if (userCredential == null) return;
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      showToast(context, "Google ile giriş başarısız: ${e.message}", false);
    }
  }

  // forget password dialog
  void showResetPasswordDialog() {
    final TextEditingController resetEmailController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text("Şifreyi Sıfırla"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "E-posta adresinizi girin, şifre sıfırlama linki gönderilecek.",
              ),
              const SizedBox(height: 15),
              TextField(
                controller: resetEmailController,
                decoration: InputDecoration(
                  hintText: "E-posta adresiniz",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("İptal"),
            ),
            ElevatedButton(
              onPressed: () {
                final email = resetEmailController.text.trim();
                if (email.isNotEmpty) {
                  resetPassword(email);
                  Navigator.pop(context);
                } else {
                  showToast(context, "Lütfen e-posta giriniz!", false);
                }
              },
              child: const Text("Gönder"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 100),

            // Language selection
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => print("🇹🇷 Türkçe seçildi"),
                  child: Image.asset(
                    "assets/images/tr.png",
                    height: 45,
                    width: 45,
                  ),
                ),
                const SizedBox(width: 35),
                GestureDetector(
                  onTap: () => print("🇩🇪 Almanca seçildi"),
                  child: Image.asset(
                    "assets/images/de.png",
                    height: 45,
                    width: 45,
                  ),
                ),
                const SizedBox(width: 35),
                GestureDetector(
                  onTap: () => print("🇬🇧 İngilizce seçildi"),
                  child: Image.asset(
                    "assets/images/uk.png",
                    height: 45,
                    width: 45,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // email
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // password
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // forget password
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: showResetPasswordDialog,
                      child: const Text(
                        "Şifreyi mi Unuttunuz?",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // error
                  errorMessage != null
                      ? Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        )
                      : const SizedBox.shrink(),

                  const SizedBox(height: 30),

                  // login button
                  CustomButton(
                    text: "Giriş Yap",
                    onPressed: signIn,
                    backgroundColor: AppTheme.primaryColor,
                    borderRadius: 20,
                    height: 55,
                  ),

                  const SizedBox(height: 30),

                  // register
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignUpPage()),
                      );
                    },
                    child: const Text("Henüz Hesabınız Yok Mu?"),
                  ),

                  const SizedBox(height: 30),

                  // google sign-in
                  GestureDetector(
                    onTap: signInWithGoogle,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      height: 75,
                      width: 75,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Image.asset(
                        "assets/images/google.png",
                        height: 30,
                        width: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
