import 'package:flutter/material.dart';

/// Elevation System (Shadow Depth)
/// Provides consistent elevation levels for layering UI elements
class Elevations {
  Elevations._(); // Private constructor

  // No shadow
  static const none = BoxShadow(
    color: Colors.transparent,
    blurRadius: 0,
    spreadRadius: 0,
    offset: Offset(0, 0),
  );

  // Level 1 - Subtle hover
  static const sm = BoxShadow(
    color: Color(0x0A000000), // 4% black
    blurRadius: 4,
    spreadRadius: 0,
    offset: Offset(0, 2),
  );

  // Level 2 - Cards
  static const md = BoxShadow(
    color: Color(0x14000000), // 8% black
    blurRadius: 8,
    spreadRadius: 0,
    offset: Offset(0, 4),
  );

  // Level 3 - Floating elements
  static const lg = BoxShadow(
    color: Color(0x1F000000), // 12% black
    blurRadius: 12,
    spreadRadius: 0,
    offset: Offset(0, 8),
  );

  // Level 4 - Modals, dialogs
  static const xl = BoxShadow(
    color: Color(0x29000000), // 16% black
    blurRadius: 16,
    spreadRadius: 0,
    offset: Offset(0, 12),
  );

  // Level 5 - Maximum elevation
  static const xxl = BoxShadow(
    color: Color(0x33000000), // 20% black
    blurRadius: 24,
    spreadRadius: 0,
    offset: Offset(0, 16),
  );

  // Helper lists for BoxDecoration
  static const List<BoxShadow> smallShadow = [sm];
  static const List<BoxShadow> mediumShadow = [md];
  static const List<BoxShadow> largeShadow = [lg];
  static const List<BoxShadow> extraLargeShadow = [xl];
  static const List<BoxShadow> hugeShadow = [xxl];
}
