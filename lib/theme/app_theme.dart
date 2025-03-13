import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors - Updated with premium color palette
  static const Color primaryColor = Color(0xFF3366FF);
  static const Color primaryDarkColor = Color(0xFF1A3BC1);
  static const Color primaryLightColor = Color(0xFFE0E7FF);
  static const Color secondaryColor = Color(0xFF00C6B3);
  static const Color accentColor = Color(0xFFF6575F);
  static const Color gradientStart = Color(0xFF3366FF);
  static const Color gradientEnd = Color(0xFF00C6B3);
  static const Color backgroundColor = Color(0xFFF9FAFF);
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF1A2151);
  static const Color textSecondaryColor = Color(0xFF8E94AA);
  static const Color dividerColor = Color(0xFFEEF0F6);
  static const Color errorColor = Color(0xFFF6575F);
  static const Color successColor = Color(0xFF00C096);
  static const Color warningColor = Color(0xFFFFB950);
  static const Color shadowColor = Color(0x1A000000);
  static const Color shimmerBaseColor = Color(0xFFEEF1F8);
  static const Color shimmerHighlightColor = Color(0xFFF9FAFF);

  // Text Styles - Enhanced with Google Fonts
  static TextStyle get headlineLarge => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
        letterSpacing: -0.5,
      );

  static TextStyle get headlineMedium => GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
        letterSpacing: -0.3,
      );

  static TextStyle get headlineSmall => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      );

  static TextStyle get titleLarge => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      );

  static TextStyle get titleMedium => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      );

  static TextStyle get bodyLarge => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textPrimaryColor,
      );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textPrimaryColor,
      );

  static TextStyle get bodySmall => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textSecondaryColor,
      );

  static TextStyle get labelMedium => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimaryColor,
      );

  static TextStyle get labelSmall => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondaryColor,
      );

  // Common decoration styles
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration get gradientDecoration => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [gradientStart, gradientEnd],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      );

  // Button Styles - More polished with gradients
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      );

  static ButtonStyle get gradientButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      );

  static ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: cardColor,
        foregroundColor: primaryColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: primaryColor, width: 1.5),
        ),
      );

  // Theme Data
  static ThemeData get themeData => ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        fontFamily: GoogleFonts.poppins().fontFamily,
        appBarTheme: AppBarTheme(
          backgroundColor: backgroundColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: textPrimaryColor),
          titleTextStyle: GoogleFonts.poppins(
            color: textPrimaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: CardTheme(
          color: cardColor,
          elevation: 5,
          shadowColor: shadowColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: dividerColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: dividerColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryColor, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: errorColor),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          hintStyle: GoogleFonts.poppins(
            color: textSecondaryColor.withOpacity(0.7),
            fontSize: 14,
          ),
          labelStyle: GoogleFonts.poppins(
            color: textSecondaryColor,
            fontSize: 14,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: primaryButtonStyle,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: secondaryButtonStyle,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: secondaryColor,
          background: backgroundColor,
          error: errorColor,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: textPrimaryColor,
          onError: Colors.white,
        ),
        useMaterial3: true,
        textTheme: TextTheme(
          displayLarge: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: textPrimaryColor,
          ),
          displayMedium: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textPrimaryColor,
          ),
          displaySmall: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textPrimaryColor,
          ),
          headlineLarge: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: textPrimaryColor,
          ),
          headlineMedium: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: textPrimaryColor,
          ),
          headlineSmall: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          titleLarge: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          titleMedium: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          titleSmall: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: textPrimaryColor,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: textPrimaryColor,
          ),
          bodySmall: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: textSecondaryColor,
          ),
          labelLarge: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textPrimaryColor,
          ),
          labelMedium: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimaryColor,
          ),
          labelSmall: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textSecondaryColor,
          ),
        ),
      );
} 