import 'package:flutter/material.dart';

class AppTheme {
  // Gen Z Color Palette
  static const _neonLime = Color(0xFFCCFF00);
  static const _electricViolet = Color(0xFF6A00FF);
  static const _hotPink = Color(0xFFFF00CC);
  static const _pitchBlack = Color(0xFF000000);
  static const _offBlack = Color(0xFF121212);
  static const _pureWhite = Color(0xFFFFFFFF);
  static const _softGrey = Color(0xFFF0F0F0);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: _electricViolet,
      onPrimary: _pureWhite,
      primaryContainer: _softGrey, // Use soft grey for container backgrounds to avoid dark violet
      onPrimaryContainer: _electricViolet, // Text on container is violet
      secondary: _hotPink,
      onSecondary: _pureWhite,
      background: _pureWhite,
      surface: _softGrey,
      onSurface: _pitchBlack,
      error: const Color(0xFFFF3333),
    ),
    scaffoldBackgroundColor: _pureWhite,
    appBarTheme: const AppBarTheme(
      backgroundColor: _pureWhite,
      foregroundColor: _pitchBlack,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: _pitchBlack,
        fontSize: 24,
        fontWeight: FontWeight.w900,
        letterSpacing: -1.0, // Tight kerning
      ),
      iconTheme: IconThemeData(color: _pitchBlack),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _pitchBlack,
        foregroundColor: _neonLime,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Pill shape
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _pitchBlack,
        foregroundColor: _neonLime,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _softGrey,
      contentPadding: const EdgeInsets.all(20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: _electricViolet, width: 2),
      ),
      hintStyle: TextStyle(
        color: _pitchBlack.withOpacity(0.5),
        fontWeight: FontWeight.w500,
      ),
    ),
    cardTheme: CardThemeData(
      color: _softGrey,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _electricViolet,
      foregroundColor: _pureWhite,
      elevation: 0,
      shape: CircleBorder(),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        letterSpacing: -1.5,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.0,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: _neonLime,
      onPrimary: _pitchBlack, // High contrast
      primaryContainer: _offBlack, // Keep it dark
      onPrimaryContainer: _neonLime, // Neon text
      secondary: _electricViolet,
      onSecondary: _pureWhite,
      background: _pitchBlack,
      surface: _offBlack,
      onSurface: _pureWhite,
      error: const Color(0xFFFF3333),
    ),
    scaffoldBackgroundColor: _pitchBlack,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: _pureWhite,
        fontSize: 32,
        fontWeight: FontWeight.w900,
        letterSpacing: -1.5,
      ),
      headlineMedium: TextStyle(
        color: _pureWhite,
        fontSize: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.0,
      ),
      titleLarge: TextStyle(
        color: _pureWhite,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
      bodyLarge: TextStyle(
        color: _pureWhite,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _pitchBlack,
      foregroundColor: _pureWhite,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: _pureWhite,
        fontSize: 24,
        fontWeight: FontWeight.w900,
        letterSpacing: -1.0,
      ),
      iconTheme: IconThemeData(color: _pureWhite),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _neonLime,
        foregroundColor: _pitchBlack,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _neonLime,
        foregroundColor: _pitchBlack,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _offBlack,
      contentPadding: const EdgeInsets.all(20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: _offBlack, width: 2), // Subtle border
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: _offBlack, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: _neonLime, width: 2),
      ),
      hintStyle: TextStyle(
        color: _pureWhite.withOpacity(0.5),
        fontWeight: FontWeight.w500,
      ),
    ),
    cardTheme: CardThemeData(
      color: _offBlack,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _neonLime,
      foregroundColor: _pitchBlack,
      elevation: 0,
      shape: CircleBorder(),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _pitchBlack,
      selectedItemColor: _neonLime,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false, // Clean look
      showUnselectedLabels: false,
    ),
  );
}
