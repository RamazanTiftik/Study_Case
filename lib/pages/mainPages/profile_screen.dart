import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:percon_case_project/pages/login_pages/login_page.dart';
import 'package:percon_case_project/pages/mainPages/favorite_screen.dart';
import 'package:percon_case_project/providers/auth_provider.dart';
import 'package:percon_case_project/theme/app_theme.dart';
import 'package:percon_case_project/widgets/custom_alert.dart';
import 'package:percon_case_project/widgets/custom_app_bar.dart';
import 'package:percon_case_project/widgets/custom_button.dart';
import 'package:percon_case_project/l10n/app_localizations.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String formatDate(DateTime? date) {
    if (date == null) return AppLocalizations.of(context)!.none;
    return DateFormat("dd/MM/yyyy HH:mm").format(date);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(
        title: loc.profileScreen,
        showBackButton: true,
        onFilterPressed: () => Navigator.pop(context),
        onFavoritePressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FavoriteScreen()),
          );
        },
        onProfilePressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          children: [
            // profile icon
            CircleAvatar(
              radius: 80,
              backgroundColor: AppTheme.primaryColor,
              child: Text(
                authState.user?.fullName != null
                    ? authState.user!.fullName![0].toUpperCase()
                    : "?",
                style: const TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50),

            // user info
            Expanded(
              child: ListView(
                children: [
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.person, color: Colors.grey),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "${loc.fullName}: ${authState.user?.fullName ?? loc.none}",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.email, color: Colors.grey),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "${loc.email}: ${authState.user?.email ?? loc.none}",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "${loc.createdAt}: ${formatDate(authState.user?.createdAt)}",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.login, color: Colors.grey),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "${loc.lastLogin}: ${formatDate(authState.user?.lastLogin)}",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // sign out button
            CustomButton(
              text: loc.logout,
              onPressed: () async {
                CustomAlert.show(
                  context,
                  title: loc.warning,
                  message: loc.confirmLogout,
                  confirmText: loc.yes,
                  cancelText: loc.no,
                  onConfirm: () async {
                    await ref.read(authProvider.notifier).logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  onCancel: () {},
                );
              },
              backgroundColor: Colors.red,
              borderRadius: 20,
              height: 55,
            ),
          ],
        ),
      ),
    );
  }
}
