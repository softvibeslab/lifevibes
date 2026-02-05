import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:lifevibes/core/theme/app_theme.dart';
import 'package:lifevibes/features/avatar/bloc/avatar_bloc.dart';
import 'package:lifevibes/features/avatar/bloc/avatar_event.dart';
import 'package:lifevibes/features/avatar/bloc/avatar_state.dart';
import 'package:lifevibes/features/avatar/models/avatar_model.dart';
import 'package:lifevibes/features/avatar/widgets/avatar_display_widget.dart';

/// Home screen (after avatar creation)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load avatar data
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      context.read<AvatarBloc>().add(AvatarLoadRequested(userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<AvatarBloc, AvatarState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.hasError) {
                return Center(
                  child: Text(
                    'Error: ${state.errorMessage ?? "Unknown error"}',
                    style: const TextStyle(color: AppColors.secondary),
                  ),
                );
              } else if (state.avatarData.isNotEmpty) {
                final avatar = AvatarModel.fromJson(state.avatarData);
                return Column(
                  children: [
                    // App bar
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          Text(
                            'LifeVibes 🗿',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          const Spacer(),
                          Text(
                            'Nivel ${avatar.level}',
                            style: const TextStyle(
                              color: AppColors.level,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.card),

                    // Avatar info
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // Avatar display using AvatarDisplayWidget
                            AvatarDisplayWidget(
                              avatar: avatar,
                              size: 200,
                              animate: true,
                            ),
                            const SizedBox(height: 24),

                            // Badges section
                            if (avatar.badges.isNotEmpty) ...[
                              Text(
                                'Insignias',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: AppColors.primary,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: avatar.badges.map((badge) {
                                  return _buildBadge(badge);
                                }).toList(),
                              ),
                              const SizedBox(height: 32),
                            ],

                            // XP bar
                            _buildXPBar(avatar),
                            const SizedBox(height: 32),

                            // Avatar appearance info
                            Text(
                              'Estilo de Avatar',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.primary,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            _buildAvatarInfoRow('Estilo de cara', avatar.faceType),
                            _buildAvatarInfoRow('Estilo de ojos', avatar.eyeStyle),
                            _buildAvatarInfoRow('Color de ojos', avatar.eyeColor),
                            _buildAvatarInfoRow('Estilo de boca', avatar.mouthStyle),
                            _buildAvatarInfoRow('Estilo de pelo', avatar.hairStyle),
                            _buildAvatarInfoRow('Color de pelo', avatar.hairColor),
                            _buildAvatarInfoRow('Color de piel', avatar.skinColor),
                            _buildAvatarInfoRow('Ropa', avatar.outfit),
                            if (avatar.accessories.isNotEmpty)
                              _buildAvatarInfoRow('Accesorios', avatar.accessories.join(', ')),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text(
                    'No avatar encontrado',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildXPBar(AvatarModel avatar) {
    final progress = avatar.levelProgress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'XP',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            Text(
              '${avatar.xp} / ${avatar.xpToNextLevel}',
              style: TextStyle(
                color: AppColors.xp,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(6),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.card,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.xp),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String badge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.yellow.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.yellow, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events, size: 16, color: Colors.orange),
          const SizedBox(width: 4),
          Text(
            badge,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
