import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lifevibes/features/avatar/bloc/match_bloc.dart';
import 'package:lifevibes/features/avatar/bloc/match_event.dart';
import 'package:lifevibes/features/avatar/bloc/match_state.dart';
import 'package:lifevibes/features/avatar/models/match_model.dart';

/// Widget de Tinder-like swipe para matches
class MatchSwipeWidget extends StatefulWidget {
  const MatchSwipeWidget({super.key});

  @override
  State<MatchSwipeWidget> createState() => _MatchSwipeWidgetState();
}

class _MatchSwipeWidgetState extends State<MatchSwipeWidget> {
  final List<UserProfile> _potentialMatches = [];

  @override
  void initState() {
    super.initState();
    _loadPotentialMatches();
  }

  void _loadPotentialMatches() {
    // TODO: Load potential matches from Firestore
    // For demo, use mock data
    setState(() {
      _potentialMatches.addAll([
        UserProfile(
          userId: '1',
          displayName: 'Maria Rodriguez',
          level: 5,
          currentPhase: 'HACER',
          values: ['Creatividad', 'Impacto', 'Libertad'],
          purpose: 'Ayudar a freelancers a escalar',
          skills: ['Diseño UI/UX', 'Branding'],
          interests: ['Marketing', 'Startups', 'Tech'],
        ),
        UserProfile(
          userId: '2',
          displayName: 'Carlos Martinez',
          level: 3,
          currentPhase: 'SER',
          values: ['Autenticidad', 'Growth', 'Community'],
          purpose: 'Crear comunidad de emprendedores',
          skills: ['Copywriting', 'Social Media'],
          interests: ['Content', 'Networking', 'Business'],
        ),
        UserProfile(
          userId: '3',
          displayName: 'Ana Lopez',
          level: 7,
          currentPhase: 'TENER',
          values: ['Innovación', 'Excelencia', 'Trust'],
          purpose: 'Transformar negocios digitales',
          skills: ['Marketing Digital', 'Automation'],
          interests: ['Tech', 'Growth', 'Strategy'],
        ),
      ]);
    });
  }

