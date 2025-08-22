import 'package:flutter/material.dart';

class AppTheme {
  // Genel primary color
  static const Color primaryColor = Color(0xFF1976D2); // mavi ton
  static const Color secondaryColor = Color(0xFF42A5F5); // açık mavi
  static const Color accentColor = Color(0xFFFFC107); // sarı

  // TextStyle
  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // ElevatedButton Theme
  static ButtonStyle elevatedButtonStyle({
    Color? backgroundColor,
    double borderRadius = 12,
    double height = 50,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      textStyle: buttonTextStyle,
      minimumSize: Size(double.infinity, height),
    );
  }

  // App genel teması
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: elevatedButtonStyle()),
  );
}
