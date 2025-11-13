import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/player_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/constants/spacing.dart';
import '../../core/theme/text_styles.dart';
import '../widgets/buttons.dart';
import '../widgets/themed_background.dart';
import 'home_screen.dart';

/// Onboarding Screen
/// First-time user experience to set up player profile
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedAvatar = 'avatar_1';
  int _currentStep = 0;

  final List<String> _avatars = [
    'avatar_1',
    'avatar_2',
    'avatar_3',
    'avatar_4',
    'avatar_5',
    'avatar_6',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_formKey.currentState!.validate()) {
        setState(() => _currentStep = 1);
      }
    } else if (_currentStep == 1) {
      _completeOnboarding();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _completeOnboarding() async {
    final playerService = context.read<PlayerService>();
    final storage = context.read<StorageService>();

    // Save player data
    await playerService.updatePlayerName(_nameController.text);
    await playerService.updatePlayerAvatar(_selectedAvatar);
    await storage.setOnboardingCompleted(true);

    // Navigate to home
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ThemedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.xl),
            child: Column(
              children: [
                // Progress indicator
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: (_currentStep + 1) / 2,
                        backgroundColor: theme.colorScheme.surface.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.xl),

                // Content
                Expanded(
                  child: _currentStep == 0
                      ? _buildNameStep(theme)
                      : _buildAvatarStep(theme),
                ),

                // Navigation buttons
                Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: SecondaryButton(
                          text: 'Back',
                          onPressed: _previousStep,
                        ),
                      ),
                    if (_currentStep > 0) const SizedBox(width: Spacing.md),
                    Expanded(
                      flex: _currentStep == 0 ? 1 : 2,
                      child: PrimaryButton(
                        text: _currentStep == 0 ? 'Next' : 'Start Playing',
                        onPressed: _nextStep,
                        icon: _currentStep == 0 ? Icons.arrow_forward : Icons.play_arrow,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameStep(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Welcome text
        Text(
          'WELCOME TO',
          style: TextStyles.h3.copyWith(
            color: theme.colorScheme.onPrimary.withOpacity(0.7),
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: Spacing.lg),
        
        // App Logo
        Image.asset(
          'assets/images/logo.png',
          width: 250,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: Spacing.xxl),

        // Name input
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What should we call you?',
                style: TextStyles.h3.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: Spacing.md),
              TextFormField(
                controller: _nameController,
                style: TextStyles.h3.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  hintStyle: TextStyles.bodyMedium.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.tertiary.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.tertiary.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.tertiary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: Spacing.lg,
                    vertical: Spacing.md,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  if (value.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  if (value.trim().length > 20) {
                    return 'Name must be less than 20 characters';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                maxLength: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarStep(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Choose Your Avatar',
          style: TextStyles.h2.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: Spacing.md),
        Text(
          'Pick a style that represents you',
          style: TextStyles.bodyMedium.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: Spacing.xxl),

        // Avatar grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: Spacing.md,
              mainAxisSpacing: Spacing.md,
              childAspectRatio: 1,
            ),
            itemCount: _avatars.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final avatarId = _avatars[index];
              final isSelected = _selectedAvatar == avatarId;

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedAvatar = avatarId);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.tertiary
                          : theme.colorScheme.surface.withOpacity(0.5),
                      width: isSelected ? 4 : 2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: theme.colorScheme.tertiary.withOpacity(0.5),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getAvatarIcon(index),
                        size: 48,
                        color: isSelected
                            ? theme.colorScheme.tertiary
                            : theme.colorScheme.onSurface,
                      ),
                      const SizedBox(height: Spacing.xs),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          size: 20,
                          color: theme.colorScheme.tertiary,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getAvatarIcon(int index) {
    const icons = [
      Icons.face,
      Icons.emoji_emotions,
      Icons.sentiment_very_satisfied,
      Icons.psychology,
      Icons.rocket_launch,
      Icons.favorite,
    ];
    return icons[index];
  }
}
