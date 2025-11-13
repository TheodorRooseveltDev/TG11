import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/stats_service.dart';
import '../../core/constants/spacing.dart';
import '../../core/theme/text_styles.dart';
import '../../data/models/player.dart';
import '../widgets/themed_background.dart';

/// Stats Screen
/// Displays player statistics and performance
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = context.watch<StatsService>();

    return ThemedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'STATISTICS',
            style: TextStyles.h2.copyWith(color: theme.colorScheme.onPrimary),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: Spacing.lg,
            right: Spacing.lg,
            top: Spacing.lg,
            bottom: 180, // Extra padding for floating navbar
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overview Stats
              Text(
                'Overview',
                style: TextStyles.h3.copyWith(color: theme.colorScheme.onPrimary),
              ),
              const SizedBox(height: Spacing.md),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Games',
                      value: stats.totalGamesPlayed.toString(),
                      icon: Icons.sports_esports,
                      color: theme.colorScheme.tertiary,
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: _StatCard(
                      title: 'Wins',
                      value: stats.totalWins.toString(),
                      icon: Icons.emoji_events,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.md),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Losses',
                      value: stats.totalLosses.toString(),
                      icon: Icons.close,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: _StatCard(
                      title: 'Win Rate',
                      value: '${stats.winRate.toStringAsFixed(1)}%',
                      icon: Icons.percent,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              
              // Streaks
              const SizedBox(height: Spacing.xl),
              Text(
                'Streaks',
                style: TextStyles.h3.copyWith(color: theme.colorScheme.onPrimary),
              ),
              const SizedBox(height: Spacing.md),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Current',
                      value: stats.currentWinStreak.toString(),
                      icon: Icons.local_fire_department,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: _StatCard(
                      title: 'Best',
                      value: stats.bestWinStreak.toString(),
                      icon: Icons.star,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
              
              // Records
              const SizedBox(height: Spacing.xl),
              Text(
                'Records',
                style: TextStyles.h3.copyWith(color: theme.colorScheme.onPrimary),
              ),
              const SizedBox(height: Spacing.md),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Fastest Win',
                      value: stats.fastestWinTime > 0 
                          ? '${stats.fastestWinTime}s' 
                          : 'N/A',
                      icon: Icons.timer,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: _StatCard(
                      title: 'Most Efficient',
                      value: stats.mostEfficientWin < 999 
                          ? '${stats.mostEfficientWin} #s' 
                          : 'N/A',
                      icon: Icons.insights,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
              
              // Per-Difficulty Stats
              const SizedBox(height: Spacing.xl),
              Text(
                'By Difficulty',
                style: TextStyles.h3.copyWith(color: theme.colorScheme.onPrimary),
              ),
              const SizedBox(height: Spacing.md),
              ...BotDifficulty.values.map((difficulty) {
                final games = stats.gamesPerDifficulty[difficulty] ?? 0;
                final wins = stats.winsPerDifficulty[difficulty] ?? 0;
                final winRate = stats.getWinRateForDifficulty(difficulty);
                
                return _DifficultyStatRow(
                  difficulty: difficulty,
                  games: games,
                  wins: wins,
                  winRate: winRate,
                );
              }),
              
              // Total Coins Earned
              const SizedBox(height: Spacing.xl),
              Container(
                padding: const EdgeInsets.all(Spacing.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.tertiary.withOpacity(0.2),
                      theme.colorScheme.secondary.withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.tertiary.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            color: Colors.amber,
                            size: 32,
                          ),
                          const SizedBox(width: Spacing.md),
                          Expanded(
                            child: Text(
                              'Total Coins Earned',
                              style: TextStyles.h3.copyWith(
                                color: theme.colorScheme.onPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Text(
                      stats.totalCoinsEarned.toString(),
                      style: TextStyles.h2.copyWith(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Stat Card Widget
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: Spacing.xs),
          Text(
            title,
            style: TextStyles.caption.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: Spacing.xxs),
          Text(
            value,
            style: TextStyles.h2.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Difficulty Stat Row Widget
class _DifficultyStatRow extends StatelessWidget {
  final BotDifficulty difficulty;
  final int games;
  final int wins;
  final double winRate;

  const _DifficultyStatRow({
    required this.difficulty,
    required this.games,
    required this.wins,
    required this.winRate,
  });

  String _getDifficultyName() {
    switch (difficulty) {
      case BotDifficulty.easy:
        return 'Easy';
      case BotDifficulty.medium:
        return 'Medium';
      case BotDifficulty.hard:
        return 'Hard';
      case BotDifficulty.expert:
        return 'Expert';
    }
  }

  Color _getDifficultyColor() {
    switch (difficulty) {
      case BotDifficulty.easy:
        return Colors.green;
      case BotDifficulty.medium:
        return Colors.blue;
      case BotDifficulty.hard:
        return Colors.orange;
      case BotDifficulty.expert:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getDifficultyColor();
    
    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getDifficultyName(),
                  style: TextStyles.bodyMedium.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: Spacing.xxs),
                Text(
                  '$wins wins / $games games',
                  style: TextStyles.caption.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Text(
            games > 0 ? '${winRate.toStringAsFixed(1)}%' : 'N/A',
            style: TextStyles.h3.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
