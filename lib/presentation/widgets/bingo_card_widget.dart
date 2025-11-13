import 'package:flutter/material.dart';
import '../../core/constants/border_radii.dart';
import '../../core/constants/animation_durations.dart';
import '../../core/theme/text_styles.dart';
import '../../data/models/bingo_card.dart';

/// Bingo Cell Widget
/// Represents a single cell on the bingo card
class BingoCellWidget extends StatelessWidget {
  final BingoCell cell;
  final VoidCallback? onTap;
  final bool isHighlighted;

  const BingoCellWidget({
    super.key,
    required this.cell,
    this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: AnimationDurations.fast,
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        gradient: cell.isMarked
            ? LinearGradient(
                colors: [
                  theme.colorScheme.tertiary,
                  theme.colorScheme.tertiary.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: cell.isMarked
            ? null
            : theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadii.small,
        border: Border.all(
          color: isHighlighted
              ? theme.colorScheme.tertiary
              : theme.colorScheme.onSurface.withOpacity(0.2),
          width: isHighlighted ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: cell.isFreeSpace ? null : onTap,
          borderRadius: BorderRadii.small,
          child: Center(
            child: cell.isFreeSpace
                ? Text(
                    'FREE',
                    style: TextStyles.caption.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : Text(
                    '${cell.number.value}',
                    style: TextStyles.bingoNumber.copyWith(
                      color: cell.isMarked
                          ? theme.colorScheme.onTertiary
                          : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Full Bingo Card Widget
/// Displays the 5x5 bingo grid
class BingoCardWidget extends StatelessWidget {
  final BingoCard card;
  final Function(int col, int row)? onCellTap;
  final List<int>? highlightedNumbers;

  const BingoCardWidget({
    super.key,
    required this.card,
    this.onCellTap,
    this.highlightedNumbers,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.secondary.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadii.large,
          boxShadow: const [
            BoxShadow(
              color: Color(0x29000000),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // B-I-N-G-O Header
            _buildHeader(context),
            const SizedBox(height: 8),
            // Grid
            Expanded(
              child: _buildGrid(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    const letters = ['B', 'I', 'N', 'G', 'O'];
    return Row(
      children: letters.map((letter) {
        return Expanded(
          child: Center(
            child: Text(
              letter,
              style: TextStyles.h3.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(5, (col) {
        return Expanded(
          child: Column(
            children: List.generate(5, (row) {
              final cell = card.getCellAt(col, row);
              final isHighlighted = highlightedNumbers != null &&
                  highlightedNumbers!.contains(cell.number.value);

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: BingoCellWidget(
                    cell: cell,
                    onTap: onCellTap != null ? () => onCellTap!(col, row) : null,
                    isHighlighted: isHighlighted,
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}
