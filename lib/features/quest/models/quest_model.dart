import 'package:flutter/material.dart';

/// Modelos para el sistema de misiones (Quests) de LifeVibes
/// Misiones basadas en la metodología Softvibes1

/// Tipo de misión
enum QuestType {
  daily,      // Misión diaria
  weekly,     // Misión semanal
  monthly,    // Misión mensual
  milestone,  // Milestone importante
  challenge,  // Desafío especial
}

/// Fase de Softvibes1
enum QuestPhase {
  ser,    // SER (Be)
  hacer,  // HACER (Do)
  tener,  // TENER (Have)
}

/// Dificultad de la misión
enum QuestDifficulty {
  easy,      // Fácil (20-50 XP)
  medium,    // Media (50-100 XP)
  hard,      // Difícil (100-200 XP)
  epic,      // Épica (200-500 XP)
}

/// Modelo de misión (Quest)
class QuestModel {
  final String questId;
  final String title;
  final String description;
  final String? instructions; // Instrucciones detalladas
  final QuestType type;
  final QuestPhase phase;
  final QuestDifficulty difficulty;
  final int xpReward;
  final List<String> badges; // Badges que otorga al completar
  final String status; // pending, in_progress, completed
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime? deadline;
  final int progress; // 0-100
  final String? userId; // Usuario asignado (null = disponible para todos)

  QuestModel({
    required this.questId,
    required this.title,
    required this.description,
    this.instructions,
    required this.type,
    required this.phase,
    required this.difficulty,
    required this.xpReward,
    this.badges = const [],
    this.status = 'pending',
    required this.createdAt,
    this.completedAt,
    this.deadline,
    this.progress = 0,
    this.userId,
  });

  factory QuestModel.fromJson(Map<String, dynamic> json) {
    return QuestModel(
      questId: json['questId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      instructions: json['instructions'] as String?,
      type: _parseQuestType(json['type'] as String? ?? 'daily'),
      phase: _parseQuestPhase(json['phase'] as String? ?? 'ser'),
      difficulty: _parseQuestDifficulty(json['difficulty'] as String? ?? 'easy'),
      xpReward: json['xpReward'] as int? ?? 50,
      badges: List<String>.from(json['badges'] ?? []),
      status: json['status'] as String? ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      progress: json['progress'] as int? ?? 0,
      userId: json['userId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questId': questId,
      'title': title,
      'description': description,
      'instructions': instructions,
      'type': type.name,
      'phase': phase.name,
      'difficulty': difficulty.name,
      'xpReward': xpReward,
      'badges': badges,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'progress': progress,
      'userId': userId,
    };
  }

  QuestModel copyWith({
    String? questId,
    String? title,
    String? description,
    String? instructions,
    QuestType? type,
    QuestPhase? phase,
    QuestDifficulty? difficulty,
    int? xpReward,
    List<String>? badges,
    String? status,
    DateTime? createdAt,
    DateTime? completedAt,
    DateTime? deadline,
    int? progress,
    String? userId,
  }) {
    return QuestModel(
      questId: questId ?? this.questId,
      title: title ?? this.title,
      description: description ?? this.description,
      instructions: instructions ?? this.instructions,
      type: type ?? this.type,
      phase: phase ?? this.phase,
      difficulty: difficulty ?? this.difficulty,
      xpReward: xpReward ?? this.xpReward,
      badges: badges ?? this.badges,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      deadline: deadline ?? this.deadline,
      progress: progress ?? this.progress,
      userId: userId ?? this.userId,
    );
  }

  // Getters útiles
  bool get isCompleted => status == 'completed';
  bool get isInProgress => status == 'in_progress';
  bool get isPending => status == 'pending';
  bool get hasDeadline => deadline != null;
  bool get isOverdue => hasDeadline && deadline!.isBefore(DateTime.now());

  String get typeLabel => _getTypeLabel(type);
  String get phaseLabel => _getPhaseLabel(phase);
  String get difficultyLabel => _getDifficultyLabel(difficulty);
  Color get difficultyColor => _getDifficultyColor(difficulty);

  static QuestType _parseQuestType(String type) {
    return QuestType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => QuestType.daily,
    );
  }

  static QuestPhase _parseQuestPhase(String phase) {
    return QuestPhase.values.firstWhere(
      (e) => e.name == phase,
      orElse: () => QuestPhase.ser,
    );
  }

  static QuestDifficulty _parseQuestDifficulty(String difficulty) {
    return QuestDifficulty.values.firstWhere(
      (e) => e.name == difficulty,
      orElse: () => QuestDifficulty.easy,
    );
  }

  static String _getTypeLabel(QuestType type) {
    switch (type) {
      case QuestType.daily:
        return 'Diaria';
      case QuestType.weekly:
        return 'Semanal';
      case QuestType.milestone:
        return 'Milestone';
      case QuestType.challenge:
        return 'Desafío';
    }
  }

  static String _getPhaseLabel(QuestPhase phase) {
    switch (phase) {
      case QuestPhase.ser:
        return 'SER';
      case QuestPhase.hacer:
        return 'HACER';
      case QuestPhase.tener:
        return 'TENER';
    }
  }

  static String _getDifficultyLabel(QuestDifficulty difficulty) {
    switch (difficulty) {
      case QuestDifficulty.easy:
        return 'Fácil';
      case QuestDifficulty.medium:
        return 'Media';
      case QuestDifficulty.hard:
        return 'Difícil';
      case QuestDifficulty.epic:
        return 'Épica';
    }
  }

  static Color _getDifficultyColor(QuestDifficulty difficulty) {
    switch (difficulty) {
      case QuestDifficulty.easy:
        return Colors.green;
      case QuestDifficulty.medium:
        return Colors.orange;
      case QuestDifficulty.hard:
        return Colors.red;
      case QuestDifficulty.epic:
        return Colors.purple;
    }
  }
}

/// Base de datos de misiones predefinidas
class QuestDatabase {
  static List<QuestModel> get allQuests => [
        ..._serQuests,
        ..._hacerQuests,
        ..._tenerQuests,
      ];

