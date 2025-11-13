import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/player.dart';

/// Stats Service
/// Tracks and persists player statistics
class StatsService extends ChangeNotifier {
  // Stats
  int _totalGamesPlayed = 0;
  int _totalWins = 0;
  int _totalLosses = 0;
  int _currentWinStreak = 0;
  int _bestWinStreak = 0;
  int _totalCoinsEarned = 0;
  int _fastestWinTime = 0; // in seconds
  int _mostEfficientWin = 999; // fewest numbers called
  
  // Per-difficulty stats
  final Map<BotDifficulty, int> _winsPerDifficulty = {
    BotDifficulty.easy: 0,
    BotDifficulty.medium: 0,
    BotDifficulty.hard: 0,
    BotDifficulty.expert: 0,
  };
  
  final Map<BotDifficulty, int> _gamesPerDifficulty = {
    BotDifficulty.easy: 0,
    BotDifficulty.medium: 0,
    BotDifficulty.hard: 0,
    BotDifficulty.expert: 0,
  };

  // Getters
  int get totalGamesPlayed => _totalGamesPlayed;
  int get totalWins => _totalWins;
  int get totalLosses => _totalLosses;
  int get currentWinStreak => _currentWinStreak;
  int get bestWinStreak => _bestWinStreak;
  int get totalCoinsEarned => _totalCoinsEarned;
  int get fastestWinTime => _fastestWinTime;
  int get mostEfficientWin => _mostEfficientWin;
  
  double get winRate => _totalGamesPlayed == 0 
      ? 0.0 
      : (_totalWins / _totalGamesPlayed) * 100;
  
  Map<BotDifficulty, int> get winsPerDifficulty => Map.unmodifiable(_winsPerDifficulty);
  Map<BotDifficulty, int> get gamesPerDifficulty => Map.unmodifiable(_gamesPerDifficulty);

  StatsService() {
    loadStats();
  }

  /// Load stats from SharedPreferences
  Future<void> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    
    _totalGamesPlayed = prefs.getInt('total_games_played') ?? 0;
    _totalWins = prefs.getInt('total_wins') ?? 0;
    _totalLosses = prefs.getInt('total_losses') ?? 0;
    _currentWinStreak = prefs.getInt('current_win_streak') ?? 0;
    _bestWinStreak = prefs.getInt('best_win_streak') ?? 0;
    _totalCoinsEarned = prefs.getInt('total_coins_earned') ?? 0;
    _fastestWinTime = prefs.getInt('fastest_win_time') ?? 0;
    _mostEfficientWin = prefs.getInt('most_efficient_win') ?? 999;
    
    // Load per-difficulty stats
    for (var difficulty in BotDifficulty.values) {
      _winsPerDifficulty[difficulty] = 
          prefs.getInt('wins_${difficulty.name}') ?? 0;
      _gamesPerDifficulty[difficulty] = 
          prefs.getInt('games_${difficulty.name}') ?? 0;
    }
    
    notifyListeners();
  }

  /// Save stats to SharedPreferences
  Future<void> _saveStats() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setInt('total_games_played', _totalGamesPlayed);
    await prefs.setInt('total_wins', _totalWins);
    await prefs.setInt('total_losses', _totalLosses);
    await prefs.setInt('current_win_streak', _currentWinStreak);
    await prefs.setInt('best_win_streak', _bestWinStreak);
    await prefs.setInt('total_coins_earned', _totalCoinsEarned);
    await prefs.setInt('fastest_win_time', _fastestWinTime);
    await prefs.setInt('most_efficient_win', _mostEfficientWin);
    
    // Save per-difficulty stats
    for (var difficulty in BotDifficulty.values) {
      await prefs.setInt('wins_${difficulty.name}', _winsPerDifficulty[difficulty]!);
      await prefs.setInt('games_${difficulty.name}', _gamesPerDifficulty[difficulty]!);
    }
  }

  /// Record a game result
  Future<void> recordGame({
    required bool won,
    required BotDifficulty difficulty,
    required int coinsEarned,
    required int numbersCalledCount,
    required int durationSeconds,
  }) async {
    _totalGamesPlayed++;
    _gamesPerDifficulty[difficulty] = (_gamesPerDifficulty[difficulty] ?? 0) + 1;
    
    if (won) {
      _totalWins++;
      _winsPerDifficulty[difficulty] = (_winsPerDifficulty[difficulty] ?? 0) + 1;
      _currentWinStreak++;
      _totalCoinsEarned += coinsEarned;
      
      // Update best win streak
      if (_currentWinStreak > _bestWinStreak) {
        _bestWinStreak = _currentWinStreak;
      }
      
      // Update fastest win time
      if (_fastestWinTime == 0 || durationSeconds < _fastestWinTime) {
        _fastestWinTime = durationSeconds;
      }
      
      // Update most efficient win
      if (numbersCalledCount < _mostEfficientWin) {
        _mostEfficientWin = numbersCalledCount;
      }
    } else {
      _totalLosses++;
      _currentWinStreak = 0;
    }
    
    await _saveStats();
    notifyListeners();
  }

  /// Reset all stats
  Future<void> resetStats() async {
    _totalGamesPlayed = 0;
    _totalWins = 0;
    _totalLosses = 0;
    _currentWinStreak = 0;
    _bestWinStreak = 0;
    _totalCoinsEarned = 0;
    _fastestWinTime = 0;
    _mostEfficientWin = 999;
    
    for (var difficulty in BotDifficulty.values) {
      _winsPerDifficulty[difficulty] = 0;
      _gamesPerDifficulty[difficulty] = 0;
    }
    
    await _saveStats();
    notifyListeners();
  }

  /// Get win rate for a specific difficulty
  double getWinRateForDifficulty(BotDifficulty difficulty) {
    final games = _gamesPerDifficulty[difficulty] ?? 0;
    if (games == 0) return 0.0;
    final wins = _winsPerDifficulty[difficulty] ?? 0;
    return (wins / games) * 100;
  }
}
