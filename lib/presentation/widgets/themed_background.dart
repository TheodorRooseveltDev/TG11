import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../../core/theme/theme_provider.dart';

/// Themed Background Widget
/// Displays theme-specific background images with gradient fallback
class ThemedBackground extends StatelessWidget {
  final Widget child;

  const ThemedBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = themeProvider.currentTheme;
    final colors = theme.colors;

    return ClipRect(
      child: Stack(
        children: [
          // Background layer
          Container(
            decoration: BoxDecoration(
              // Gradient fallback if no background image
              gradient: theme.backgroundImage == null
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colors.primary,
                        colors.primaryDark,
                      ],
                    )
                  : null,
              // Background image
              image: theme.backgroundImage != null
                  ? DecorationImage(
                      image: AssetImage(theme.backgroundImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
          // Blur overlay
          if (theme.backgroundImage != null)
            Positioned.fill(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    color: Colors.black.withOpacity(0.05),
                  ),
                ),
              ),
            ),
          // Content
          child,
        ],
      ),
    );
  }
}
