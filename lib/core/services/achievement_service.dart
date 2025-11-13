import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../../data/models/game_state.dart';
import 'storage_service.dart';
import 'player_service.dart';

/// Service for tracking and managing player achievements
class AchievementService extends ChangeNotifier {
  final StorageService _storage;
  final PlayerService _playerService;

  List<Achievement> _achievements = [];
  int _consecutiveWins = 0;
  int _gamesPlayedToday = 0;
  DateTime? _lastGameDate;

  AchievementService(this._storage, this._playerService) {
    _initializeAchievements();
    _loadProgress();
  }

  List<Achievement> get achievements => _achievements;
  List<Achievement> get unlockedAchievements =>
      _achievements.where((a) => a.isUnlocked).toList();
  List<Achievement> get lockedAchievements =>
      _achievements.where((a) => !a.isUnlocked).toList();

  int get totalAchievements => _achievements.length;
  int get unlockedCount => unlockedAchievements.length;
  double get completionPercentage =>
      totalAchievements > 0 ? (unlockedCount / totalAchievements) * 100 : 0;

  void _initializeAchievements() {
    _achievements = [
      // General achievements
      const Achievement(
        id: 'first_game',
        title: 'Getting Started',
        description: 'Play your first game',
        icon: '🎮',
        coinReward: 50,
        category: AchievementCategory.general,
      ),
      const Achievement(
        id: 'games_10',
        title: 'Dedicated Player',
        description: 'Play 10 games',
        icon: '🎯',
        coinReward: 100,
        category: AchievementCategory.general,
      ),
      const Achievement(
        id: 'games_50',
        title: 'Bingo Enthusiast',
        description: 'Play 50 games',
        icon: '🏆',
        coinReward: 250,
        category: AchievementCategory.general,
      ),
      const Achievement(
        id: 'games_100',
        title: 'Century Club',
        description: 'Play 100 games',
        icon: '💯',
        coinReward: 500,
        category: AchievementCategory.general,
      ),

      // Win achievements
      const Achievement(
        id: 'first_win',
        title: 'First Victory',
        description: 'Win your first game',
        icon: '🎊',
        coinReward: 75,
        category: AchievementCategory.wins,
      ),
      const Achievement(
        id: 'wins_10',
        title: 'Winner',
        description: 'Win 10 games',
        icon: '🥇',
        coinReward: 150,
        category: AchievementCategory.wins,
      ),
      const Achievement(
        id: 'wins_50',
        title: 'Champion',
        description: 'Win 50 games',
        icon: '👑',
        coinReward: 500,
        category: AchievementCategory.wins,
      ),
      const Achievement(
        id: 'wins_100',
        title: 'Legend',
        description: 'Win 100 games',
        icon: '⭐',
        coinReward: 1000,
        category: AchievementCategory.wins,
      ),

      // Speed achievements
      const Achievement(
        id: 'speed_demon',
        title: 'Speed Demon',
        description: 'Win a game in under 2 minutes',
        icon: '⚡',
        coinReward: 200,
        category: AchievementCategory.speed,
      ),
      const Achievement(
        id: 'lightning_fast',
        title: 'Lightning Fast',
        description: 'Win a game in under 1 minute',
        icon: '🚀',
        coinReward: 500,
        category: AchievementCategory.speed,
      ),

      // Efficiency achievements
      const Achievement(
        id: 'perfect_game',
        title: 'Perfect Game',
        description: 'Win with exactly 5 marked numbers',
        icon: '💎',
        coinReward: 300,
        category: AchievementCategory.efficiency,
      ),
      const Achievement(
        id: 'efficient_winner',
        title: 'Efficient Winner',
        description: 'Win with 7 or fewer marked numbers',
        icon: '✨',
        coinReward: 150,
        category: AchievementCategory.efficiency,
      ),

      // Pattern achievements
      const Achievement(
        id: 'all_patterns',
        title: 'Pattern Master',
        description: 'Complete all 12 bingo patterns',
        icon: '🎨',
        coinReward: 400,
        category: AchievementCategory.patterns,
      ),
      const Achievement(
        id: 'diagonal_master',
        title: 'Diagonal Expert',
        description: 'Win with both diagonal patterns',
        icon: '📐',
        coinReward: 150,
        category: AchievementCategory.patterns,
      ),
      const Achievement(
        id: 'corner_master',
        title: 'Corner Specialist',
        description: 'Win with all four corner patterns',
        icon: '📍',
        coinReward: 200,
        category: AchievementCategory.patterns,
      ),

      // Streak achievements
      const Achievement(
        id: 'win_streak_3',
        title: 'Hot Streak',
        description: 'Win 3 games in a row',
        icon: '🔥',
        coinReward: 200,
        category: AchievementCategory.streaks,
      ),
      const Achievement(
        id: 'win_streak_5',
        title: 'Unstoppable',
        description: 'Win 5 games in a row',
        icon: '💪',
        coinReward: 400,
        category: AchievementCategory.streaks,
      ),
      const Achievement(
        id: 'daily_grind',
        title: 'Daily Grind',
        description: 'Play 5 games in one day',
        icon: '📅',
        coinReward: 150,
        category: AchievementCategory.general,
      ),
    ];
  }

