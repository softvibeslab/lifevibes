import 'package:equatable/equatable.dart';
import 'package:lifevibes/features/poppy/models/poppy_message.dart';

class CoachChatState extends Equatable {
  final List<PoppyMessage> messages;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final bool isGenerating;

  const CoachChatState({
    this.messages = const [],
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.isGenerating = false,
  });

  CoachChatState copyWith({
    List<PoppyMessage>? messages,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    bool? isGenerating,
  }) {
    return CoachChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
      isGenerating: isGenerating ?? this.isGenerating,
    );
  }

  @override
  List<Object?> get props => [
        messages,
        isLoading,
        hasError,
        errorMessage,
        isGenerating,
      ];
}
