import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/spacing.dart';
import '../../core/constants/border_radii.dart';
import '../../core/constants/elevations.dart';
import '../../core/constants/animation_durations.dart';
import '../../core/theme/text_styles.dart';
import '../../core/services/sound_service.dart';

/// Primary Button Widget
/// Main CTA button with gradient and elevation
class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final double? width;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.height = 56.0,
    this.width,
    this.icon,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final soundService = context.read<SoundService>();
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    return AnimatedScale(
      scale: _isPressed ? 0.98 : 1.0,
      duration: AnimationDurations.fastest,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          gradient: isEnabled
              ? LinearGradient(
                  colors: [
                    theme.colorScheme.tertiary,
                    theme.colorScheme.tertiary.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [
                    Colors.grey.shade600,
                    Colors.grey.shade700,
                  ],
                ),
          borderRadius: BorderRadii.medium,
          boxShadow: isEnabled ? Elevations.mediumShadow : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled
                ? () {
                    soundService.playButtonClick();
                    widget.onPressed?.call();
                  }
                : null,
            onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
            onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
            onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
            borderRadius: BorderRadii.medium,
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.onTertiary,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            color: theme.colorScheme.onTertiary,
                            size: 20,
                          ),
                          const SizedBox(width: Spacing.xs),
                        ],
                        Text(
                          widget.text,
                          style: TextStyles.button.copyWith(
                            color: theme.colorScheme.onTertiary,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Secondary Button Widget
/// Outlined button for secondary actions
class SecondaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final double? width;
  final IconData? icon;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.height = 48.0,
    this.width,
    this.icon,
  });

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final soundService = context.read<SoundService>();
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    return AnimatedScale(
      scale: _isPressed ? 0.98 : 1.0,
      duration: AnimationDurations.fastest,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          border: Border.all(
            color: isEnabled ? theme.colorScheme.tertiary : Colors.grey.shade600,
            width: 2,
          ),
          borderRadius: BorderRadii.medium,
          color: Colors.transparent,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled
                ? () {
                    soundService.playButtonClick();
                    widget.onPressed?.call();
                  }
                : null,
            onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
            onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
            onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
            borderRadius: BorderRadii.medium,
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.tertiary,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            color: isEnabled
                                ? theme.colorScheme.tertiary
                                : Colors.grey.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: Spacing.xs),
                        ],
                        Text(
                          widget.text,
                          style: TextStyles.button.copyWith(
                            color: isEnabled
                                ? theme.colorScheme.tertiary
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Icon Button Widget
/// Square button with icon only
class AppIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 48.0,
  });

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final soundService = context.read<SoundService>();
    final isEnabled = widget.onPressed != null;

    return AnimatedScale(
      scale: _isPressed ? 0.95 : 1.0,
      duration: AnimationDurations.fastest,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.backgroundColor ??
              theme.colorScheme.secondary.withOpacity(0.1),
          borderRadius: BorderRadii.medium,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled
                ? () {
                    soundService.playButtonClick();
                    widget.onPressed?.call();
                  }
                : null,
            onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
            onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
            onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
            borderRadius: BorderRadii.medium,
            child: Center(
              child: Icon(
                widget.icon,
                color: widget.iconColor ?? theme.colorScheme.onSurface,
                size: widget.size * 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
