import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Storage Service
/// Centralized local data persistence using SharedPreferences
class StorageService {
  static const String _keyPlayerName = 'player_name';
  static const String _keyPlayerAvatar = 'player_avatar';
  static const String _keyPlayerLevel = 'player_level';
  static const String _keyPlayerXP = 'player_xp';
  static const String _keyCoins = 'coins';
  static const String _keyUnlockedThemes = 'unlocked_themes';
  static const String _keyHasCompletedOnboarding = 'has_completed_onboarding';
  static const String _keySelectedTheme = 'selected_theme';
  static const String _keySoundEnabled = 'sound_enabled';
  static const String _keyMusicEnabled = 'music_enabled';
  static const String _keyEffectsVolume = 'effects_volume';
  static const String _keyMusicVolume = 'music_volume';
  
  // Achievement tracking
  static const String _keyUnlockedAchievements = 'unlocked_achievements';
  static const String _keyConsecutiveWins = 'consecutive_wins';
  static const String _keyCompletedPatterns = 'completed_patterns';
  static const String _keyTotalGames = 'total_games';
  static const String _keyTotalWins = 'total_wins';

  late SharedPreferences _prefs;
  bool _isInitialized = false;

  /// Initialize the storage service
  Future<void> initialize() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  void _checkInitialized() {
    if (!_isInitialized) {
      throw Exception('StorageService not initialized. Call initialize() first.');
    }
  }

  // Player Data
  Future<void> savePlayerName(String name) async {
    _checkInitialized();
    await _prefs.setString(_keyPlayerName, name);
  }

  String? getPlayerName() {
    _checkInitialized();
    return _prefs.getString(_keyPlayerName);
  }

  Future<void> savePlayerAvatar(String avatarId) async {
    _checkInitialized();
    await _prefs.setString(_keyPlayerAvatar, avatarId);
  }

  String? getPlayerAvatar() {
    _checkInitialized();
    return _prefs.getString(_keyPlayerAvatar);
  }

  Future<void> savePlayerLevel(int level) async {
    _checkInitialized();
    await _prefs.setInt(_keyPlayerLevel, level);
  }

  int getPlayerLevel() {
    _checkInitialized();
    return _prefs.getInt(_keyPlayerLevel) ?? 1;
  }

  Future<void> savePlayerXP(int xp) async {
    _checkInitialized();
    await _prefs.setInt(_keyPlayerXP, xp);
  }

  int getPlayerXP() {
    _checkInitialized();
    return _prefs.getInt(_keyPlayerXP) ?? 0;
  }

  // Coins
  Future<void> saveCoins(int coins) async {
    _checkInitialized();
    await _prefs.setInt(_keyCoins, coins);
  }

  int getCoins() {
    _checkInitialized();
    return _prefs.getInt(_keyCoins) ?? 500; // Starting coins
  }

  // Unlocked Themes
  Future<void> saveUnlockedThemes(List<String> themeIds) async {
    _checkInitialized();
    await _prefs.setString(_keyUnlockedThemes, jsonEncode(themeIds));
  }

  List<String> getUnlockedThemes() {
    _checkInitialized();
    final String? data = _prefs.getString(_keyUnlockedThemes);
    if (data == null) {
      return ['modern_vibrant']; // Default unlocked theme
    }
    return List<String>.from(jsonDecode(data));
  }

  // Selected Theme
  Future<void> saveSelectedTheme(String themeId) async {
    _checkInitialized();
    await _prefs.setString(_keySelectedTheme, themeId);
  }

  String? getSelectedTheme() {
    _checkInitialized();
    return _prefs.getString(_keySelectedTheme);
  }

  // Onboarding
  Future<void> setOnboardingCompleted(bool completed) async {
    _checkInitialized();
    await _prefs.setBool(_keyHasCompletedOnboarding, completed);
  }

  bool hasCompletedOnboarding() {
    _checkInitialized();
    return _prefs.getBool(_keyHasCompletedOnboarding) ?? false;
  }

