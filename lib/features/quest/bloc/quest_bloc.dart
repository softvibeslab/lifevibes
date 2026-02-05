import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../models/quest_model.dart';
import 'quest_event.dart';
import 'quest_state.dart';

class QuestBloc extends Bloc<QuestEvent, QuestState> {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseFunctions _functions;

  QuestBloc(this._firestore, this._auth, this._functions)
      : super(const QuestState()) {
    on<QuestLoadRequested>(_onQuestLoadRequested);
    on<QuestDailyAssignRequested>(_onQuestDailyAssignRequested);
    on<QuestStartRequested>(_onQuestStartRequested);
    on<QuestCompleteRequested>(_onQuestCompleteRequested);
    on<QuestRefreshRequested>(_onQuestRefreshRequested);
  }

  Future<void> _onQuestLoadRequested(
    QuestLoadRequested event,
    Emitter<QuestState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, hasError: false));

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        emit(state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: 'Usuario no autenticado',
        ));
        return;
      }

      // Load user's quests
      final questsSnapshot = await _firestore
          .collection('quests')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      // Load today's daily quest
      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      final todayEnd = todayStart.add(const Duration(days: 1));

      final dailyQuestSnapshot = await _firestore
          .collection('quests')
          .where('userId', isEqualTo: userId)
          .where('createdAt', isGreaterThanOrEqualTo: todayStart)
          .where('createdAt', isLessThan: todayEnd)
          .where('type', isEqualTo: 'daily')
          .limit(1)
          .get();

      // Parse quests
      final allQuests = questsSnapshot.docs.map((doc) {
        final data = doc.data();
        return QuestModel.fromJson({
          ...data,
          'questId': doc.id,
        });
      }).toList();

      final activeQuests = allQuests.where((q) => !q.isCompleted).toList();
      final completedQuests = allQuests.where((q) => q.isCompleted).toList();

      // Get daily quest
      QuestModel? dailyQuest;
      if (dailyQuestSnapshot.docs.isNotEmpty) {
        final data = dailyQuestSnapshot.docs.first.data();
        dailyQuest = QuestModel.fromJson({
          ...data,
          'questId': dailyQuestSnapshot.docs.first.id,
        });
      }

      // Calculate total XP
      final totalXP = completedQuests.fold<int>(
        0,
        (sum, q) => sum + q.xpReward,
      );

      emit(state.copyWith(
        isLoading: false,
        activeQuests: activeQuests,
        completedQuests: completedQuests,
        currentDailyQuest: dailyQuest,
        totalXP: totalXP,
        totalQuestsCompleted: completedQuests.length,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Error cargando misiones: ${e.toString()}',
      ));
    }
  }

  Future<void> _onQuestDailyAssignRequested(
    QuestDailyAssignRequested event,
    Emitter<QuestState> emit,
  ) async {
    try {
      // Call Cloud Function to assign daily quest
      final result = await _functions.httpsCallable('assignDailyQuest').call();

      if (result.data != null) {
        final data = result.data as Map<String, dynamic>;
        final questData = data['quest'] as Map<String, dynamic>;
        final dailyQuest = QuestModel.fromJson({
          ...questData,
          'questId': data['questId'],
        });

        emit(state.copyWith(
          currentDailyQuest: dailyQuest,
          activeQuests: [dailyQuest, ...state.activeQuests],
        ));

        ScaffoldMessenger.of(context).mounted
            ? ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✨ ¡Nueva misión diaria asignada!'),
                  backgroundColor: Colors.green,
                ),
              )
            : null;
      }
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: 'Error asignando misión diaria: ${e.toString()}',
      ));
    }
  }

  Future<void> _onQuestStartRequested(
    QuestStartRequested event,
    Emitter<QuestState> emit,
  ) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      // Update quest status to in_progress
      await _firestore
          .collection('quests')
          .doc(event.questId)
          .update({'status': 'in_progress'});

      // Update local state
      final updatedQuests = state.activeQuests.map((q) {
        if (q.questId == event.questId) {
          return q.copyWith(status: 'in_progress');
        }
        return q;
      }).toList();

      emit(state.copyWith(activeQuests: updatedQuests));
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: 'Error iniciando misión: ${e.toString()}',
      ));
    }
  }

  Future<void> _onQuestCompleteRequested(
    QuestCompleteRequested event,
    Emitter<QuestState> emit,
  ) async {
    try {
      // Call Cloud Function to validate and complete quest
      final result = await _functions.httpsCallable('validateQuestCompletion').call({
        'questId': event.questId,
      });

      if (result.data != null) {
        final data = result.data as Map<String, dynamic>;
        final xpAwarded = data['xpAwarded'] as int? ?? 0;

        // Update local state
        final completedQuest = state.activeQuests.firstWhere(
          (q) => q.questId == event.questId,
        );

        final updatedActive = state.activeQuests
            .where((q) => q.questId != event.questId)
            .toList();

        emit(state.copyWith(
          activeQuests: updatedActive,
          completedQuests: [
            completedQuest.copyWith(
              status: 'completed',
              completedAt: DateTime.now(),
              progress: 100,
            ),
            ...state.completedQuests,
          ],
          totalXP: state.totalXP + xpAwarded,
          totalQuestsCompleted: state.totalQuestsCompleted + 1,
        ));

        ScaffoldMessenger.of(context).mounted
            ? ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('🎉 ¡+$xpAwarded XP! Misión completada'),
                  backgroundColor: Colors.green,
                ),
              )
            : null;
      }
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: 'Error completando misión: ${e.toString()}',
      ));
    }
  }

  Future<void> _onQuestRefreshRequested(
    QuestRefreshRequested event,
    Emitter<QuestState> emit,
  ) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;
    add(QuestLoadRequested(userId));
  }
}

// Get context for ScaffoldMessenger
extension on BuildContext {
  bool get mounted {
    try {
      widget;
      return true;
    } catch (e) {
      return false;
    }
  }
}
