import 'dart:math';
import 'package:flutter/material.dart';

/// Animated Star Field Background
/// Perfect for Space Opera and 80's Retro themes
class StarFieldPainter extends CustomPainter {
  final Animation<double> animation;
  final Color starColor;
  final int starCount;

  StarFieldPainter({
    required this.animation,
    required this.starColor,
    this.starCount = 100,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final random = Random(42); // Fixed seed for consistent positions
    
    for (int i = 0; i < starCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final starSize = random.nextDouble() * 3 + 1.5; // BIGGER STARS
      
      // Twinkle effect based on animation
      final twinkle = sin((animation.value * 2 * pi) + (i * 0.1)) * 0.5 + 0.5;
      
      paint.color = starColor.withOpacity(twinkle * 0.95); // MORE VISIBLE
      canvas.drawCircle(Offset(x, y), starSize, paint);
    }
  }

  @override
  bool shouldRepaint(StarFieldPainter oldDelegate) => true;
}

/// Floating Geometric Shapes Background
/// Perfect for Modern Vibrant theme
class FloatingShapesPainter extends CustomPainter {
  final Animation<double> animation;
  final Color shapeColor;

  FloatingShapesPainter({
    required this.animation,
    required this.shapeColor,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4; // EVEN THICKER

    final random = Random(123);
    
    for (int i = 0; i < 25; i++) { // MORE SHAPES
      final baseX = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final shapeSize = random.nextDouble() * 100 + 50; // EVEN BIGGER
      final speed = random.nextDouble() * 0.5 + 0.3;
      
      // Float up and down
      final offsetY = sin((animation.value * speed * 2 * pi) + i) * 30;
      final x = baseX;
      final y = baseY + offsetY;
      
      final opacity = (sin(animation.value * pi + i) * 0.2 + 0.5) * 0.4; // MUCH MORE VISIBLE
      paint.color = shapeColor.withOpacity(opacity);
      
      // Draw different shapes
      if (i % 3 == 0) {
        // Circle
        canvas.drawCircle(Offset(x, y), shapeSize / 2, paint);
      } else if (i % 3 == 1) {
        // Square
        final rect = Rect.fromCenter(
          center: Offset(x, y),
          width: shapeSize,
          height: shapeSize,
        );
        canvas.drawRect(rect, paint);
      } else {
        // Triangle
        final path = Path();
        path.moveTo(x, y - shapeSize / 2);
        path.lineTo(x - shapeSize / 2, y + shapeSize / 2);
        path.lineTo(x + shapeSize / 2, y + shapeSize / 2);
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(FloatingShapesPainter oldDelegate) => true;
}

/// Grid Background with Perspective
/// Perfect for 80's Retro and Cyberpunk themes
class GridPainter extends CustomPainter {
  final Animation<double> animation;
  final Color gridColor;
  final bool hasPerspective;

  GridPainter({
    required this.animation,
    required this.gridColor,
    this.hasPerspective = true,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = gridColor.withOpacity(0.5); // MORE VISIBLE GRID

    if (hasPerspective) {
      // Draw perspective grid (like Tron/80s style)
      final horizonY = size.height * 0.4;
      final gridSize = 40.0;
      final animatedOffset = animation.value * gridSize;

      // Horizontal lines with perspective
      for (double y = horizonY; y < size.height; y += gridSize) {
        final progress = (y - horizonY) / (size.height - horizonY);
        final perspectiveScale = 1 - (progress * 0.5);
        
        final adjustedY = y + (animatedOffset % gridSize);
        final lineWidth = size.width * perspectiveScale;
        final startX = (size.width - lineWidth) / 2;
        
        canvas.drawLine(
          Offset(startX, adjustedY),
          Offset(startX + lineWidth, adjustedY),
          paint,
        );
      }

      // Vertical lines with perspective
      for (int i = -5; i <= 5; i++) {
        final path = Path();
        final startX = size.width / 2 + (i * gridSize);
        
        path.moveTo(startX, horizonY);
        
        for (double y = horizonY; y < size.height; y += 10) {
          final progress = (y - horizonY) / (size.height - horizonY);
          final perspectiveScale = 1 - (progress * 0.5);
          final offsetX = (startX - size.width / 2) * perspectiveScale + size.width / 2;
          path.lineTo(offsetX, y);
        }
        
        canvas.drawPath(path, paint);
      }
    } else {
      // Simple grid
      final gridSize = 50.0;
      
      for (double x = 0; x < size.width; x += gridSize) {
        canvas.drawLine(
          Offset(x, 0),
          Offset(x, size.height),
          paint,
        );
      }
      
      for (double y = 0; y < size.height; y += gridSize) {
        canvas.drawLine(
          Offset(0, y),
          Offset(size.width, y),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => true;
}

/// Digital Rain Effect (Matrix-style)
/// Perfect for Cyberpunk theme
class DigitalRainPainter extends CustomPainter {
  final Animation<double> animation;
  final Color rainColor;

  DigitalRainPainter({
    required this.animation,
    required this.rainColor,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final random = Random(456);
    final columnCount = 20;
    final columnWidth = size.width / columnCount;

    for (int i = 0; i < columnCount; i++) {
      final speed = random.nextDouble() * 0.5 + 0.5;
      final length = random.nextDouble() * 200 + 100;
      final offset = (animation.value * speed) % 1.0;
      
      final x = i * columnWidth + columnWidth / 2;
      final startY = offset * (size.height + length) - length;
      
      // Draw fade gradient
      for (double j = 0; j < length; j += 8) {
        final y = startY + j;
        if (y >= 0 && y <= size.height) {
          final opacity = (1 - j / length) * 0.8; // MORE VISIBLE RAIN
          paint.color = rainColor.withOpacity(opacity);
          canvas.drawCircle(Offset(x, y), 2.5, paint); // BIGGER DROPS
        }
      }
    }
  }

  @override
  bool shouldRepaint(DigitalRainPainter oldDelegate) => true;
}

/// Organic Wave Pattern
/// Perfect for Nature Zen theme
class WavePatternPainter extends CustomPainter {
  final Animation<double> animation;
  final Color waveColor;

  WavePatternPainter({
    required this.animation,
    required this.waveColor,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3; // THICKER WAVES

    for (int i = 0; i < 8; i++) {
      final path = Path();
      final yOffset = i * (size.height / 8);
      final opacity = 0.2 - (i * 0.015); // MORE VISIBLE
      
      paint.color = waveColor.withOpacity(opacity);
      
      path.moveTo(0, yOffset);
      
      for (double x = 0; x <= size.width; x += 10) {
        final wave1 = sin((x / 100) + (animation.value * 2 * pi)) * 20;
        final wave2 = sin((x / 150) + (animation.value * 2 * pi * 0.7) + i) * 15;
        final y = yOffset + wave1 + wave2;
        path.lineTo(x, y);
      }
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(WavePatternPainter oldDelegate) => true;
}

/// Hexagon Pattern Background
/// Perfect for Minimalist theme
class HexagonPatternPainter extends CustomPainter {
  final Color hexColor;

  HexagonPatternPainter({
    required this.hexColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = hexColor.withOpacity(0.15);

    final hexSize = 30.0;
    final hexWidth = hexSize * 2;
    final hexHeight = hexSize * sqrt(3);
    final horizontalSpacing = hexWidth * 0.75;
    final verticalSpacing = hexHeight;

    // Calculate how many hexagons we need
    final cols = (size.width / horizontalSpacing).ceil() + 2;
    final rows = (size.height / verticalSpacing).ceil() + 2;

    for (int row = -1; row < rows; row++) {
      for (int col = -1; col < cols; col++) {
        final x = col * horizontalSpacing;
        final y = row * verticalSpacing + (col % 2 == 1 ? verticalSpacing / 2 : 0);
        _drawHexagon(canvas, paint, Offset(x, y), hexSize);
      }
    }
  }

  void _drawHexagon(Canvas canvas, Paint paint, Offset center, double size) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (pi / 3) * i;
      final x = center.dx + size * cos(angle);
      final y = center.dy + size * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(HexagonPatternPainter oldDelegate) => false;
}

/// Circular Radial Pattern
/// Adds depth and focus to backgrounds
class RadialPatternPainter extends CustomPainter {
  final Color patternColor;

  RadialPatternPainter({
    required this.patternColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = sqrt(size.width * size.width + size.height * size.height) / 2;

    for (double i = 0; i < maxRadius; i += 60) {
      final opacity = 0.12 * (1 - i / maxRadius); // MORE VISIBLE
      paint.color = patternColor.withOpacity(opacity);
      canvas.drawCircle(center, i, paint);
    }
  }

  @override
  bool shouldRepaint(RadialPatternPainter oldDelegate) => false;
}
