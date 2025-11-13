import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/spacing.dart';
import '../../core/theme/text_styles.dart';
import '../../data/models/player.dart';
import '../../domain/game_controller.dart';
import '../widgets/buttons.dart';
import '../widgets/themed_background.dart';
import 'game_screen.dart';

/// Game Setup Screen
/// Select bot difficulty and configure game options
class GameSetupScreen extends StatefulWidget {
  const GameSetupScreen({super.key});

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  BotDifficulty _selectedDifficulty = BotDifficulty.easy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: ThemedBackground(
        child: Stack(
          children: [
            // Main content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60), // Space for floating header
                    Text(
                      'Select Bot Difficulty',
                      style: TextStyles.h2.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Spacing.xxl),

                    // Difficulty Cards
                    Expanded(
                      child: ListView(
                        children: [
                          _buildDifficultyCard(
                            BotDifficulty.easy,
                            'Easy Bot',
                            '60% speed • 2-4s delay • 1x coins',
                            Icons.sentiment_satisfied,
                          ),
                          const SizedBox(height: Spacing.md),
                          _buildDifficultyCard(
                            BotDifficulty.medium,
                            'Medium Bot',
                            '80% speed • 1-2s delay • 1.5x coins',
                            Icons.sentiment_neutral,
                          ),
                          const SizedBox(height: Spacing.md),
                          _buildDifficultyCard(
                            BotDifficulty.hard,
                            'Hard Bot',
                            '95% speed • 0.5-1s delay • 2x coins',
                            Icons.sentiment_dissatisfied,
                          ),
                          const SizedBox(height: Spacing.md),
                          _buildDifficultyCard(
                            BotDifficulty.expert,
                            'Expert Bot',
                            '100% speed • Instant • 3x coins',
                            Icons.psychology,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: Spacing.lg),

                    // Start Game Button
                    PrimaryButton(
                      text: 'START GAME',
                      icon: Icons.play_arrow,
                      onPressed: _startGame,
                    ),
                  ],
                ),
              ),
            ),
            // Floating header overlay
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: theme.colorScheme.onPrimary,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          'GAME SETUP',
                          style: TextStyles.h2.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48), // Balance for back button
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyCard(
    BotDifficulty difficulty,
    String title,
    String description,
    IconData icon,
  ) {
    final isSelected = _selectedDifficulty == difficulty;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => setState(() => _selectedDifficulty = difficulty),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.tertiary.withOpacity(0.2)
              : theme.colorScheme.surface.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.tertiary
                : theme.colorScheme.onPrimary.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.onPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected 
                    ? theme.colorScheme.onTertiary
                    : theme.colorScheme.onPrimary,
                size: 32,
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.h3.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyles.bodySmall.copyWith(
                      color: theme.colorScheme.onPrimary.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.tertiary,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }

  void _startGame() {
    final gameController = Provider.of<GameController>(context, listen: false);

    final humanPlayer = Player.human(name: 'You');
    final botPlayer = Player.bot(_selectedDifficulty);

    gameController.startNewGame(
      humanPlayer: humanPlayer,
      botPlayer: botPlayer,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const GameScreen(),
      ),
    );
  }
}
