import 'package:flutter/material.dart';
import '../models/memory_card.dart';

/// Custom card widget for the memory game.
class MemoryCardWidget extends StatelessWidget {
  final MemoryCard card;
  final VoidCallback onTap;
  final double cardWidth;
  final double cardHeight;

  const MemoryCardWidget({
    super.key,
    required this.card,
    required this.onTap,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: card.isRevealed || card.isMatched
                ? Colors.white
                : Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: card.isRevealed || card.isMatched
              ? Center(
                  child: Text(
                    card.icon,
                    style: TextStyle(
                      fontSize: cardWidth * 0.5,
                    ),
                  ),
                )
              : const Center(
                  child: Icon(
                    Icons.question_mark,
                    color: Colors.white70,
                    size: 20,
                  ),
                ),
        ),
      ),
    );
  }
}