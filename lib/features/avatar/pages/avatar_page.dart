import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bloc/avatar_bloc.dart';
import '../widgets/avatar_display_widget.dart';
import 'avatar_customization_widget.dart';

/// Página principal del avatar
/// Muestra el avatar del usuario y permite personalizarlo
class AvatarPage extends StatefulWidget {
  const AvatarPage({super.key});

  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  @override
  void initState() {
    super.initState();
    // Load avatar on page load
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      context.read<AvatarBloc>().add(AvatarLoadRequested(userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu Avatar'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshAvatar(context),
          ),
        ],
      ),
      body: BlocBuilder<AvatarBloc, AvatarState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? 'Error al cargar avatar',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _refreshAvatar(context),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state.avatarData.isEmpty) {
            return const Center(
              child: Text('No se encontró información del avatar'),
            );
          }

          return _buildAvatarContent(context, state);
        },
      ),
    );
  }

  Widget _buildAvatarContent(BuildContext context, AvatarState state) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final avatar = AvatarModel.fromJson(state.avatarData);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Avatar display
          AvatarDisplayWidget(
            avatar: avatar,
            size: 180,
          ),
          const SizedBox(height: 20),
          // Level and XP
          AvatarLevelProgress(avatar: avatar),
          const SizedBox(height: 30),
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.edit,
                label: 'Personalizar',
                onTap: () => _openCustomization(context, userId!, avatar),
              ),
              _buildActionButton(
                icon: Icons.refresh,
                label: 'Reiniciar',
                onTap: () => _resetAvatar(context, userId!),
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Badges section
          if (avatar.badges.isNotEmpty) ...[
            const Text(
              'Insignias',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: avatar.badges.map((badge) {
                return _buildBadge(badge);
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
          // Stats card
          _buildStatsCard(avatar),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
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

  Widget _buildStatsCard(AvatarModel avatar) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estadísticas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow('Nivel actual', '${avatar.level}'),
            _buildStatRow('XP actual', '${avatar.xp}'),
            _buildStatRow(
              'XP para siguiente nivel',
              '${avatar.xpToNextLevel}',
            ),
            _buildStatRow(
              'Progreso',
              '${(avatar.levelProgress * 100).toInt()}%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
        ],
      ),
    );
  }

  void _openCustomization(BuildContext context, String userId, AvatarModel avatar) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AvatarCustomizationWidget(
          userId: userId,
          avatar: avatar,
        ),
      ),
    );
  }

  void _resetAvatar(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reiniciar Avatar'),
        content: const Text(
          '¿Estás seguro de que deseas reiniciar el avatar? Se perderán todos los cambios.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<AvatarBloc>().add(AvatarResetRequested(userId));
              Navigator.pop(context);
            },
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }

  void _refreshAvatar(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      context.read<AvatarBloc>().add(AvatarLoadRequested(userId));
    }
  }
}
