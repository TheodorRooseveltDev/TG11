import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../data/models/game_state.dart';
import '../data/models/bingo_number.dart';
import '../data/models/player.dart';
import '../core/models/achievement.dart';
import '../core/services/sound_service.dart';
import '../core/services/stats_service.dart';
import '../core/services/achievement_service.dart';
import '../core/services/daily_challenge_service.dart';
import '../core/services/player_service.dart';

/// Game Controller
/// Manages the game flow, number calling, and bot AI
class GameController extends ChangeNotifier {
  GameState? _gameState;
  Timer? _numberCallTimer;
  Timer? _botActionTimer;
  DateTime? _gameStartTime;
  List<Achievement> _unlockedAchievements = [];
  int _xpEarned = 0;
  bool _leveledUp = false;
  int _newLevel = 0;

  final SoundService? _soundService;
  final StatsService? _statsService;
  final AchievementService? _achievementService;
  final DailyChallengeService? _dailyChallengeService;
  final PlayerService? _playerService;

  GameState? get gameState => _gameState;
  List<Achievement> get unlockedAchievements => _unlockedAchievements;
  int get xpEarned => _xpEarned;
  bool get leveledUp => _leveledUp;
  int get newLevel => _newLevel;
  bool get isGameActive => _gameState != null && _gameState!.status == GameStatus.playing;

  final Random _random = Random();

  GameController({
    SoundService? soundService,
    StatsService? statsService,
    AchievementService? achievementService,
    DailyChallengeService? dailyChallengeService,
    PlayerService? playerService,
  })  : _soundService = soundService,
        _statsService = statsService,
        _achievementService = achievementService,
        _dailyChallengeService = dailyChallengeService,
        _playerService = playerService;

  /// Start a new game
  void startNewGame({
    required Player humanPlayer,
    required Player botPlayer,
    bool doubleCoins = false,
  }) {
    // Cancel any existing timers
    _cancelTimers();

    // Reset XP tracking
    _xpEarned = 0;
    _leveledUp = false;
    _newLevel = 0;

    // Create new game state
    _gameState = GameState.newGame(
      humanPlayer: humanPlayer,
      botPlayer: botPlayer,
    );

    if (doubleCoins) {
      _gameState!.activateDoubleCoins();
    }

    _gameState!.start();
    _gameStartTime = DateTime.now();
    notifyListeners();

    // Start calling numbers
    _startNumberCalling();
  }