  /// Misiones de Fase SER (Be)
  static List<QuestModel> get _serQuests => [
        QuestModel(
          questId: 'ser_001',
          title: 'Define tu "Por Qué"',
          description: 'Escribe 3 párrafos sobre por qué haces lo que haces.',
          instructions: '''
1. Piensa en tu infancia: ¿Qué te hacía feliz?
2. Piensa en hoy: ¿Qué problemas te apasiona resolver?
3. Imagina el futuro: ¿Qué legado quieres dejar?

Escribe 3 párrafos reflexionando sobre estas preguntas.
''',
          type: QuestType.milestone,
          phase: QuestPhase.ser,
          difficulty: QuestDifficulty.medium,
          xpReward: 75,
          badges: ['purpose_discoverer'],
          createdAt: DateTime.now(),
        ),
        QuestModel(
          questId: 'ser_002',
          title: 'Identifica tus Valores',
          description: 'Selecciona 5 valores que definan tu esencia.',
          instructions: '''
De esta lista, elige los 5 valores más importantes para ti:

Autenticidad, Creatividad, Impacto, Libertad, Crecimiento,
Comunidad, Innovación, Excelencia, Trust, Generosidad,
Pasión, Resiliencia, Integridad, Humildad, Valor...

Reflexiona sobre por qué estos 5 son los más importantes.
''',
          type: QuestType.milestone,
          phase: QuestPhase.ser,
          difficulty: QuestDifficulty.easy,
          xpReward: 50,
          badges: ['values_master'],
          createdAt: DateTime.now(),
        ),
        QuestModel(
          questId: 'ser_003',
          title: 'Forja tu Superpoder',
          description: 'Convierte tu mejor habilidad en un superpoder único.',
          instructions: '''
1. ¿En qué eres el MEJOR?
2. ¿Cómo se diferencia de otros?
3. ¿Qué problema específico resuelve mejor que nadie?

Define tu superpoder con:
- NOMBRE (ej: "Simplificador de Lo Complejo")
- DESCRIPCIÓN (en 1 frase)
- PRUEBA SOCIAL (3 casos de éxito)
''',
          type: QuestType.milestone,
          phase: QuestPhase.ser,
          difficulty: QuestDifficulty.hard,
          xpReward: 150,
          badges: ['superpower_forger'],
          createdAt: DateTime.now(),
        ),
        QuestModel(
          questId: 'ser_004_daily',
          title: 'Reflexión Diaria',
          description: 'Escribe 3 gratitudes y 1 aprendizaje del día.',
          type: QuestType.daily,
          phase: QuestPhase.ser,
          difficulty: QuestDifficulty.easy,
          xpReward: 25,
          createdAt: DateTime.now(),
        ),
      ];

  /// Misiones de Fase HACER (Do)
  static List<QuestModel> get _hacerQuests => [
        QuestModel(
          questId: 'hacer_001',
          title: 'Crea tu Primer Contenido',
          description: 'Publica algo que aporte valor a tu audiencia.',
          instructions: '''
1. Elige un tópico de tu estrategia de contenido
2. Crea un post/video (formato que prefieras)
3. Publica en tu plataforma favorita
4. Anota los resultados (likes, comentarios, shares)

Mínimo: 1 contenido esta semana.
''',
          type: QuestType.daily,
          phase: QuestPhase.hacer,
          difficulty: QuestDifficulty.medium,
          xpReward: 60,
          badges: ['content_creator'],
          createdAt: DateTime.now(),
        ),
        QuestModel(
          questId: 'hacer_002',
          title: 'Conecta con 3 Personas',
          description: 'Reach out y ofrece valor primero.',
          instructions: '''
Encuentra 3 personas en tu nicho y:

1. Comenta en su contenido (agrega valor, no solo "nice")
2. Envía un DM con:
   - Algo específico que te gustó de su trabajo
   - Una pregunta genuina o oferta de ayuda
   - NADA de pitches o ventas

Meta: 3 conversaciones genuinas esta semana.
''',
          type: QuestType.weekly,
          phase: QuestPhase.hacer,
          difficulty: QuestDifficulty.medium,
          xpReward: 100,
          badges: ['networker'],
          createdAt: DateTime.now(),
        ),
        QuestModel(
          questId: 'hacer_003',
          title: 'Construye tu Embudo',
          description: 'Diseña tu primer funnel: Lead Magnet → Email → Offer.',
          instructions: '''
1. LEAD MAGNET: ¿Qué puedes dar GRATIS que resuelva un problema pequeño?
2. EMAIL SEQUENCE: 3-5 emails que nutren la relación
3. OFFER: Tu primer producto digital ($7-$77)

Escribe cada componente. No necesitas implementarlo todavía.
''',
          type: QuestType.milestone,
          phase: QuestPhase.hacer,
          difficulty: QuestDifficulty.hard,
          xpReward: 200,
          badges: ['funnel_builder'],
          createdAt: DateTime.now(),
        ),
      ];

