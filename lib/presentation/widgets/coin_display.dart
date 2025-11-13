import 'package:flutter/material.dart';
import '../../core/constants/spacing.dart';
import '../../core/theme/text_styles.dart';

/// Coin Display Widget
/// Shows the player's coin balance with an animated counter
class CoinDisplay extends StatelessWidget {
  final int coins;
  final bool showLabel;

  const CoinDisplay({
    super.key,
    required this.coins,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.tertiary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.monetization_on,
            color: theme.colorScheme.tertiary,
            size: 20,
          ),
          const SizedBox(width: Spacing.xs),
          Text(
            coins.toString(),
            style: TextStyles.h4.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (showLabel) ...[
            const SizedBox(width: Spacing.xxs),
            Text(
              'coins',
              style: TextStyles.caption.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
