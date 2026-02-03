import 'package:equatable/equatable.dart';
import '../models/poppy_message.dart';

abstract class CoachChatEvent extends Equatable {
  const CoachChatEvent();

  @override
  List<Object?> get props => [];
}

class CoachChatStarted extends CoachChatEvent {
  const CoachChatStarted();
}

class CoachMessageSent extends CoachChatEvent {
  final String message;

  const CoachMessageSent(this.message);

  @override
  List<Object?> get props => [message];
}

class CoachChatHistoryLoaded extends CoachChatEvent {
  final List<PoppyMessage> history;

  const CoachChatHistoryLoaded(this.history);

  @override
  List<Object?> get props => [history];
}

class CoachManifestoGenerated extends CoachChatEvent {
  final String usuario;
  final String valores;
  final String proposito;
  final String superpoder;

  const CoachManifestoGenerated({
    required this.usuario,
    required this.valores,
    required this.proposito,
    required this.superpoder,
  });

  @override
  List<Object?> get props => [usuario, valores, proposito, superpoder];
}

class CoachContentStrategyGenerated extends CoachChatEvent {
  final String nicho;
  final String audiencia;
  final List<String> pilares;

  const CoachContentStrategyGenerated({
    required this.nicho,
    required this.audiencia,
    required this.pilares,
  });

  @override
  List<Object?> get props => [nicho, audiencia, pilares];
}

class CoachChatCleared extends CoachChatEvent {
  const CoachChatCleared();
}
