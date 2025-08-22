import 'package:flutter/material.dart';
import 'package:percon_case_project/pages/mainPages/profile_screen.dart';
import 'package:percon_case_project/widgets/custom_app_bar.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    // VIEW
    return Scaffold(
      appBar: CustomAppBar(
        title: "Favorite Screen",
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
    );
  }
}