  /// Misiones de Fase TENER (Have)
  static List<QuestModel> get _tenerQuests => [
        QuestModel(
          questId: 'tener_001',
          title: 'Lanza tu Primer Producto',
          description: 'Publica tu primer DBY (Done-By-You) producto.',
          instructions: '''
1. Crea un producto digital (ebook, curso, template)
2. Define el precio ($7-$77)
3. Crea una landing page básica
4. Haz 3 ventas

Tip: Empieza pequeño. Un $7 ebook es mejor que un producto perfecto que nunca lanza.
''',
          type: QuestType.milestone,
          phase: QuestPhase.tener,
          difficulty: QuestDifficulty.epic,
          xpReward: 500,
          badges: ['product_launcher', 'entrepreneur'],
          createdAt: DateTime.now(),
        ),
        QuestModel(
          questId: 'tener_002',
          title: 'Alcanza $100 en Ventas',
          description: 'Genera $100 en ventas este mes.',
          type: QuestType.monthly,
          phase: QuestPhase.tener,
          difficulty: QuestDifficulty.hard,
          xpReward: 300,
          badges: ['hundred_club'],
          createdAt: DateTime.now(),
        ),
        QuestModel(
          questId: 'tener_003',
          title: 'Consigue tu Primer Cliente DWY',
          description: 'Cierra tu primer cliente de mentoría grupal ($97-$497).',
          type: QuestType.milestone,
          phase: QuestPhase.tener,
          difficulty: QuestDifficulty.epic,
          xpReward: 750,
          badges: ['first_client'],
          createdAt: DateTime.now(),
        ),
      ];

  /// Generar misión aleatoria basada en fase del usuario
  static QuestModel generateRandomQuest(QuestPhase phase, QuestDifficulty? difficulty) {
    final phaseQuests = allQuests.where((q) => q.phase == phase).toList();
    final filteredQuests = difficulty != null
        ? phaseQuests.where((q) => q.difficulty == difficulty).toList()
        : phaseQuests;

    if (filteredQuests.isEmpty) return phaseQuests.first;

    final randomIndex = DateTime.now().millisecondsSinceEpoch % filteredQuests.length;
    return filteredQuests[randomIndex];
  }

  /// Misiones diarias predefinidas
  static List<QuestModel> get dailyQuests => [
        QuestModel(
          questId: 'daily_001',
          title: 'Reflexión Diaria',
          description: 'Escribe 3 gratitudes y 1 aprendizaje del día.',
          type: QuestType.daily,
          phase: QuestPhase.ser,
          difficulty: QuestDifficulty.easy,
          xpReward: 25,
          createdAt: DateTime.now(),
        ),
        QuestModel(
          questId: 'daily_002',
          title: 'Aprende Algo Nuevo',
          description: 'Dedica 30 minutos a aprender una habilidad nueva.',
          type: QuestType.daily,
          phase: QuestPhase.hacer,
          difficulty: QuestDifficulty.easy,
          xpReward: 30,
          createdAt: DateTime.now(),
        ),
        QuestModel(
          questId: 'daily_003',
          title: 'Reach Out',
          description: 'Conecta con 1 persona nueva y ofrece valor.',
          type: QuestType.daily,
          phase: QuestPhase.hacer,
          difficulty: QuestDifficulty.medium,
          xpReward: 40,
          createdAt: DateTime.now(),
        ),
        QuestModel(
          questId: 'daily_004',
          title: 'Vende Algo',
          description: 'Hace 1 intento de venta (outbound o inbound).',
          type: QuestType.daily,
          phase: QuestPhase.tener,
          difficulty: QuestDifficulty.medium,
          xpReward: 50,
          createdAt: DateTime.now(),
        ),
      ];

  /// Seleccionar misión diaria aleatoria
  static QuestModel getDailyQuest() {
    final randomIndex = DateTime.now().millisecondsSinceEpoch % dailyQuests.length;
    return dailyQuests[randomIndex];
  }
}
