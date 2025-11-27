import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/spacing.dart';
import '../../core/theme/text_styles.dart';
import '../../core/services/player_service.dart';
import '../../core/services/daily_challenge_service.dart';
import '../../data/models/game_state.dart';
import '../../domain/game_controller.dart';
import '../widgets/bingo_card_widget.dart';
import '../widgets/buttons.dart';
import '../widgets/themed_background.dart';
import '../widgets/animated_result_dialog.dart';
import '../widgets/achievement_notification.dart';

/// Game Screen
/// Main gameplay screen with bingo card and controls
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    final gameController = Provider.of<GameController>(context);
    final gameState = gameController.gameState;

    if (gameState == null) {
      return const Scaffold(
        body: Center(
          child: Text('No game in progress'),
        ),
      );
    }

    // Check if game is finished
    if (gameState.status == GameStatus.finished) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showGameResults(context, gameState);
      });
    }

    return Scaffold(
      body: ThemedBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Top HUD
              _buildTopHUD(context, gameState),

              const SizedBox(height: Spacing.md),

              // Current Number Display
              _buildCurrentNumberDisplay(context, gameState),

              const SizedBox(height: Spacing.lg),

              // Player's Bingo Card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                  child: BingoCardWidget(
                    card: gameState.playerCard,
                    onCellTap: (col, row) {
                      gameController.markPlayerNumber(col, row);
                    },
                  ),
                ),
              ),

              const SizedBox(height: Spacing.lg),

              // Bottom Controls
              _buildBottomControls(context, gameState, gameController),

              const SizedBox(height: Spacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHUD(BuildContext context, GameState gameState) {
    final theme = Theme.of(context);
    final gameController = Provider.of<GameController>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(Spacing.md),
      child: Column(
        children: [
          // Back button row
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.colorScheme.onPrimary,
                ),
                onPressed: () {
                  _showExitConfirmationDialog(context, gameController);
                },
              ),
              const Spacer(),
            ],
          ),
          // Score row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Player Score
              _buildScoreCard(
                '🎮 You',
                gameState.playerCard.markedCount,
                theme.colorScheme.tertiary,
              ),

              // Game Info
              Column(
                children: [
                  Text(
                    'Called: ${gameState.calledNumbers.length}',
                    style: TextStyles.bodySmall.copyWith(
                      color: theme.colorScheme.onPrimary.withOpacity(0.9),
                    ),
                  ),
                  if (gameState.durationInSeconds != null)
                    Text(
                      _formatDuration(gameState.durationInSeconds!),
                      style: TextStyles.caption.copyWith(
                        color: theme.colorScheme.onPrimary.withOpacity(0.7),
                      ),
                    ),
                ],
              ),

              // Bot Score
              _buildScoreCard(
                '🤖 Bot',
                gameState.botCard.markedCount,
                theme.colorScheme.error,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String label, int score, Color color) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyles.caption.copyWith(
              color: theme.colorScheme.onPrimary.withOpacity(0.9),
            ),
          ),
          Text(
            '$score',
            style: TextStyles.h3.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentNumberDisplay(BuildContext context, GameState gameState) {
    final theme = Theme.of(context);
    final currentNumber = gameState.currentNumber;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: currentNumber != null
          ? Container(
              key: ValueKey(currentNumber.value),
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.tertiary,
                    theme.colorScheme.tertiary.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.tertiary.withOpacity(0.5),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentNumber.letter,
                      style: TextStyles.h3.copyWith(
                        color: theme.colorScheme.onTertiary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '${currentNumber.value}',
                      style: TextStyles.display1.copyWith(
                        color: theme.colorScheme.onTertiary,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox(
              key: ValueKey('waiting'),
              height: 120,
            ),
    );
  }

  Widget _buildBottomControls(
    BuildContext context,
    GameState gameState,
    GameController gameController,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      child: Row(
        children: [
          // Pause Button
          AppIconButton(
            icon: gameState.status == GameStatus.playing
                ? Icons.pause
                : Icons.play_arrow,
            onPressed: () {
              if (gameState.status == GameStatus.playing) {
                gameController.pauseGame();
              } else {
                gameController.resumeGame();
              }
            },
            backgroundColor: theme.colorScheme.secondary.withOpacity(0.3),
            iconColor: theme.colorScheme.onPrimary,
          ),

          const SizedBox(width: Spacing.md),

          // BINGO Button
          Expanded(
            child: PrimaryButton(
              text: 'BINGO!',
              height: 48,
              onPressed: gameState.playerCard.hasWinningPattern()
                  ? () {
                      gameController.endGame();
                    }
                  : null,
            ),
          ),

          const SizedBox(width: Spacing.md),

          // More Options
          AppIconButton(
            icon: Icons.more_vert,
            onPressed: () {
              _showGameMenu(context, gameController);
            },
            backgroundColor: theme.colorScheme.secondary.withOpacity(0.3),
            iconColor: theme.colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }

  void _showGameMenu(BuildContext context, GameController gameController) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Quit Game'),
              onTap: () {
                Navigator.pop(context); // Close menu
                Navigator.pop(context); // Go back to home
                gameController.clearGame();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context, GameController gameController) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Leave Game?',
          style: TextStyles.h3.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          'Are you sure you want to leave? Your progress in this game will be lost.',
          style: TextStyles.bodyMedium.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'STAY',
              style: TextStyles.button.copyWith(
                color: theme.colorScheme.tertiary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to previous screen
              gameController.clearGame();
            },
            child: Text(
              'LEAVE',
              style: TextStyles.button.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showGameResults(BuildContext context, GameState gameState) {
    final coinsEarned = gameState.calculateCoinsEarned();
    final gameController = Provider.of<GameController>(context, listen: false);
    final dailyChallenge = Provider.of<DailyChallengeService>(context, listen: false);
    
    // Check if daily challenge was just completed
    final dailyChallengeCompleted = dailyChallenge.isCompleted && 
        dailyChallenge.winsToday == dailyChallenge.requiredWinsCount &&
        gameState.result == GameResult.playerWon;

    // Show achievement notifications if any
    if (gameController.unlockedAchievements.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) {
          AchievementNotification.showMultiple(
            context,
            gameController.unlockedAchievements,
          );
          gameController.clearUnlockedAchievements();
        }
      });
    }
    
    // Show daily challenge completion notification
    if (dailyChallengeCompleted) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (context.mounted) {
          _showDailyChallengeCompleteDialog(context, dailyChallenge);
        }
      });
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AnimatedResultDialog(
        gameState: gameState,
        coinsEarned: coinsEarned,
        xpEarned: gameController.xpEarned,
        leveledUp: gameController.leveledUp,
        newLevel: gameController.newLevel,
        onBackToHome: () {
          Navigator.pop(context); // Close dialog
          Navigator.pop(context); // Go back to home
          Provider.of<GameController>(context, listen: false).clearGame();
          // Add coins to player
          Provider.of<PlayerService>(context, listen: false).addCoins(coinsEarned);
        },
        onPlayAgain: () {
          Navigator.pop(context); // Close dialog
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const GameScreen(),
            ),
          );
          // Start a new game with the same settings
          final gc = Provider.of<GameController>(context, listen: false);
          final oldState = gc.gameState;
          if (oldState != null) {
            gc.startNewGame(
              humanPlayer: oldState.humanPlayer,
              botPlayer: oldState.botPlayer,
            );
          }
        },
      ),
    );
  }

  void _showDailyChallengeCompleteDialog(BuildContext context, DailyChallengeService dailyChallenge) {
    final theme = Theme.of(context);
    final playerService = Provider.of<PlayerService>(context, listen: false);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Column(
          children: [
            Icon(
              Icons.emoji_events,
              color: Colors.amber,
              size: 64,
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              'Daily Challenge Complete!',
              style: TextStyles.h2.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Congratulations! You won ${dailyChallenge.requiredWinsCount} games today!',
              style: TextStyles.bodyLarge.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.lg),
            Container(
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.monetization_on,
                    color: Colors.amber,
                    size: 32,
                  ),
                  const SizedBox(width: Spacing.sm),
                  Text(
                    '+${dailyChallenge.reward} Coins',
                    style: TextStyles.h2.copyWith(
                      color: theme.colorScheme.tertiary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.md),
            Text(
              'Come back tomorrow for a new challenge!',
              style: TextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          PrimaryButton(
            text: 'CLAIM REWARD',
            onPressed: () {
              playerService.addCoins(dailyChallenge.reward);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('🎉 +${dailyChallenge.reward} coins earned!'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
        actionsPadding: const EdgeInsets.all(Spacing.md),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
