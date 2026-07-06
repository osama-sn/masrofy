import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ===========================
  // Brand Colors
  // ===========================

  static const Color primary = Color(0xFF16A34A); // الزرار الرئيسي
  static const Color primaryDark = Color(0xFF15803D);
  static const Color primaryLight = Color(0xFF4ADE80);

  static const Color secondary = Color(0xFF0F766E);
  static const Color accent = Color(0xFFEAB308);

  // ===========================
  // Light Theme
  // ===========================

  static const Color backgroundLight = Color(0xFFF5F7FA);

  static const Color surfaceLight = Colors.white;
  static const Color cardLight = Color(0xFFFFFFFF);

  static const Color textPrimaryLight = Color(0xFF111827);
  static const Color textSecondaryLight = Color(0xFF6B7280);

  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color dividerLight = Color(0xFFF1F5F9);

  // ===========================
  // Dark Theme
  // ===========================

  static const Color backgroundDark = Color(0xFF090E16);
  static const Color surfaceDark = Color(0xFF111827);
  static const Color cardDark = Color(0xFF171F2C);

  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);

  static const Color borderDark = Color(0xFF263244);
  static const Color dividerDark = Color(0xFF1F2937);

  // ===========================
  // Financial Colors
  // ===========================

  static const Color income = Color(0xFF22C55E);
  static const Color expense = Color(0xFFEF4444);
  static const Color saving = Color(0xFF3B82F6);
  static const Color debt = Color(0xFFF97316);

  // ===========================
  // Status
  // ===========================

  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // ===========================
  // Extra Colors
  // ===========================
  static const Color white = Color.fromARGB(255, 252, 252, 252);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color orange = Color(0xFFF97316);
  static const Color blue = Color(0xFF3B82F6);
  static const Color cyan = Color(0xFF06B6D4);

  // ===========================
  // Greys
  // ===========================

  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // ===========================
  // Gradients
  // ===========================

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF15803D), Color(0xFF22C55E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF182231), Color(0xFF111827)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient walletGradient = LinearGradient(
    colors: [Color(0xFF0F766E), Color(0xFF16A34A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
