import 'package:flutter/animation.dart';

/// Animation Duration System
/// Consistent timing for all animations across the app
class AnimationDurations {
  AnimationDurations._(); // Private constructor

  static const Duration instant = Duration(milliseconds: 0);
  static const Duration fastest = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration slowest = Duration(milliseconds: 700);
}

/// Animation Curves
/// Easing functions for smooth animations
class AnimationCurves {
  AnimationCurves._(); // Private constructor

  // Standard curves
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve bounce = Curves.bounceOut;
  static const Curve elastic = Curves.elasticOut;
  static const Curve decelerate = Curves.decelerate;
}

