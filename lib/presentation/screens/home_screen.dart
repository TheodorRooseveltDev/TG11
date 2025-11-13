import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/spacing.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/text_styles.dart';
import '../../core/services/player_service.dart';
import '../../core/services/daily_challenge_service.dart';
import '../widgets/buttons.dart';
import '../widgets/coin_display.dart';
import '../widgets/themed_background.dart';
import '../widgets/themed_bottom_nav.dart';
import 'game_setup_screen.dart';
import 'cosmetics_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';
import 'achievements_screen.dart';

/// Home Screen
/// Main landing screen with navigation to all major features
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _HomeTab(),
    const StatsScreen(),
    const CosmeticsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          _screens[_currentIndex],
          // Floating navbar on top
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ThemedBottomNav(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
            ),
          ),
        ],
      ),
    );
  }
}

/// Home Tab Content
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ThemedBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 
                         MediaQuery.of(context).padding.top - 
                         MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Top Bar
                  _buildTopBar(context, themeProvider),
                  
                  const Spacer(),

                  // Logo/Title (at top)
                  Text(
                    'BINGO CLASH',
                    style: TextStyles.display1.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          color: theme.brightness == Brightness.light
                              ? Colors.black.withOpacity(0.1)
                              : Colors.black.withOpacity(0.5),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Spacing.sm),

                  Text(
                    'Challenge bots and master the game',
                    style: TextStyles.bodyLarge.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: Spacing.xl),

                  // Main Action Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.xxl),
                    child: Column(
                children: [
                  PrimaryButton(
                    text: 'PLAY VS BOT',
                    icon: Icons.smart_toy,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GameSetupScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: Spacing.md),
                  // Locked Multiplayer Button with Coming Soon Ribbon
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Full styled button matching primary button style
                      Container(
                        height: 56.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.tertiary,
                              theme.colorScheme.tertiary.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.people,
                                color: theme.colorScheme.onTertiary,
                                size: 20,
                              ),
                              const SizedBox(width: Spacing.xs),
                              Text(
                                'MULTIPLAYER',
                                style: TextStyles.button.copyWith(
                                  color: theme.colorScheme.onTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Block interactions
                      Positioned.fill(
                        child: Container(color: Colors.transparent),
                      ),
                      // Coming Soon ribbon banner
                      Positioned(
                        top: -6,
                        right: -6,
                        child: Transform.rotate(
                          angle: 0.4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFFD700),
                                  Color(0xFFFFC700),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 6,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                              border: Border.all(
                                color: Color(0xFF886400),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              'SOON',
                              style: TextStyles.caption.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                                fontSize: 9,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: Spacing.lg),

            const Spacer(),

            // Daily Challenge Banner (at bottom, above navbar)
            Padding(
              padding: const EdgeInsets.only(bottom: Spacing.xl),
              child: _buildDailyChallenge(context),
            ),

            const SizedBox(height: 100),

            // Space for floating navbar
            const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, ThemeProvider themeProvider) {
    final theme = Theme.of(context);
    final playerService = context.watch<PlayerService>();

    return Padding(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // User Avatar and Name
          Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.colorScheme.tertiary.withOpacity(0.2),
                  child: Icon(
                    _getAvatarIcon(playerService.playerAvatar),
                    color: theme.colorScheme.tertiary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showLevelInfoDialog(context, playerService),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          playerService.playerName,
                          style: TextStyles.h4.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Text(
                              'Lvl ${playerService.level}',
                              style: TextStyles.caption.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(width: Spacing.xs),
                            // XP Progress Bar
                            Expanded(
                              child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: playerService.levelProgress.clamp(0.0, 1.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          theme.colorScheme.tertiary,
                                          theme.colorScheme.tertiary.withOpacity(0.7),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Coins and Achievements
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Achievements button
              IconButton(
                icon: Icon(
                  Icons.emoji_events,
                  color: theme.colorScheme.tertiary,
                  size: 24,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AchievementsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: Spacing.xs),
              CoinDisplay(coins: playerService.coins),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getAvatarIcon(String avatarId) {
    const icons = {
      'avatar_1': Icons.face,
      'avatar_2': Icons.emoji_emotions,
      'avatar_3': Icons.sentiment_very_satisfied,
      'avatar_4': Icons.psychology,
      'avatar_5': Icons.rocket_launch,
      'avatar_6': Icons.favorite,
    };
    return icons[avatarId] ?? Icons.face;
  }  Widget _buildDailyChallenge(BuildContext context) {
    final theme = Theme.of(context);
    final dailyChallenge = context.watch<DailyChallengeService>();

    return GestureDetector(
      onTap: dailyChallenge.isCompleted 
          ? null 
          : () => _showDailyChallengeDialog(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: Spacing.md),
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: dailyChallenge.isCompleted
              ? theme.colorScheme.secondary.withOpacity(0.15)
              : theme.colorScheme.secondary.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: dailyChallenge.isCompleted
                ? theme.colorScheme.tertiary.withOpacity(0.15)
                : theme.colorScheme.tertiary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: dailyChallenge.isCompleted
                    ? Colors.green.withOpacity(0.2)
                    : theme.colorScheme.tertiary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                dailyChallenge.isCompleted ? Icons.check_circle : Icons.star,
                color: dailyChallenge.isCompleted
                    ? Colors.green
                    : theme.colorScheme.tertiary,
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Challenge',
                    style: TextStyles.h4.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dailyChallenge.getProgressText(),
                    style: TextStyles.bodySmall.copyWith(
                      color: theme.colorScheme.onPrimary.withOpacity(0.8),
                    ),
                  ),
                  if (!dailyChallenge.isCompleted && dailyChallenge.winsToday > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: LinearProgressIndicator(
                        value: dailyChallenge.winsToday / dailyChallenge.requiredWinsCount,
                        backgroundColor: theme.colorScheme.surface.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.tertiary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              dailyChallenge.isCompleted ? Icons.done : Icons.arrow_forward_ios,
              color: theme.colorScheme.onPrimary.withOpacity(0.6),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showDailyChallengeDialog(BuildContext context) {
    final theme = Theme.of(context);
    final dailyChallenge = context.read<DailyChallengeService>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.star,
              color: theme.colorScheme.tertiary,
              size: 28,
            ),
            const SizedBox(width: Spacing.sm),
            Text(
              'Daily Challenge',
              style: TextStyles.h3.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Win ${dailyChallenge.requiredWinsCount} games today to earn ${dailyChallenge.reward} coins!',
              style: TextStyles.bodyLarge.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.lg),
            Text(
              'Progress: ${dailyChallenge.winsToday}/${dailyChallenge.requiredWinsCount}',
              style: TextStyles.h4.copyWith(
                color: theme.colorScheme.tertiary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            LinearProgressIndicator(
              value: dailyChallenge.winsToday / dailyChallenge.requiredWinsCount,
              backgroundColor: theme.colorScheme.surface.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.tertiary,
              ),
            ),
            const SizedBox(height: Spacing.lg),
            Text(
              '${dailyChallenge.winsRemaining} more win${dailyChallenge.winsRemaining == 1 ? '' : 's'} needed',
              style: TextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CLOSE',
              style: TextStyles.button.copyWith(
                color: theme.colorScheme.tertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLevelInfoDialog(BuildContext context, PlayerService playerService) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.stars,
              color: theme.colorScheme.tertiary,
              size: 28,
            ),
            const SizedBox(width: Spacing.sm),
            Text(
              'Level Progress',
              style: TextStyles.h3.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Level: ${playerService.level}',
              style: TextStyles.h4.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Spacing.md),
            Text(
              'XP: ${playerService.xp} / ${playerService.xpForNextLevel}',
              style: TextStyles.bodyLarge.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            LinearProgressIndicator(
              value: playerService.levelProgress.clamp(0.0, 1.0),
              backgroundColor: theme.colorScheme.surface.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.tertiary,
              ),
            ),
            const SizedBox(height: Spacing.md),
            Text(
              '${playerService.xpForNextLevel - playerService.xp} XP needed for Level ${playerService.level + 1}',
              style: TextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: Spacing.lg),
            Container(
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How to earn XP:',
                    style: TextStyles.bodyMedium.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    '• Win games (+50 base XP)\n'
                    '• Win quickly (+30 XP bonus)\n'
                    '• Win efficiently (+30 XP bonus)\n'
                    '• Participation (+5 XP)',
                    style: TextStyles.bodySmall.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CLOSE',
              style: TextStyles.button.copyWith(
                color: theme.colorScheme.tertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
