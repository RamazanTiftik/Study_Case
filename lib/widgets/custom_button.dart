import 'package:flutter/material.dart';
import 'package:percon_case_project/theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final double? borderRadius;
  final double? height;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.borderRadius,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: AppTheme.elevatedButtonStyle(
          backgroundColor: backgroundColor,
          borderRadius: borderRadius ?? 12,
          height: height ?? 50,
        ),
        child: Text(text),
      ),
    );
  }
}
