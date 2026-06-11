import 'package:flutter/material.dart';

const Color kPrimary = Color(0xFF6750A4);
const Color kOnPrimary = Colors.white;
const Color kSecondary = Color(0xFFEADDFF);
const Color kOnSecondary = Color(0xFF21005D);
const Color kBackground = Color(0xFFFEF7FF);
const Color kSurface = Colors.white;
const Color kSurfaceVariant = Color(0xFFF3EDF7);
const Color kOnSurface = Color(0xFF1D1B20);
const Color kOnSurfaceVariant = Color(0xFF49454F);
const Color kOutline = Color(0xFFCAC4D0);
const Color kError = Color(0xFFB3261E);
const Color kErrorContainer = Color(0xFFF2B8B5);
const Color kGreenDone = Color(0xFF2E7D32);
const Color kGreenDark = Color(0xFF1B5E20);

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: kPrimary,
      onPrimary: kOnPrimary,
      secondary: kSecondary,
      onSecondary: kOnSecondary,
      error: kError,
      onError: Colors.white,
      surface: kBackground,
      onSurface: kOnSurface,
      primaryContainer: Color(0xFFEADDFF),
      onPrimaryContainer: Color(0xFF21005D),
      secondaryContainer: Color(0xFFE8DEF8),
      onSecondaryContainer: Color(0xFF1D192B),
      errorContainer: kErrorContainer,
      onErrorContainer: kError,
      outline: kOutline,
      surfaceContainerHighest: kSurfaceVariant,
    ),
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: kBackground,
    cardTheme: CardTheme(
      color: kSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
