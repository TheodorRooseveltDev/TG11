/// Achievement Category
enum AchievementCategory {
  gameplay,
  collection,
  economy,
  worldTravel,
  pattern,
  powerUp,
  daily,
}

/// Achievement Rarity
enum AchievementRarity {
  common,
  rare,
  epic,
  legendary,
}

/// Achievement Model
class Achievement {
  final String id;
  final String name;
  final String description;
  final AchievementCategory category;
  final AchievementRarity rarity;
  final String emoji;
  final int coinReward;
  final int targetValue;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.rarity,
    required this.emoji,
    required this.coinReward,
    required this.targetValue,
  });

  /// All available achievements
  static const List<Achievement> allAchievements = [
    // Gameplay Achievements
    Achievement(
      id: 'first_win',
      name: 'First Win',
      description: 'Win your first game',
      category: AchievementCategory.gameplay,
      rarity: AchievementRarity.common,
      emoji: '🎉',
      coinReward: 10,
      targetValue: 1,
    ),
    Achievement(
      id: 'winning_streak',
      name: 'Winning Streak',
      description: 'Win 5 games in a row',
      category: AchievementCategory.gameplay,
      rarity: AchievementRarity.rare,
      emoji: '🔥',
      coinReward: 100,
      targetValue: 5,
    ),
    Achievement(
      id: 'perfect_game',
      name: 'Perfect Game',
      description: 'Win before 30 numbers called',
      category: AchievementCategory.gameplay,
      rarity: AchievementRarity.epic,
      emoji: '⭐',
      coinReward: 250,
      targetValue: 1,
    ),
    Achievement(
      id: 'marathon_player',
      name: 'Marathon Player',
      description: 'Play 100 games',
      category: AchievementCategory.gameplay,
      rarity: AchievementRarity.epic,
      emoji: '🏃',
      coinReward: 500,
      targetValue: 100,
    ),
    Achievement(
      id: 'bingo_master',
      name: 'Bingo Master',
      description: 'Win 50 games',
      category: AchievementCategory.gameplay,
      rarity: AchievementRarity.epic,
      emoji: '👑',
      coinReward: 300,
      targetValue: 50,
    ),
    Achievement(
      id: 'speed_demon',
      name: 'Speed Demon',
      description: 'Win in under 5 minutes',
      category: AchievementCategory.gameplay,
      rarity: AchievementRarity.rare,
      emoji: '⚡',
      coinReward: 200,
      targetValue: 1,
    ),
    Achievement(
      id: 'david_vs_goliath',
      name: 'David vs Goliath',
      description: 'Beat Expert bot',
      category: AchievementCategory.gameplay,
      rarity: AchievementRarity.legendary,
      emoji: '🏆',
      coinReward: 500,
      targetValue: 1,
    ),
    Achievement(
      id: 'no_help_needed',
      name: 'No Help Needed',
      description: 'Win without using power-ups',
      category: AchievementCategory.gameplay,
      rarity: AchievementRarity.rare,
      emoji: '💪',
      coinReward: 200,
      targetValue: 1,
    ),

    // Collection Achievements
    Achievement(
      id: 'style_icon',
      name: 'Style Icon',
      description: 'Unlock 5 themes',
      category: AchievementCategory.collection,
      rarity: AchievementRarity.rare,
      emoji: '🎨',
      coinReward: 150,
      targetValue: 5,
    ),
    Achievement(
      id: 'fashionista',
      name: 'Fashionista',
      description: 'Unlock all themes',
      category: AchievementCategory.collection,
      rarity: AchievementRarity.legendary,
      emoji: '✨',
      coinReward: 1000,
      targetValue: 7,
    ),
    Achievement(
      id: 'collector',
      name: 'Collector',
      description: 'Own 10 of each power-up',
      category: AchievementCategory.collection,
      rarity: AchievementRarity.epic,
      emoji: '📦',
      coinReward: 400,
      targetValue: 10,
    ),

    // Economy Achievements
    Achievement(
      id: 'penny_pincher',
      name: 'Penny Pincher',
      description: 'Accumulate 5,000 coins',
      category: AchievementCategory.economy,
      rarity: AchievementRarity.rare,
      emoji: '💰',
      coinReward: 250,
      targetValue: 5000,
    ),
    Achievement(
      id: 'high_roller',
      name: 'High Roller',
      description: 'Accumulate 25,000 coins',
      category: AchievementCategory.economy,
      rarity: AchievementRarity.epic,
      emoji: '💎',
      coinReward: 1000,
      targetValue: 25000,
    ),
    Achievement(
      id: 'coin_tycoon',
      name: 'Coin Tycoon',
      description: 'Earn 100,000 total coins',
      category: AchievementCategory.economy,
      rarity: AchievementRarity.legendary,
      emoji: '🤑',
      coinReward: 5000,
      targetValue: 100000,
    ),

    // Pattern Achievements
    Achievement(
      id: 'line_master',
      name: 'Line Master',
      description: 'Win with each line type',
      category: AchievementCategory.pattern,
      rarity: AchievementRarity.rare,
      emoji: '📏',
      coinReward: 200,
      targetValue: 3,
    ),
    Achievement(
      id: 'corner_expert',
      name: 'Corner Expert',
      description: 'Win with four corners 10 times',
      category: AchievementCategory.pattern,
      rarity: AchievementRarity.epic,
      emoji: '🔲',
      coinReward: 300,
      targetValue: 10,
    ),
    Achievement(
      id: 'full_house',
      name: 'Full House',
      description: 'Complete a full card',
      category: AchievementCategory.pattern,
      rarity: AchievementRarity.epic,
      emoji: '🏠',
      coinReward: 500,
      targetValue: 1,
    ),

    // Power-Up Achievements
    Achievement(
      id: 'power_player',
      name: 'Power Player',
      description: 'Use 100 power-ups total',
      category: AchievementCategory.powerUp,
      rarity: AchievementRarity.rare,
      emoji: '⚡',
      coinReward: 200,
      targetValue: 100,
    ),

    // Daily Achievements
    Achievement(
      id: 'daily_devotee',
      name: 'Daily Devotee',
      description: 'Log in 7 days straight',
      category: AchievementCategory.daily,
      rarity: AchievementRarity.epic,
      emoji: '📅',
      coinReward: 500,
      targetValue: 7,
    ),
  ];

  /// Get achievement by ID
  static Achievement? getById(String id) {
    try {
      return allAchievements.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get achievements by category
  static List<Achievement> getByCategory(AchievementCategory category) {
    return allAchievements.where((a) => a.category == category).toList();
  }

  /// Get achievements by rarity
  static List<Achievement> getByRarity(AchievementRarity rarity) {
    return allAchievements.where((a) => a.rarity == rarity).toList();
  }
}

/// Achievement Progress Tracker
class AchievementProgress {
  final String achievementId;
  int currentValue;
  bool isUnlocked;
  DateTime? unlockedAt;

  AchievementProgress({
    required this.achievementId,
    this.currentValue = 0,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  /// Get the achievement definition
  Achievement? get achievement => Achievement.getById(achievementId);

  /// Get progress percentage
  double get progressPercentage {
    final ach = achievement;
    if (ach == null) return 0.0;
    if (isUnlocked) return 100.0;
    return (currentValue / ach.targetValue * 100).clamp(0.0, 100.0);
  }

  /// Increment progress
  bool incrementProgress(int amount) {
    if (isUnlocked) return false;

    currentValue += amount;
    final ach = achievement;
    if (ach != null && currentValue >= ach.targetValue) {
      unlock();
      return true;
    }
    return false;
  }

  /// Unlock the achievement
  void unlock() {
    if (!isUnlocked) {
      isUnlocked = true;
      unlockedAt = DateTime.now();
    }
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'achievementId': achievementId,
        'currentValue': currentValue,
        'isUnlocked': isUnlocked,
        'unlockedAt': unlockedAt?.toIso8601String(),
      };

  /// Create from JSON
  factory AchievementProgress.fromJson(Map<String, dynamic> json) {
    return AchievementProgress(
      achievementId: json['achievementId'] as String,
      currentValue: json['currentValue'] as int? ?? 0,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
    );
  }
}
