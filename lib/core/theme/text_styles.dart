import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography System using Modular Scale (1.25 - Major Third)
/// Font: Inter for excellent readability
class TextStyles {
  TextStyles._(); // Private constructor

  // Base font family
  static TextStyle get _baseTextStyle => GoogleFonts.inter();

  // Display Text (56px, 44px)
  static TextStyle get display1 => _baseTextStyle.copyWith(
        fontSize: 56.0,
        fontWeight: FontWeight.w800,
        height: 1.1,
        letterSpacing: -1.5,
      );

  static TextStyle get display2 => _baseTextStyle.copyWith(
        fontSize: 44.0,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -1.0,
      );

  // Headers (36px, 28px, 24px, 20px)
  static TextStyle get h1 => _baseTextStyle.copyWith(
        fontSize: 36.0,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.5,
      );

  static TextStyle get h2 => _baseTextStyle.copyWith(
        fontSize: 28.0,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.25,
      );

  static TextStyle get h3 => _baseTextStyle.copyWith(
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0,
      );

  static TextStyle get h4 => _baseTextStyle.copyWith(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0,
      );

  // Body Text (18px, 16px, 14px)
  static TextStyle get bodyLarge => _baseTextStyle.copyWith(
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0,
      );

  static TextStyle get bodyMedium => _baseTextStyle.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0,
      );

  static TextStyle get bodySmall => _baseTextStyle.copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0,
      );

  // UI Text
  static TextStyle get button => _baseTextStyle.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.5,
      );

  static TextStyle get caption => _baseTextStyle.copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        height: 1.3,
        letterSpacing: 0.4,
      );

  static TextStyle get overline => _baseTextStyle.copyWith(
        fontSize: 10.0,
        fontWeight: FontWeight.w600,
        height: 1.6,
        letterSpacing: 1.5,
        textBaseline: TextBaseline.alphabetic,
      );

  // Number text (for bingo cells)
  static TextStyle get bingoNumber => _baseTextStyle.copyWith(
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
        height: 1.0,
        letterSpacing: 0,
      );

  // Large number (called number display)
  static TextStyle get calledNumber => _baseTextStyle.copyWith(
        fontSize: 72.0,
        fontWeight: FontWeight.w900,
        height: 1.0,
        letterSpacing: -2.0,
      );
}