  Future<void> _loadProgress() async {
    final data = _storage.getUnlockedAchievements();
    final consecutiveWins = _storage.getConsecutiveWins();
    
    _consecutiveWins = consecutiveWins;

    // Update achievement unlock status
    for (int i = 0; i < _achievements.length; i++) {
      final achievementData = data.firstWhere(
        (a) => a['id'] == _achievements[i].id,
        orElse: () => {},
      );

      if (achievementData.isNotEmpty) {
        _achievements[i] = Achievement.fromJson(achievementData);
      }
    }

    notifyListeners();
  }

  /// Check and unlock achievements based on game completion
  Future<List<Achievement>> checkGameAchievements(GameState gameState) async {
    final newAchievements = <Achievement>[];

    // Update consecutive wins
    final hasWon = gameState.result == GameResult.playerWon;
    if (hasWon) {
      _consecutiveWins++;
      await _storage.saveConsecutiveWins(_consecutiveWins);
    } else {
      _consecutiveWins = 0;
      await _storage.saveConsecutiveWins(0);
    }

    // Update daily games counter
    final now = DateTime.now();
    if (_lastGameDate == null ||
        !_isSameDay(_lastGameDate!, now)) {
      _gamesPlayedToday = 1;
      _lastGameDate = now;
    } else {
      _gamesPlayedToday++;
    }

    // Get stats for checking
    final totalGames = _storage.getTotalGames();
    final totalWins = _storage.getTotalWins();
    final completedPatterns = _storage.getCompletedPatterns();

    // Check achievements
    newAchievements.addAll(await _checkGeneralAchievements(totalGames));
    
    if (hasWon) {
      newAchievements.addAll(await _checkWinAchievements(totalWins));
      newAchievements.addAll(await _checkSpeedAchievements(gameState));
      newAchievements.addAll(await _checkEfficiencyAchievements(gameState));
      newAchievements.addAll(await _checkPatternAchievements(
        gameState,
        completedPatterns,
      ));
    }
    
    newAchievements.addAll(await _checkStreakAchievements());

    // Award coins for new achievements
    for (final achievement in newAchievements) {
      _playerService.addCoins(achievement.coinReward);
    }

    if (newAchievements.isNotEmpty) {
      notifyListeners();
    }

    return newAchievements;
  }

  Future<List<Achievement>> _checkGeneralAchievements(int totalGames) async {
    final newAchievements = <Achievement>[];

    // First game
    if (totalGames == 1) {
      final achievement = await _unlockAchievement('first_game');
      if (achievement != null) newAchievements.add(achievement);
    }

    // Games played milestones
    if (totalGames == 10) {
      final achievement = await _unlockAchievement('games_10');
      if (achievement != null) newAchievements.add(achievement);
    }
    if (totalGames == 50) {
      final achievement = await _unlockAchievement('games_50');
      if (achievement != null) newAchievements.add(achievement);
    }
    if (totalGames == 100) {
      final achievement = await _unlockAchievement('games_100');
      if (achievement != null) newAchievements.add(achievement);
    }

    // Daily grind
    if (_gamesPlayedToday == 5) {
      final achievement = await _unlockAchievement('daily_grind');
      if (achievement != null) newAchievements.add(achievement);
    }

    return newAchievements;
  }

  Future<List<Achievement>> _checkWinAchievements(int totalWins) async {
    final newAchievements = <Achievement>[];

    if (totalWins == 1) {
      final achievement = await _unlockAchievement('first_win');
      if (achievement != null) newAchievements.add(achievement);
    }
    if (totalWins == 10) {
      final achievement = await _unlockAchievement('wins_10');
      if (achievement != null) newAchievements.add(achievement);
    }
    if (totalWins == 50) {
      final achievement = await _unlockAchievement('wins_50');
      if (achievement != null) newAchievements.add(achievement);
    }
    if (totalWins == 100) {
      final achievement = await _unlockAchievement('wins_100');
      if (achievement != null) newAchievements.add(achievement);
    }

    return newAchievements;
  }

