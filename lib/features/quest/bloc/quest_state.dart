import 'package:equatable/equatable.dart';
import '../models/quest_model.dart';

class QuestState extends Equatable {
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final String? message;
  final List<QuestModel> activeQuests;
  final List<QuestModel> completedQuests;
  final QuestModel? currentDailyQuest;
  final int totalXP;
  final int totalQuestsCompleted;

  const QuestState({
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.message,
    this.activeQuests = const [],
    this.completedQuests = const [],
    this.currentDailyQuest,
    this.totalXP = 0,
    this.totalQuestsCompleted = 0,
  });

  QuestState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    String? message,
    List<QuestModel>? activeQuests,
    List<QuestModel>? completedQuests,
    QuestModel? currentDailyQuest,
    int? totalXP,
    int? totalQuestsCompleted,
  }) {
    return QuestState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
      message: message,
      activeQuests: activeQuests ?? this.activeQuests,
      completedQuests: completedQuests ?? this.completedQuests,
      currentDailyQuest: currentDailyQuest ?? this.currentDailyQuest,
      totalXP: totalXP ?? this.totalXP,
      totalQuestsCompleted: totalQuestsCompleted ?? this.totalQuestsCompleted,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        hasError,
        errorMessage,
        message,
        activeQuests,
        completedQuests,
        currentDailyQuest,
        totalXP,
        totalQuestsCompleted,
      ];
}
