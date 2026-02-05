import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/avatar_service.dart';
import '../../models/avatar.dart';

/// Avatar creation screen (La Forja del Superpoder)
class AvatarCreationScreen extends StatefulWidget {
  const AvatarCreationScreen({super.key});

  @override
  State<AvatarCreationScreen> createState() => _AvatarCreationScreenState();
}

class _AvatarCreationScreenState extends State<AvatarCreationScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  final AvatarService _avatarService = AvatarService();
  
  bool _isLoading = false;
  int _selectedAvatarIndex = 0;
  
  // Available avatar appearances (emojis/characters)
  final List<String> _avatarAppearances = [
    '🧑', // Base male
    '🧒', // Base female
    '👨‍💼', // Professional
    '👩‍💼', // Professional female
    '🧙', // Wizard
    '🧙‍♀️', // Witch
    '🦸', // Superhero male
    '🦹', // Superhero female
    '🤖', // Robot
    '🧚', // Astronaut
  ];
  
  // Available superpowers (skills)
  final Map<String, int> _superpowers = {
    'Creatividad': 1,
    'Innovación': 1,
    'Comunicación': 1,
    'Liderazgo': 1,
    'Tecnología': 1,
    'Diseño': 1,
    'Negociación': 1,
    'Análisis': 1,
    'Estrategia': 1,
  };
  
  // Selected superpowers
  final Set<String> _selectedSuperpowers = <String>{};

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createAvatar() async {
    if (_nameController.text.trim().isEmpty) {
      _showErrorSnackBar('Por favor, ingresa un nombre para tu avatar');
      return;
    }

    if (_selectedSuperpowers.isEmpty) {
      _showErrorSnackBar('Selecciona al menos 1 superpoder');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _avatarService.createAvatar(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        superpowers: Map.fromEntries(
          _selectedSuperpowers.map(
            (power) => MapEntry(power, _superpowers[power] ?? 1),
          ),
        ),
        appearance: _avatarAppearances[_selectedAvatarIndex],
      );

      if (mounted) {
        _showSuccessSnackBar();
        // Navigate to home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error al crear avatar: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.level),
            const SizedBox(width: 12),
            const Text('¡Avatar creado exitosamente!'),
          ],
        ),
        backgroundColor: AppColors.card,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: AppColors.secondary),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.card,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Title
                  Text(
                    'La Forja del Superpoder',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ).animate().fadeIn(duration: 300.ms),
                  const SizedBox(height: 8),
                  Text(
                    'Crea tu avatar digital y define tus habilidades',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ).animate().fadeIn(delay: 100.ms, duration: 300.ms),
                  const SizedBox(height: 32),
                  
                  // Avatar selection
                  Text(
                    'Elige tu Apariencia',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                  ).animate().fadeIn(delay: 200.ms, duration: 300.ms),
                  const SizedBox(height: 16),
                  _buildAvatarSelector(),
                  const SizedBox(height: 32),
                  
                  // Avatar name
                  Text(
                    'Nombre de tu Avatar',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                  ).animate().fadeIn(delay: 300.ms, duration: 300.ms),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.card,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Ejemplo: DigitalRon',
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ).animate().fadeIn(delay: 350.ms, duration: 300.ms),
                  const SizedBox(height: 24),
                  
                  // Avatar description
                  Text(
                    'Descripción (opcional)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                  ).animate().fadeIn(delay: 400.ms, duration: 300.ms),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.card,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Cuéntanos sobre tu avatar...',
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ).animate().fadeIn(delay: 450.ms, duration: 300.ms),
                  const SizedBox(height: 32),
                  
                  // Superpowers selection
                  Text(
                    'Selecciona tus Superpoderes',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                  ).animate().fadeIn(delay: 500.ms, duration: 300.ms),
                  const SizedBox(height: 16),
                  _buildSuperpowersGrid(),
                  const SizedBox(height: 32),
                  
                  // Create button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _createAvatar,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              'Crear Avatar',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ).animate().fadeIn(delay: 600.ms, duration: 300.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Avatar selector with Tinder-style horizontal scroll
  Widget _buildAvatarSelector() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: AppColors.card.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _avatarAppearances.length,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          final isSelected = index == _selectedAvatarIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedAvatarIndex = index;
              });
              // Haptic feedback
              HapticFeedback.lightImpact();
            },
            child: Container(
              width: 120,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primaryLight : Colors.transparent,
                  width: isSelected ? 3 : 0,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _avatarAppearances[index],
                    style: TextStyle(
                      fontSize: 48,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isSelected ? '¡Este soy yo!' : 'Seleccionar',
                    style: TextStyle(
                      color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Superpowers grid
  Widget _buildSuperpowersGrid() {
    final superpowerColors = <String, Color>{
      'Creatividad': AppColors.powerCreativity,
      'Innovación': AppColors.powerCreativity,
      'Comunicación': AppColors.powerCharisma,
      'Liderazgo': AppColors.powerCharisma,
      'Tecnología': AppColors.powerIntelligence,
      'Diseño': AppColors.powerCreativity,
      'Negociación': AppColors.powerWisdom,
      'Análisis': AppColors.powerIntelligence,
      'Estrategia': AppColors.powerWisdom,
    };

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _superpowers.length,
      itemBuilder: (context, index) {
        final powerName = _superpowers.keys.elementAt(index);
        final isSelected = _selectedSuperpowers.contains(powerName);
        final powerColor = superpowerColors[powerName] ?? AppColors.primary;

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedSuperpowers.remove(powerName);
              } else {
                _selectedSuperpowers.add(powerName);
              }
              // Haptic feedback
              HapticFeedback.lightImpact();
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? powerColor.withOpacity(0.3) : AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? powerColor : Colors.transparent,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  color: powerColor,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  powerName,
                  style: TextStyle(
                    color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
