/// Bingo Number Model
/// Represents a single number in the B-I-N-G-O system (1-75)
class BingoNumber {
  final int value;
  final String letter; // B, I, N, G, or O

  const BingoNumber({
    required this.value,
    required this.letter,
  });

  /// Create from a number value (1-75)
  factory BingoNumber.fromValue(int value) {
    assert(value >= 1 && value <= 75, 'Bingo number must be between 1 and 75');

    String letter;
    if (value <= 15) {
      letter = 'B';
    } else if (value <= 30) {
      letter = 'I';
    } else if (value <= 45) {
      letter = 'N';
    } else if (value <= 60) {
      letter = 'G';
    } else {
      letter = 'O';
    }

    return BingoNumber(value: value, letter: letter);
  }

  /// Get the full display string (e.g., "B-12")
  String get displayString => '$letter-$value';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BingoNumber && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => displayString;

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'value': value,
        'letter': letter,
      };

  /// Create from JSON
  factory BingoNumber.fromJson(Map<String, dynamic> json) => BingoNumber(
        value: json['value'] as int,
        letter: json['letter'] as String,
      );
}
