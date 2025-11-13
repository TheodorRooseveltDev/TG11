import 'dart:math';
import 'bingo_number.dart';

/// Bingo Cell Model
/// Represents a single cell on a bingo card
class BingoCell {
  final BingoNumber number;
  final bool isFreeSpace;
  bool isMarked;

  BingoCell({
    required this.number,
    this.isFreeSpace = false,
    this.isMarked = false,
  });

  /// Create a free space cell
  factory BingoCell.freeSpace() => BingoCell(
        number: BingoNumber.fromValue(1), // Dummy value
        isFreeSpace: true,
        isMarked: true, // Free space is always marked
      );

  /// Toggle the marked state
  void toggleMark() {
    if (!isFreeSpace) {
      isMarked = !isMarked;
    }
  }

  /// Mark the cell
  void mark() {
    isMarked = true;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'number': number.toJson(),
        'isFreeSpace': isFreeSpace,
        'isMarked': isMarked,
      };

  /// Create from JSON
  factory BingoCell.fromJson(Map<String, dynamic> json) => BingoCell(
        number: BingoNumber.fromJson(json['number'] as Map<String, dynamic>),
        isFreeSpace: json['isFreeSpace'] as bool,
        isMarked: json['isMarked'] as bool,
      );
}

/// Bingo Card Model
/// Represents a 5x5 bingo card
class BingoCard {
  final String id;
  final List<List<BingoCell>> cells; // 5x5 grid

  BingoCard({
    required this.id,
    required this.cells,
  });

  /// Generate a random bingo card
  factory BingoCard.generate({String? customId}) {
    final random = Random();
    final cells = <List<BingoCell>>[];

    // Generate 5 columns (B, I, N, G, O)
    for (int col = 0; col < 5; col++) {
      final column = <BingoCell>[];
      final columnLetter = ['B', 'I', 'N', 'G', 'O'][col];

      // Determine the range for this column
      final minValue = col * 15 + 1;

      // Generate 5 unique numbers for this column
      final availableNumbers = List.generate(15, (i) => minValue + i);
      availableNumbers.shuffle(random);
      final selectedNumbers = availableNumbers.take(5).toList();
      selectedNumbers.sort();

      for (int row = 0; row < 5; row++) {
        // Middle cell (2,2) is the FREE space
        if (col == 2 && row == 2) {
          column.add(BingoCell.freeSpace());
        } else {
          column.add(BingoCell(
            number: BingoNumber(
              value: selectedNumbers[row],
              letter: columnLetter,
            ),
          ));
        }
      }

      cells.add(column);
    }

    return BingoCard(
      id: customId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      cells: cells,
    );
  }

  /// Get cell at position (col, row)
  BingoCell getCellAt(int col, int row) {
    assert(col >= 0 && col < 5 && row >= 0 && row < 5);
    return cells[col][row];
  }

  /// Mark a number if it exists on the card
  bool markNumber(BingoNumber number) {
    for (var column in cells) {
      for (var cell in column) {
        if (!cell.isFreeSpace && cell.number == number) {
          cell.mark();
          return true;
        }
      }
    }
    return false;
  }

  /// Check if the card has a winning pattern
  bool hasWinningPattern() {
    return hasHorizontalLine() ||
        hasVerticalLine() ||
        hasDiagonalLine() ||
        hasFourCorners() ||
        hasFullHouse();
  }

  /// Check for horizontal line (any row)
  bool hasHorizontalLine() {
    for (int row = 0; row < 5; row++) {
      bool hasLine = true;
      for (int col = 0; col < 5; col++) {
        if (!cells[col][row].isMarked) {
          hasLine = false;
          break;
        }
      }
      if (hasLine) return true;
    }
    return false;
  }

  /// Check for vertical line (any column)
  bool hasVerticalLine() {
    for (int col = 0; col < 5; col++) {
      bool hasLine = true;
      for (int row = 0; row < 5; row++) {
        if (!cells[col][row].isMarked) {
          hasLine = false;
          break;
        }
      }
      if (hasLine) return true;
    }
    return false;
  }

  /// Check for diagonal lines
  bool hasDiagonalLine() {
    // Top-left to bottom-right
    bool diagonal1 = true;
    for (int i = 0; i < 5; i++) {
      if (!cells[i][i].isMarked) {
        diagonal1 = false;
        break;
      }
    }
    if (diagonal1) return true;

    // Top-right to bottom-left
    bool diagonal2 = true;
    for (int i = 0; i < 5; i++) {
      if (!cells[4 - i][i].isMarked) {
        diagonal2 = false;
        break;
      }
    }
    return diagonal2;
  }

  /// Check for four corners
  bool hasFourCorners() {
    return cells[0][0].isMarked &&
        cells[4][0].isMarked &&
        cells[0][4].isMarked &&
        cells[4][4].isMarked;
  }

  /// Check for full house (all cells marked)
  bool hasFullHouse() {
    for (var column in cells) {
      for (var cell in column) {
        if (!cell.isMarked) return false;
      }
    }
    return true;
  }

  /// Get marked cells count
  int get markedCount {
    int count = 0;
    for (var column in cells) {
      for (var cell in column) {
        if (cell.isMarked) count++;
      }
    }
    return count;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'cells': cells.map((col) => col.map((cell) => cell.toJson()).toList()).toList(),
      };

  /// Create from JSON
  factory BingoCard.fromJson(Map<String, dynamic> json) => BingoCard(
        id: json['id'] as String,
        cells: (json['cells'] as List)
            .map((col) =>
                (col as List).map((cell) => BingoCell.fromJson(cell as Map<String, dynamic>)).toList())
            .toList(),
      );
}
