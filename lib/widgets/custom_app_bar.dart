import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onFilterPressed;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onProfilePressed;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onFilterPressed,
    this.onFavoritePressed,
    this.onProfilePressed,
    this.showBackButton = false, // default false
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              iconSize: 28,
              onPressed: () => Navigator.pop(context),
            )
          : IconButton(
              icon: const Icon(Icons.filter_list),
              iconSize: 30,
              onPressed: onFilterPressed,
            ),
      title: Text(title),
      actions: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.favorite),
                iconSize: 28,
                color: Colors.red,
                onPressed: onFavoritePressed,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.person),
                iconSize: 28,
                color: Colors.blue,
                onPressed: onProfilePressed,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
