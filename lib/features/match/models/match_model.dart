/// Modelos para el sistema de matches de LifeVibes
/// Basado en el algoritmo Softvibes de compatibilidad

/// Perfil de usuario para mostrar en el sistema de match
class UserProfile {
  final String userId;
  final String displayName;
  final String? photoURL;
  final int level;
  final String currentPhase; // SER, HACER, TENER
  final List<String> values; // Valores del usuario
  final String purpose; // Propósito del usuario
  final List<String> skills; // Habilidades del usuario
  final List<String> interests; // Intereses del usuario

  UserProfile({
    required this.userId,
    required this.displayName,
    this.photoURL,
    required this.level,
    required this.currentPhase,
    this.values = const [],
    this.purpose = '',
    this.skills = const [],
    this.interests = const [],
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String? ?? '',
      photoURL: json['photoURL'] as String?,
      level: json['level'] as int? ?? 1,
      currentPhase: json['currentPhase'] as String? ?? 'SER',
      values: List<String>.from(json['values'] ?? []),
      purpose: json['purpose'] as String? ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      interests: List<String>.from(json['interests'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      'photoURL': photoURL,
      'level': level,
      'currentPhase': currentPhase,
      'values': values,
      'purpose': purpose,
      'skills': skills,
      'interests': interests,
    };
  }

  UserProfile copyWith({
    String? userId,
    String? displayName,
    String? photoURL,
    int? level,
    String? currentPhase,
    List<String>? values,
    String? purpose,
    List<String>? skills,
    List<String>? interests,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      level: level ?? this.level,
      currentPhase: currentPhase ?? this.currentPhase,
      values: values ?? this.values,
      purpose: purpose ?? this.purpose,
      skills: skills ?? this.skills,
      interests: interests ?? this.interests,
    );
  }
}

/// Modelo de match entre dos usuarios
class MatchModel {
  final String matchId;
  final String userId1;
  final String userId2;
  final int matchScore; // 0-100
  final DateTime matchDate;
  final String status; // pending, accepted, rejected, completed
  final MatchBreakdown? breakdown; // Desglose del puntaje

  MatchModel({
    required this.matchId,
    required this.userId1,
    required this.userId2,
    required this.matchScore,
    required this.matchDate,
    this.status = 'pending',
    this.breakdown,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      matchId: json['matchId'] as String,
      userId1: json['userId1'] as String,
      userId2: json['userId2'] as String,
      matchScore: json['matchScore'] as int? ?? 0,
      matchDate: json['matchDate'] != null
          ? DateTime.parse(json['matchDate'] as String)
          : DateTime.now(),
      status: json['status'] as String? ?? 'pending',
      breakdown: json['breakdown'] != null
          ? MatchBreakdown.fromJson(json['breakdown'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'userId1': userId1,
      'userId2': userId2,
      'matchScore': matchScore,
      'matchDate': matchDate.toIso8601String(),
      'status': status,
      if (breakdown != null) 'breakdown': breakdown!.toJson(),
    };
  }

  /// Check if match is high compatibility (80+)
  bool get isHighCompatibility => matchScore >= 80;

  /// Check if match is medium compatibility (60-79)
  bool get isMediumCompatibility => matchScore >= 60 && matchScore < 80;

  /// Get compatibility label
  String get compatibilityLabel {
    if (matchScore >= 90) return 'Excelente';
    if (matchScore >= 80) return 'Muy Alta';
    if (matchScore >= 70) return 'Alta';
    if (matchScore >= 60) return 'Media';
    if (matchScore >= 40) return 'Baja';
    return 'Muy Baja';
  }

  MatchModel copyWith({
    String? matchId,
    String? userId1,
    String? userId2,
    int? matchScore,
    DateTime? matchDate,
    String? status,
    MatchBreakdown? breakdown,
  }) {
    return MatchModel(
      matchId: matchId ?? this.matchId,
      userId1: userId1 ?? this.userId1,
      userId2: userId2 ?? this.userId2,
      matchScore: matchScore ?? this.matchScore,
      matchDate: matchDate ?? this.matchDate,
      status: status ?? this.status,
      breakdown: breakdown ?? this.breakdown,
    );
  }
}

/// Desglose del puntaje de match
class MatchBreakdown {
  final int commonValuesScore; // 0-40
  final int alignedPurposeScore; // 0-30
  final int complementarySkillsScore; // 0-20
  final int similarInterestsScore; // 0-10
  final String explanation;

  MatchBreakdown({
    required this.commonValuesScore,
    required this.alignedPurposeScore,
    required this.complementarySkillsScore,
    required this.similarInterestsScore,
    required this.explanation,
  });

  factory MatchBreakdown.fromJson(Map<String, dynamic> json) {
    return MatchBreakdown(
      commonValuesScore: json['commonValuesScore'] as int? ?? 0,
      alignedPurposeScore: json['alignedPurposeScore'] as int? ?? 0,
      complementarySkillsScore: json['complementarySkillsScore'] as int? ?? 0,
      similarInterestsScore: json['similarInterestsScore'] as int? ?? 0,
      explanation: json['explanation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commonValuesScore': commonValuesScore,
      'alignedPurposeScore': alignedPurposeScore,
      'complementarySkillsScore': complementarySkillsScore,
      'similarInterestsScore': similarInterestsScore,
      'explanation': explanation,
    };
  }

  /// Get total score
  int get totalScore =>
      commonValuesScore +
      alignedPurposeScore +
      complementarySkillsScore +
      similarInterestsScore;
}

/// Algoritmo de Match Softvibes
/// Calcula compatibilidad entre dos usuarios
class SoftvibesMatchAlgorithm {
  /// Calcula el puntaje de match entre dos usuarios
  static MatchBreakdown calculateMatch({
    required UserProfile user1,
    required UserProfile user2,
  }) {
    // 1. Valores comunes (40% del total)
    final commonValuesScore = _calculateCommonValuesScore(
      user1.values,
      user2.values,
    );

    // 2. Propósitos alineados (30% del total)
    final alignedPurposeScore = _calculateAlignedPurposeScore(
      user1.purpose,
      user2.purpose,
    );

    // 3. Habilidades complementarias (20% del total)
    final complementarySkillsScore = _calculateComplementarySkillsScore(
      user1.skills,
      user2.skills,
    );

    // 4. Intereses similares (10% del total)
    final similarInterestsScore = _calculateSimilarInterestsScore(
      user1.interests,
      user2.interests,
    );

    // Generar explicación
    final explanation = _generateExplanation(
      commonValuesScore: commonValuesScore,
      alignedPurposeScore: alignedPurposeScore,
      complementarySkillsScore: complementarySkillsScore,
      similarInterestsScore: similarInterestsScore,
    );

    return MatchBreakdown(
      commonValuesScore: commonValuesScore,
      alignedPurposeScore: alignedPurposeScore,
      complementarySkillsScore: complementarySkillsScore,
      similarInterestsScore: similarInterestsScore,
      explanation: explanation,
    );
  }

  /// Calcula puntaje de valores comunes (0-40)
  static int _calculateCommonValuesScore(List<String> values1, List<String> values2) {
    if (values1.isEmpty || values2.isEmpty) return 0;

    // Encontrar valores comunes
    final commonValues = values1.where((v) => values2.contains(v)).toList();

    // Calcular porcentaje de valores comunes
    final totalValues = (values1.length + values2.length) / 2;
    final commonPercentage = commonValues.length / totalValues;

    // Convertir a puntaje 0-40
    return (commonPercentage * 40).round();
  }

  /// Calcula puntaje de propósitos alineados (0-30)
  static int _calculateAlignedPurposeScore(String purpose1, String purpose2) {
    if (purpose1.isEmpty || purpose2.isEmpty) return 0;

    // Comparar propósitos por palabras clave
    final words1 = _extractKeywords(purpose1);
    final words2 = _extractKeywords(purpose2);

    final commonWords = words1.where((w) => words2.contains(w)).toList();
    final totalWords = (words1.length + words2.length) / 2;
    final commonPercentage = commonWords.length / totalWords;

    return (commonPercentage * 30).round();
  }

  /// Calcula puntaje de habilidades complementarias (0-20)
  static int _calculateComplementarySkillsScore(
    List<String> skills1,
    List<String> skills2,
  ) {
    if (skills1.isEmpty || skills2.isEmpty) return 0;

    // Penalizar habilidades idénticas (no son complementarias)
    final identicalSkills = skills1.where((s) => skills2.contains(s)).toList();

    // Bonus por habilidades complementarias (sin palabras clave comunes)
    final uniqueSkills1 = skills1.where((s) => !skills2.contains(s)).toList();
    final uniqueSkills2 = skills2.where((s) => !skills1.contains(s)).toList();

    // Calcular puntaje basado en unicidad
    final totalUniqueSkills = uniqueSkills1.length + uniqueSkills2.length;
    const maxUniqueSkills = 10; // Asumimos máximo 10 habilidades únicas por usuario

    final uniquePercentage = (totalUniqueSkills / (maxUniqueSkills * 2)).clamp(0, 1);
    return (uniquePercentage * 20).round();
  }

  /// Calcula puntaje de intereses similares (0-10)
  static int _calculateSimilarInterestsScore(
    List<String> interests1,
    List<String> interests2,
  ) {
    if (interests1.isEmpty || interests2.isEmpty) return 0;

    final commonInterests = interests1.where((i) => interests2.contains(i)).toList();
    final totalInterests = (interests1.length + interests2.length) / 2;
    final commonPercentage = commonInterests.length / totalInterests;

    return (commonPercentage * 10).round();
  }

  /// Extrae palabras clave de un texto
  static List<String> _extractKeywords(String text) {
    // Palabras vacías en español
    const stopWords = {
      'el', 'la', 'de', 'que', 'y', 'a', 'en', 'un', 'es', 'se', 'no',
      'habia', 'era', 'para', 'con', 'su', 'por', 'le', 'esta', 'pero',
      'sus', 'cuando', 'muy', 'sin', 'sobre', 'este', 'ya', 'entre',
    };

    // Extraer palabras, limpiar y filtrar
    final words = text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .split(' ')
        .where((w) => w.length > 3 && !stopWords.contains(w))
        .toList();

    return words;
  }

  /// Genera explicación del match
  static String _generateExplanation({
    required int commonValuesScore,
    required int alignedPurposeScore,
    required int complementarySkillsScore,
    required int similarInterestsScore,
  }) {
    final explanation = StringBuffer();

    // Valores comunes
    if (commonValuesScore >= 30) {
      explanation.writeln('✨ Tienen valores muy alineados.');
    } else if (commonValuesScore >= 20) {
      explanation.writeln('👍 Comparten varios valores importantes.');
    }

    // Propósito alineado
    if (alignedPurposeScore >= 20) {
      explanation.writeln('🎯 Sus propósitos están muy bien alineados.');
    } else if (alignedPurposeScore >= 15) {
      explanation.writeln('🎯 Tienen propósitos similares.');
    }

    // Habilidades complementarias
    if (complementarySkillsScore >= 15) {
      explanation.writeln('🔗 Sus habilidades son muy complementarias.');
    } else if (complementarySkillsScore >= 10) {
      explanation.writeln('🔗 Pueden complementarse mutuamente.');
    }

    // Intereses similares
    if (similarInterestsScore >= 7) {
      explanation.writeln('❤️ Comparten muchos intereses.');
    } else if (similarInterestsScore >= 5) {
      explanation.writeln('❤️ Tienen intereses en común.');
    }

    return explanation.toString().trim();
  }
}
