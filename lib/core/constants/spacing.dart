/// 8-Point Grid System
/// Base unit: 8px for consistent spacing across the app
class Spacing {
  Spacing._(); // Private constructor to prevent instantiation

  // Micro spacing
  static const double xxxs = 2.0; // 2px - Micro spacing
  static const double xxs = 4.0; // 4px - Very tight

  // Standard spacing scale (8-point grid)
  static const double xs = 8.0; // 8px - Tight
  static const double sm = 12.0; // 12px - Small
  static const double md = 16.0; // 16px - Medium (most common)
  static const double lg = 24.0; // 24px - Large
  static const double xl = 32.0; // 32px - Extra large
  static const double xxl = 48.0; // 48px - Very large
  static const double xxxl = 64.0; // 64px - Huge
  static const double mega = 96.0; // 96px - Mega
}
