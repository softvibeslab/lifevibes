import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lifevibes/features/avatar/bloc/quest_bloc.dart';
import 'package:lifevibes/features/avatar/bloc/quest_event.dart';
import 'package:lifevibes/features/avatar/bloc/quest_state.dart';
import 'package:lifevibes/features/quest/models/quest_model.dart';

/// Widget para mostrar lista de misiones activas
class ActiveQuestsWidget extends StatelessWidget {
  const ActiveQuestsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestBloc, QuestState>(
      builder: (context, state) {
        if (state.activeQuests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No hay misiones activas',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.activeQuests.length,
          itemBuilder: (context, index) {
            final quest = state.activeQuests[index];
            return _QuestCard(quest: quest);
          },
        );
      },
    );
  }
}

/// Widget para mostrar lista de misiones completadas
class CompletedQuestsWidget extends StatelessWidget {
  const CompletedQuestsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestBloc, QuestState>(
      builder: (context, state) {
        if (state.completedQuests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.history, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Aún no has completado misiones',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.completedQuests.length,
          itemBuilder: (context, index) {
            final quest = state.completedQuests[index];
            return _QuestCard(quest: quest, showCompleted: true);
          },
        );
      },
    );
  }
}

/// Card individual de misión
class _QuestCard extends StatelessWidget {
  final QuestModel quest;
  final bool showCompleted;

  const _QuestCard({
    required this.quest,
    this.showCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showQuestDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Phase badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _getPhaseColor(quest.phase),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      quest.phaseLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Type badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      quest.typeLabel,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // XP badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 12, color: Colors.orange),
                        const SizedBox(width: 4),
                        Text(
                          '+${quest.xpReward}',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Title
              Text(
                quest.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // Description
              Text(
                quest.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              // Bottom row
              Row(
                children: [
                  // Difficulty
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: quest.difficultyColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
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
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Status
                  if (showCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check, size: 12, color: Colors.green),
                          const SizedBox(width: 4),
                          Text(
                            'Completado',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(quest.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getStatusIcon(quest.status),
                            size: 12,
                            color: _getStatusColor(quest.status),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getStatusText(quest.status),
                            style: TextStyle(
                              color: _getStatusColor(quest.status),
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              // Progress bar (if in progress)
              if (quest.isInProgress && quest.progress > 0) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: quest.progress / 100,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation(Colors.purple),
                    minHeight: 4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1, end: 0);
  }

  void _showQuestDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _QuestDetailSheet(quest: quest),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.schedule;
      case 'in_progress':
        return Icons.play_arrow;
      case 'completed':
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'in_progress':
        return 'En Progreso';
      case 'completed':
        return 'Completado';
      default:
        return 'Desconocido';
    }
  }
}

/// Bottom sheet con detalles de la misión
class _QuestDetailSheet extends StatelessWidget {
  final QuestModel quest;

  const _QuestDetailSheet({required this.quest});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        quest.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Description
                    _buildSection('Descripción', quest.description),
                    // Instructions
                    if (quest.instructions != null)
                      _buildSection('Instrucciones', quest.instructions!),
                    // Badges
                    if (quest.badges.isNotEmpty)
                      _buildBadgesSection(),
                    // XP Reward
                    _buildRewardSection(),
                    const SizedBox(height: 20),
                    // Action buttons
                    if (!quest.isCompleted) ...[
                      _buildActionButton(
                        context,
                        icon: Icons.play_arrow,
                        label: 'Iniciar Misión',
                        color: Colors.green,
                        onTap: quest.isPending
                            ? () {
                                context.read<QuestBloc>().add(
                                      QuestStartRequested(quest.questId),
                                    );
                                Navigator.pop(context);
                              }
                            : null,
                        isEnabled: quest.isPending,
                      ),
                      const SizedBox(height: 12),
                      _buildActionButton(
                        context,
                        icon: Icons.check_circle,
                        label: 'Completar Misión',
                        color: Colors.blue,
                        onTap: quest.isInProgress
                            ? () {
                                context.read<QuestBloc>().add(
                                      QuestCompleteRequested(quest.questId),
                                    );
                                Navigator.pop(context);
                              }
                            : null,
                        isEnabled: quest.isInProgress,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Insignias que ganarás',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: quest.badges.map((badge) {
              return Chip(
                avatar: const Icon(Icons.emoji_events, size: 16),
                label: Text(badge),
                backgroundColor: Colors.yellow.shade100,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardSection() {
    return Card(
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.star, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recompensa',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '+${quest.xpReward} XP',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
    required bool isEnabled,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? color : Colors.grey.shade300,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
