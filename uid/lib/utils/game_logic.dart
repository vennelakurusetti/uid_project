import '../models/memory_card.dart';

/// Utility class containing game logic and helper functions.
/// Handles card matching logic, scoring, and difficulty configurations.
class GameLogic {
  GameLogic._();

  /// Card icons available for the game
  static const List<String> cardIcons = [
    '🍎', // Apple
    '🍌', // Banana
    '🍇', // Grapes
    '🍉', // Watermelon
    '🐶', // Dog
    '🐱', // Cat
    '🦊', // Fox
    '🐼', // Panda
    '🐸', // Frog
    '🦁', // Lion
    '🐵', // Monkey
    '🐰', // Rabbit
  ];

  /// Difficulty configurations with grid dimensions and pair counts
  static const Map<String, Map<String, dynamic>> difficulties = {
    'easy': {
      'name': 'Easy',
      'rows': 2,
      'cols': 3,
      'pairs': 3,
    },
    'medium': {
      'name': 'Medium',
      'rows': 2,
      'cols': 5,
      'pairs': 5,
    },
    'hard': {
      'name': 'Hard',
      'rows': 4,
      'cols': 4,
      'pairs': 8,
    },
  };

  /// Scoring constants
  static const int matchBonus = 10;
  static const int mismatchPenalty = 2;
  static const int timeBonusPerSecond = 1;

  /// Generates a list of MemoryCard objects for the game.
  /// [numPairs] specifies how many pairs to create.
  /// [difficulty] is the selected difficulty level.
  static List<MemoryCard> generateCards(int numPairs, String difficulty) {
    // Select random icons for the pairs
    final shuffledIcons = List<String>.from(cardIcons);
    shuffledIcons.shuffle();
    final selectedIcons = shuffledIcons.take(numPairs).toList();

    // Create pairs of cards
    final List<MemoryCard> cards = [];
    int cardId = 0;

    for (final icon in selectedIcons) {
      // Create two cards with the same icon
      cards.add(MemoryCard(id: cardId++, icon: icon));
      cards.add(MemoryCard(id: cardId++, icon: icon));
    }

    // Shuffle the cards
    cards.shuffle();

    print('DEBUG GameLogic: Generated ${cards.length} cards for $numPairs pairs');
    return cards;
  }

  /// Calculates the score based on moves and time taken.
  /// [moves] is the number of moves made.
  /// [timeSeconds] is the time taken in seconds.
  /// [baseScore] is the score from matching pairs (numPairs * matchBonus).
  static int calculateScore(int moves, int timeSeconds, int numPairs) {
    // Base score from matching pairs
    int score = numPairs * matchBonus;

    // Apply time bonus
    if (timeSeconds > 0) {
      score += (timeBonusPerSecond * 30 ~/ (timeSeconds + 1)) * 5;
    }

    // Penalty for moves (fewer moves = better score)
    if (moves > 0) {
      score -= (moves - numPairs) * mismatchPenalty;
    }

    // Ensure score is not negative
    return score.clamp(0, 2147483647);
  }

  /// Formats the elapsed time into a readable string.
  /// [seconds] is the number of seconds to format.
  static String formatTime(int seconds) {
    final int mins = seconds ~/ 60;
    final int secs = seconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  /// Validates the player name.
  /// Returns null if valid, or an error message if invalid.
  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Please enter your name';
    }
    if (name.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (name.trim().length > 20) {
      return 'Name must be less than 20 characters';
    }
    return null;
  }

  /// Gets the number of pairs based on difficulty.
  static int getPairsForDifficulty(String difficulty) {
    return difficulties[difficulty]?['pairs'] ?? difficulties['medium']!['pairs']!;
  }

  /// Gets the grid dimensions based on difficulty.
  static Map<String, int> getGridDimensions(String difficulty) {
    return {
      'rows': difficulties[difficulty]?['rows'] ?? 4,
      'cols': difficulties[difficulty]?['cols'] ?? 4,
    };
  }

  /// Checks if all cards are matched.
  static bool isGameComplete(List<MemoryCard> cards) {
    return cards.every((card) => card.isMatched);
  }
}
