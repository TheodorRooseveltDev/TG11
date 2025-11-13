import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Daily Challenge Service
/// Manages daily challenge progress and rewards
class DailyChallengeService extends ChangeNotifier {
  static const String _lastResetDateKey = 'daily_challenge_last_reset';
  static const String _winsProgressKey = 'daily_challenge_wins_progress';
  static const String _completedTodayKey = 'daily_challenge_completed_today';
  
  static const int requiredWins = 3;
  static const int rewardCoins = 150;
  
  int _winsToday = 0;
  bool _completedToday = false;
  DateTime? _lastResetDate;

  int get winsToday => _winsToday;
  int get requiredWinsCount => requiredWins;
  int get reward => rewardCoins;
  bool get isCompleted => _completedToday;
  bool get isAvailable => !_completedToday;
  int get winsRemaining => requiredWins - _winsToday;

  /// Initialize and check if we need to reset for new day
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load saved data
    final lastResetString = prefs.getString(_lastResetDateKey);
    _lastResetDate = lastResetString != null 
        ? DateTime.parse(lastResetString) 
        : null;
    
    _winsToday = prefs.getInt(_winsProgressKey) ?? 0;
    _completedToday = prefs.getBool(_completedTodayKey) ?? false;

    // Check if we need to reset for a new day
    _checkAndResetIfNewDay();
    
    notifyListeners();
  }

  /// Check if it's a new day and reset progress
  void _checkAndResetIfNewDay() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (_lastResetDate == null) {
      _lastResetDate = today;
      _saveLastResetDate();
      return;
    }
    
    final lastReset = DateTime(
      _lastResetDate!.year, 
      _lastResetDate!.month, 
      _lastResetDate!.day,
    );
    
    // If it's a new day, reset progress
    if (today.isAfter(lastReset)) {
      _resetChallenge();
      _lastResetDate = today;
      _saveLastResetDate();
    }
  }

  /// Reset challenge progress
  void _resetChallenge() {
    _winsToday = 0;
    _completedToday = false;
    _saveProgress();
  }

  /// Record a win (call this after winning a game)
  Future<bool> recordWin() async {
    if (_completedToday) {
      return false; // Already completed today
    }

    _winsToday++;
    
    // Check if challenge is completed
    if (_winsToday >= requiredWins) {
      _completedToday = true;
    }
    
    await _saveProgress();
    notifyListeners();
    
    return _completedToday; // Return true if just completed
  }

  /// Claim the reward (returns coins earned)
  Future<int> claimReward() async {
    if (!_completedToday || _winsToday < requiredWins) {
      return 0;
    }

    // Mark as claimed by resetting (or you could add a separate claimed flag)
    await _saveProgress();
    notifyListeners();
    
    return rewardCoins;
  }

  /// Save progress to SharedPreferences
  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_winsProgressKey, _winsToday);
    await prefs.setBool(_completedTodayKey, _completedToday);
  }

  /// Save last reset date
  Future<void> _saveLastResetDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastResetDateKey, _lastResetDate!.toIso8601String());
  }

  /// Get progress text for UI
  String getProgressText() {
    if (_completedToday) {
      return 'Challenge completed! Come back tomorrow';
    }
    return 'Win ${winsRemaining} more game${winsRemaining == 1 ? '' : 's'} for +$rewardCoins coins';
  }

  /// Reset for testing (DEBUG only)
  Future<void> debugReset() async {
    _winsToday = 0;
    _completedToday = false;
    await _saveProgress();
    notifyListeners();
  }
}
