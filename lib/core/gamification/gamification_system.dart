import 'package:flutter/material.dart';

/// Sistema centralizado de gamificación para LifeVibes
/// Maneja niveles, XP, badges, y recompensas

/// Nivel del usuario
class GamificationLevel {
  final int level;
  final int xpRequired;
  final String title;
  final String icon;
  final List<String> rewards;

  GamificationLevel({
    required this.level,
    required this.xpRequired,
    required this.title,
    required this.icon,
    this.rewards = const [],
  });

  /// Get level from XP
  static GamificationLevel getLevelFromXP(int totalXP) {
    for (var i = _levels.length - 1; i >= 0; i--) {
      if (totalXP >= _levels[i].xpRequired) {
        return _levels[i];
      }
    }
    return _levels[0]; // Level 1 if no XP
  }

  /// Get next level
  GamificationLevel? get nextLevel {
    if (level < _levels.length) {
      return _levels[level];
    }
    return null;
  }

  /// Get progress to next level (0.0 to 1.0)
  double get progress(int currentXP) {
    final nextLvl = nextLevel;
    if (nextLvl == null) return 1.0; // Max level

    final currentLevelXP = xpRequired;
    final nextLevelXP = nextLvl!.xpRequired;
    final xpInCurrentLevel = currentXP - currentLevelXP;
    final xpNeeded = nextLevelXP - currentLevelXP;

    return (xpInCurrentLevel / xpNeeded).clamp(0.0, 1.0);
  }

  /// Predefined levels
  static const List<GamificationLevel> _levels = [
    GamificationLevel(
      level: 1,
      xpRequired: 0,
      title: 'Novato',
      icon: '🌱',
      rewards: ['Unlocked: Avatar básico'],
    ),
    GamificationLevel(
      level: 2,
      xpRequired: 100,
      title: 'Explorador',
      icon: '🔍',
      rewards: ['Unlocked: 2 slots de quests'],
    ),
    GamificationLevel(
      level: 3,
      xpRequired: 300,
      title: 'Aprendiz',
      icon: '📚',
      rewards: ['Unlocked: 3 slots de quests'],
    ),
    GamificationLevel(
      level: 4,
      xpRequired: 600,
      title: 'Estudiante',
      icon: '🎓',
      rewards: ['Unlocked: 4 slots de quests', 'Badge: Student'],
    ),
    GamificationLevel(
      level: 5,
      xpRequired: 1000,
      title: 'Practicante',
      icon: '💪',
      rewards: ['Unlocked: 5 slots de quests'],
    ),
    GamificationLevel(
      level: 6,
      xpRequired: 1500,
      title: 'Iniciado',
      icon: '🚀',
      rewards: ['Unlocked: 6 slots de quests', 'Badge: Started'],
    ),
    GamificationLevel(
      level: 7,
      xpRequired: 2100,
      title: 'Intermedio',
      icon: '⭐',
      rewards: ['Unlocked: 7 slots de quests'],
    ),
    GamificationLevel(
      level: 8,
      xpRequired: 2800,
      title: 'Avanzado',
      icon: '🌟',
      rewards: ['Unlocked: 8 slots de quests', 'Badge: Advanced'],
    ),
    GamificationLevel(
      level: 9,
      xpRequired: 3600,
      title: 'Experto',
      icon: '🏆',
      rewards: ['Unlocked: 9 slots de quests'],
    ),
    GamificationLevel(
      level: 10,
      xpRequired: 4500,
      title: 'Maestro',
      icon: '👑',
      rewards: ['Unlocked: 10 slots de quests', 'Badge: Master'],
    ),
    GamificationLevel(
      level: 11,
      xpRequired: 5500,
      title: 'Leyenda',
      icon: '🌈',
      rewards: ['Unlocked: Todos los slots', 'Badge: Legend'],
    ),
  ];

  /// Get all levels
  static List<GamificationLevel> get allLevels() => List.from(_levels);
}

/// Badge (insignia) de gamificación
class GamificationBadge {
  final String badgeId;
  final String name;
  final String description;
  final String icon;
  final int xpReward; // XP reward when earned
  final String? rarity; // common, rare, epic, legendary
  final DateTime? unlockedAt;
  final String? category; // avatar, quest, match, funnel, product

  GamificationBadge({
    required this.badgeId,
    required this.name,
    required this.description,
    required this.icon,
    this.xpReward = 0,
    this.rarity,
    this.unlockedAt,
    this.category,
  });

