import 'package:flutter/material.dart';

/// Border Radius System
/// Consistent rounded corners across all components
class BorderRadii {
  BorderRadii._(); // Private constructor

  static const double none = 0.0;
  static const double sm = 4.0; // Small elements
  static const double md = 8.0; // Buttons, inputs
  static const double lg = 12.0; // Cards
  static const double xl = 16.0; // Large cards
  static const double xxl = 24.0; // Hero elements
  static const double full = 9999.0; // Pills/circular

  // Helper methods for quick BorderRadius creation
  static BorderRadius circular(double radius) => BorderRadius.circular(radius);

  static const BorderRadius small = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(md));
  static const BorderRadius large = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius extraLarge = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius huge = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(full));
}
