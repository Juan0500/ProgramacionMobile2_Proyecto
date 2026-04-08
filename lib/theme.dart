import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF9F402D);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFFFDAD3);
  static const Color onPrimaryContainer = Color(0xFF3D0700);

  static const Color secondary = Color(0xFF77574E);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFFFDAD3);
  static const Color onSecondaryContainer = Color(0xFF2D1610);

  static const Color background = Color(0xFFFFFCFB);
  static const Color onBackground = Color(0xFF201A19);

  static const Color surface = Color(0xFFFFFCFB);
  static const Color onSurface = Color(0xFF201A19);
  static const Color surfaceVariant = Color(0xFFF5DDD8);
  static const Color onSurfaceVariant = Color(0xFF534340);

  static const Color outline = Color(0xFF85736F);
  static const Color outlineVariant = Color(0xFFD8C2BE);

  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFFFF1EE);
  static const Color surfaceContainer = Color(0xFFF9EBE8);
  static const Color surfaceContainerHigh = Color(0xFFF4E6E2);
  static const Color surfaceContainerHighest = Color(0xFFEDE0DD);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        surface: surface,
        onSurface: onSurface,
        surfaceContainerHighest: surfaceContainerHighest,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
        error: const Color(0xFFBA1A1A),
        onError: Color(0xFFFFFFFF),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.manrope(
          fontWeight: FontWeight.w800,
          color: onSurface,
          letterSpacing: -0.02,
        ),
        headlineLarge: GoogleFonts.manrope(
          fontWeight: FontWeight.bold,
          color: onSurface,
        ),
        headlineMedium: GoogleFonts.manrope(
          fontWeight: FontWeight.bold,
          color: onSurface,
        ),
        titleLarge: GoogleFonts.manrope(
          fontWeight: FontWeight.bold,
          color: onSurface,
        ),
        bodyLarge: GoogleFonts.inter(
          color: onSurface,
        ),
        bodyMedium: GoogleFonts.inter(
          color: onSurface,
        ),
        labelLarge: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          letterSpacing: 0.05,
          color: onSurface,
        ),
        labelSmall: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.05,
          color: outline,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceContainerLowest,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
