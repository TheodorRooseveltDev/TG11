import 'package:flutter/material.dart';

/// Color Tokens using 60:30:10 Rule
/// 60% Primary, 30% Secondary, 10% Accent
class ColorTokens {
  final String id;
  final String name;

  // Primary (60%) - Dominant color, backgrounds, large surfaces
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;

  // Secondary (30%) - Supporting elements, cards, containers
  final Color secondary;
  final Color secondaryLight;
  final Color secondaryDark;

  // Accent (10%) - CTAs, highlights, interactive elements
  final Color accent;
  final Color accentLight;
  final Color accentDark;

  // Semantic Colors
  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  // Neutral Colors
  final Color background;
  final Color surface;
  final Color onPrimary;
  final Color onSecondary;
  final Color onAccent;
  final Color onBackground;
  final Color onSurface;

  // Text Colors
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;

  // Border & Divider
  final Color border;
  final Color divider;

  const ColorTokens({
    required this.id,
    required this.name,
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.secondary,
    required this.secondaryLight,
    required this.secondaryDark,
    required this.accent,
    required this.accentLight,
    required this.accentDark,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.background,
    required this.surface,
    required this.onPrimary,
    required this.onSecondary,
    required this.onAccent,
    required this.onBackground,
    required this.onSurface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.border,
    required this.divider,
  });

  /// Convert to Flutter ThemeData
  ThemeData toThemeData() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        tertiary: accent,
        surface: surface,
        error: error,
        onPrimary: onPrimary,
        onSecondary: onSecondary,
        onTertiary: onAccent,
        onSurface: onSurface,
        onError: onPrimary,
      ),
      scaffoldBackgroundColor: background,
    );
  }
}
