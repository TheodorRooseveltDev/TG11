import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import '../../core/constants/spacing.dart';
import '../../core/theme/text_styles.dart';
import '../../data/models/game_state.dart';
import '../widgets/buttons.dart';

/// Animated Game Result Dialog
/// Shows win/loss with confetti and animations
class AnimatedResultDialog extends StatefulWidget {
  final GameState gameState;
  final int coinsEarned;
  final int xpEarned;
  final bool leveledUp;
  final int newLevel;
  final VoidCallback onBackToHome;
  final VoidCallback onPlayAgain;

  const AnimatedResultDialog({
    super.key,
    required this.gameState,
    required this.coinsEarned,
    this.xpEarned = 0,
    this.leveledUp = false,
    this.newLevel = 0,
    required this.onBackToHome,
    required this.onPlayAgain,
  });

  @override
  State<AnimatedResultDialog> createState() => _AnimatedResultDialogState();
}

class _AnimatedResultDialogState extends State<AnimatedResultDialog>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _scaleController;
  late AnimationController _coinController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _coinAnimation;

  @override
  void initState() {
    super.initState();

    // Confetti controller
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    // Scale animation for result text
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    // Coin counter animation
    _coinController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _coinAnimation = CurvedAnimation(
      parent: _coinController,
      curve: Curves.easeOut,
    );

    // Start animations
    _scaleController.forward();
    _coinController.forward();

    // Trigger confetti if player won
    if (widget.gameState.result == GameResult.playerWon) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _confettiController.play();
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _scaleController.dispose();
    _coinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWin = widget.gameState.result == GameResult.playerWon;

    return Stack(
      children: [
        // Main dialog
        Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(Spacing.xl),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.surface,
                  theme.colorScheme.surface.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isWin
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.error,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isWin
                          ? theme.colorScheme.tertiary
                          : theme.colorScheme.error)
                      .withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Title
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Text(
                    isWin ? '🎉 VICTORY!' : '😔 DEFEATED',
                    textAlign: TextAlign.center,
                    style: TextStyles.display1.copyWith(
                      color: isWin
                          ? theme.colorScheme.tertiary
                          : theme.colorScheme.error,
                      fontWeight: FontWeight.w900,
                      fontSize: 48,
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.lg),

                // Message
                Text(
                  isWin
                      ? 'Congratulations! You won!'
                      : 'Better luck next time!',
                  textAlign: TextAlign.center,
                  style: TextStyles.h3.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.lg),

                // Animated Coins Earned
                AnimatedBuilder(
                  animation: _coinAnimation,
                  builder: (context, child) {
                    final displayCoins =
                        (_coinAnimation.value * widget.coinsEarned).round();
                    final displayXP =
                        (_coinAnimation.value * widget.xpEarned).round();
                    return Column(
                      children: [
                        // Coins
                        Container(
                          padding: const EdgeInsets.all(Spacing.lg),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber.withOpacity(0.3),
                                Colors.orange.withOpacity(0.3),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.amber,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.monetization_on,
                                    color: Colors.amber,
                                    size: 32,
                                  ),
                                  const SizedBox(width: Spacing.sm),
                                  Text(
                                    'Coins Earned',
                                    style: TextStyles.h4.copyWith(
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: Spacing.xs),
                              Text(
                                '+$displayCoins',
                                style: TextStyles.display1.copyWith(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 56,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // XP
                        if (widget.xpEarned > 0) ...[
                          const SizedBox(height: Spacing.md),
                          Container(
                            padding: const EdgeInsets.all(Spacing.md),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.tertiary.withOpacity(0.3),
                                  theme.colorScheme.tertiary.withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.colorScheme.tertiary,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.stars,
                                  color: theme.colorScheme.tertiary,
                                  size: 24,
                                ),
                                const SizedBox(width: Spacing.sm),
                                Text(
                                  '+$displayXP XP',
                                  style: TextStyles.h3.copyWith(
                                    color: theme.colorScheme.tertiary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (widget.leveledUp) ...[
                                  const SizedBox(width: Spacing.sm),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Spacing.sm,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.arrow_upward,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Level ${widget.newLevel}!',
                                          style: TextStyles.caption.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: Spacing.lg),

                // Game Stats
                Container(
                  padding: const EdgeInsets.all(Spacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildStatRow(
                        context,
                        Icons.numbers,
                        'Numbers Called',
                        widget.gameState.calledNumbers.length.toString(),
                      ),
                      if (widget.gameState.durationInSeconds != null) ...[
                        const SizedBox(height: Spacing.sm),
                        _buildStatRow(
                          context,
                          Icons.timer,
                          'Time',
                          _formatDuration(widget.gameState.durationInSeconds!),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.xl),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        text: 'Home',
                        onPressed: widget.onBackToHome,
                        icon: Icons.home,
                      ),
                    ),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      flex: 2,
                      child: PrimaryButton(
                        text: 'Play Again',
                        onPressed: widget.onPlayAgain,
                        icon: Icons.refresh,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Confetti overlay (only for wins)
        if (isWin) ...[
          // Left confetti
          Align(
            alignment: Alignment.topLeft,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 4, // 45 degrees to the right
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              maxBlastForce: 20,
              minBlastForce: 10,
              gravity: 0.3,
              colors: const [
                Colors.pink,
                Colors.purple,
                Colors.blue,
                Colors.amber,
                Colors.green,
                Colors.red,
              ],
            ),
          ),
          // Right confetti
          Align(
            alignment: Alignment.topRight,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 3 * pi / 4, // 135 degrees to the left
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              maxBlastForce: 20,
              minBlastForce: 10,
              gravity: 0.3,
              colors: const [
                Colors.pink,
                Colors.purple,
                Colors.blue,
                Colors.amber,
                Colors.green,
                Colors.red,
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.tertiary, size: 20),
        const SizedBox(width: Spacing.sm),
        Text(
          label,
          style: TextStyles.bodyMedium.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyles.h4.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
