import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../avatar/bloc/avatar_bloc.dart';
import '../../../avatar/bloc/avatar_event.dart';
import '../../../avatar/bloc/avatar_state.dart';
import '../../../avatar/models/avatar.dart';

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
    context.read<AvatarBloc>().add(const AvatarLoadRequested());
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
              if (state is AvatarLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is AvatarError) {
                return Center(
                  child: Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: AppColors.secondary),
                  ),
                );
              } else if (state is AvatarLoaded) {
                final avatar = state.avatar;
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
                            // Avatar display
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppColors.primaryGradient,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  avatar.appearance.isNotEmpty
                                      ? avatar.appearance
                                      : '🧑',
                                  style: const TextStyle(fontSize: 80),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Avatar name
                            Text(
                              avatar.name,
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            
                            // Avatar description
                            if (avatar.description.isNotEmpty)
                              Text(
                                avatar.description,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            const SizedBox(height: 32),
                            
                            // Stats
                            _buildStatCard('Salud', avatar.health, AppColors.health),
                            const SizedBox(height: 16),
                            _buildStatCard('Energía', avatar.energy, AppColors.energy),
                            const SizedBox(height: 16),
                            _buildStatCard('Felicidad', avatar.happiness, AppColors.happiness),
                            const SizedBox(height: 32),
                            
                            // XP bar
                            _buildXPBar(avatar),
                            const SizedBox(height: 32),
                            
                            // Superpowers
                            Text(
                              'Superpoderes',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.primary,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: avatar.superpowers.entries.map((entry) {
                                return _buildSuperpowerChip(entry.key, entry.value);
                              }).toList(),
                            ),
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

  Widget _buildStatCard(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            _getStatIcon(label),
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$value%',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXPBar(Avatar avatar) {
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
              '${avatar.xp} / ${avatar.xp + avatar.xpToNextLevel}',
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
              valueColor: AppColors.xpGradient,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuperpowerChip(String name, int level) {
    Color color;
    
    switch (name.toLowerCase()) {
      case 'creatividad':
        color = AppColors.skillCreatividad;
        break;
      case 'innovacion':
        color = AppColors.skillInnovacion;
        break;
      case 'comunicacion':
        color = AppColors.skillComunicacion;
        break;
      case 'liderazgo':
        color = AppColors.skillLiderazgo;
        break;
      case 'tecnologia':
        color = AppColors.skillTecnologia;
        break;
      case 'diseno':
        color = AppColors.skillDiseno;
        break;
      case 'negociacion':
        color = AppColors.skillNegociacion;
        break;
      case 'analisis':
        color = AppColors.skillAnalisis;
        break;
      case 'estrategia':
        color = AppColors.skillEstrategia;
        break;
      default:
        color = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '⚡',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Nivel $level',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatIcon(String label) {
    switch (label.toLowerCase()) {
      case 'salud':
        return Icons.favorite;
      case 'energía':
        return Icons.bolt;
      case 'felicidad':
        return Icons.sentiment_satisfied;
      default:
        return Icons.star;
    }
  }
}
