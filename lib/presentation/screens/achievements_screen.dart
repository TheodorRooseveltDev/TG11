import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/achievement_service.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/color_tokens.dart';
import '../../core/models/achievement.dart';
import '../widgets/themed_background.dart';
import 'package:intl/intl.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final achievementService = Provider.of<AchievementService>(context);
    final theme = Provider.of<ThemeProvider>(context);
    final colors = theme.currentTheme.colors;

    return Scaffold(
      body: ThemedBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, colors, achievementService),
              _buildProgressBar(colors, achievementService),
              const SizedBox(height: 16),
              _buildCategoryTabs(context, colors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ColorTokens colors,
    AchievementService achievementService,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: colors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Achievements',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${achievementService.unlockedCount} of ${achievementService.totalAchievements} unlocked',
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(
    ColorTokens colors,
    AchievementService achievementService,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overall Progress',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${achievementService.completionPercentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: colors.accent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: achievementService.completionPercentage / 100,
              backgroundColor: colors.surface.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation(colors.accent),
              minHeight: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(BuildContext context, ColorTokens colors) {
    return Expanded(
      child: DefaultTabController(
        length: 7,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              labelColor: colors.accent,
              unselectedLabelColor: colors.textSecondary,
              indicatorColor: colors.accent,
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'General'),
                Tab(text: 'Wins'),
                Tab(text: 'Speed'),
                Tab(text: 'Efficiency'),
                Tab(text: 'Patterns'),
                Tab(text: 'Streaks'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildAchievementList(context, colors, null),
                  _buildAchievementList(context, colors, AchievementCategory.general),
                  _buildAchievementList(context, colors, AchievementCategory.wins),
                  _buildAchievementList(context, colors, AchievementCategory.speed),
                  _buildAchievementList(context, colors, AchievementCategory.efficiency),
                  _buildAchievementList(context, colors, AchievementCategory.patterns),
                  _buildAchievementList(context, colors, AchievementCategory.streaks),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementList(
    BuildContext context,
    ColorTokens colors,
    AchievementCategory? category,
  ) {
    final achievementService = Provider.of<AchievementService>(context);
    
    List<Achievement> achievements;
    if (category == null) {
      achievements = achievementService.achievements;
    } else {
      achievements = achievementService.achievements
          .where((a) => a.category == category)
          .toList();
    }

    if (achievements.isEmpty) {
      return Center(
        child: Text(
          'No achievements in this category',
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        return _buildAchievementCard(colors, achievements[index]);
      },
    );
  }

  Widget _buildAchievementCard(ColorTokens colors, Achievement achievement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: achievement.isUnlocked
              ? [colors.surface, colors.surface.withOpacity(0.8)]
              : [
                  colors.surface.withOpacity(0.3),
                  colors.surface.withOpacity(0.2),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: achievement.isUnlocked
              ? colors.accent.withOpacity(0.3)
              : colors.textSecondary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: achievement.isUnlocked
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [colors.accent, colors.secondary],
                    )
                  : LinearGradient(
                      colors: [
                        colors.textSecondary.withOpacity(0.2),
                        colors.textSecondary.withOpacity(0.1),
                      ],
                    ),
            ),
            child: Center(
              child: Text(
                achievement.icon,
                style: TextStyle(
                  fontSize: 28,
                  color: achievement.isUnlocked ? null : colors.textSecondary.withOpacity(0.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: TextStyle(
                    color: achievement.isUnlocked
                        ? colors.textPrimary
                        : colors.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.description,
                  style: TextStyle(
                    color: achievement.isUnlocked
                        ? colors.textSecondary
                        : colors.textSecondary.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
                if (achievement.isUnlocked && achievement.unlockedAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Unlocked ${_formatDate(achievement.unlockedAt!)}',
                    style: TextStyle(
                      color: colors.accent,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Reward
          Column(
            children: [
              Icon(
                achievement.isUnlocked ? Icons.check_circle : Icons.lock,
                color: achievement.isUnlocked ? colors.accent : colors.textSecondary.withOpacity(0.3),
                size: 24,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.monetization_on,
                    color: achievement.isUnlocked
                        ? Colors.amber
                        : colors.textSecondary.withOpacity(0.3),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${achievement.coinReward}',
                    style: TextStyle(
                      color: achievement.isUnlocked
                          ? Colors.amber
                          : colors.textSecondary.withOpacity(0.5),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d, y').format(date);
    }
  }
}
