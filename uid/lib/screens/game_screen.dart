import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/memory_card.dart';
import '../widgets/memory_card.dart';
import '../widgets/game_header.dart';

/// Game screen displaying the card grid.
class GameScreen extends StatefulWidget {
  static const String routeName = '/game';

  GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<GameProvider>(context, listen: false);
      if (!provider.isGameActive && !provider.isGameFinished) {
        Navigator.pushReplacementNamed(context, '/difficulty');
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context, listen: true);

    // Navigate to result screen when game is finished
    if (provider.isGameFinished) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/result');
      });
    }

    final cols = provider.cols;
    final rows = provider.rows;

    // Calculate card size to fit screen without scrolling
    final screenWidth = MediaQuery.of(context).size.width - 32;
    final screenHeight = MediaQuery.of(context).size.height - 200;
    final cardWidth = (screenWidth - (cols - 1) * 8) / cols;
    final cardHeight = (screenHeight - (rows - 1) * 8) / rows;
    final cardSize = cardWidth < cardHeight ? cardWidth : cardHeight;
    final actualSize = cardSize.clamp(0.0, 60.0); // Reduced from 80px to 60px

    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: SafeArea(
          child: Column(
            children: [
              GameHeader(
                playerName: provider.playerName,
                score: provider.score,
                moves: provider.moves,
                timer: provider.timer,
                pairsFound: provider.pairsFound,
                totalPairs: provider.numPairs,
                onRestart: () {
                  provider.restartGame();
                },
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: provider.cards.length,
                      itemBuilder: (context, index) {
                        final card = provider.cards[index];
                        return MemoryCardWidget(
                          card: card,
                          cardWidth: actualSize,
                          cardHeight: actualSize,
                          onTap: () => provider.onCardTapped(index),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}