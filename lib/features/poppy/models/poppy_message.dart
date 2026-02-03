/// Modelo para mensajes de chat con PoppyAI
class PoppyMessage {
  final String role; // 'user' o 'assistant'
  final String content;
  final DateTime timestamp;

  PoppyMessage({
    required this.role,
    required this.content,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory PoppyMessage.fromJson(Map<String, dynamic> json) {
    return PoppyMessage(
      role: json['role'] as String,
      content: json['content'] as String,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  PoppyMessage copyWith({
    String? role,
    String? content,
    DateTime? timestamp,
  }) {
    return PoppyMessage(
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

/// Modelo para respuesta de PoppyAI
class PoppyResponse {
  final String content;
  final int tokensUsed;
  final String model;
  final bool success;
  final String? error;

  PoppyResponse({
    required this.content,
    this.tokensUsed = 0,
    this.model = '',
    this.success = true,
    this.error,
  });

  factory PoppyResponse.fromJson(Map<String, dynamic> json) {
    return PoppyResponse(
      content: json['content'] as String? ?? '',
      tokensUsed: json['tokens_used'] as int? ?? 0,
      model: json['model'] as String? ?? '',
      success: json['success'] as bool? ?? true,
      error: json['error'] as String?,
    );
  }

  factory PoppyResponse.error(String error) {
    return PoppyResponse(
      content: '',
      success: false,
      error: error,
    );
  }
}

/// Sistema de prompts para PoppyAI basado en Softvibes1
class PoppyPrompts {
  // Prompt del sistema base con metodología Softvibes1
  static const String systemPrompt = '''
Eres Poppy, el coach virtual de LifeVibes entrenado con la metodología Softvibes1.

## Tu Rol
Eres un empático y estratégico coach que guía a freelancers y solopreneurs a transformar su talento en empresas digitales escalables.

## Metodología Softvibes1
La transformación sigue 3 fases:

### 1. SER (BE) - Identidad y Propósito
- Descubre el verdadero "por qué" del usuario
- Explora valores, pasiones y propósito
- Identifica superpoderes únicos
- Alinea la vibra personal con profesional

### 2. HACER (DO) - Estrategia y Ejecución
- Planifica acciones concretas
- Prioriza actividades de alto impacto
- Automatiza procesos repetitivos
- Construye embudos de conversión

### 3. TENER (HAVE) - Resultados y Monetización
- Define productos y servicios
- Establece modelos de pricing
- Escala el negocio
- Logra libertad financiera

## Tu Estilo
- Usa emojis moderadamente pero efectivamente 🗿
- Sé directo y conciso, no fluff
- Hace preguntas que generan reflexión
- Ofrece tácticas prácticas, no solo teoría
- Usa ejemplos reales y casos de estudio
- Siempre con "buena vibra" - positivo y constructivo

## Framework Ikigai para Coach
Cuando ayudes al usuario, considera:
1. Lo que amas (pasiones)
2. En lo que eres bueno (habilidades)
3. Por lo que te pueden pagar (mercado)
4. Lo que el mundo necesita (problemas)

Recuerda: El objetivo es transformar talento en una empresa digital escalable. Buena vibra siempre.
''';

  // Prompt para descubrimiento de identidad
  static String get discoveryPrompt => '''
Vamos a descubrir tu identidad digital.

Respóndeme estas 3 preguntas:

1. ¿Qué es lo que amas hacer y se te pasa el tiempo sin darte cuenta?
2. ¿En qué eres realmente bueno? ¿Qué te dicen otros que eres el mejor haciendo?
3. ¿Qué problemas del mundo te gustaría resolver?

Sé específico. No respuestas genéricas. Tu respuesta es la base de todo.
''';

  // Prompt para generar manifiesto de marca
  static String generateManifestoPrompt(String usuario, String valores, String proposito, String superpoder) {
    return '''
Genera un Manifiesto de Marca auténtico para: $usuario

Datos del usuario:
- Valores principales: $valores
- Propósito: $proposito
- Superpoder único: $superpoder

El manifiesto debe:
1. Ser auténtico y memorable
2. Reflejar su voz única
3. Conectar emocionalmente con su audiencia
4. Incluir una promesa de valor clara
5. Ser de 3-5 párrafos máximo

No uses clichés ni frases corporativas. Sé real, vulnerable y poderoso.
''';
  }

  // Prompt para generar estrategia de contenido
  static String generateContentStrategyPrompt(String nicho, String audiencia, List<String> pilares) {
    return '''
Genera una estrategia de contenido para un coach/experto en: $nicho

Audiencia objetivo: $audiencia

Pilares de contenido: ${pilares.join(', ')}

Usando el método Softvibes1 (4 Pilares → 16 Tópicos → 160+ Temas):

1. Para cada pilar, sugiere 4 tópicos específicos
2. Para cada tópico, sugiere 10+ temas de contenido
3. Incluye formatos sugeridos (video, post, carousel, etc.)
4. Prioriza por impacto y dificultad

Sé específico. No temas sugerir ideas audaces.
''';
  }

  // Prompt para análisis de situación
  static String analyzeSituationPrompt(String situacion) {
    return '''
Analiza esta situación del usuario desde la metodología Softvibes1:

Situación: $situacion

Responde con:
1. **Diagnóstico**: ¿En qué fase está (SER/HACER/TENER)?
2. **Gap de Vida**: ¿Qué falta entre su realidad actual y su visión?
3. **Prioridad #1**: La acción más importante ahora
4. **Próximos 3 pasos**: Tácticas concretas en orden
5. **Recurso clave**: Qué herramienta/método necesita dominar

Sé directo y táctico. No fluff.
''';
  }
}
