import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lifevibes/features/avatar/bloc/quest_bloc.dart';
import 'package:lifevibes/features/avatar/bloc/quest_event.dart';
import 'package:lifevibes/features/avatar/bloc/quest_state.dart';
import 'package:lifevibes/features/avatar/models/quest_model.dart';

/// Widget para mostrar la misión diaria
class DailyQuestWidget extends StatelessWidget {
  const DailyQuestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestBloc, QuestState>(
      builder: (context, state) {
        final dailyQuest = state.currentDailyQuest;

        if (dailyQuest == null) {
          return Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(Icons.casino, size: 48, color: Colors.purple),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay misión diaria asignada',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Asigna una nueva misión para empezar a ganar XP',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<QuestBloc>().add(const QuestDailyAssignRequested());
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Asignar Misión'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return _DailyQuestCard(quest: dailyQuest);
      },
    );
  }
}

/// Card para mostrar misión diaria individual
class _DailyQuestCard extends StatelessWidget {
  final QuestModel quest;

  const _DailyQuestCard({required this.quest});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade400,
              Colors.purple.shade600,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      quest.typeLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildXPBadge(quest.xpReward),
                ],
              ),
              const SizedBox(height: 16),
              // Title
              Text(
                quest.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              // Description
              Text(
                quest.description,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 16),
              // Phase badge
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _getPhaseColor(quest.phase),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      quest.phaseLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: quest.difficultyColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: quest.difficultyColor,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      quest.difficultyLabel,
                      style: TextStyle(
                        color: quest.difficultyColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Actions
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.play_arrow,
                      label: 'Iniciar',
                      color: Colors.green,
                      onTap: quest.isPending
                          ? () => context.read<QuestBloc>().add(
                                QuestStartRequested(quest.questId),
                              )
                          : null,
                      isEnabled: quest.isPending,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.check_circle,
                      label: 'Completar',
                      color: Colors.blue,
                      onTap: quest.isInProgress
                          ? () => context.read<QuestBloc>().add(
                                QuestCompleteRequested(quest.questId),
                              )
                          : null,
                      isEnabled: quest.isInProgress,
                    ),
                  ),
                ],
              ),
              if (quest.badges.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 6,
                  children: quest.badges.take(3).map((badge) {
                    return Chip(
                      label: Text(
                        badge,
                        style: const TextStyle(fontSize: 10),
                      ),
                      backgroundColor: Colors.white.withOpacity(0.2),
                      labelStyle: const TextStyle(color: Colors.white),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildXPBadge(int xp) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 16, color: Colors.orange),
          const SizedBox(width: 4),
          Text(
            '+$xp XP',
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
    required bool isEnabled,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ? color : Colors.grey,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        disabledBackgroundColor: Colors.grey.shade300,
      ),
    );
  }

  Color _getPhaseColor(QuestPhase phase) {
    switch (phase) {
      case QuestPhase.ser:
        return Colors.purple;
      case QuestPhase.hacer:
        return Colors.blue;
      case QuestPhase.tener:
        return Colors.green;
    }
  }
}
