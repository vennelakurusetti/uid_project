/// Model class representing a single memory card.
/// Each card has an ID, icon, and state (whether it's revealed or matched).
class MemoryCard {
  final int id;
  final String icon;
  final bool isRevealed;
  final bool isMatched;

  /// Creates a new MemoryCard instance.
  /// [id] is a unique identifier for the card.
  /// [icon] is the emoji/icon displayed on the card.
  /// [isRevealed] indicates if the card is currently face-up.
  /// [isMatched] indicates if the card has been successfully matched.
  MemoryCard({
    required this.id,
    required this.icon,
    this.isRevealed = false,
    this.isMatched = false,
  });

  /// Creates a copy of the card with updated values.
  MemoryCard copyWith({
    bool? isRevealed,
    bool? isMatched,
  }) {
    return MemoryCard(
      id: id,
      icon: icon,
      isRevealed: isRevealed ?? this.isRevealed,
      isMatched: isMatched ?? this.isMatched,
    );
  }

  /// Converts the card to a JSON map for serialization.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon': icon,
      'isRevealed': isRevealed,
      'isMatched': isMatched,
    };
  }

  /// Creates a MemoryCard from a JSON map.
  factory MemoryCard.fromJson(Map<String, dynamic> json) {
    return MemoryCard(
      id: json['id'],
      icon: json['icon'],
      isRevealed: json['isRevealed'] ?? false,
      isMatched: json['isMatched'] ?? false,
    );
  }

  @override
  String toString() {
    return 'MemoryCard(id: $id, icon: $icon, revealed: $isRevealed, matched: $isMatched)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MemoryCard && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
