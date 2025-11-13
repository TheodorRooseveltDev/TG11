import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Custom Bingo Ball Loader
/// Animated loader with rotating bingo balls
class CustomBingoLoader extends StatefulWidget {
  final double size;
  final Color? color1;
  final Color? color2;
  final Color? color3;

  const CustomBingoLoader({
    super.key,
    this.size = 80.0,
    this.color1,
    this.color2,
    this.color3,
  });

  @override
  State<CustomBingoLoader> createState() => _CustomBingoLoaderState();
}

class _CustomBingoLoaderState extends State<CustomBingoLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final ballColor1 = widget.color1 ?? const Color(0xFFFF006E); // Hot pink
    final ballColor2 = widget.color2 ?? const Color(0xFF00D9FF); // Cyan
    final ballColor3 = widget.color3 ?? theme.colorScheme.tertiary; // Purple

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _BingoBallLoaderPainter(
              animation: _controller.value,
              color1: ballColor1,
              color2: ballColor2,
              color3: ballColor3,
            ),
          );
        },
      ),
    );
  }
}

class _BingoBallLoaderPainter extends CustomPainter {
  final double animation;
  final Color color1;
  final Color color2;
  final Color color3;

  _BingoBallLoaderPainter({
    required this.animation,
    required this.color1,
    required this.color2,
    required this.color3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final ballRadius = radius * 0.25;
    final orbitRadius = radius * 0.6;

    // Draw three orbiting balls
    for (int i = 0; i < 3; i++) {
      final angle = (animation * 2 * math.pi) + (i * 2 * math.pi / 3);
      final x = center.dx + orbitRadius * math.cos(angle);
      final y = center.dy + orbitRadius * math.sin(angle);
      
      final ballCenter = Offset(x, y);
      
      // Choose color based on ball index
      final ballColor = i == 0 ? color1 : (i == 1 ? color2 : color3);
      
      // Draw ball shadow
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(
        Offset(ballCenter.dx + 2, ballCenter.dy + 2),
        ballRadius,
        shadowPaint,
      );
      
      // Draw ball gradient
      final gradient = RadialGradient(
        colors: [
          ballColor.withOpacity(1),
          ballColor.withOpacity(0.7),
        ],
        stops: const [0.3, 1.0],
      );
      
      final paint = Paint()
        ..shader = gradient.createShader(
          Rect.fromCircle(center: ballCenter, radius: ballRadius),
        );
      
      canvas.drawCircle(ballCenter, ballRadius, paint);
      
      // Draw highlight
      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(
        Offset(ballCenter.dx - ballRadius * 0.3, ballCenter.dy - ballRadius * 0.3),
        ballRadius * 0.3,
        highlightPaint,
      );
      
      // Add outer glow
      final glowPaint = Paint()
        ..color = ballColor.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(ballCenter, ballRadius * 1.2, glowPaint);
    }
  }

  @override
  bool shouldRepaint(_BingoBallLoaderPainter oldDelegate) {
    return animation != oldDelegate.animation;
  }
}

/// Pulsing Glow Loader
/// Simple pulsing circle loader
class PulsingGlowLoader extends StatefulWidget {
  final double size;
  final Color? color;

  const PulsingGlowLoader({
    super.key,
    this.size = 60.0,
    this.color,
  });

  @override
  State<PulsingGlowLoader> createState() => _PulsingGlowLoaderState();
}

class _PulsingGlowLoaderState extends State<PulsingGlowLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loaderColor = widget.color ?? Theme.of(context).colorScheme.tertiary;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      loaderColor.withOpacity(0.8),
                      loaderColor.withOpacity(0.2),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: loaderColor.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
