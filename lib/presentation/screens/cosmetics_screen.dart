import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../../core/theme/bingo_theme.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/services/player_service.dart';
import '../../core/services/sound_service.dart';
import '../../core/constants/spacing.dart';
import '../../core/theme/text_styles.dart';
import '../widgets/themed_background.dart';

/// Cosmetics Screen
/// Theme selection and customization
class CosmeticsScreen extends StatelessWidget {
  const CosmeticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return ThemedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'THEMES',
            style: TextStyles.h2.copyWith(color: theme.colorScheme.onPrimary),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: Spacing.md,
            right: Spacing.md,
            top: Spacing.md,
            bottom: 140, // Extra padding for floating navbar
          ),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: Spacing.md,
              mainAxisSpacing: Spacing.md,
              childAspectRatio: 0.85,
            ),
            itemCount: BingoThemes.allThemes.length,
            itemBuilder: (context, index) {
              final bingoTheme = BingoThemes.allThemes[index];
              final isUnlocked = themeProvider.isThemeUnlocked(bingoTheme);
              final isActive = themeProvider.currentTheme.id == bingoTheme.id;

              return _ThemeCard(
                theme: bingoTheme,
                isUnlocked: isUnlocked,
                isActive: isActive,
                onTap: () async {
                  if (isUnlocked) {
                    await themeProvider.setTheme(bingoTheme);
                  } else {
                    _showUnlockDialog(context, bingoTheme, themeProvider);
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showUnlockDialog(
    BuildContext context,
    BingoTheme bingoTheme,
    ThemeProvider themeProvider,
  ) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Unlock ${bingoTheme.name}?',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        content: Text(
          'Cost: ${bingoTheme.unlockCost} coins\n\n${bingoTheme.description}',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.onSurface,
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final playerService = context.read<PlayerService>();
              final soundService = context.read<SoundService>();
              
              // Check if player has enough coins
              if (playerService.coins >= bingoTheme.unlockCost) {
                // Spend coins
                final success = await playerService.spendCoins(bingoTheme.unlockCost);
                
                if (success) {
                  // Unlock theme
                  await themeProvider.unlockTheme(bingoTheme);
                  
                  // Play unlock sound
                  soundService.playThemeUnlock();
                  
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${bingoTheme.name} unlocked!')),
                    );
                  }
                }
              } else {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Not enough coins')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.tertiary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
            child: const Text('Unlock'),
          ),
        ],
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final BingoTheme theme;
  final bool isUnlocked;
  final bool isActive;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.theme,
    required this.isUnlocked,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            // Show background image preview if available, otherwise gradient
            gradient: theme.backgroundImage == null
                ? LinearGradient(
                    colors: [
                      theme.colors.secondary,
                      theme.colors.secondary.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            image: theme.backgroundImage != null
                ? DecorationImage(
                    image: AssetImage(theme.backgroundImage!),
                    fit: BoxFit.cover,
                    // Full opacity - no darkening!
                  )
                : null,
            borderRadius: BorderRadius.circular(16),
            border: isActive
                ? Border.all(color: theme.colors.accent, width: 3)
                : null,
          ),
          child: Stack(
            children: [
              // Subtle gradient only at bottom for text readability
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isActive)
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.colors.accent,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.colors.accent.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Text(
                    theme.name,
                    style: TextStyles.h4.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      shadows: [
                        const Shadow(
                          color: Colors.black,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    theme.description,
                    style: TextStyles.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      shadows: [
                        const Shadow(
                          color: Colors.black,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Spacing.sm),
                  if (!isUnlocked)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                        vertical: Spacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colors.accent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colors.accent.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${theme.unlockCost} coins',
                        style: TextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (!isUnlocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
