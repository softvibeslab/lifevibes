import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifevibes/features/poppy/services/poppy_service.dart';
import 'package:lifevibes/features/poppy/models/poppy_message.dart'
    show PoppyMessage, PoppyPrompts;
import 'coach_chat_event.dart';
import 'coach_chat_state.dart';

class CoachChatBloc extends Bloc<CoachChatEvent, CoachChatState> {
  final PoppyService _poppyService;

  CoachChatBloc(this._poppyService) : super(const CoachChatState()) {
    on<CoachChatStarted>(_onCoachChatStarted);
    on<CoachMessageSent>(_onCoachMessageSent);
    on<CoachChatHistoryLoaded>(_onCoachChatHistoryLoaded);
    on<CoachManifestoGenerated>(_onCoachManifestoGenerated);
    on<CoachContentStrategyGenerated>(_onCoachContentStrategyGenerated);
    on<CoachChatCleared>(_onCoachChatCleared);
  }

  Future<void> _onCoachChatStarted(
    CoachChatStarted event,
    Emitter<CoachChatState> emit,
  ) async {
    // Send discovery prompt to start the conversation
    emit(state.copyWith(
      isGenerating: true,
      hasError: false,
    ));

    try {
      final response = await _poppyService.sendMessage(
        messages: [],
        systemPrompt: PoppyPrompts.systemPrompt,
      );

      if (response.success) {
        emit(state.copyWith(
          messages: [
            PoppyMessage(
              role: 'assistant',
              content: '¡Hola! 👋 Soy Poppy, tu coach virtual de LifeVibes.\n\n' +
                  response.content,
            ),
          ],
          isGenerating: false,
        ));
      } else {
        emit(state.copyWith(
          hasError: true,
          errorMessage: response.error,
          isGenerating: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: 'Error inicializando coach: ${e.toString()}',
        isGenerating: false,
      ));
    }
  }

  Future<void> _onCoachMessageSent(
    CoachMessageSent event,
    Emitter<CoachChatState> emit,
  ) async {
    // Add user message
    final userMessage = PoppyMessage(role: 'user', content: event.message);
    emit(state.copyWith(
      messages: [...state.messages, userMessage],
      isGenerating: true,
    ));

    try {
      final response = await _poppyService.chat(
        history: state.messages,
        userMessage: event.message,
      );

      if (response.success) {
        final assistantMessage = PoppyMessage(
          role: 'assistant',
          content: response.content,
        );
        emit(state.copyWith(
          messages: [...state.messages, assistantMessage],
          isGenerating: false,
        ));
      } else {
        emit(state.copyWith(
          hasError: true,
          errorMessage: response.error,
          isGenerating: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: 'Error enviando mensaje: ${e.toString()}',
        isGenerating: false,
      ));
    }
  }

  Future<void> _onCoachChatHistoryLoaded(
    CoachChatHistoryLoaded event,
    Emitter<CoachChatState> emit,
  ) async {
    emit(state.copyWith(messages: event.history));
  }

  Future<void> _onCoachManifestoGenerated(
    CoachManifestoGenerated event,
    Emitter<CoachChatState> emit,
  ) async {
    emit(state.copyWith(
      isGenerating: true,
      hasError: false,
    ));

    try {
      final response = await _poppyService.generateManifesto(
        usuario: event.usuario,
        valores: event.valores,
        proposito: event.proposito,
        superpoder: event.superpoder,
      );

      if (response.success) {
        final message = PoppyMessage(
          role: 'assistant',
          content: '## Tu Manifiesto de Marca\n\n' + response.content,
        );
        emit(state.copyWith(
          messages: [...state.messages, message],
          isGenerating: false,
        ));
      } else {
        emit(state.copyWith(
          hasError: true,
          errorMessage: response.error,
          isGenerating: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: 'Error generando manifiesto: ${e.toString()}',
        isGenerating: false,
      ));
    }
  }

  Future<void> _onCoachContentStrategyGenerated(
    CoachContentStrategyGenerated event,
    Emitter<CoachChatState> emit,
  ) async {
    emit(state.copyWith(
      isGenerating: true,
      hasError: false,
    ));

    try {
      final response = await _poppyService.generateContentStrategy(
        nicho: event.nicho,
        audiencia: event.audiencia,
        pilares: event.pilares,
      );

      if (response.success) {
        final message = PoppyMessage(
          role: 'assistant',
          content: '## Tu Estrategia de Contenido\n\n' + response.content,
        );
        emit(state.copyWith(
          messages: [...state.messages, message],
          isGenerating: false,
        ));
      } else {
        emit(state.copyWith(
          hasError: true,
          errorMessage: response.error,
          isGenerating: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: 'Error generando estrategia: ${e.toString()}',
        isGenerating: false,
      ));
    }
  }

  Future<void> _onCoachChatCleared(
    CoachChatCleared event,
    Emitter<CoachChatState> emit,
  ) async {
    emit(const CoachChatState());
  }
}
