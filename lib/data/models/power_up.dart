/// Power-Up Types
enum PowerUpType {
  bonusBall, // Marks one random unmarked number
  freeze, // Freezes bot for 10 seconds
  peek, // Shows next 3 numbers to be called
  swap, // Swap one number on card
  doubleCoins, // Doubles coin earnings
}

/// Power-Up Model
class PowerUp {
  final PowerUpType type;
  final String name;
  final String description;
  final int cost;
  final String emoji;
  final int maxUsesPerGame;
  final int cooldownSeconds;

  const PowerUp({
    required this.type,
    required this.name,
    required this.description,
    required this.cost,
    required this.emoji,
    this.maxUsesPerGame = 1,
    this.cooldownSeconds = 0,
  });

  /// Get all available power-ups
  static const List<PowerUp> allPowerUps = [
    PowerUp(
      type: PowerUpType.bonusBall,
      name: 'Bonus Ball',
      description: 'Instantly marks one random unmarked number on your card',
      cost: 50,
      emoji: '🎯',
      maxUsesPerGame: 2,
      cooldownSeconds: 30,
    ),
    PowerUp(
      type: PowerUpType.freeze,
      name: 'Freeze',
      description: 'Freezes bot marking for 10 seconds',
      cost: 100,
      emoji: '❄️',
      maxUsesPerGame: 1,
      cooldownSeconds: 60,
    ),
    PowerUp(
      type: PowerUpType.peek,
      name: 'Peek',
      description: 'Shows next 3 numbers to be called',
      cost: 75,
      emoji: '👁️',
      maxUsesPerGame: 1,
      cooldownSeconds: 0,
    ),
    PowerUp(
      type: PowerUpType.swap,
      name: 'Swap',
      description: 'Swap one number on your card with a random number from the pool',
      cost: 150,
      emoji: '🔄',
      maxUsesPerGame: 1,
      cooldownSeconds: 0,
    ),
    PowerUp(
      type: PowerUpType.doubleCoins,
      name: 'Double Coins',
      description: 'Doubles coin earnings for this game',
      cost: 200,
      emoji: '⚡',
      maxUsesPerGame: 1,
      cooldownSeconds: 0,
    ),
  ];

  /// Get a specific power-up by type
  static PowerUp getByType(PowerUpType type) {
    return allPowerUps.firstWhere((p) => p.type == type);
  }

  @override
  String toString() => '$emoji $name';
}

/// Power-Up Inventory Item
class PowerUpInventoryItem {
  final PowerUpType type;
  int quantity;

  PowerUpInventoryItem({
    required this.type,
    this.quantity = 0,
  });

  /// Get the power-up definition
  PowerUp get powerUp => PowerUp.getByType(type);

  /// Add to quantity
  void add(int amount) {
    quantity += amount;
  }

  /// Remove from quantity
  bool remove(int amount) {
    if (quantity >= amount) {
      quantity -= amount;
      return true;
    }
    return false;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'quantity': quantity,
      };

  /// Create from JSON
  factory PowerUpInventoryItem.fromJson(Map<String, dynamic> json) {
    return PowerUpInventoryItem(
      type: PowerUpType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
      quantity: json['quantity'] as int,
    );
  }
}
