import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/player_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/sound_service.dart';
import '../../core/services/stats_service.dart';
import '../../core/constants/spacing.dart';
import '../../core/theme/text_styles.dart';
import '../widgets/themed_background.dart';
import 'webview_screen.dart';

/// Settings Screen
/// App settings and user preferences
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final playerService = context.watch<PlayerService>();
    final soundService = context.watch<SoundService>();
    final storage = context.read<StorageService>();

    return ThemedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'SETTINGS',
            style: TextStyles.h2.copyWith(color: theme.colorScheme.onPrimary),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.only(
            left: Spacing.lg,
            right: Spacing.lg,
            top: Spacing.lg,
            bottom: 180, // Extra padding for floating navbar
          ),
          children: [
            // Player Profile Section
            _buildSectionHeader(context, 'Player Profile'),
            _buildProfileCard(context, playerService),
            const SizedBox(height: Spacing.xl),

            // Audio Settings Section
            _buildSectionHeader(context, 'Audio'),
            _buildAudioSettings(context, soundService, storage),
            const SizedBox(height: Spacing.xl),

            // Data & Privacy Section
            _buildSectionHeader(context, 'Data & Privacy'),
            _buildDataSettings(context, storage, playerService),
            const SizedBox(height: Spacing.xl),

            // Legal Section
            _buildSectionHeader(context, 'Legal'),
            _buildLegalSection(context),
            const SizedBox(height: Spacing.xl),

            // About Section
            _buildSectionHeader(context, 'About'),
            _buildAboutSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: Text(
        title.toUpperCase(),
        style: TextStyles.h3.copyWith(
          color: theme.colorScheme.onPrimary,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, PlayerService playerService) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.tertiary.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: theme.colorScheme.tertiary.withOpacity(0.2),
                child: Icon(
                  _getAvatarIcon(playerService.playerAvatar),
                  color: theme.colorScheme.tertiary,
                  size: 36,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playerService.playerName,
                      style: TextStyles.h3.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Spacing.xxs),
                    Text(
                      'Level ${playerService.level}',
                      style: TextStyles.bodyMedium.copyWith(
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
                      const SizedBox(width: Spacing.xs),
                      Text(
                        playerService.coins.toString(),
                        style: TextStyles.h3.copyWith(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          // XP Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'XP Progress',
                    style: TextStyles.caption.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    '${playerService.xp} / ${playerService.xpForNextLevel}',
                    style: TextStyles.caption.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.xs),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: playerService.levelProgress,
                  minHeight: 8,
                  backgroundColor: theme.colorScheme.surface.withOpacity(0.5),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.tertiary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAudioSettings(
    BuildContext context,
    SoundService soundService,
    StorageService storage,
  ) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.tertiary.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Sound Effects Toggle
          SwitchListTile(
            title: Text(
              'Sound Effects',
              style: TextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            subtitle: Text(
              'Game sounds and UI feedback',
              style: TextStyles.caption.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            value: soundService.isSoundEnabled,
            onChanged: (value) {
              soundService.toggleSound();
              storage.saveSoundEnabled(value);
            },
            activeColor: theme.colorScheme.tertiary,
          ),
          // Effects Volume Slider
          if (soundService.isSoundEnabled)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
              child: Row(
                children: [
                  const Icon(Icons.volume_down, color: Colors.white70),
                  Expanded(
                    child: Slider(
                      value: soundService.effectsVolume,
                      onChanged: (value) {
                        soundService.setEffectsVolume(value);
                        storage.saveEffectsVolume(value);
                      },
                      activeColor: theme.colorScheme.tertiary,
                      inactiveColor: theme.colorScheme.surface,
                    ),
                  ),
                  const Icon(Icons.volume_up, color: Colors.white70),
                ],
              ),
            ),
          const Divider(height: 1),
          // Music Toggle
          SwitchListTile(
            title: Text(
              'Background Music',
              style: TextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            subtitle: Text(
              'Ambient background music',
              style: TextStyles.caption.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            value: soundService.isMusicEnabled,
            onChanged: (value) {
              soundService.toggleMusic();
              storage.saveMusicEnabled(value);
            },
            activeColor: theme.colorScheme.tertiary,
          ),
          // Music Volume Slider
          if (soundService.isMusicEnabled)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
              child: Row(
                children: [
                  const Icon(Icons.volume_down, color: Colors.white70),
                  Expanded(
                    child: Slider(
                      value: soundService.musicVolume,
                      onChanged: (value) {
                        soundService.setMusicVolume(value);
                        storage.saveMusicVolume(value);
                      },
                      activeColor: theme.colorScheme.tertiary,
                      inactiveColor: theme.colorScheme.surface,
                    ),
                  ),
                  const Icon(Icons.volume_up, color: Colors.white70),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDataSettings(
    BuildContext context,
    StorageService storage,
    PlayerService playerService,
  ) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.tertiary.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.edit, color: theme.colorScheme.tertiary),
            title: Text(
              'Change Name',
              style: TextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            subtitle: Text(
              'Update your display name',
              style: TextStyles.caption.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
              size: 16,
            ),
            onTap: () => _showChangeNameDialog(context, playerService),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.refresh, color: theme.colorScheme.tertiary),
            title: Text(
              'Reset Progress',
              style: TextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            subtitle: Text(
              'Reset stats, coins, and levels',
              style: TextStyles.caption.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            onTap: () => _showResetProgressDialog(context, storage, playerService),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.delete_forever, color: theme.colorScheme.error),
            title: Text(
              'Clear All Data',
              style: TextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            subtitle: Text(
              'Delete everything and restart',
              style: TextStyles.caption.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            onTap: () => _showClearDataDialog(context, storage),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalSection(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.tertiary.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.privacy_tip, color: theme.colorScheme.tertiary),
            title: Text(
              'Privacy Policy',
              style: TextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            subtitle: Text(
              'How we handle your data',
              style: TextStyles.caption.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: theme.colorScheme.tertiary, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WebViewScreen(
                    title: 'Privacy Policy',
                    url: 'https://bingoclashduo.com/privacy',
                  ),
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.description, color: theme.colorScheme.tertiary),
            title: Text(
              'Terms of Service',
              style: TextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            subtitle: Text(
              'Terms and conditions',
              style: TextStyles.caption.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: theme.colorScheme.tertiary, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WebViewScreen(
                    title: 'Terms of Service',
                    url: 'https://bingoclashduo.com/terms',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.tertiary.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // App Logo
          Image.asset(
            'assets/images/logo.png',
            width: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: Spacing.lg),
          Text(
            'Version 1.0.0',
            style: TextStyles.bodyMedium.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: Spacing.md),
          Text(
            'Challenge bots and master the ultimate bingo experience',
            style: TextStyles.bodySmall.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.lg),
          Text(
            '© 2025 Bingo Clash',
            style: TextStyles.caption.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetProgressDialog(
    BuildContext context,
    StorageService storage,
    PlayerService playerService,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Progress'),
        content: const Text(
          'This will reset your stats, coins, and level to default values. Your name and unlocked themes will be kept. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Reset player progress
              await playerService.resetProgress();
              
              // Reset stats
              final statsService = context.read<StatsService>();
              await statsService.resetStats();
              
              // Reset to defaults but keep profile
              await storage.resetToDefaults();
              
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Progress reset successfully')),
                );
              }
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, StorageService storage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will delete ALL your data including your profile, progress, and unlocked themes. This action cannot be undone. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await storage.clearAll();
              if (context.mounted) {
                Navigator.pop(context);
                // Note: App should restart to show onboarding again
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All data cleared. Please restart the app.'),
                  ),
                );
              }
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showChangeNameDialog(BuildContext context, PlayerService playerService) {
    final theme = Theme.of(context);
    final nameController = TextEditingController(text: playerService.playerName);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Change Name',
          style: TextStyles.h3.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: TextField(
          controller: nameController,
          autofocus: true,
          maxLength: 20,
          style: TextStyles.bodyLarge.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            labelText: 'Player Name',
            labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
            hintText: 'Enter your name',
            hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: theme.colorScheme.tertiary.withOpacity(0.5)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: theme.colorScheme.tertiary),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: TextStyles.button.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final newName = nameController.text.trim();
              if (newName.isNotEmpty && newName != playerService.playerName) {
                await playerService.updatePlayerName(newName);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Name changed to "$newName"'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              } else {
                Navigator.pop(context);
              }
            },
            child: Text(
              'SAVE',
              style: TextStyles.button.copyWith(
                color: theme.colorScheme.tertiary,
              ),
            ),
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
  }
}
