import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/constants/spacing.dart';
import '../../core/theme/text_styles.dart';

/// Themed Bottom Navigation Bar
/// Beautiful navigation bar that adapts to each theme with unique styling
class ThemedBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const ThemedBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final currentTheme = themeProvider.currentTheme;
    final colors = currentTheme.colors;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(Spacing.md),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            decoration: BoxDecoration(
              color: colors.primary,
              // Background image if available
              image: currentTheme.navbarImage != null
                  ? DecorationImage(
                      image: AssetImage(currentTheme.navbarImage!),
                      fit: BoxFit.fill,
                      alignment: Alignment.center,
                    )
                  : null,
              // Gradient fallback
              gradient: currentTheme.navbarImage == null
                  ? LinearGradient(
                      colors: [
                        colors.secondary.withOpacity(0.95),
                        colors.primary.withOpacity(0.98),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                  : null,
            ),
            child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: Spacing.sm,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(
                        context,
                        iconPath: 'assets/icons/home_icon.png',
                        label: 'Home',
                        index: 0,
                        colors: colors,
                      ),
                      _buildNavItem(
                        context,
                        iconPath: 'assets/icons/stats_icon.png',
                        label: 'Stats',
                        index: 1,
                        colors: colors,
                      ),
                      _buildNavItem(
                        context,
                        iconPath: 'assets/icons/themes_icon.png',
                        label: 'Themes',
                        index: 2,
                        colors: colors,
                      ),
                      _buildNavItem(
                        context,
                        iconPath: 'assets/icons/settings_icon.png',
                        label: 'Settings',
                        index: 3,
                        colors: colors,
                      ),
                    ],
                  ),
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String iconPath,
    required String label,
    required int index,
    required colors,
  }) {
    final isActive = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: Spacing.sm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with glow effect when active
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isActive
                      ? colors.accent.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  // Glow effect for active item
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: colors.accent.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Image.asset(
                  iconPath,
                  width: 28,
                  height: 28,
                  color: isActive
                      ? colors.accent
                      : colors.onPrimary.withOpacity(0.8),
                  filterQuality: FilterQuality.high,
                ),
              ),
              const SizedBox(height: 4),
              // Label
              Text(
                label,
                style: TextStyles.caption.copyWith(
                  color: isActive
                      ? colors.accent
                      : colors.onPrimary.withOpacity(0.6),
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 11,
                  shadows: isActive
                      ? [
                          Shadow(
                            color: colors.accent.withOpacity(0.5),
                            blurRadius: 4,
                          ),
                        ]
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
