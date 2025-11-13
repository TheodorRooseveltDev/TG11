import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme_provider.dart';
import 'core/services/sound_service.dart';
import 'core/services/stats_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/player_service.dart';
import 'core/services/achievement_service.dart';
import 'core/services/daily_challenge_service.dart';
import 'domain/game_controller.dart';
import 'presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize storage
  final storage = StorageService();
  await storage.initialize();

  runApp(BingoClashApp(storage: storage));
}

class BingoClashApp extends StatelessWidget {
  final StorageService storage;

  const BingoClashApp({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storage),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(storage),
        ),
        ChangeNotifierProvider(
          create: (context) => PlayerService(storage),
        ),
        ChangeNotifierProvider(
          create: (context) => AchievementService(
            storage,
            context.read<PlayerService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => DailyChallengeService()..initialize(),
        ),
        ChangeNotifierProvider(create: (_) => SoundService()),
        ChangeNotifierProvider(create: (_) => StatsService()),
        ChangeNotifierProxyProvider5<SoundService, StatsService, AchievementService, DailyChallengeService, PlayerService, GameController>(
          create: (context) => GameController(
            soundService: context.read<SoundService>(),
            statsService: context.read<StatsService>(),
            achievementService: context.read<AchievementService>(),
            dailyChallengeService: context.read<DailyChallengeService>(),
            playerService: context.read<PlayerService>(),
          ),
          update: (context, soundService, statsService, achievementService, dailyChallengeService, playerService, gameController) =>
              gameController ??
              GameController(
                soundService: soundService,
                statsService: statsService,
                achievementService: achievementService,
                dailyChallengeService: dailyChallengeService,
                playerService: playerService,
              ),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Bingo Clash',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.currentTheme.colors.toThemeData(),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
