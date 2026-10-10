# Memory Card Match - Flutter Project

A colorful and interactive memory card matching game built with Flutter for a college lab project.

## Overview

**Memory Match** is a fun mobile game where players flip cards to find matching pairs. The game features smooth animations, a scoring system, and a leaderboard to track top players.

### Features

- 🎮 **Three difficulty levels** (Easy, Medium, Hard)
- 🎨 **Modern Material UI** with vibrant gradients
- 📱 **Responsive design** - cards fit perfectly on screen
- 🔄 **Smooth card flip animations**
- ⏱️ **Timer and move counter**
- 🏆 **Scoring system** with bonuses for speed
- 📊 **Leaderboard** - track top 10 scores with medals
- 🎉 **Victory celebration** with confetti animation
- 📋 **Player name validation**
- 🎯 **No scrolling** - optimized grid layout

## Project Structure

```
lib/
├── main.dart                 # App entry point with theme and routing
├── models/
│   └── memory_card.dart      # Card data model
├── providers/
│   └── game_provider.dart    # State management using Provider
├── screens/
│   ├── home_screen.dart      # Welcome screen with name input
│   ├── difficulty_screen.dart # Difficulty selection
│   ├── game_screen.dart      # Main game grid
│   ├── result_screen.dart    # Game completion screen with confetti
│   ├── how_to_play_screen.dart # Rules explanation
│   └── leaderboard_screen.dart # Top scores display
├── widgets/
│   ├── memory_card.dart      # Custom card widget with animations
│   ├── custom_button.dart    # Reusable button components
│   ├── difficulty_card.dart  # Difficulty selection card
│   └── game_header.dart      # Game stats header
└── utils/
    └── game_logic.dart       # Game rules and utilities

test/
├── game_logic_test.dart      # Unit tests for game logic
└── widget_test.dart          # Widget tests

pubspec.yaml                  # Dependencies and configuration
README.md                     # This file
```

## Technology Stack

- **Flutter SDK**: UI framework
- **Dart**: Programming language
- **Provider**: State management
- **Material 3**: UI design system
- **Custom Animations**: Confetti celebration

## How to Run

### Prerequisites

- Flutter SDK installed (3.0.0 or higher)
- Dart SDK (bundled with Flutter)
- Chrome/Edge browser or Android Studio/Xcode

### Installation

```bash
# Navigate to the project directory
cd D:\btech_projects\uid

# Get dependencies
flutter pub get

# Run the app on Chrome
flutter run -d chrome

# Or run on connected device
flutter run
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/game_logic_test.dart
```

## Screen Flow

```
Welcome Screen (/)
    ↓
Difficulty Selection (/difficulty)
    ↓
Game Screen (/game)
    ↓
Result Screen (/result) 🎉
    ↑
Leaderboard (/leaderboard)
    ↑
How to Play (/how-to-play)
```

## Game Rules

1. Enter your name on the welcome screen
2. Select a difficulty level
3. Tap a card to reveal its icon
4. Tap another card to find a match
5. If cards match, they stay revealed
6. If no match, cards flip back after a brief pause
7. Match all pairs with the fewest moves and fastest time
8. Celebrate with confetti! 🎊

## Difficulty Levels

| Level  | Grid Size | Cards | Pairs | Challenge    |
|--------|-----------|-------|-------|--------------|
| Easy   | 2 × 3     | 6     | 3     | Quick        |
| Medium | 2 × 5     | 10    | 5     | Moderate     |
| Hard   | 4 × 4     | 16    | 8     | Challenging  |

## Scoring System

- **Match found**: +10 points
- **Mismatch**: -2 points
- **Time bonus**: Faster completion = higher bonus
- **Score never goes negative**
- **Top 10 scores saved** in leaderboard

## Leaderboard

- 🥇 **Gold medal** for 1st place
- 🥈 **Silver medal** for 2nd place
- 🥉 **Bronze medal** for 3rd place
- Shows player name, score, moves, and time
- Can be cleared from the leaderboard screen

## Flutter Syllabus Mapping

### 1. Basic UI Components
- `Container`, `Column`, `Row`, `GridView`
- `Text`, `TextField`, `IconButton`
- `Card`, `GestureDetector`

### 2. State Management
- `Provider` pattern for game state
- `ChangeNotifier` for reactive updates
- `setState()` for local state

### 3. Navigation
- Named routes with `MaterialApp`
- `Navigator.pushNamed()` and `pop()`
- Route table configuration

### 4. Animations
- `AnimationController` with `TickerProviderStateMixin`
- Custom `CustomPainter` for confetti
- `AnimatedBuilder` for reactive animations

### 5. Responsive Design
- `MediaQuery` for screen dimensions
- `LayoutBuilder` for adaptive layouts
- Fixed container sizing for consistency

### 6. Data Models
- Custom classes with `copyWith` methods
- Leaderboard data management
- Timer and score tracking

### 7. Testing
- Unit tests with `flutter_test`
- Game logic validation
- `expect()` assertions

## Code Highlights

### Confetti Animation
```dart
CustomPaint(
  painter: ConfettiPainter(
    particles: _particles,
    progress: _confettiController.value,
  ),
)
```

### Fixed Grid Layout
```dart
SizedBox(
  width: 650,
  height: 420,
  child: GridView.builder(
    physics: const NeverScrollableScrollPhysics(),
    // No scrolling - perfect fit!
  ),
)
```

### Leaderboard Sorting
```dart
_leaderboard.sort((a, b) => b['score'].compareTo(a['score']));
if (_leaderboard.length > 10) {
  _leaderboard = _leaderboard.sublist(0, 10);
}
```

## Troubleshooting

### "Too many cards showing"
- Run `flutter clean`
- Then `flutter pub get`
- Restart the app

### "Cards don't fit on screen"
- Fixed at 650×420px container
- Max card size: 190px
- No scrolling physics enabled

### "Buttons not clickable on result screen"
- Confetti wrapped in `IgnorePointer`
- Should work after update

## License

This project is created for educational purposes as part of a Flutter lab assignment.

## Author

Created as a Flutter lab project demonstrating core Flutter concepts including state management, animations, and responsive design.

---

**Enjoy the game!** 🎮🎉
