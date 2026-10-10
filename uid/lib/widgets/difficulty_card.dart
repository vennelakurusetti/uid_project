import 'package:flutter/material.dart';
import '../providers/game_provider.dart';
import '../utils/game_logic.dart';

/// Difficulty selection card widget.
class DifficultyCard extends StatelessWidget {
  final String difficulty;
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const DifficultyCard({
    super.key,
    required this.difficulty,
    required this.label,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7)
                          : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'PLAY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Extends the main DifficultyCard with GameProvider integration.
class DifficultyCardWithProvider extends StatelessWidget {
  final String difficulty;
  final GameProvider provider;

  const DifficultyCardWithProvider({
    super.key,
    required this.difficulty,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final difficultyConfig = GameLogic.difficulties[difficulty]!;
    final isSelected = provider.difficulty == difficulty;

    return DifficultyCard(
      difficulty: difficulty,
      label: difficultyConfig['name']!,
      description: '${difficultyConfig['rows']} × ${difficultyConfig['cols']} grid',
      isSelected: isSelected,
      onTap: () {
        provider.setDifficulty(difficulty);
        provider.startGame();
        Navigator.pushReplacementNamed(context, '/game');
      },
    );
  }
}