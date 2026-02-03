/// Avatar model for LifeVibes app
/// Represents the user's digital avatar with customization options
class AvatarModel {
  final String faceType;
  final String eyeStyle;
  final String eyeColor;
  final String mouthStyle;
  final String hairStyle;
  final String hairColor;
  final String skinColor;
  final String outfit;
  final List<String> accessories;
  final int level;
  final int xp;
  final List<String> badges;
  final DateTime? lastUpdated;

  AvatarModel({
    this.faceType = 'round',
    this.eyeStyle = 'normal',
    this.eyeColor = '#4A5568',
    this.mouthStyle = 'smile',
    this.hairStyle = 'short',
    this.hairColor = '#1A202C',
    this.skinColor = '#FBD38D',
    this.outfit = 'casual',
    this.accessories = const [],
    this.level = 1,
    this.xp = 0,
    this.badges = const [],
    this.lastUpdated,
  });

  factory AvatarModel.fromJson(Map<String, dynamic> json) {
    return AvatarModel(
      faceType: json['faceType'] as String? ?? 'round',
      eyeStyle: json['eyeStyle'] as String? ?? 'normal',
      eyeColor: json['eyeColor'] as String? ?? '#4A5568',
      mouthStyle: json['mouthStyle'] as String? ?? 'smile',
      hairStyle: json['hairStyle'] as String? ?? 'short',
      hairColor: json['hairColor'] as String? ?? '#1A202C',
      skinColor: json['skinColor'] as String? ?? '#FBD38D',
      outfit: json['outfit'] as String? ?? 'casual',
      accessories: List<String>.from(json['accessories'] ?? []),
      level: json['level'] as int? ?? 1,
      xp: json['xp'] as int? ?? 0,
      badges: List<String>.from(json['badges'] ?? []),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'faceType': faceType,
      'eyeStyle': eyeStyle,
      'eyeColor': eyeColor,
      'mouthStyle': mouthStyle,
      'hairStyle': hairStyle,
      'hairColor': hairColor,
      'skinColor': skinColor,
      'outfit': outfit,
      'accessories': accessories,
      'level': level,
      'xp': xp,
      'badges': badges,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  AvatarModel copyWith({
    String? faceType,
    String? eyeStyle,
    String? eyeColor,
    String? mouthStyle,
    String? hairStyle,
    String? hairColor,
    String? skinColor,
    String? outfit,
    List<String>? accessories,
    int? level,
    int? xp,
    List<String>? badges,
    DateTime? lastUpdated,
  }) {
    return AvatarModel(
      faceType: faceType ?? this.faceType,
      eyeStyle: eyeStyle ?? this.eyeStyle,
      eyeColor: eyeColor ?? this.eyeColor,
      mouthStyle: mouthStyle ?? this.mouthStyle,
      hairStyle: hairStyle ?? this.hairStyle,
      hairColor: hairColor ?? this.hairColor,
      skinColor: skinColor ?? this.skinColor,
      outfit: outfit ?? this.outfit,
      accessories: accessories ?? this.accessories,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      badges: badges ?? this.badges,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // Get XP required for next level (simple formula: level * 100)
  int get xpToNextLevel => level * 100;

  // Check if avatar can level up
  bool get canLevelUp => xp >= xpToNextLevel;

  // Get current level progress (0.0 to 1.0)
  double get levelProgress => (xp % xpToNextLevel) / xpToNextLevel;
}
