import 'bingo_card.dart';
import 'bingo_number.dart';
import 'player.dart';

/// Game State Enum
enum GameStatus {
  setup, // Game is being set up
  playing, // Game in progress
  paused, // Game is paused
  finished, // Game has finished
}

/// Game Result
enum GameResult {
  playerWon,
  botWon,
  draw, // Rare, but possible
}

/// Game State Model
/// Manages the complete state of a bingo game
class GameState {
  final String id;
  final Player humanPlayer;
  final Player botPlayer;
  final BingoCard playerCard;
  final BingoCard botCard;

  GameStatus status;
  List<BingoNumber> calledNumbers;
  BingoNumber? currentNumber;
  List<BingoNumber> remainingNumbers;

  DateTime? startTime;
  DateTime? endTime;
  GameResult? result;

  // Power-up tracking
  Map<String, int> playerPowerUpUsage;
  bool isBotFrozen;
  DateTime? botFreezeEndTime;
  List<BingoNumber>? peekedNumbers;
  bool doubleCoinsActive;

  GameState({
    required this.id,
    required this.humanPlayer,
    required this.botPlayer,
    required this.playerCard,
    required this.botCard,
    this.status = GameStatus.setup,
    List<BingoNumber>? calledNumbers,
    this.currentNumber,
    List<BingoNumber>? remainingNumbers,
    this.startTime,
    this.endTime,
    this.result,
    Map<String, int>? playerPowerUpUsage,
    this.isBotFrozen = false,
    this.botFreezeEndTime,
    this.peekedNumbers,
    this.doubleCoinsActive = false,
  })  : calledNumbers = calledNumbers ?? [],
        remainingNumbers = remainingNumbers ?? _generateAllNumbers(),
        playerPowerUpUsage = playerPowerUpUsage ?? {};

  /// Generate all 75 bingo numbers
  static List<BingoNumber> _generateAllNumbers() {
    return List.generate(75, (i) => BingoNumber.fromValue(i + 1));
  }

  /// Create a new game
  factory GameState.newGame({
    required Player humanPlayer,
    required Player botPlayer,
    BingoCard? playerCard,
    BingoCard? botCard,
  }) {
    return GameState(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      humanPlayer: humanPlayer,
      botPlayer: botPlayer,
      playerCard: playerCard ?? BingoCard.generate(),
      botCard: botCard ?? BingoCard.generate(),
      status: GameStatus.setup,
    );
  }

  /// Start the game
  void start() {
    status = GameStatus.playing;
    startTime = DateTime.now();
  }

  /// Pause the game
  void pause() {
    if (status == GameStatus.playing) {
      status = GameStatus.paused;
    }
  }

  /// Resume the game
  void resume() {
    if (status == GameStatus.paused) {
      status = GameStatus.playing;
    }
  }

  /// Call the next number
  BingoNumber? callNextNumber() {
    if (remainingNumbers.isEmpty) return null;

    // Shuffle and take the first number for randomness
    remainingNumbers.shuffle();
    final number = remainingNumbers.removeAt(0);

    calledNumbers.add(number);
    currentNumber = number;

    return number;
  }

  /// Mark number on player's card
  void markPlayerNumber(BingoNumber number) {
    playerCard.markNumber(number);
    checkWinConditions();
  }

  /// Mark number on bot's card (automated)
  void markBotNumber(BingoNumber number) {
    if (!isBotFrozen) {
      botCard.markNumber(number);
      checkWinConditions();
    }
  }

  /// Check if anyone has won
  void checkWinConditions() {
    final playerWon = playerCard.hasWinningPattern();
    final botWon = botCard.hasWinningPattern();

    if (playerWon && botWon) {
      finishGame(GameResult.draw);
    } else if (playerWon) {
      finishGame(GameResult.playerWon);
    } else if (botWon) {
      finishGame(GameResult.botWon);
    }
  }

  /// Finish the game
  void finishGame(GameResult gameResult) {
    status = GameStatus.finished;
    result = gameResult;
    endTime = DateTime.now();
  }

  /// Get game duration in seconds
  int? get durationInSeconds {
    if (startTime == null) return null;
    final end = endTime ?? DateTime.now();
    return end.difference(startTime!).inSeconds;
  }

