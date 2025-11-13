import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Sound Service
/// Manages all audio playback in the app
class SoundService extends ChangeNotifier {
  final AudioPlayer _effectsPlayer = AudioPlayer();
  final AudioPlayer _backgroundPlayer = AudioPlayer();
  
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  double _effectsVolume = 0.7;
  double _musicVolume = 0.3;

  bool get soundEnabled => _soundEnabled;
  bool get musicEnabled => _musicEnabled;
  double get effectsVolume => _effectsVolume;
  double get musicVolume => _musicVolume;

  // Aliases for consistency
  bool get isSoundEnabled => _soundEnabled;
  bool get isMusicEnabled => _musicEnabled;

  SoundService() {
    _initializePlayers();
  }

  void _initializePlayers() {
    _effectsPlayer.setVolume(_effectsVolume);
    _backgroundPlayer.setVolume(_musicVolume);
    _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
  }

  // Sound effects
  Future<void> playNumberCall() async {
    if (!_soundEnabled) return;
    // For now, use system sounds or synthesized beeps
    // In production, you'd load actual audio files
    try {
      await _effectsPlayer.play(AssetSource('sounds/number_call.mp3'));
    } catch (e) {
      debugPrint('Sound effect not found: $e');
    }
  }

  Future<void> playCardMark() async {
    if (!_soundEnabled) return;
    try {
      await _effectsPlayer.play(AssetSource('sounds/card_mark.mp3'));
    } catch (e) {
      debugPrint('Sound effect not found: $e');
    }
  }

  Future<void> playWin() async {
    if (!_soundEnabled) return;
    try {
      await _effectsPlayer.play(AssetSource('sounds/win.mp3'));
    } catch (e) {
      debugPrint('Sound effect not found: $e');
    }
  }

  Future<void> playLose() async {
    if (!_soundEnabled) return;
    try {
      await _effectsPlayer.play(AssetSource('sounds/lose.mp3'));
    } catch (e) {
      debugPrint('Sound effect not found: $e');
    }
  }

  Future<void> playButtonClick() async {
    if (!_soundEnabled) return;
    try {
      await _effectsPlayer.play(AssetSource('sounds/button_click.mp3'));
    } catch (e) {
      debugPrint('Sound effect not found: $e');
    }
  }

  Future<void> playThemeUnlock() async {
    if (!_soundEnabled) return;
    try {
      await _effectsPlayer.play(AssetSource('sounds/theme_unlock.mp3'));
    } catch (e) {
      debugPrint('Sound effect not found: $e');
    }
  }

  // Background music
  Future<void> playBackgroundMusic() async {
    if (!_musicEnabled) return;
    try {
      await _backgroundPlayer.play(AssetSource('sounds/background_music.mp3'));
    } catch (e) {
      debugPrint('Background music not found: $e');
    }
  }

  Future<void> stopBackgroundMusic() async {
    await _backgroundPlayer.stop();
  }

  // Settings
  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    notifyListeners();
  }

  void toggleMusic() {
    _musicEnabled = !_musicEnabled;
    if (_musicEnabled) {
      playBackgroundMusic();
    } else {
      stopBackgroundMusic();
    }
    notifyListeners();
  }

  void setEffectsVolume(double volume) {
    _effectsVolume = volume.clamp(0.0, 1.0);
    _effectsPlayer.setVolume(_effectsVolume);
    notifyListeners();
  }

  void setMusicVolume(double volume) {
    _musicVolume = volume.clamp(0.0, 1.0);
    _backgroundPlayer.setVolume(_musicVolume);
    notifyListeners();
  }

  @override
  void dispose() {
    _effectsPlayer.dispose();
    _backgroundPlayer.dispose();
    super.dispose();
  }
}