  /// Start calling numbers automatically
  void _startNumberCalling() {
    // Call number every 3-5 seconds
    _numberCallTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_gameState != null && _gameState!.status == GameStatus.playing) {
        callNextNumber();
      } else {
        timer.cancel();
      }
    });
  }

  /// Call the next number
  void callNextNumber() {
    if (_gameState == null || _gameState!.status != GameStatus.playing) return;

    final number = _gameState!.callNextNumber();
    if (number != null) {
      // Play sound effect
      _soundService?.playNumberCall();
      
      notifyListeners();

      // Schedule bot to mark the number
      _scheduleBotAction(number);
    } else {
      // No more numbers to call
      endGame();
    }
  }

  /// Player marks a number on their card
  void markPlayerNumber(int col, int row) {
    if (_gameState == null || _gameState!.status != GameStatus.playing) return;

    final cell = _gameState!.playerCard.getCellAt(col, row);

    // Check if this number has been called
    final hasBeenCalled = _gameState!.calledNumbers.contains(cell.number);

    if (hasBeenCalled && !cell.isMarked) {
      _gameState!.markPlayerNumber(cell.number);
      
      // Play sound effect
      _soundService?.playCardMark();
      
      notifyListeners();

      // Check if player won
      if (_gameState!.result != null) {
        _onGameEnd();
      }
    }
  }

  /// Schedule bot to mark a number with appropriate delay
  void _scheduleBotAction(BingoNumber number) {
    if (_gameState == null) return;

    // Check if bot freeze is active
    _gameState!.updateBotFreeze();
    if (_gameState!.isBotFrozen) {
      return; // Bot is frozen, skip marking
    }

    final bot = _gameState!.botPlayer;
    if (!bot.isBot) return;

    // Determine if bot will mark this number (based on difficulty/speed)
    final willMark = _random.nextDouble() < bot.botMarkingSpeed;
    if (!willMark) return;

    // Get delay range for this bot
    final delayRange = bot.botDelayRange;
    final delayMs = delayRange.min + _random.nextInt(delayRange.max - delayRange.min);

    // Schedule the bot action
    _botActionTimer?.cancel();
    _botActionTimer = Timer(Duration(milliseconds: delayMs), () {
      if (_gameState != null && _gameState!.status == GameStatus.playing) {
        _gameState!.markBotNumber(number);
        notifyListeners();

        // Check if bot won
        if (_gameState!.result != null) {
          _onGameEnd();
        }
      }
    });
  }

  /// Pause the game
  void pauseGame() {
    if (_gameState == null) return;
    _gameState!.pause();
    _numberCallTimer?.cancel();
    _botActionTimer?.cancel();
    notifyListeners();
  }

  /// Resume the game
  void resumeGame() {
    if (_gameState == null) return;
    _gameState!.resume();
    _startNumberCalling();
    notifyListeners();
  }

  /// End the game
  void endGame() {
    _cancelTimers();

    if (_gameState != null && _gameState!.result == null) {
      // Game ended without a winner (ran out of numbers)
      // Determine winner by most marked cells
      final playerMarked = _gameState!.playerCard.markedCount;
      final botMarked = _gameState!.botCard.markedCount;

      if (playerMarked > botMarked) {
        _gameState!.finishGame(GameResult.playerWon);
      } else if (botMarked > playerMarked) {
        _gameState!.finishGame(GameResult.botWon);
      } else {
        _gameState!.finishGame(GameResult.draw);
      }

      notifyListeners();
    }

    _onGameEnd();
  }

  /// Handle game end
  void _onGameEnd() async {
    _cancelTimers();
    
    if (_gameState == null || _gameStartTime == null) return;
    
    final result = _gameState!.result;
    if (result == null) return;
    
    // Calculate game duration
    final duration = DateTime.now().difference(_gameStartTime!);
    final durationSeconds = duration.inSeconds;
    
    // Determine if player won
    final playerWon = result == GameResult.playerWon;
    
    // Play sound effect
    if (playerWon) {
      _soundService?.playWin();
    } else {
      _soundService?.playLose();
    }
    
    // Record stats
    final botDifficulty = _gameState!.botPlayer.botDifficulty ?? BotDifficulty.easy;
    final coinsEarned = playerWon ? _gameState!.calculateCoinsEarned() : 0;
    
    _statsService?.recordGame(
      won: playerWon,
      difficulty: botDifficulty,
      coinsEarned: coinsEarned,
      numbersCalledCount: _gameState!.calledNumbers.length,
      durationSeconds: durationSeconds,
    );

    // Check achievements
    _unlockedAchievements = [];
    if (_achievementService != null) {
      _unlockedAchievements = await _achievementService.checkGameAchievements(_gameState!);
    }
    
    // Award XP
    if (_playerService != null) {
      final oldLevel = _playerService.level;
      
      _xpEarned = _playerService.calculateXPReward(
        won: playerWon,
        numbersCalledCount: _gameState!.calledNumbers.length,
        durationSeconds: durationSeconds,
      );
      
      await _playerService.addXP(_xpEarned);
      
      // Check if player leveled up
      _leveledUp = _playerService.level > oldLevel;
      _newLevel = _playerService.level;
    }
    
    // Record daily challenge win
    if (playerWon && _dailyChallengeService != null) {
      final justCompleted = await _dailyChallengeService.recordWin();
      if (justCompleted) {
        // Daily challenge just completed - will be handled by UI
      }
    }
    
    notifyListeners();
  }

  /// Clear unlocked achievements (call after showing notifications)
  void clearUnlockedAchievements() {
    _unlockedAchievements = [];
  }

  /// Use Bonus Ball power-up
  void useBonusBall() {
    if (_gameState == null || _gameState!.status != GameStatus.playing) return;

    final unmarkedCells = <({int col, int row})>[];

    // Find all unmarked cells that have been called
    for (int col = 0; col < 5; col++) {
      for (int row = 0; row < 5; row++) {
        final cell = _gameState!.playerCard.getCellAt(col, row);
        if (!cell.isMarked &&
            !cell.isFreeSpace &&
            _gameState!.calledNumbers.contains(cell.number)) {
          unmarkedCells.add((col: col, row: row));
        }
      }
    }

    if (unmarkedCells.isNotEmpty) {
      // Pick a random unmarked cell and mark it
      final randomCell = unmarkedCells[_random.nextInt(unmarkedCells.length)];
      _gameState!.markPlayerNumber(
        _gameState!.playerCard.getCellAt(randomCell.col, randomCell.row).number,
      );
      _gameState!.usePowerUp('bonus_ball');
      notifyListeners();

      // Check if player won
      if (_gameState!.result != null) {
        _onGameEnd();
      }
    }
  }

  /// Use Freeze power-up
  void useFreeze() {
    if (_gameState == null || _gameState!.status != GameStatus.playing) return;

    _gameState!.freezeBot(10); // Freeze for 10 seconds
    _gameState!.usePowerUp('freeze');
    notifyListeners();
  }

  /// Use Peek power-up
  void usePeek() {
    if (_gameState == null || _gameState!.status != GameStatus.playing) return;

    _gameState!.peekNextNumbers(3); // Peek at next 3 numbers
    _gameState!.usePowerUp('peek');
    notifyListeners();
  }

  /// Cancel all timers
  void _cancelTimers() {
    _numberCallTimer?.cancel();
    _numberCallTimer = null;
    _botActionTimer?.cancel();
    _botActionTimer = null;
  }

  /// Clear game state
  void clearGame() {
    _cancelTimers();
    _gameState = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _cancelTimers();
    super.dispose();
  }
}
