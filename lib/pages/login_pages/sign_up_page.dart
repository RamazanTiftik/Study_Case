import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percon_case_project/l10n/app_localizations.dart';
import 'package:percon_case_project/pages/login_pages/login_page.dart';
import 'package:percon_case_project/theme/app_theme.dart';
import 'package:percon_case_project/widgets/custom_button.dart';
import 'package:percon_case_project/providers/auth_provider.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  //text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  //create user method
  Future<void> createUser() async {
    //state management
    final authNotifier = ref.read(authProvider.notifier);

    //localization
    final loc = AppLocalizations.of(context)!;

    // password check
    if (passwordController.text != passwordConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.passwordsDoNotMatch),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    await authNotifier.register(
      emailController.text.trim(),
      passwordController.text.trim(),
      usernameController.text.trim(),
    );

    // state check after register
    final state = ref.watch(authProvider);
    if (state.user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${loc.signUpFailed} ${state.error}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //auth state
    final authState = ref.watch(authProvider);

    //localization
    final loc = AppLocalizations.of(context)!;

    //VIEW
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 196, 217, 234),
        title: Text(loc.signUp),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // username
                TextField(
                  controller: usernameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: loc.usernameHint,
                    border: const OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                // email
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: loc.email,
                    border: const OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                // password
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: loc.password,
                    border: const OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                // confirm password
                TextField(
                  controller: passwordConfirmController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: loc.confirmPassword,
                    border: const OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                // error message
                if (authState.error != null)
                  Text(
                    authState.error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),

                const SizedBox(height: 20),

                // sign up button
                CustomButton(
                  text: authState.isLoading ? loc.signingUp : loc.signUp,
                  onPressed: authState.isLoading
                      ? null
                      : () async => await createUser(),
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

  //dispose
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    usernameController.dispose();
    super.dispose();
  }
}