  /// Calculate coins earned
  int calculateCoinsEarned() {
    if (result == null) return 0;

    int baseCoins = 0;

    switch (result!) {
      case GameResult.playerWon:
        // Win amount based on bot difficulty
        baseCoins = (50 * botPlayer.coinMultiplier).round();
        break;
      case GameResult.botWon:
        // Participation reward
        baseCoins = 10;
        break;
      case GameResult.draw:
        // Half of win amount
        baseCoins = (25 * botPlayer.coinMultiplier).round();
        break;
    }

    // Apply double coins power-up
    if (doubleCoinsActive) {
      baseCoins *= 2;
    }

    return baseCoins;
  }

  /// Use a power-up
  void usePowerUp(String powerUpId) {
    playerPowerUpUsage[powerUpId] = (playerPowerUpUsage[powerUpId] ?? 0) + 1;
  }

  /// Freeze the bot
  void freezeBot(int durationSeconds) {
    isBotFrozen = true;
    botFreezeEndTime = DateTime.now().add(Duration(seconds: durationSeconds));
  }

  /// Check if bot freeze has expired
  void updateBotFreeze() {
    if (isBotFrozen && botFreezeEndTime != null) {
      if (DateTime.now().isAfter(botFreezeEndTime!)) {
        isBotFrozen = false;
        botFreezeEndTime = null;
      }
    }
  }

  /// Peek at next numbers
  void peekNextNumbers(int count) {
    if (remainingNumbers.length >= count) {
      // Create a shuffled copy to peek at
      final tempList = List<BingoNumber>.from(remainingNumbers);
      tempList.shuffle();
      peekedNumbers = tempList.take(count).toList();
    }
  }

  /// Activate double coins
  void activateDoubleCoins() {
    doubleCoinsActive = true;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'humanPlayer': humanPlayer.toJson(),
        'botPlayer': botPlayer.toJson(),
        'playerCard': playerCard.toJson(),
        'botCard': botCard.toJson(),
        'status': status.name,
        'calledNumbers': calledNumbers.map((n) => n.toJson()).toList(),
        'currentNumber': currentNumber?.toJson(),
        'remainingNumbers': remainingNumbers.map((n) => n.toJson()).toList(),
        'startTime': startTime?.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'result': result?.name,
        'playerPowerUpUsage': playerPowerUpUsage,
        'isBotFrozen': isBotFrozen,
        'botFreezeEndTime': botFreezeEndTime?.toIso8601String(),
        'peekedNumbers': peekedNumbers?.map((n) => n.toJson()).toList(),
        'doubleCoinsActive': doubleCoinsActive,
      };

  /// Create from JSON
  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      id: json['id'] as String,
      humanPlayer: Player.fromJson(json['humanPlayer'] as Map<String, dynamic>),
      botPlayer: Player.fromJson(json['botPlayer'] as Map<String, dynamic>),
      playerCard: BingoCard.fromJson(json['playerCard'] as Map<String, dynamic>),
      botCard: BingoCard.fromJson(json['botCard'] as Map<String, dynamic>),
      status: GameStatus.values.firstWhere((e) => e.name == json['status']),
      calledNumbers: (json['calledNumbers'] as List)
          .map((n) => BingoNumber.fromJson(n as Map<String, dynamic>))
          .toList(),
      currentNumber: json['currentNumber'] != null
          ? BingoNumber.fromJson(json['currentNumber'] as Map<String, dynamic>)
          : null,
      remainingNumbers: (json['remainingNumbers'] as List)
          .map((n) => BingoNumber.fromJson(n as Map<String, dynamic>))
          .toList(),
      startTime:
          json['startTime'] != null ? DateTime.parse(json['startTime'] as String) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
      result: json['result'] != null
          ? GameResult.values.firstWhere((e) => e.name == json['result'])
          : null,
      playerPowerUpUsage: Map<String, int>.from(json['playerPowerUpUsage'] as Map? ?? {}),
      isBotFrozen: json['isBotFrozen'] as bool? ?? false,
      botFreezeEndTime: json['botFreezeEndTime'] != null
          ? DateTime.parse(json['botFreezeEndTime'] as String)
          : null,
      peekedNumbers: json['peekedNumbers'] != null
          ? (json['peekedNumbers'] as List)
              .map((n) => BingoNumber.fromJson(n as Map<String, dynamic>))
              .toList()
          : null,
      doubleCoinsActive: json['doubleCoinsActive'] as bool? ?? false,
    );
  }
}
