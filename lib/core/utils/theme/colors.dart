import 'package:flutter/material.dart';

class HColors {
  // App theme colors
  // static const Color primary = Color(0xff5F33E1);
  // static const Color secondary = Color(0xFF8D6AE7);
  // static const Color accent = Colors.blue;

  static const Color primary = Color(0xFF317AAA);
  static const Color secondary = Color(0xFF42A5F5);
  static const Color accent = Color(0xFF90CAF9);

  static const Color sidebarColor = Color(0xFF212D32);

  // Text colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textWhite = Colors.white;

  // Background colors
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFFDCDFE6);

  // Background Container colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static Color darkContainer = HColors.white.withValues(alpha: 0.1);

  // Button colors
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = Color(0xFF6C757D);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  // Chip colors
  static const Color selectedTextColor = Colors.white;
  static const Color unselectedTextColor = Color(0xFF333333);
  static const Color selectedBackgroundColor = primary;
  static const Color unselectedBackgroundColor = Colors.white;

  // Border colors
  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  // Error and validation colors
  static const Color error = Color(0xFFE57373);
  static const Color success = Color(0xFF8BC34A);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF64B5F6);

  // Neutral Shades
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Colors.transparent;

  // Status Colors
  static const Color pendingColor = Color(0xFFFFA000);
  static const Color approvedColor = Color(0xFF4CAF50);
  static const Color rejectedColor = Color(0xFFE53935);

  // Status Background Colors
  static const Color pendingBgColor = Color(0xFFFFF3E0);
  static const Color approvedBgColor = Color(0xFFE8F5E9);
  static const Color rejectedBgColor = Color(0xFFFFEBEE);
}
