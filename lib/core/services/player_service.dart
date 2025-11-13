import 'package:flutter/foundation.dart';
import 'storage_service.dart';

/// Player Service
/// Manages player profile, level, XP, and progression
class PlayerService extends ChangeNotifier {
  final StorageService _storage;

  String _playerName = 'Player';
  String _playerAvatar = 'avatar_1';
  int _level = 1;
  int _xp = 0;
  int _coins = 500;

  String get playerName => _playerName;
  String get playerAvatar => _playerAvatar;
  int get level => _level;
  int get xp => _xp;
  int get coins => _coins;

  // XP required for next level (increases by 100 per level)
  int get xpForNextLevel => _level * 100;
  
  // Progress to next level (0.0 to 1.0)
  double get levelProgress => _xp / xpForNextLevel;

  PlayerService(this._storage) {
    _loadPlayerData();
  }

  /// Load player data from storage
  Future<void> _loadPlayerData() async {
    _playerName = _storage.getPlayerName() ?? 'Player';
    _playerAvatar = _storage.getPlayerAvatar() ?? 'avatar_1';
    _level = _storage.getPlayerLevel();
    _xp = _storage.getPlayerXP();
    _coins = _storage.getCoins();
    notifyListeners();
  }

  /// Update player name
  Future<void> updatePlayerName(String name) async {
    if (name.trim().isEmpty) return;
    _playerName = name.trim();
    await _storage.savePlayerName(_playerName);
    notifyListeners();
  }

  /// Update player avatar
  Future<void> updatePlayerAvatar(String avatarId) async {
    _playerAvatar = avatarId;
    await _storage.savePlayerAvatar(_playerAvatar);
    notifyListeners();
  }

  /// Add XP and handle level ups
  Future<void> addXP(int amount) async {
    _xp += amount;
    
    // Check for level up
    while (_xp >= xpForNextLevel) {
      _xp -= xpForNextLevel;
      _level++;
      
      // Reward coins for leveling up
      await addCoins(50);
      
      await _storage.savePlayerLevel(_level);
    }
    
    await _storage.savePlayerXP(_xp);
    notifyListeners();
  }

  /// Add coins
  Future<void> addCoins(int amount) async {
    _coins += amount;
    await _storage.saveCoins(_coins);
    notifyListeners();
  }

  /// Spend coins
  Future<bool> spendCoins(int amount) async {
    if (_coins >= amount) {
      _coins -= amount;
      await _storage.saveCoins(_coins);
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Reset player progress (keep name and avatar)
  Future<void> resetProgress() async {
    _level = 1;
    _xp = 0;
    _coins = 500;
    
    await _storage.savePlayerLevel(_level);
    await _storage.savePlayerXP(_xp);
    await _storage.saveCoins(_coins);
    notifyListeners();
  }

  /// Calculate XP reward based on game performance
  int calculateXPReward({
    required bool won,
    required int numbersCalledCount,
    required int durationSeconds,
  }) {
    if (!won) return 5; // Small XP for participation
    
    int xp = 50; // Base XP for winning
    
    // Bonus for efficiency (fewer numbers called)
    if (numbersCalledCount < 30) {
      xp += 30; // Very efficient
    } else if (numbersCalledCount < 40) {
      xp += 20; // Efficient
    } else if (numbersCalledCount < 50) {
      xp += 10; // Moderately efficient
    }
    
    // Bonus for speed (faster wins)
    if (durationSeconds < 60) {
      xp += 30; // Very fast
    } else if (durationSeconds < 120) {
      xp += 20; // Fast
    } else if (durationSeconds < 180) {
      xp += 10; // Moderately fast
    }
    
    return xp;
  }
}
