import 'package:flutter_test/flutter_test.dart';
import 'package:memory_match/utils/game_logic.dart';
import 'package:memory_match/models/memory_card.dart';

void main() {
  group('GameLogic Tests', () {
    test('Card generation creates correct number of pairs', () {
      final cards = GameLogic.generateCards(4, 'easy');
      expect(cards.length, 8); // 4 pairs = 8 cards
    });

    test('Card generation creates pairs with matching icons', () {
      final cards = GameLogic.generateCards(4, 'easy');
      final icons = cards.map((c) => c.icon).toList();

      // Each icon should appear exactly twice
      for (final icon in icons) {
        final count = icons.where((i) => i == icon).length;
        expect(count, 2);
      }
    });

    test('Card generation shuffles cards', () {
      final cards1 = GameLogic.generateCards(4, 'easy');
      final cards2 = GameLogic.generateCards(4, 'easy');

      // The order should be different (very high probability)
      final isDifferent = cards1.map((c) => c.icon).toList() !=
          cards2.map((c) => c.icon).toList();
      expect(isDifferent, true);
    });

    test('Game completion check returns true when all matched', () {
      final cards = [
        MemoryCard(id: 1, icon: '🍎', isMatched: true),
        MemoryCard(id: 2, icon: '🍎', isMatched: true),
        MemoryCard(id: 3, icon: '🍌', isMatched: true),
        MemoryCard(id: 4, icon: '🍌', isMatched: true),
      ];
      expect(GameLogic.isGameComplete(cards), true);
    });

    test('Game completion check returns false when not all matched', () {
      final cards = [
        MemoryCard(id: 1, icon: '🍎', isMatched: true),
        MemoryCard(id: 2, icon: '🍎', isMatched: false),
        MemoryCard(id: 3, icon: '🍌', isMatched: true),
        MemoryCard(id: 4, icon: '🍌', isMatched: true),
      ];
      expect(GameLogic.isGameComplete(cards), false);
    });

    test('Score calculation with perfect score', () {
      // Perfect game: 4 pairs, 4 moves, 60 seconds
      final score = GameLogic.calculateScore(4, 60, 4);
      expect(score, greaterThan(0));
    });

    test('Score never goes negative', () {
      final score = GameLogic.calculateScore(100, 1, 4);
      expect(score, greaterThanOrEqualTo(0));
    });

    test('Time formatting', () {
      expect(GameLogic.formatTime(0), '0:00');
      expect(GameLogic.formatTime(5), '0:05');
      expect(GameLogic.formatTime(65), '1:05');
      expect(GameLogic.formatTime(3661), '61:01');
    });

    test('Name validation returns error for empty name', () {
      expect(GameLogic.validateName(''), isNotNull);
      expect(GameLogic.validateName(null), isNotNull);
    });

    test('Name validation returns error for short name', () {
      expect(GameLogic.validateName('A'), isNotNull);
    });

    test('Name validation returns null for valid name', () {
      expect(GameLogic.validateName('John'), isNull);
      expect(GameLogic.validateName('Mary Smith'), isNull);
    });

    test('Get pairs for difficulty', () {
      expect(GameLogic.getPairsForDifficulty('easy'), 4);
      expect(GameLogic.getPairsForDifficulty('medium'), 8);
      expect(GameLogic.getPairsForDifficulty('hard'), 12);
    });

    test('Get grid dimensions', () {
      expect(GameLogic.getGridDimensions('easy'), {'rows': 2, 'cols': 4});
      expect(GameLogic.getGridDimensions('medium'), {'rows': 4, 'cols': 4});
      expect(GameLogic.getGridDimensions('hard'), {'rows': 4, 'cols': 6});
    });

    test('Difficulty configurations exist', () {
      expect(GameLogic.difficulties.containsKey('easy'), true);
      expect(GameLogic.difficulties.containsKey('medium'), true);
      expect(GameLogic.difficulties.containsKey('hard'), true);
    });
  });
}
