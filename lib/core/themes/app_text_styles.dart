import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get displayLarge => GoogleFonts.cairo(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -.5,
      );

  static TextStyle get displayMedium => GoogleFonts.cairo(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  static TextStyle get headlineLarge => GoogleFonts.cairo(
        fontSize: 28,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get headlineMedium => GoogleFonts.cairo(
        fontSize: 24,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get headlineSmall => GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get titleLarge => GoogleFonts.cairo(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get titleMedium => GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get titleSmall => GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get bodyLarge => GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get bodyMedium => GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get bodySmall => GoogleFonts.cairo(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get labelLarge => GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get labelMedium => GoogleFonts.cairo(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get labelSmall => GoogleFonts.cairo(
        fontSize: 10,
        fontWeight: FontWeight.w500,
      );

  // للأرقام (الرصيد - المبالغ)
  static TextStyle get amountLarge => GoogleFonts.cairo(
        fontSize: 34,
        fontWeight: FontWeight.w800,
      );

  static TextStyle get amountMedium => GoogleFonts.cairo(
        fontSize: 26,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get amountSmall => GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.w700,
      );

  // Buttons
  static TextStyle get button => GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      );

  // Caption
  static TextStyle get caption => GoogleFonts.cairo(
        fontSize: 11,
        fontWeight: FontWeight.w400,
      );

  // Overline
  static TextStyle get overline => GoogleFonts.cairo(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      );
}