  void _onSwipe(UserProfile user, bool isLike) {
    context.read<MatchBloc>().add(MatchSwipe(
          targetUserId: user.userId,
          isLike: isLike,
        ));

    setState(() {
      _potentialMatches.remove(user);
    });

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isLike ? '❤️ Like' : '👎 Pass'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('El Motor de Conexión'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: _potentialMatches.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No hay más perfiles',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _loadPotentialMatches(),
                    child: const Text('Recargar'),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                // Background cards
                ...List.generate(
                  _potentialMatches.length - 1,
                  (index) => _buildCard(
                    _potentialMatches[index],
                    index: index + 1,
                  ),
                ),
                // Foreground card (active)
                _potentialMatches.isNotEmpty
                    ? _buildCard(_potentialMatches.last, index: 0)
                    : const SizedBox.shrink(),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<MatchBloc>().add(const MatchesRefreshRequested());
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const MatchListWidget(),
            ),
          );
        },
        icon: const Icon(Icons.list),
        label: const Text('Mis Matches'),
        backgroundColor: Colors.purple,
      ),
    );
  }

  Widget _buildCard(UserProfile user, {required int index}) {
    final opacity = 1.0 - (index * 0.2);
    final scale = 1.0 - (index * 0.05);
    final yOffset = index * 10.0;

    return Positioned(
      top: yOffset,
      left: 16,
      right: 16,
      bottom: 100,
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          child: _SwipeCard(
            user: user,
            isActive: index == 0,
            onSwipe: (isLike) => _onSwipe(user, isLike),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

/// Individual swipeable card
class _SwipeCard extends StatelessWidget {
  final UserProfile user;
  final bool isActive;
  final Function(bool) onSwipe;

  const _SwipeCard({
    required this.user,
    required this.isActive,
    required this.onSwipe,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanEnd: (details) {
        final velocity = details.velocity.pixelsPerSecond.dx;
        if (velocity > 300) {
          onSwipe(true); // Like
        } else if (velocity < -300) {
          onSwipe(false); // Pass
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Photo
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.purple.shade400,
                      Colors.purple.shade600,
                    ],
                  ),
                ),
                child: Center(
                  child: user.photoURL != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            user.photoURL!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                size: 120,
                                color: Colors.white,
                              );
                            },
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          size: 120,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.displayName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Lvl ${user.level} · ${user.currentPhase}',
                                    style: const TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (isActive) ...[
                        _buildActionButton(
                          icon: Icons.close,
                          color: Colors.red,
                          onTap: () => onSwipe(false),
                        ),
                        const SizedBox(width: 8),
                        _buildActionButton(
                          icon: Icons.favorite,
                          color: Colors.green,
                          onTap: () => onSwipe(true),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Values
                  if (user.values.isNotEmpty) ...[
                    const Text(
                      'Valores',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      children: user.values
                          .take(3)
                          .map((value) => Chip(
                                label: Text(value),
                                backgroundColor:
                                    Colors.purple.withOpacity(0.1),
                                labelStyle: const TextStyle(
                                  color: Colors.purple,
                                  fontSize: 12,
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 12),
                  // Purpose preview
                  if (user.purpose.isNotEmpty) ...[
                    Text(
                      user.purpose,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: 32),
      ),
    );
  }
}

/// Widget to show list of matches
class MatchListWidget extends StatelessWidget {
  const MatchListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Matches'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<MatchBloc>().add(const MatchesRefreshRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<MatchBloc, MatchState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? 'Error',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state.pendingMatches.isEmpty && state.acceptedMatches.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No tienes matches aún',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MatchSwipeWidget(),
                        ),
                      );
                    },
                    child: const Text('Buscar Matches'),
                  ),
                ],
              ),
            );
          }

          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  tabs: [Tab(text: 'Pendientes'), Tab(text: 'Aceptados')],
                  labelColor: Colors.purple,
                  indicatorColor: Colors.purple,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildMatchList(state.pendingMatches),
                      _buildMatchList(state.acceptedMatches),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const MatchSwipeWidget(),
            ),
          );
        },
        icon: const Icon(Icons.people),
        label: const Text('Buscar'),
        backgroundColor: Colors.purple,
      ),
    );
  }

  Widget _buildMatchList(List<MatchModel> matches) {
    if (matches.isEmpty) {
      return Center(
        child: Text(
          'No hay matches',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];
        return _MatchCard(match: match);
      },
    );
  }
}

/// Card showing a match with its details
class _MatchCard extends StatelessWidget {
  final MatchModel match;

  const _MatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Match score badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getMatchColor(match.matchScore),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${match.matchScore}% ${match.compatibilityLabel}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(match.matchDate),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (match.breakdown != null) ...[
              Text(
                match.breakdown!.explanation,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              // Breakdown bars
              _buildBreakdownBar(
                'Valores',
                match.breakdown!.commonValuesScore,
                40,
              ),
              const SizedBox(height: 8),
              _buildBreakdownBar(
                'Propósito',
                match.breakdown!.alignedPurposeScore,
                30,
              ),
              const SizedBox(height: 8),
              _buildBreakdownBar(
                'Habilidades',
                match.breakdown!.complementarySkillsScore,
                20,
              ),
              const SizedBox(height: 8),
              _buildBreakdownBar(
                'Intereses',
                match.breakdown!.similarInterestsScore,
                10,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getMatchColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inHours < 1) {
      return '${difference.inMinutes} min';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Widget _buildBreakdownBar(String label, int score, int maxScore) {
    final percentage = score / maxScore;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              '$score/$maxScore',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(
              percentage >= 0.7 ? Colors.green : Colors.orange,
            ),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
