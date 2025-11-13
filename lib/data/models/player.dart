import 'power_up.dart';

/// Bot Difficulty Levels
enum BotDifficulty {
  easy,
  medium,
  hard,
  expert,
}

/// Player Model
class Player {
  final String id;
  final String name;
  final bool isBot;
  final BotDifficulty? botDifficulty;
  final String avatarUrl;
  int score;

  Player({
    required this.id,
    required this.name,
    this.isBot = false,
    this.botDifficulty,
    this.avatarUrl = '',
    this.score = 0,
  });

  /// Create a bot player
  factory Player.bot(BotDifficulty difficulty) {
    final names = {
      BotDifficulty.easy: 'Rookie Bot',
      BotDifficulty.medium: 'Pro Bot',
      BotDifficulty.hard: 'Expert Bot',
      BotDifficulty.expert: 'Master Bot',
    };

    return Player(
      id: 'bot_${difficulty.name}',
      name: names[difficulty]!,
      isBot: true,
      botDifficulty: difficulty,
      avatarUrl: 'assets/images/bot_${difficulty.name}.png',
    );
  }

  /// Create a human player
  factory Player.human({
    String? id,
    required String name,
    String avatarUrl = '',
  }) {
    return Player(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      isBot: false,
      avatarUrl: avatarUrl,
    );
  }

  /// Get the bot's marking speed (0.0 to 1.0)
  double get botMarkingSpeed {
    if (!isBot || botDifficulty == null) return 1.0;

    switch (botDifficulty!) {
      case BotDifficulty.easy:
        return 0.6; // 60% speed
      case BotDifficulty.medium:
        return 0.8; // 80% speed
      case BotDifficulty.hard:
        return 0.95; // 95% speed
      case BotDifficulty.expert:
        return 1.0; // 100% speed
    }
  }

  /// Get the bot's delay range in milliseconds
  ({int min, int max}) get botDelayRange {
    if (!isBot || botDifficulty == null) {
      return (min: 0, max: 0);
    }

    switch (botDifficulty!) {
      case BotDifficulty.easy:
        return (min: 2000, max: 4000); // 2-4 seconds
      case BotDifficulty.medium:
        return (min: 1000, max: 2000); // 1-2 seconds
      case BotDifficulty.hard:
        return (min: 500, max: 1000); // 0.5-1 second
      case BotDifficulty.expert:
        return (min: 0, max: 100); // Instant to 0.1 seconds
    }
  }

  /// Get coin multiplier for this difficulty
  double get coinMultiplier {
    if (!isBot || botDifficulty == null) return 1.0;

    switch (botDifficulty!) {
      case BotDifficulty.easy:
        return 1.0;
      case BotDifficulty.medium:
        return 1.5;
      case BotDifficulty.hard:
        return 2.0;
      case BotDifficulty.expert:
        return 3.0;
    }
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'isBot': isBot,
        'botDifficulty': botDifficulty?.name,
        'avatarUrl': avatarUrl,
        'score': score,
      };

  /// Create from JSON
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as String,
      name: json['name'] as String,
      isBot: json['isBot'] as bool? ?? false,
      botDifficulty: json['botDifficulty'] != null
          ? BotDifficulty.values.firstWhere(
              (e) => e.name == json['botDifficulty'],
            )
          : null,
      avatarUrl: json['avatarUrl'] as String? ?? '',
      score: json['score'] as int? ?? 0,
    );
  }
}

/// User Profile Model (for the human player)
class UserProfile {
  final String id;
  String username;
  String avatarUrl;
  int totalCoins;
  int totalGamesPlayed;
  int totalWins;
  int totalLosses;
  int currentWinStreak;
  int bestWinStreak;
  DateTime createdAt;
  DateTime lastPlayedAt;
  Map<PowerUpType, int> powerUpInventory;
  List<String> unlockedThemes;
  List<String> unlockedCountries;
  String currentThemeId;

