import 'package:equatable/equatable.dart';

/// Firebase constants for the app
class FirebaseConstants {
  static const int xpPerLevel = 100;
}

/// Avatar model
class Avatar extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String description;
  final int level;
  final int xp;
  final Map<String, int> superpowers;
  final int health;
  final int energy;
  final int happiness;
  final String appearance;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Avatar({
    required this.id,
    required this.userId,
    required this.name,
    this.description = '',
    this.level = 1,
    this.xp = 0,
    Map<String, int>? superpowers,
    this.health = 100,
    this.energy = 100,
    this.happiness = 100,
    this.appearance = '',
    required this.createdAt,
    DateTime? updatedAt,
  })  : superpowers = superpowers ?? const {},
        updatedAt = updatedAt ?? createdAt;

  Avatar copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    int? level,
    int? xp,
    Map<String, int>? superpowers,
    int? health,
    int? energy,
    int? happiness,
    String? appearance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Avatar(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      superpowers: superpowers ?? this.superpowers,
      health: health ?? this.health,
      energy: energy ?? this.energy,
      happiness: happiness ?? this.happiness,
      appearance: appearance ?? this.appearance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toDocument() {
    return {
      'userId': userId,
      'name': name,
      'description': description,
      'level': level,
      'xp': xp,
      'superpowers': superpowers,
      'health': health,
      'energy': energy,
      'happiness': happiness,
      'appearance': appearance,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create Avatar from Firestore document
  factory Avatar.fromDocument(Map<String, dynamic> doc, String id) {
    return Avatar(
      id: id,
      userId: doc['userId'] as String,
      name: doc['name'] as String,
      description: doc['description'] as String? ?? '',
      level: doc['level'] as int? ?? 1,
      xp: doc['xp'] as int? ?? 0,
      superpowers: (doc['superpowers'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as int)) ??
          const {},
      health: doc['health'] as int? ?? 100,
      energy: doc['energy'] as int? ?? 100,
      happiness: doc['happiness'] as int? ?? 100,
      appearance: doc['appearance'] as String? ?? '',
      createdAt: DateTime.parse(doc['createdAt'] as String),
      updatedAt: doc['updatedAt'] != null
          ? DateTime.parse(doc['updatedAt'] as String)
          : null,
    );
  }

  /// Calculate required XP for next level
  int get xpToNextLevel => (level * FirebaseConstants.xpPerLevel) - xp;

  /// Calculate level progress percentage (0.0 to 1.0)
  double get levelProgress {
    final xpForCurrentLevel = (level - 1) * FirebaseConstants.xpPerLevel;
    final xpInCurrentLevel = xp - xpForCurrentLevel;
    return xpInCurrentLevel / FirebaseConstants.xpPerLevel;
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    description,
    level,
    xp,
    superpowers,
    health,
    energy,
    happiness,
    appearance,
    createdAt,
    updatedAt,
  ];
}
