/// Modelos para el sistema de embudos (Funnels) de LifeVibes
/// Webinar funnels, quest sequences, y funnels de conversión

/// Tipo de funnel
enum FunnelType {
  webinar,      // Webinar funnel
  leadMagnet,   // Lead magnet funnel
  product,      // Product launch funnel
  webinarSequence, // Webinar como secuencia de quests
}

/// Estado del funnel
enum FunnelStatus {
  draft,        // Borrador
  active,       // Activo
  paused,       // Pausado
  completed,    // Completado
}

/// Paso del funnel
class FunnelStep {
  final String stepId;
  final String title;
  final String description;
  final int order; // Orden en el funnel
  final String type; // lead_capture, email_nurture, webinar, sales_call, etc.
  final Map<String, dynamic> config; // Configuración específica del paso
  final String? questId; // Si es un paso tipo quest
  final bool isCompleted;

  FunnelStep({
    required this.stepId,
    required this.title,
    required this.description,
    required this.order,
    required this.type,
    this.config = const {},
    this.questId,
    this.isCompleted = false,
  });

  factory FunnelStep.fromJson(Map<String, dynamic> json) {
    return FunnelStep(
      stepId: json['stepId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      order: json['order'] as int? ?? 0,
      type: json['type'] as String? ?? 'generic',
      config: Map<String, dynamic>.from(json['config'] ?? {}),
      questId: json['questId'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stepId': stepId,
      'title': title,
      'description': description,
      'order': order,
      'type': type,
      'config': config,
      'questId': questId,
      'isCompleted': isCompleted,
    };
  }

  FunnelStep copyWith({
    String? stepId,
    String? title,
    String? description,
    int? order,
    String? type,
    Map<String, dynamic>? config,
    String? questId,
    bool? isCompleted,
  }) {
    return FunnelStep(
      stepId: stepId ?? this.stepId,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      type: type ?? this.type,
      config: config ?? this.config,
      questId: questId ?? this.questId,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// Métricas del funnel
class FunnelMetrics {
  final String funnelId;
  final int totalVisitors;      // Visitantes totales
  final int leadsCaptured;     // Leads capturados
  final int webinarsRegistered; // Registrados al webinar
  final int webinarsAttended;  // Asistentes al webinar
  final int sales;              // Ventas
  final double conversionRate;   // Tasa de conversión (%)
  final DateTime? lastUpdated;

  FunnelMetrics({
    required this.funnelId,
    this.totalVisitors = 0,
    this.leadsCaptured = 0,
    this.webinarsRegistered = 0,
    this.webinarsAttended = 0,
    this.sales = 0,
    this.conversionRate = 0.0,
    this.lastUpdated,
  });

  factory FunnelMetrics.fromJson(Map<String, dynamic> json) {
    return FunnelMetrics(
      funnelId: json['funnelId'] as String,
      totalVisitors: json['totalVisitors'] as int? ?? 0,
      leadsCaptured: json['leadsCaptured'] as int? ?? 0,
      webinarsRegistered: json['webinarsRegistered'] as int? ?? 0,
      webinarsAttended: json['webinarsAttended'] as int? ?? 0,
      sales: json['sales'] as int? ?? 0,
      conversionRate: (json['conversionRate'] as num?)?.toDouble() ?? 0.0,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'funnelId': funnelId,
      'totalVisitors': totalVisitors,
      'leadsCaptured': leadsCaptured,
      'webinarsRegistered': webinarsRegistered,
      'webinarsAttended': webinarsAttended,
      'sales': sales,
      'conversionRate': conversionRate,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  /// Calcular tasa de conversión
  double calculateConversionRate() {
    if (totalVisitors == 0) return 0.0;
    return (sales / totalVisitors) * 100;
  }

  /// Calcular tasa de lead capture
  double get leadCaptureRate {
    if (totalVisitors == 0) return 0.0;
    return (leadsCaptured / totalVisitors) * 100;
  }

  /// Calcular tasa de asistencia al webinar
  double get webinarAttendanceRate {
    if (webinarsRegistered == 0) return 0.0;
    return (webinarsAttended / webinarsRegistered) * 100;
  }
}

/// Modelo de Funnel
class FunnelModel {
  final String funnelId;
  final String userId;
  final String title;
  final String description;
  final FunnelType type;
  final FunnelStatus status;
  final List<FunnelStep> steps;
  final FunnelMetrics metrics;
  final String? targetProduct; // ID del producto (si aplica)
  final String? leadMagnet; // Lead magnet (si aplica)
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? startDate; // Fecha de inicio (si es programado)
  final DateTime? endDate;   // Fecha de fin

  FunnelModel({
    required this.funnelId,
    required this.userId,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    this.steps = const [],
    required this.metrics,
    this.targetProduct,
    this.leadMagnet,
    required this.createdAt,
    this.updatedAt,
    this.startDate,
    this.endDate,
  });

  factory FunnelModel.fromJson(Map<String, dynamic> json) {
    return FunnelModel(
      funnelId: json['funnelId'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: _parseFunnelType(json['type'] as String? ?? 'webinar'),
      status: _parseFunnelStatus(json['status'] as String? ?? 'draft'),
      steps: (json['steps'] as List<dynamic>?)
              ?.map((s) => FunnelStep.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      metrics: FunnelMetrics.fromJson(
        json['metrics'] as Map<String, dynamic>? ?? {},
      ),
      targetProduct: json['targetProduct'] as String?,
      leadMagnet: json['leadMagnet'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'funnelId': funnelId,
      'userId': userId,
      'title': title,
      'description': description,
      'type': type.name,
      'status': status.name,
      'steps': steps.map((s) => s.toJson()).toList(),
      'metrics': metrics.toJson(),
      'targetProduct': targetProduct,
      'leadMagnet': leadMagnet,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  FunnelModel copyWith({
    String? funnelId,
    String? userId,
    String? title,
    String? description,
    FunnelType? type,
    FunnelStatus? status,
    List<FunnelStep>? steps,
    FunnelMetrics? metrics,
    String? targetProduct,
    String? leadMagnet,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return FunnelModel(
      funnelId: funnelId ?? this.funnelId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      steps: steps ?? this.steps,
      metrics: metrics ?? this.metrics,
      targetProduct: targetProduct ?? this.targetProduct,
      leadMagnet: leadMagnet ?? this.leadMagnet,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  // Getters útiles
  bool get isDraft => status == FunnelStatus.draft;
  bool get isActive => status == FunnelStatus.active;
  bool get isPaused => status == FunnelStatus.paused;
  bool get isCompleted => status == FunnelStatus.completed;

  String get typeLabel => _getTypeLabel(type);
  String get statusLabel => _getStatusLabel(status);
  Color get statusColor => _getStatusColor(status);

  static FunnelType _parseFunnelType(String type) {
    return FunnelType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => FunnelType.webinar,
    );
  }

  static FunnelStatus _parseFunnelStatus(String status) {
    return FunnelStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => FunnelStatus.draft,
    );
  }

  static String _getTypeLabel(FunnelType type) {
    switch (type) {
      case FunnelType.webinar:
        return 'Webinar';
      case FunnelType.leadMagnet:
        return 'Lead Magnet';
      case FunnelType.product:
        return 'Product Launch';
      case FunnelType.webinarSequence:
        return 'Webinar Sequence';
    }
  }

  static String _getStatusLabel(FunnelStatus status) {
    switch (status) {
      case FunnelStatus.draft:
        return 'Borrador';
      case FunnelStatus.active:
        return 'Activo';
      case FunnelStatus.paused:
        return 'Pausado';
      case FunnelStatus.completed:
        return 'Completado';
    }
  }

  static Color _getStatusColor(FunnelStatus status) {
    switch (status) {
      case FunnelStatus.draft:
        return Colors.grey;
      case FunnelStatus.active:
        return Colors.green;
      case FunnelStatus.paused:
        return Colors.orange;
      case FunnelStatus.completed:
        return Colors.blue;
    }
  }
}

/// Plantillas predefinidas de funnels
class FunnelTemplates {
  /// Webinar funnel básico
  static FunnelModel get webinarTemplate {
    final now = DateTime.now();
    return FunnelModel(
      funnelId: 'template_webinar',
      userId: '',
      title: 'Webinar Funnel Básico',
      description: 'Funnel para webinar con lead magnet y venta',
      type: FunnelType.webinar,
      status: FunnelStatus.draft,
      steps: [
        FunnelStep(
          stepId: 'step_1',
          title: 'Landing Page de Webinar',
          description: 'Página de registro para el webinar',
          order: 1,
          type: 'lead_capture',
          config: {
            'headline': 'Webinar: [Título del Webinar]',
            'callToAction': 'Regístrate Gratis',
            'fields': ['name', 'email'],
          },
        ),
        FunnelStep(
          stepId: 'step_2',
          title: 'Email de Confirmación',
          description: 'Envía email de confirmación y link al webinar',
          order: 2,
          type: 'email_nurture',
          config: {
            'subject': 'Confirmación: Tu registro al webinar',
            'includeCalendarInvite': true,
          },
        ),
        FunnelStep(
          stepId: 'step_3',
          title: 'Recordatorio 1h antes',
          description: 'Recordatorio 1 hora antes del webinar',
          order: 3,
          type: 'email_nurture',
          config: {
            'subject': 'El webinar empieza en 1 hora',
            'sendBefore': 60, // minutos
          },
        ),
        FunnelStep(
          stepId: 'step_4',
          title: 'Live Webinar',
          description: 'Sesión en vivo del webinar',
          order: 4,
          type: 'webinar',
          config: {
            'duration': 60, // minutos
            'recordingEnabled': true,
          },
        ),
        FunnelStep(
          stepId: 'step_5',
          title: 'Oferta Especial',
          description: 'Oferta especial para asistentes',
          order: 5,
          type: 'sales_call',
          config: {
            'headline': 'Oferta Exclusiva para Asistentes',
            'discount': 30, // 30% descuento
            'expiresAfter': 48, // horas
          },
        ),
        FunnelStep(
          stepId: 'step_6',
          title: 'Follow-up Email',
          description: 'Email de seguimiento a no compradores',
          order: 6,
          type: 'email_nurture',
          config: {
            'subject': '¿Qué te pareció el webinar?',
            'sendAfter': 24, // horas
          },
        ),
      ],
      metrics: FunnelMetrics(
        funnelId: 'template_webinar',
      ),
      createdAt: now,
    );
  }

  /// Lead magnet funnel
  static FunnelModel get leadMagnetTemplate {
    final now = DateTime.now();
    return FunnelModel(
      funnelId: 'template_lead_magnet',
      userId: '',
      title: 'Lead Magnet Funnel',
      description: 'Funnel para capturar leads con un recurso gratuito',
      type: FunnelType.leadMagnet,
      status: FunnelStatus.draft,
      steps: [
        FunnelStep(
          stepId: 'step_1',
          title: 'Landing Page del Lead Magnet',
          description: 'Página para descargar el recurso gratuito',
          order: 1,
          type: 'lead_capture',
          config: {
            'headline': 'Descarga Gratis: [Nombre del Recurso]',
            'callToAction': 'Descargar Ahora',
            'deliveryMethod': 'email',
          },
        ),
        FunnelStep(
          stepId: 'step_2',
          title: 'Email de Entrega',
          description: 'Envía el recurso por email',
          order: 2,
          type: 'email_nurture',
          config: {
            'subject': 'Aquí está tu recurso gratuito',
            'attachResource': true,
          },
        ),
        FunnelStep(
          stepId: 'step_3',
          title: 'Nurture Sequence',
          description: 'Secuencia de emails para educar y vender',
          order: 3,
          type: 'email_nurture',
          config: {
            'numberOfEmails': 5,
            'intervalDays': 2,
          },
        ),
      ],
      metrics: FunnelMetrics(
        funnelId: 'template_lead_magnet',
      ),
      createdAt: now,
    );
  }

  /// Webinar sequence (quests)
  static FunnelModel get webinarSequenceTemplate {
    final now = DateTime.now();
    return FunnelModel(
      funnelId: 'template_webinar_sequence',
      userId: '',
      title: 'Webinar como Secuencia de Quests',
      description: 'Convierte el webinar en una secuencia de misiones',
      type: FunnelType.webinarSequence,
      status: FunnelStatus.draft,
      steps: [
        FunnelStep(
          stepId: 'step_1',
          title: 'Quest: Planificar Webinar',
          description: 'Planifica el contenido del webinar',
          order: 1,
          type: 'quest',
          config: {
            'xpReward': 100,
            'badges': ['webinar_planner'],
          },
          questId: 'quest_webinar_plan',
        ),
        FunnelStep(
          stepId: 'step_2',
          title: 'Quest: Crear Landing Page',
          description: 'Crea la landing page de registro',
          order: 2,
          type: 'quest',
          config: {
            'xpReward': 150,
            'badges': ['landing_page_creator'],
          },
          questId: 'quest_landing_page',
        ),
        FunnelStep(
          stepId: 'step_3',
          title: 'Quest: Configurar Emails',
          description: 'Configura la secuencia de emails',
          order: 3,
          type: 'quest',
          config: {
            'xpReward': 100,
            'badges': ['email_configurator'],
          },
          questId: 'quest_email_setup',
        ),
        FunnelStep(
          stepId: 'step_4',
          title: 'Quest: Promocionar Webinar',
          description: 'Promociona el webinar en redes',
          order: 4,
          type: 'quest',
          config: {
            'xpReward': 200,
            'badges': ['webinar_promoter'],
          },
          questId: 'quest_promote_webinar',
        ),
        FunnelStep(
          stepId: 'step_5',
          title: 'Quest: Hacer Webinar Live',
          description: 'Realiza el webinar en vivo',
          order: 5,
          type: 'quest',
          config: {
            'xpReward': 300,
            'badges': ['webinar_host'],
          },
          questId: 'quest_host_webinar',
        ),
      ],
      metrics: FunnelMetrics(
        funnelId: 'template_webinar_sequence',
      ),
      createdAt: now,
    );
  }

  /// Generar funnel aleatorio basado en fase del usuario
  static FunnelModel generateForPhase(String phase) {
    switch (phase) {
      case 'SER':
        return leadMagnetTemplate;
      case 'HACER':
        return webinarTemplate;
      case 'TENER':
        return webinarSequenceTemplate;
      default:
        return webinarTemplate;
    }
  }
}