  // Sound Settings
  Future<void> saveSoundEnabled(bool enabled) async {
    _checkInitialized();
    await _prefs.setBool(_keySoundEnabled, enabled);
  }

  bool isSoundEnabled() {
    _checkInitialized();
    return _prefs.getBool(_keySoundEnabled) ?? true;
  }

  Future<void> saveMusicEnabled(bool enabled) async {
    _checkInitialized();
    await _prefs.setBool(_keyMusicEnabled, enabled);
  }

  bool isMusicEnabled() {
    _checkInitialized();
    return _prefs.getBool(_keyMusicEnabled) ?? true;
  }

  Future<void> saveEffectsVolume(double volume) async {
    _checkInitialized();
    await _prefs.setDouble(_keyEffectsVolume, volume);
  }

  double getEffectsVolume() {
    _checkInitialized();
    return _prefs.getDouble(_keyEffectsVolume) ?? 0.7;
  }

  Future<void> saveMusicVolume(double volume) async {
    _checkInitialized();
    await _prefs.setDouble(_keyMusicVolume, volume);
  }

  double getMusicVolume() {
    _checkInitialized();
    return _prefs.getDouble(_keyMusicVolume) ?? 0.3;
  }

  // Achievement tracking
  Future<void> saveUnlockedAchievements(List<Map<String, dynamic>> achievements) async {
    _checkInitialized();
    await _prefs.setString(_keyUnlockedAchievements, jsonEncode(achievements));
  }

  List<Map<String, dynamic>> getUnlockedAchievements() {
    _checkInitialized();
    final String? data = _prefs.getString(_keyUnlockedAchievements);
    if (data == null) return [];
    final List<dynamic> decoded = jsonDecode(data);
    return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<void> saveConsecutiveWins(int wins) async {
    _checkInitialized();
    await _prefs.setInt(_keyConsecutiveWins, wins);
  }

  int getConsecutiveWins() {
    _checkInitialized();
    return _prefs.getInt(_keyConsecutiveWins) ?? 0;
  }

  Future<void> saveCompletedPatterns(Set<String> patterns) async {
    _checkInitialized();
    await _prefs.setString(_keyCompletedPatterns, jsonEncode(patterns.toList()));
  }

  Set<String> getCompletedPatterns() {
    _checkInitialized();
    final String? data = _prefs.getString(_keyCompletedPatterns);
    if (data == null) return {};
    return Set<String>.from(jsonDecode(data));
  }

  Future<void> saveTotalGames(int games) async {
    _checkInitialized();
    await _prefs.setInt(_keyTotalGames, games);
  }

  int getTotalGames() {
    _checkInitialized();
    return _prefs.getInt(_keyTotalGames) ?? 0;
  }

  Future<void> saveTotalWins(int wins) async {
    _checkInitialized();
    await _prefs.setInt(_keyTotalWins, wins);
  }

  int getTotalWins() {
    _checkInitialized();
    return _prefs.getInt(_keyTotalWins) ?? 0;
  }

  // Clear all data
  Future<void> clearAll() async {
    _checkInitialized();
    await _prefs.clear();
  }

  // Reset to defaults (keep onboarding completed)
  Future<void> resetToDefaults() async {
    _checkInitialized();
    final hasOnboarded = hasCompletedOnboarding();
    final playerName = getPlayerName();
    final playerAvatar = getPlayerAvatar();
    
    await _prefs.clear();
    
    // Restore essential data
    if (hasOnboarded && playerName != null) {
      await setOnboardingCompleted(true);
      await savePlayerName(playerName);
      if (playerAvatar != null) {
        await savePlayerAvatar(playerAvatar);
      }
    }
    
    // Reset to defaults
    await saveCoins(500);
    await savePlayerLevel(1);
    await savePlayerXP(0);
    await saveUnlockedThemes(['modern_vibrant']);
    await saveSelectedTheme('modern_vibrant');
  }
}
