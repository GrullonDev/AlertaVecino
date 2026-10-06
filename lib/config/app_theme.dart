import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF1B3A5C);
  static const primaryLight = Color(0xFF2A5A8C);
  static const secondary = Color(0xFF2A9D8F);
  static const secondaryLight = Color(0xFF3CC4B4);

  static const panic = Color(0xFFD32F2F);
  static const panicBg = Color(0xFFFDEAEA);
  static const warning = Color(0xFFE65100);
  static const warningBg = Color(0xFFFFF3E0);
  static const caution = Color(0xFFF9A825);
  static const cautionBg = Color(0xFFFFFDE7);
  static const success = Color(0xFF2E7D32);
  static const successBg = Color(0xFFE8F5E9);
  static const info = Color(0xFF1565C0);
  static const infoBg = Color(0xFFE3F2FD);

  static const panicDark = Color(0xFFEF5350);
  static const panicBgDark = Color(0xFF2D1A1A);
  static const warningDark = Color(0xFFFF8A50);
  static const warningBgDark = Color(0xFF2D2010);
  static const cautionDark = Color(0xFFFFD54F);
  static const cautionBgDark = Color(0xFF2D2A10);
  static const successDark = Color(0xFF66BB6A);
  static const successBgDark = Color(0xFF1A2D1A);
  static const infoDark = Color(0xFF42A5F5);
  static const infoBgDark = Color(0xFF1A2030);
}

class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFEDF4FB),
      onPrimaryContainer: AppColors.primary,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFE0F5F2),
      onSecondaryContainer: const Color(0xFF1A6B60),
      surface: Colors.white,
      onSurface: const Color(0xFF1A1D23),
      onSurfaceVariant: const Color(0xFF6B7080),
      error: AppColors.panic,
      onError: Colors.white,
      outline: const Color(0xFFE2E4EA),
      outlineVariant: const Color(0xFFF0F1F4),
      shadow: Colors.black,
      inverseSurface: const Color(0xFF1A1D23),
      onInverseSurface: const Color(0xFFE4E6EC),
      surfaceContainerHighest: const Color(0xFFF7F8FA),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF7F8FA),
      textTheme: _buildTextTheme(colorScheme),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1D23),
        elevation: 0,
        scrolledUnderElevation: 1,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1D23),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE2E4EA)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 52),
          side: const BorderSide(color: Color(0xFFE2E4EA)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E4EA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E4EA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.panic),
        ),
        labelStyle: GoogleFonts.inter(color: const Color(0xFF6B7080)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Color(0xFF6B7080),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE2E4EA),
        thickness: 1,
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: const Color(0xFF5B9BD5),
      onPrimary: const Color(0xFF0A1929),
      primaryContainer: const Color(0xFF1A2636),
      onPrimaryContainer: const Color(0xFF7AB5E8),
      secondary: const Color(0xFF3CC4B4),
      onSecondary: const Color(0xFF0A2924),
      secondaryContainer: const Color(0xFF1A3630),
      onSecondaryContainer: const Color(0xFF5EDDD0),
      surface: const Color(0xFF1A1D24),
      onSurface: const Color(0xFFE4E6EC),
      onSurfaceVariant: const Color(0xFF8B90A0),
      error: AppColors.panicDark,
      onError: const Color(0xFF2D1A1A),
      outline: const Color(0xFF2A2D36),
      outlineVariant: const Color(0xFF22252C),
      shadow: Colors.black,
      inverseSurface: const Color(0xFFE4E6EC),
      onInverseSurface: const Color(0xFF1A1D23),
      surfaceContainerHighest: const Color(0xFF111318),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF111318),
      textTheme: _buildTextTheme(colorScheme),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1A1D24),
        foregroundColor: const Color(0xFFE4E6EC),
        elevation: 0,
        scrolledUnderElevation: 1,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFE4E6EC),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1A1D24),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF2A2D36)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5B9BD5),
          foregroundColor: const Color(0xFF0A1929),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF5B9BD5),
          minimumSize: const Size(double.infinity, 52),
          side: const BorderSide(color: Color(0xFF2A2D36)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1A1D24),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2A2D36)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2A2D36)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF5B9BD5), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF5350)),
        ),
        labelStyle: GoogleFonts.inter(color: const Color(0xFF8B90A0)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1A1D24),
        selectedItemColor: Color(0xFF5B9BD5),
        unselectedItemColor: Color(0xFF8B90A0),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2A2D36),
        thickness: 1,
      ),
    );
  }

  static TextTheme _buildTextTheme(ColorScheme cs) {
    return TextTheme(
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: cs.onSurface,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: cs.onSurface,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: cs.onSurface,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: cs.onSurface,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: cs.onSurface,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: cs.onSurface,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: cs.onSurface,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: cs.onSurfaceVariant,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: cs.onSurfaceVariant,
      ),
    );
  }
}
