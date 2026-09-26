import 'package:flutter/material.dart';

/// PROJECT BLACK SKY visual identity: matte black surfaces, red accent,
/// condensed military-HUD typography feel using system fonts until a custom
/// display font is licensed/added under assets/fonts.
class AppTheme {
  AppTheme._();

  static const Color background = Color(0xFF0A0A0B);
  static const Color surface = Color(0xFF141416);
  static const Color surfaceRaised = Color(0xFF1D1D20);
  static const Color accentRed = Color(0xFFE0272B);
  static const Color accentRedDim = Color(0xFF7A1518);
  static const Color textPrimary = Color(0xFFEAEAEA);
  static const Color textSecondary = Color(0xFF9A9A9E);
  static const Color hudGreen = Color(0xFF4CD97B);
  static const Color hudAmber = Color(0xFFE0A72B);

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: background,
      colorScheme: base.colorScheme.copyWith(
        primary: accentRed,
        secondary: hudAmber,
        surface: surface,
        error: accentRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 20,
          letterSpacing: 1.2,
        ),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentRed,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.1),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceRaised,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: const BorderSide(color: Color(0xFF2A2A2E)),
        ),
      ),
      dividerColor: const Color(0xFF2A2A2E),
    );
  }
}
