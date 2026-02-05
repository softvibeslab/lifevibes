import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:lifevibes/features/poppy/config/poppy_config.dart';
import 'package:lifevibes/features/poppy/models/poppy_message.dart';

/// Servicio para interactuar con PoppyAI API
class PoppyService {
  final Dio _dio;

  PoppyService() : _dio = Dio(BaseOptions(
    baseUrl: PoppyConfig.baseUrl,
    connectTimeout: Duration(seconds: PoppyConfig.timeoutSeconds),
    receiveTimeout: Duration(seconds: PoppyConfig.timeoutSeconds),
  )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add authorization header
        options.headers['Authorization'] = 'Bearer ${PoppyConfig.apiKey}';
        options.headers['Content-Type'] = 'application/json';
        return handler.next(options);
      },
    ));
  }

  /// Envía un mensaje a PoppyAI y recibe respuesta
  Future<PoppyResponse> sendMessage({
    required List<PoppyMessage> messages,
    String? systemPrompt,
  }) async {
    try {
      // Prepare the messages array
      final messageList = <Map<String, dynamic>>[];

      // Add system prompt if provided
      if (systemPrompt != null) {
        messageList.add({
          'role': 'system',
          'content': systemPrompt,
        });
      }

      // Add conversation history
      messageList.addAll(messages.map((m) => m.toJson()));

      // Make API request
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': PoppyConfig.modelId,
          'messages': messageList,
          'max_tokens': PoppyConfig.maxTokens,
          'temperature': PoppyConfig.temperature,
        },
      );

      // Parse response
      final data = response.data as Map<String, dynamic>;
      final content = data['choices']?[0]?['message']?['content'] as String? ?? '';

      return PoppyResponse(
        content: content,
        tokensUsed: data['usage']?['total_tokens'] as int? ?? 0,
        model: data['model'] as String? ?? PoppyConfig.modelId,
      );
    } on DioException catch (e) {
      String errorMessage;

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Timeout conectando con PoppyAI';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Error de conexión. Verifica tu internet.';
      } else if (e.response?.statusCode == 401) {
        errorMessage = 'API Key inválida. Verifica tu configuración.';
      } else if (e.response?.statusCode == 429) {
        errorMessage = 'Límite de llamadas excedido. Intenta más tarde.';
      } else {
        errorMessage = 'Error de PoppyAI: ${e.message ?? "Desconocido"}';
      }

      return PoppyResponse.error(errorMessage);
    } catch (e) {
      return PoppyResponse.error('Error inesperado: ${e.toString()}');
    }
  }

  /// Genera un manifiesto de marca con PoppyAI
  Future<PoppyResponse> generateManifesto({
    required String usuario,
    required String valores,
    required String proposito,
    required String superpoder,
  }) async {
    final prompt = PoppyPrompts.generateManifestoPrompt(
      usuario,
      valores,
      proposito,
      superpoder,
    );

    return await sendMessage(
      messages: [
        PoppyMessage(role: 'user', content: prompt),
      ],
    );
  }

  /// Genera estrategia de contenido con PoppyAI
  Future<PoppyResponse> generateContentStrategy({
    required String nicho,
    required String audiencia,
    required List<String> pilares,
  }) async {
    final prompt = PoppyPrompts.generateContentStrategyPrompt(
      nicho,
      audiencia,
      pilares,
    );

    return await sendMessage(
      messages: [
        PoppyMessage(role: 'user', content: prompt),
      ],
    );
  }

  /// Analiza situación del usuario
  Future<PoppyResponse> analyzeSituation({
    required String situacion,
  }) async {
    final prompt = PoppyPrompts.analyzeSituationPrompt(situacion);

    return await sendMessage(
      messages: [
        PoppyMessage(role: 'user', content: prompt),
      ],
    );
  }

  /// Chat general con PoppyAI
  Future<PoppyResponse> chat({
    required List<PoppyMessage> history,
    required String userMessage,
  }) async {
    // Add new user message to history
    final updatedHistory = [
      ...history,
      PoppyMessage(role: 'user', content: userMessage),
    ];

    return await sendMessage(
      messages: updatedHistory,
      systemPrompt: PoppyPrompts.systemPrompt,
    );
  }
}