  factory GamificationBadge.fromJson(Map<String, dynamic> json) {
    return GamificationBadge(
      badgeId: json['badgeId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      xpReward: json['xpReward'] as int? ?? 0,
      rarity: json['rarity'] as String?,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'badgeId': badgeId,
      'name': name,
      'description': description,
      'icon': icon,
      'xpReward': xpReward,
      'rarity': rarity,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'category': category,
    };
  }

  bool get isUnlocked => unlockedAt != null;

  /// Get rarity color
  Color get rarityColor {
    switch (rarity) {
      case 'common':
        return Colors.grey;
      case 'rare':
        return Colors.blue;
      case 'epic':
        return Colors.purple;
      case 'legendary':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  /// Predefined badges
  static List<GamificationBadge> getAllBadges() {
    return [
      // SER Phase badges
      GamificationBadge(
        badgeId: 'purpose_discoverer',
        name: 'Descubridor de Propósito',
        description: 'Has descubierto tu propósito de vida',
        icon: '🎯',
        xpReward: 100,
        rarity: 'rare',
        category: 'avatar',
      ),
      GamificationBadge(
        badgeId: 'values_master',
        name: 'Maestro de Valores',
        description: 'Has identificado y alineado tus valores',
        icon: '💎',
        xpReward: 150,
        rarity: 'epic',
        category: 'avatar',
      ),
      GamificationBadge(
        badgeId: 'superpower_forger',
        name: 'Forjador de Superpoder',
        description: 'Has transformado una habilidad en superpoder',
        icon: '⚡',
        xpReward: 200,
        rarity: 'epic',
        category: 'avatar',
      ),

      // HACER Phase badges
      GamificationBadge(
        badgeId: 'content_creator',
        name: 'Creador de Contenido',
        description: 'Has creado tu primer contenido',
        icon: '✍️',
        xpReward: 75,
        rarity: 'common',
        category: 'quest',
      ),
      GamificationBadge(
        badgeId: 'networker',
        name: 'Networker',
        description: 'Has conectado con 10 personas',
        icon: '🤝',
        xpReward: 150,
        rarity: 'rare',
        category: 'match',
      ),
      GamificationBadge(
        badgeId: 'funnel_builder',
        name: 'Constructor de Embudos',
        description: 'Has creado tu primer funnel',
        icon: '🚀',
        xpReward: 200,
        rarity: 'epic',
        category: 'funnel',
      ),

      // TENER Phase badges
      GamificationBadge(
        badgeId: 'product_launcher',
        name: 'Lanzador de Productos',
        description: 'Has lanzado tu primer producto',
        icon: '📦',
        xpReward: 250,
        rarity: 'rare',
        category: 'product',
      ),
      GamificationBadge(
        badgeId: 'entrepreneur',
        name: 'Emprendedor',
        description: 'Has hecho tu primera venta',
        icon: '💰',
        xpReward: 500,
        rarity: 'epic',
        category: 'product',
      ),
      GamificationBadge(
        badgeId: 'first_client',
        name: 'Primer Cliente DWY',
        description: 'Has conseguido tu primer cliente de mentoría',
        icon: '🎉',
        xpReward: 750,
        rarity: 'legendary',
        category: 'product',
      ),

      // Streak badges
      GamificationBadge(
        badgeId: 'streak_7_days',
        name: 'Streak de 7 Días',
        description: 'Has mantenido actividad por 7 días',
        icon: '🔥',
        xpReward: 175,
        rarity: 'rare',
        category: 'quest',
      ),
      GamificationBadge(
        badgeId: 'streak_30_days',
        name: 'Streak de 30 Días',
        description: 'Has mantenido actividad por 30 días',
        icon: '💥',
        xpReward: 750,
        rarity: 'epic',
        category: 'quest',
      ),

      // Milestone badges
      GamificationBadge(
        badgeId: 'hundred_club',
        name: 'Club de los 100',
        description: 'Has ganado más de $100 en ventas',
        icon: '💵',
        xpReward: 300,
        rarity: 'rare',
        category: 'product',
      ),
      GamificationBadge(
        badgeId: 'thousand_club',
        name: 'Club de los 1,000',
        description: 'Has ganado más de $1,000 en ventas',
        icon: '💎',
        xpReward: 1000,
        rarity: 'legendary',
        category: 'product',
      ),

      // Special badges
      GamificationBadge(
        badgeId: 'early_adopter',
        name: 'Early Adopter',
        description: 'Te uniste en las primeras 48 horas',
        icon: '🌟',
        xpReward: 100,
        rarity: 'rare',
        category: 'avatar',
      ),
      GamificationBadge(
        badgeId: 'completionist',
        name: 'Perfeccionista',
        description: 'Has completado el 90% de los pasos del onboarding',
        icon: '✨',
        xpReward: 150,
        rarity: 'epic',
        category: 'avatar',
      ),
    ];
  }
}

import 'package:flutter/material.dart';
