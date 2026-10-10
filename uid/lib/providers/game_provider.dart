import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/memory_card.dart';
import '../utils/game_logic.dart';

/// Game state management using Provider pattern.
class GameProvider with ChangeNotifier {
  // Player information
  String _playerName = '';
  String? _playerNameError;

  // Game configuration
  String _difficulty = 'medium';
  int _numPairs = 5;

  // Game state
  List<MemoryCard> _cards = [];
  List<MemoryCard> _selectedCards = [];
  int _moves = 0;
  int _score = 0;
  int _timer = 0;
  Timer? _timerSubscription;
  bool _isGameActive = false;
  bool _isGameFinished = false;
  bool _isProcessing = false;

  // Leaderboard
  List<Map<String, dynamic>> _leaderboard = [];

  // Getters
  String get playerName => _playerName;
  String? get playerNameError => _playerNameError;

  String get difficulty => _difficulty;
  int get numPairs => _numPairs;

  List<MemoryCard> get cards => _cards;
  List<MemoryCard> get selectedCards => _selectedCards;
  int get moves => _moves;
  int get score => _score;
  int get timer => _timer;
  bool get isGameActive => _isGameActive;
  bool get isGameFinished => _isGameFinished;
  bool get isProcessing => _isProcessing;
  int get finalScore => _score;
  int get pairsFound => calculatePairsFound();
  List<Map<String, dynamic>> get leaderboard => _leaderboard;

  // Get grid dimensions based on difficulty
  int get rows => GameLogic.getGridDimensions(_difficulty)['rows']!;
  int get cols => GameLogic.getGridDimensions(_difficulty)['cols']!;

  // Calculate pairs found (matched cards / 2)
  int calculatePairsFound() {
    return _cards.where((card) => card.isMatched).length ~/ 2;
  }

  /// Sets the player name and validates it.
  void setPlayerName(String name) {
    _playerName = name.trim();
    _playerNameError = GameLogic.validateName(_playerName);
    notifyListeners();
  }

  /// Sets the difficulty level.
  void setDifficulty(String difficulty) {
    print('DEBUG: Setting difficulty to: $difficulty');
    _difficulty = difficulty;
    _numPairs = GameLogic.getPairsForDifficulty(difficulty);
    print('DEBUG: Number of pairs for $difficulty: $_numPairs');
    notifyListeners();
  }

  /// Starts a new game.
  void startGame() {
    print('DEBUG: Starting game with difficulty: $_difficulty, pairs: $_numPairs');
    _cards = GameLogic.generateCards(_numPairs, _difficulty);
    print('DEBUG: Generated ${_cards.length} cards');
    _selectedCards = [];
    _moves = 0;
    _score = 0;
    _timer = 0;
    _isGameActive = true;
    _isGameFinished = false;
    _isProcessing = false;

    _startTimer();
    notifyListeners();
  }

  /// Starts the game timer.
  void _startTimer() {
    _timerSubscription?.cancel();
    _timerSubscription = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isGameActive && !_isGameFinished) {
        _timer++;
        notifyListeners();
      }
    });
  }

  /// Handles card tap event.
  void onCardTapped(int index) {
    if (_isProcessing || !_isGameActive || _isGameFinished) return;

    final card = _cards[index];

    if (card.isRevealed || card.isMatched) return;

    _revealCard(index);
    _selectedCards.add(card);

    if (_selectedCards.length == 2) {
      _handleCardComparison();
    }

    notifyListeners();
  }

  /// Reveals a card.
  void _revealCard(int index) {
    _cards[index] = _cards[index].copyWith(isRevealed: true);
  }

  /// Compares two selected cards.
  void _handleCardComparison() {
    _isProcessing = true;
    notifyListeners();

    final card1 = _selectedCards[0];
    final card2 = _selectedCards[1];

    if (card1.icon == card2.icon) {
      _handleMatch(card1, card2);
    } else {
      _handleMismatch(card1, card2);
    }
  }

  /// Handles a successful match.
  void _handleMatch(MemoryCard card1, MemoryCard card2) {
    _moves++;
    _score += GameLogic.matchBonus;

    for (int i = 0; i < _cards.length; i++) {
      if (_cards[i].id == card1.id || _cards[i].id == card2.id) {
        _cards[i] = _cards[i].copyWith(isMatched: true, isRevealed: false);
      }
    }

    _selectedCards = [];
    _isProcessing = false;

    if (calculatePairsFound() == _numPairs) {
      _endGame();
    }

    notifyListeners();
  }

  /// Handles a mismatch.
  void _handleMismatch(MemoryCard card1, MemoryCard card2) {
    if (_score > 0) {
      _score -= GameLogic.mismatchPenalty;
    }
    _moves++;

    _selectedCards = [];

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!_isGameActive) return;

      for (int i = 0; i < _cards.length; i++) {
        if (_cards[i].id == card1.id || _cards[i].id == card2.id) {
          _cards[i] = _cards[i].copyWith(isRevealed: false);
        }
      }

      _isProcessing = false;
      notifyListeners();
    });
  }

  /// Ends the game and saves score to leaderboard.
  void _endGame() {
    _isGameActive = false;
    _isGameFinished = true;
    _timerSubscription?.cancel();

    // Save to leaderboard
    if (_playerName.isNotEmpty) {
      _leaderboard.insert(0, {
        'name': _playerName,
        'score': _score,
        'moves': _moves,
        'time': _timer,
        'difficulty': _difficulty,
        'date': DateTime.now().toString(),
      });

      // Sort by score and keep top 10
      _leaderboard.sort((a, b) => b['score'].compareTo(a['score']));
      if (_leaderboard.length > 10) {
        _leaderboard = _leaderboard.sublist(0, 10);
      }
    }

    notifyListeners();
  }

  /// Restarts the current game.
  void restartGame() {
    startGame();
  }

  /// Restarts with a different difficulty.
  void restartWithDifficulty(String newDifficulty) {
    setDifficulty(newDifficulty);
    startGame();
  }

  /// Returns to the home screen.
  void resetGame() {
    _timerSubscription?.cancel();
    _isGameActive = false;
    _isGameFinished = false;
    _difficulty = 'medium';
    _numPairs = GameLogic.getPairsForDifficulty('medium');
    _playerName = '';
    _playerNameError = null;
    notifyListeners();
  }

  /// Clears the leaderboard.
  void clearLeaderboard() {
    _leaderboard = [];
    notifyListeners();
  }

  /// Returns difficulty name for display.
  String getDifficultyName() {
    return GameLogic.difficulties[_difficulty]?['name'] ?? 'Medium';
  }

  /// Formats the time for display.
  String formatTime(int seconds) {
    return GameLogic.formatTime(seconds);
  }

  @override
  void dispose() {
    _timerSubscription?.cancel();
    super.dispose();
  }
}