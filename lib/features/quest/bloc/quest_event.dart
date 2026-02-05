import 'package:equatable/equatable.dart';
import 'package:lifevibes/features/quest/models/quest_model.dart';

abstract class QuestEvent extends Equatable {
  const QuestEvent();

  @override
  List<Object?> get props => [];
}

class QuestLoadRequested extends QuestEvent {
  final String userId;

  const QuestLoadRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class QuestDailyAssignRequested extends QuestEvent {
  const QuestDailyAssignRequested();
}

class QuestStartRequested extends QuestEvent {
  final String questId;

  const QuestStartRequested(this.questId);

  @override
  List<Object?> get props => [questId];
}

class QuestCompleteRequested extends QuestEvent {
  final String questId;

  const QuestCompleteRequested(this.questId);

  @override
  List<Object?> get props => [questId];
}

class QuestRefreshRequested extends QuestEvent {
  const QuestRefreshRequested();
}