  Future<List<Achievement>> _checkSpeedAchievements(GameState gameState) async {
    final newAchievements = <Achievement>[];
    final duration = gameState.endTime?.difference(gameState.startTime ?? DateTime.now()) 
        ?? Duration.zero;

    if (duration.inSeconds < 120 && duration.inSeconds > 0) {
      final achievement = await _unlockAchievement('speed_demon');
      if (achievement != null) newAchievements.add(achievement);
    }
    if (duration.inSeconds < 60 && duration.inSeconds > 0) {
      final achievement = await _unlockAchievement('lightning_fast');
      if (achievement != null) newAchievements.add(achievement);
    }

    return newAchievements;
  }

  Future<List<Achievement>> _checkEfficiencyAchievements(
    GameState gameState,
  ) async {
    final newAchievements = <Achievement>[];
    // Use the markedCount getter from BingoCard
    final markedCount = gameState.playerCard.markedCount;

    if (markedCount == 5) {
      final achievement = await _unlockAchievement('perfect_game');
      if (achievement != null) newAchievements.add(achievement);
    } else if (markedCount <= 7) {
      final achievement = await _unlockAchievement('efficient_winner');
      if (achievement != null) newAchievements.add(achievement);
    }

    return newAchievements;
  }

  Future<List<Achievement>> _checkPatternAchievements(
    GameState gameState,
    Set<String> completedPatterns,
  ) async {
    final newAchievements = <Achievement>[];
    
    // Detect which pattern was achieved
    String pattern = '';
    if (gameState.playerCard.hasHorizontalLine()) {
      pattern = 'horizontal';
    } else if (gameState.playerCard.hasVerticalLine()) {
      pattern = 'vertical';
    } else if (gameState.playerCard.hasDiagonalLine()) {
      // Check which diagonal
      bool diag1 = true;
      for (int i = 0; i < 5; i++) {
        if (!gameState.playerCard.cells[i][i].isMarked) {
          diag1 = false;
          break;
        }
      }
      pattern = diag1 ? 'diagonal_left' : 'diagonal_right';
    } else if (gameState.playerCard.hasFourCorners()) {
      pattern = 'four_corners';
    } else if (gameState.playerCard.hasFullHouse()) {
      pattern = 'full_house';
    }

    // Track completed patterns
    if (pattern.isNotEmpty) {
      completedPatterns.add(pattern);
      await _storage.saveCompletedPatterns(completedPatterns);
    }

    // All patterns completed (simplified to 6 main patterns)
    if (completedPatterns.length >= 6) {
      final achievement = await _unlockAchievement('all_patterns');
      if (achievement != null) newAchievements.add(achievement);
    }

    // Diagonal master
    if (completedPatterns.contains('diagonal_left') &&
        completedPatterns.contains('diagonal_right')) {
      final achievement = await _unlockAchievement('diagonal_master');
      if (achievement != null) newAchievements.add(achievement);
    }

    // Corner master
    if (completedPatterns.contains('four_corners')) {
      final achievement = await _unlockAchievement('corner_master');
      if (achievement != null) newAchievements.add(achievement);
    }

    return newAchievements;
  }

  Future<List<Achievement>> _checkStreakAchievements() async {
    final newAchievements = <Achievement>[];

    if (_consecutiveWins >= 3) {
      final achievement = await _unlockAchievement('win_streak_3');
      if (achievement != null) newAchievements.add(achievement);
    }
    if (_consecutiveWins >= 5) {
      final achievement = await _unlockAchievement('win_streak_5');
      if (achievement != null) newAchievements.add(achievement);
    }

    return newAchievements;
  }

  Future<Achievement?> _unlockAchievement(String achievementId) async {
    final index = _achievements.indexWhere((a) => a.id == achievementId);
    if (index == -1 || _achievements[index].isUnlocked) {
      return null;
    }

    final now = DateTime.now();
    _achievements[index] = _achievements[index].copyWith(
      isUnlocked: true,
      unlockedAt: now,
    );

    // Save to storage
    final unlockedData = _achievements
        .where((a) => a.isUnlocked)
        .map((a) => a.toJson())
        .toList();
    await _storage.saveUnlockedAchievements(unlockedData);

    return _achievements[index];
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Reset all achievements (for testing or data reset)
  Future<void> resetAchievements() async {
    _consecutiveWins = 0;
    _gamesPlayedToday = 0;
    _lastGameDate = null;

    for (int i = 0; i < _achievements.length; i++) {
      _achievements[i] = _achievements[i].copyWith(
        isUnlocked: false,
        unlockedAt: null,
      );
    }

    await _storage.saveUnlockedAchievements([]);
    await _storage.saveConsecutiveWins(0);
    await _storage.saveCompletedPatterns({});

    notifyListeners();
  }
}
