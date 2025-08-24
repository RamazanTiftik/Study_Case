import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percon_case_project/pages/login_pages/sign_up_page.dart';
import 'package:percon_case_project/pages/mainPages/home_screen.dart';
import 'package:percon_case_project/providers/locale_provider.dart';
import 'package:percon_case_project/service/auth.dart';
import 'package:percon_case_project/theme/app_theme.dart';
import 'package:percon_case_project/widgets/custom_button.dart';
import 'package:percon_case_project/widgets/custom_toast_message.dart';
import 'package:percon_case_project/providers/auth_provider.dart';
import 'package:percon_case_project/l10n/app_localizations.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  //text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //auth service
  final Auth _authService = Auth();

  //sign in method
  Future<void> signIn() async {
    //state management initialize
    final authNotifier = ref.read(authProvider.notifier);

    await authNotifier.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    final state = ref.read(authProvider);
    if (state.user != null && mounted) {
      //if user not null, it's mean -> user did not signout then navigate to home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (state.error != null) {
      showToast(
        context,
        "${AppLocalizations.of(context)!.loginFailed}: ${state.error}",
        false,
      );
    }
  }

  //reset password -> send link to the mail
  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email: email);
      if (!mounted) return;
      showToast(
        context,
        AppLocalizations.of(context)!.resetPasswordLinkSent,
        true,
      );
    } on FirebaseException catch (e) {
      showToast(
        context,
        "${AppLocalizations.of(context)!.error}: ${e.message}",
        false,
      );
    }
  }

  //sign in with google method
  Future<void> signInWithGoogle() async {
    final authNotifier = ref.read(authProvider.notifier);

    await authNotifier.loginWithGoogle();

    final state = ref.read(authProvider);
    if (state.user != null && mounted) {
      //login handled, navigate to home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (state.error != null) {
      showToast(
        context,
        "${AppLocalizations.of(context)!.googleSignInFailed}: ${state.error}",
        false,
      );
    }
  }

  //reset password modal method
  void showResetPasswordDialog() {
    final TextEditingController resetEmailController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(l10n.resetPassword),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.enterEmailToReset),
              const SizedBox(height: 15),
              TextField(
                controller: resetEmailController,
                decoration: InputDecoration(
                  hintText: l10n.emailHint,
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
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final email = resetEmailController.text.trim();
                if (email.isNotEmpty) {
                  resetPassword(email);
                  Navigator.pop(context);
                } else {
                  showToast(context, l10n.enterEmailAlert, false);
                }
              },
              child: Text(l10n.send),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //auth state
    final authState = ref.watch(authProvider);

    //localization
    final l10n = AppLocalizations.of(context)!;

    //VIEW
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                //TR Button
                GestureDetector(
                  onTap: () => ref.read(localeProvider.notifier).state =
                      const Locale('tr'),
                  child: Image.asset(
                    "assets/images/tr.png",
                    height: 45,
                    width: 45,
                  ),
                ),

                const SizedBox(width: 35),

                //DE Button
                GestureDetector(
                  onTap: () => ref.read(localeProvider.notifier).state =
                      const Locale('de'),
                  child: Image.asset(
                    "assets/images/de.png",
                    height: 45,
                    width: 45,
                  ),
                ),

                const SizedBox(width: 35),

                //UK Button
                GestureDetector(
                  onTap: () => ref.read(localeProvider.notifier).state =
                      const Locale('en'),
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
                  //mail textfield
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: l10n.emailHint,
                      border: const OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  //password textfield
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: l10n.passwordHint,
                      border: const OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  //reset password text button
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: showResetPasswordDialog,
                      child: Text(
                        l10n.forgotPassword,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  //error -> toast message
                  if (authState.error != null)
                    Text(
                      authState.error!,
                      style: const TextStyle(color: Colors.red),
                    ),

                  const SizedBox(height: 30),

                  //sign in button
                  CustomButton(
                    text: authState.isLoading ? l10n.loggingIn : l10n.login,
                    onPressed: authState.isLoading ? null : signIn,
                    backgroundColor: AppTheme.primaryColor,
                    borderRadius: 20,
                    height: 55,
                  ),

                  const SizedBox(height: 30),

                  //sign up button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignUpPage()),
                      );
                    },
                    child: Text(l10n.noAccountYet),
                  ),

                  const SizedBox(height: 30),

                  //sign in with google button
                  GestureDetector(
                    onTap: authState.isLoading ? null : signInWithGoogle,
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

  //dispose
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
