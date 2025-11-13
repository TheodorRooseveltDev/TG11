import 'package:flutter/foundation.dart';
import 'bingo_theme.dart';
import '../services/storage_service.dart';

/// Theme Provider
/// Manages theme switching and persistence
class ThemeProvider extends ChangeNotifier {
  final StorageService _storage;
  
  BingoTheme _currentTheme = BingoThemes.modernVibrant;
  List<String> _unlockedThemeIds = [];

  BingoTheme get currentTheme => _currentTheme;
  List<String> get unlockedThemeIds => _unlockedThemeIds;

  ThemeProvider(this._storage) {
    _loadFromStorage();
  }

  /// Load saved theme and unlocked themes from storage
  void _loadFromStorage() {
    try {
      // Load unlocked themes
      _unlockedThemeIds = _storage.getUnlockedThemes();

      // Load current theme
      final savedThemeId = _storage.getSelectedTheme();
      if (savedThemeId != null) {
        final theme = BingoThemes.allThemes.firstWhere(
          (t) => t.id == savedThemeId,
          orElse: () => BingoThemes.modernVibrant,
        );
        _currentTheme = theme;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme preferences: $e');
    }
  }

  /// Set the current theme
  Future<void> setTheme(BingoTheme theme) async {
    if (!isThemeUnlocked(theme)) {
      debugPrint('Theme ${theme.name} is not unlocked');
      return;
    }

    _currentTheme = theme;
    notifyListeners();

    try {
      await _storage.saveSelectedTheme(theme.id);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }

  /// Check if a theme is unlocked
  bool isThemeUnlocked(BingoTheme theme) {
    return theme.isUnlockedByDefault || _unlockedThemeIds.contains(theme.id);
  }

  /// Unlock a theme (coins managed by PlayerService)
  Future<void> unlockTheme(BingoTheme theme) async {
    // Check if already unlocked
    if (isThemeUnlocked(theme)) {
      return;
    }

    // Add to unlocked list
    _unlockedThemeIds.add(theme.id);
    notifyListeners();

    try {
      await _storage.saveUnlockedThemes(_unlockedThemeIds);
    } catch (e) {
      debugPrint('Error unlocking theme: $e');
    }
  }

  /// Get all unlocked themes
  List<BingoTheme> get unlockedThemes {
    return BingoThemes.allThemes.where((theme) => isThemeUnlocked(theme)).toList();
  }

  /// Get all locked themes
  List<BingoTheme> get lockedThemes {
    return BingoThemes.allThemes.where((theme) => !isThemeUnlocked(theme)).toList();
  }
}
