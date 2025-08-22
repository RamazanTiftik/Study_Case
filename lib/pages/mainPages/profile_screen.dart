import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percon_case_project/pages/mainPages/favorite_screen.dart';
import 'package:percon_case_project/providers/auth_provider.dart';
import 'package:percon_case_project/theme/app_theme.dart';
import 'package:percon_case_project/widgets/custom_app_bar.dart';
import 'package:percon_case_project/widgets/custom_button.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // VIEW
    return Scaffold(
      appBar: CustomAppBar(
        title: "Profile Screen",
        showBackButton: true,
        onFilterPressed: () {
          Navigator.pop(context);
        },
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            // Profil ikonu
            CircleAvatar(
              radius: 60, // büyük görünmesi için
              backgroundColor: AppTheme.primaryColor,
              child: Text(
                authState.user?.fullName != null
                    ? authState.user!.fullName![0].toUpperCase()
                    : "?",
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Kullanıcı bilgileri
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Full Name: ${authState.user?.fullName ?? 'Yok'}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Email: ${authState.user?.email ?? 'Yok'}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Created At: ${authState.user?.createdAt != null ? authState.user!.createdAt!.toString() : 'Yok'}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Last Login: ${authState.user?.lastLogin != null ? authState.user!.lastLogin!.toString() : 'Yok'}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),

            // Çıkış Yap Butonu
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: "Çıkış Yap",
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  Navigator.pop(context); // veya LoginPage’e yönlendir
                },
                backgroundColor: Colors.red,
                borderRadius: 20,
                height: 55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