  UserProfile({
    required this.id,
    required this.username,
    this.avatarUrl = '',
    this.totalCoins = 0,
    this.totalGamesPlayed = 0,
    this.totalWins = 0,
    this.totalLosses = 0,
    this.currentWinStreak = 0,
    this.bestWinStreak = 0,
    required this.createdAt,
    required this.lastPlayedAt,
    Map<PowerUpType, int>? powerUpInventory,
    List<String>? unlockedThemes,
    List<String>? unlockedCountries,
    this.currentThemeId = 'modern_vibrant',
  })  : powerUpInventory = powerUpInventory ?? {},
        unlockedThemes = unlockedThemes ?? ['modern_vibrant', 'minimalist'],
        unlockedCountries = unlockedCountries ?? ['united_states'];

  /// Create a new user profile
  factory UserProfile.create({
    String? id,
    required String username,
  }) {
    final now = DateTime.now();
    return UserProfile(
      id: id ?? now.millisecondsSinceEpoch.toString(),
      username: username,
      createdAt: now,
      lastPlayedAt: now,
    );
  }

  /// Win rate percentage
  double get winRate {
    if (totalGamesPlayed == 0) return 0.0;
    return (totalWins / totalGamesPlayed) * 100;
  }

  /// Add coins
  void addCoins(int amount) {
    totalCoins += amount;
  }

  /// Spend coins
  bool spendCoins(int amount) {
    if (totalCoins >= amount) {
      totalCoins -= amount;
      return true;
    }
    return false;
  }

  /// Record a win
  void recordWin() {
    totalGamesPlayed++;
    totalWins++;
    currentWinStreak++;
    if (currentWinStreak > bestWinStreak) {
      bestWinStreak = currentWinStreak;
    }
    lastPlayedAt = DateTime.now();
  }

  /// Record a loss
  void recordLoss() {
    totalGamesPlayed++;
    totalLosses++;
    currentWinStreak = 0;
    lastPlayedAt = DateTime.now();
  }

  /// Get power-up quantity
  int getPowerUpQuantity(PowerUpType type) {
    return powerUpInventory[type] ?? 0;
  }

  /// Add power-up to inventory
  void addPowerUp(PowerUpType type, int quantity) {
    powerUpInventory[type] = (powerUpInventory[type] ?? 0) + quantity;
  }

  /// Use a power-up
  bool usePowerUp(PowerUpType type) {
    final quantity = powerUpInventory[type] ?? 0;
    if (quantity > 0) {
      powerUpInventory[type] = quantity - 1;
      return true;
    }
    return false;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'avatarUrl': avatarUrl,
        'totalCoins': totalCoins,
        'totalGamesPlayed': totalGamesPlayed,
        'totalWins': totalWins,
        'totalLosses': totalLosses,
        'currentWinStreak': currentWinStreak,
        'bestWinStreak': bestWinStreak,
        'createdAt': createdAt.toIso8601String(),
        'lastPlayedAt': lastPlayedAt.toIso8601String(),
        'powerUpInventory': powerUpInventory.map((key, value) => MapEntry(key.name, value)),
        'unlockedThemes': unlockedThemes,
        'unlockedCountries': unlockedCountries,
        'currentThemeId': currentThemeId,
      };

  /// Create from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String? ?? '',
      totalCoins: json['totalCoins'] as int? ?? 0,
      totalGamesPlayed: json['totalGamesPlayed'] as int? ?? 0,
      totalWins: json['totalWins'] as int? ?? 0,
      totalLosses: json['totalLosses'] as int? ?? 0,
      currentWinStreak: json['currentWinStreak'] as int? ?? 0,
      bestWinStreak: json['bestWinStreak'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastPlayedAt: DateTime.parse(json['lastPlayedAt'] as String),
      powerUpInventory: (json['powerUpInventory'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              PowerUpType.values.firstWhere((e) => e.name == key),
              value as int,
            ),
          ) ??
          {},
      unlockedThemes: (json['unlockedThemes'] as List?)?.cast<String>() ?? [],
      unlockedCountries: (json['unlockedCountries'] as List?)?.cast<String>() ?? [],
      currentThemeId: json['currentThemeId'] as String? ?? 'modern_vibrant',
    );
  }
}
