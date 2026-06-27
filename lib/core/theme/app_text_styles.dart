import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get heading1 => GoogleFonts.cairo(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get heading2 => GoogleFonts.cairo(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get heading3 => GoogleFonts.cairo(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get subtitle => GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get body => GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodySmall => GoogleFonts.cairo(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get button => GoogleFonts.cairo(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );

  static TextStyle get label => GoogleFonts.cairo(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );
}
