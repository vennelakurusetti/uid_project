import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:memory_match/models/memory_card.dart';
import 'package:memory_match/providers/game_provider.dart';
import 'package:memory_match/widgets/memory_card.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('MemoryCardWidget displays face-down initially', (tester) async {
      final card = MemoryCard(id: 1, icon: '🍎', isRevealed: false);
      final provider = GameProvider();
      provider.setPlayerName('TestPlayer');

      await tester.pumpWidget(
        MaterialApp(
          home: Provider<GameProvider>.value(
            value: provider,
            child: Scaffold(
              body: Center(
                child: MemoryCardWidget(
                  card: card,
                  cardWidth: 100,
                  cardHeight: 100,
                  onTap: () {},
                ),
              ),
            ),
          ),
        ),
      );

      // Check that backside (not the icon) is displayed
      expect(find.byIcon(Icons.backside), findsOneWidget);
    });

    testWidgets('MemoryCardWidget displays icon when revealed', (tester) async {
      final card = MemoryCard(id: 1, icon: '🍎', isRevealed: true);
      final provider = GameProvider();
      provider.setPlayerName('TestPlayer');

      await tester.pumpWidget(
        MaterialApp(
          home: Provider<GameProvider>.value(
            value: provider,
            child: Scaffold(
              body: Center(
                child: MemoryCardWidget(
                  card: card,
                  cardWidth: 100,
                  cardHeight: 100,
                  onTap: () {},
                ),
              ),
            ),
          ),
        ),
      );

      // Check that the icon is displayed
      expect(find.text('🍎'), findsOneWidget);
    });

    testWidgets('GameProvider initializes with default values', (tester) async {
      final provider = GameProvider();

      expect(provider.playerName, '');
      expect(provider.difficulty, 'medium');
      expect(provider.numPairs, 8);
      expect(provider.moves, 0);
      expect(provider.score, 0);
      expect(provider.timer, 0);
      expect(provider.isGameActive, false);
      expect(provider.isGameFinished, false);

      provider.dispose();
    });

    testWidgets('GameProvider sets player name correctly', (tester) async {
      final provider = GameProvider();

      provider.setPlayerName('John');
      expect(provider.playerName, 'John');
      expect(provider.playerNameError, isNull);

      provider.setPlayerName('A');
      expect(provider.playerNameError, isNotNull);

      provider.dispose();
    });

    testWidgets('GameProvider sets difficulty correctly', (tester) async {
      final provider = GameProvider();

      provider.setDifficulty('easy');
      expect(provider.difficulty, 'easy');
      expect(provider.numPairs, 4);

      provider.setDifficulty('medium');
      expect(provider.difficulty, 'medium');
      expect(provider.numPairs, 8);

      provider.setDifficulty('hard');
      expect(provider.difficulty, 'hard');
      expect(provider.numPairs, 12);

      provider.dispose();
    });

    testWidgets('GameProvider generates cards on start', (tester) async {
      final provider = GameProvider();
      provider.setPlayerName('Test');
      provider.setDifficulty('easy');
      provider.startGame();

      expect(provider.cards.length, 8);
      expect(provider.isGameActive, true);
      expect(provider.moves, 0);
      expect(provider.score, 0);

      provider.dispose();
    });

    testWidgets('Card matching logic', (tester) async {
      final provider = GameProvider();
      provider.setPlayerName('Test');
      provider.setDifficulty('easy');
      provider.startGame();

      // Get first two cards with same icon
      final cards = provider.cards;
      final String firstIcon = cards[0].icon;

      // Find all cards with this icon
      final List<int> matchingIndices = [];
      for (int i = 0; i < cards.length; i++) {
        if (cards[i].icon == firstIcon) {
          matchingIndices.add(i);
        }
      }

      // Tap first matching card
      provider.onCardTapped(matchingIndices[0]);
      expect(cards[matchingIndices[0]].isRevealed, true);

      // Tap second matching card
      provider.onCardTapped(matchingIndices[1]);
      expect(cards[matchingIndices[1]].isRevealed, true);

      // Wait for animation
      await tester.pumpAndSettle(const Duration(milliseconds: 900));

      // Both cards should be matched now
      expect(cards[matchingIndices[0]].isMatched, true);
      expect(cards[matchingIndices[1]].isMatched, true);
      expect(provider.score, 10);
      expect(provider.moves, 1);

      provider.dispose();
    });
  });
}
