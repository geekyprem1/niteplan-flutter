import 'package:flutter/material.dart';

// ── Brand Colors ──
const Color kDeepNavy    = Color(0xFF1A1A2E);
const Color kCardBg      = Color(0xFF1E1E30);
const Color kAccent      = Color(0xFF7C4DFF);
const Color kAccentLight = Color(0xFFB39DDB);
const Color kSuccess     = Color(0xFF00C896);
const Color kWarning     = Color(0xFFFF9100);
const Color kDanger      = Color(0xFFFF4060);
const Color kTextPrimary = Color(0xFFF0F0F5);
const Color kTextMuted   = Color(0xFF9090AA);
const Color kDivider     = Color(0xFF2A2A40);
const Color kSurface     = Color(0xFF12121E);

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: kSurface,
    colorScheme: const ColorScheme.dark(
      primary: kAccent,
      onPrimary: Colors.white,
      secondary: kAccentLight,
      onSecondary: kDeepNavy,
      error: kDanger,
      onError: Colors.white,
      surface: kCardBg,
      onSurface: kTextPrimary,
      primaryContainer: Color(0xFF2A1A4E),
      onPrimaryContainer: kAccentLight,
      secondaryContainer: Color(0xFF2A2A40),
      onSecondaryContainer: kTextPrimary,
      errorContainer: Color(0xFF3A1020),
      onErrorContainer: kDanger,
      outline: kDivider,
      surfaceContainerHighest: Color(0xFF252535),
    ),
    cardTheme: CardTheme(
      color: kCardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: kSurface,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: kTextPrimary),
      titleTextStyle: TextStyle(
        color: kTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: kCardBg,
      indicatorColor: kAccent.withValues(alpha: 0.2),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: kAccent);
        }
        return const IconThemeData(color: kTextMuted);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(color: kAccent, fontWeight: FontWeight.bold, fontSize: 11);
        }
        return const TextStyle(color: kTextMuted, fontSize: 11);
      }),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: kTextPrimary, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(color: kTextPrimary, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: kTextPrimary),
      bodyMedium: TextStyle(color: kTextPrimary),
      bodySmall: TextStyle(color: kTextMuted),
      labelLarge: TextStyle(color: kTextPrimary, fontWeight: FontWeight.w600),
      labelMedium: TextStyle(color: kTextMuted),
      labelSmall: TextStyle(color: kTextMuted, fontSize: 10),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF252535),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kDivider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kDivider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kAccent, width: 1.5),
      ),
      labelStyle: const TextStyle(color: kTextMuted),
      hintStyle: const TextStyle(color: kTextMuted),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
    ),
    dividerTheme: const DividerThemeData(color: kDivider, space: 1),
  );
}

// ── Shared Widgets ──

Widget buildSectionHeader(String title, {String? subtitle, Widget? trailing}) {
  return Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
            if (subtitle != null) Text(subtitle, style: const TextStyle(color: kTextMuted, fontSize: 12)),
          ],
        ),
      ),
      if (trailing != null) trailing,
    ],
  );
}

Widget buildStatChip(String label, String value, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Column(
      children: [
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 22)),
        Text(label, style: const TextStyle(color: kTextMuted, fontSize: 10)),
      ],
    ),
  );
}
