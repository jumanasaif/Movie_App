import 'package:flutter/material.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,

    scaffoldBackgroundColor: const Color(0xFF0B0C10),
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFFB71C1C),
      secondary: const Color(0xFFFFD700),
      surface: const Color(0xFF1F1F1F),
      onPrimary: Colors.white,
      onSurface: Colors.white70,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Bilbo',
        fontSize: 42,
        fontWeight: FontWeight.w500,
        color: Color(0xFFFFD700),
      ),
      bodyMedium: TextStyle(fontSize: 16, color: Color(0xFFECECEC)),
    ),
    cardColor: const Color(0xFF1F1F1F),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0B0C10),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
  );
}
