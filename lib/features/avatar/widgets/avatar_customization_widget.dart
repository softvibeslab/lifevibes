import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/avatar_bloc.dart';
import '../models/avatar_model.dart';
import 'avatar_display_widget.dart';

/// Widget para personalizar el avatar
/// Permite cambiar cara, ojos, boca, pelo, ropa y accesorios
class AvatarCustomizationWidget extends StatefulWidget {
  final String userId;
  final AvatarModel avatar;

  const AvatarCustomizationWidget({
    super.key,
    required this.userId,
    required this.avatar,
  });

  @override
  State<AvatarCustomizationWidget> createState() =>
      _AvatarCustomizationWidgetState();
}

class _AvatarCustomizationWidgetState extends State<AvatarCustomizationWidget> {
  late AvatarModel _currentAvatar;

  @override
  void initState() {
    super.initState();
    _currentAvatar = widget.avatar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personaliza tu Avatar'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveAvatar,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar preview
            AvatarDisplayWidget(
              avatar: _currentAvatar,
              size: 150,
            ),
            const SizedBox(height: 10),
            AvatarLevelProgress(avatar: _currentAvatar),
            const SizedBox(height: 30),
            // Customization options
            _buildCustomizationOptions(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomizationOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection('Forma de Cara', _buildFaceTypeOptions()),
          _buildSection('Estilo de Ojos', _buildEyeStyleOptions()),
          _buildSection('Color de Ojos', _buildEyeColorOptions()),
          _buildSection('Boca', _buildMouthStyleOptions()),
          _buildSection('Estilo de Pelo', _buildHairStyleOptions()),
          _buildSection('Color de Pelo', _buildHairColorOptions()),
          _buildSection('Color de Piel', _buildSkinColorOptions()),
          _buildSection('Ropa', _buildOutfitOptions()),
          _buildSection('Accesorios', _buildAccessoryOptions()),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content,
        const Divider(height: 32),
      ],
    );
  }

  Widget _buildFaceTypeOptions() {
    return _buildOptionRow(
      options: const [
        {'label': 'Redondo', 'value': 'round'},
        {'label': 'Ovalado', 'value': 'oval'},
        {'label': 'Cuadrado', 'value': 'square'},
      ],
      selectedValue: _currentAvatar.faceType,
      onTap: (value) => setState(() {
        _currentAvatar = _currentAvatar.copyWith(faceType: value);
      }),
    );
  }

  Widget _buildEyeStyleOptions() {
    return _buildOptionRow(
      options: const [
        {'label': 'Normal', 'value': 'normal'},
        {'label': 'Grande', 'value': 'wide'},
        {'label': 'Pequeño', 'value': 'small'},
      ],
      selectedValue: _currentAvatar.eyeStyle,
      onTap: (value) => setState(() {
        _currentAvatar = _currentAvatar.copyWith(eyeStyle: value);
      }),
    );
  }

  Widget _buildEyeColorOptions() {
    return _buildColorRow(
      colors: const [
        '#4A5568', // Dark gray
        '#2B6CB0', // Blue
        '#276749', // Green
        '#9B2C2C', // Red
        '#553C9A', // Purple
      ],
      selectedColor: _currentAvatar.eyeColor,
      onTap: (value) => setState(() {
        _currentAvatar = _currentAvatar.copyWith(eyeColor: value);
      }),
    );
  }

  Widget _buildMouthStyleOptions() {
    return _buildOptionRow(
      options: const [
        {'label': 'Sonrisa', 'value': 'smile'},
        {'label': 'Neutro', 'value': 'neutral'},
        {'label': 'Serio', 'value': 'serious'},
      ],
      selectedValue: _currentAvatar.mouthStyle,
      onTap: (value) => setState(() {
        _currentAvatar = _currentAvatar.copyWith(mouthStyle: value);
      }),
    );
  }

  Widget _buildHairStyleOptions() {
    return _buildOptionRow(
      options: const [
        {'label': 'Corto', 'value': 'short'},
        {'label': 'Largo', 'value': 'long'},
        {'label': 'Calvo', 'value': 'bald'},
      ],
      selectedValue: _currentAvatar.hairStyle,
      onTap: (value) => setState(() {
        _currentAvatar = _currentAvatar.copyWith(hairStyle: value);
      }),
    );
  }

  Widget _buildHairColorOptions() {
    return _buildColorRow(
      colors: const [
        '#1A202C', // Black
        '#4A5568', // Dark gray
        '#9F7AEA', // Purple
        '#F6AD55', // Orange
        '#F6E05E', // Yellow
      ],
      selectedColor: _currentAvatar.hairColor,
      onTap: (value) => setState(() {
        _currentAvatar = _currentAvatar.copyWith(hairColor: value);
      }),
    );
  }

  Widget _buildSkinColorOptions() {
    return _buildColorRow(
      colors: const [
        '#FBD38D', // Light
        '#F6E05E', // Yellowish
        '#ED8936', // Orangeish
        '#C05621', // Dark
      ],
      selectedColor: _currentAvatar.skinColor,
      onTap: (value) => setState(() {
        _currentAvatar = _currentAvatar.copyWith(skinColor: value);
      }),
    );
  }

  Widget _buildOutfitOptions() {
    return _buildOptionRow(
      options: const [
        {'label': 'Casual', 'value': 'casual'},
        {'label': 'Formal', 'value': 'formal'},
        {'label': 'Deportivo', 'value': 'sporty'},
      ],
      selectedValue: _currentAvatar.outfit,
      onTap: (value) => setState(() {
        _currentAvatar = _currentAvatar.copyWith(outfit: value);
      }),
    );
  }

  Widget _buildAccessoryOptions() {
    return Wrap(
      spacing: 10,
      children: [
        _buildAccessoryChip('Lentes', 'glasses'),
        _buildAccessoryChip('Sombrero', 'hat'),
      ],
    );
  }

  Widget _buildAccessoryChip(String label, String accessory) {
    final isSelected = _currentAvatar.accessories.contains(accessory);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _currentAvatar = _currentAvatar.copyWith(
              accessories: [..._currentAvatar.accessories, accessory],
            );
          } else {
            _currentAvatar = _currentAvatar.copyWith(
              accessories: _currentAvatar.accessories
                  .where((a) => a != accessory)
                  .toList(),
            );
          }
        });
      },
      selectedColor: Colors.purple.withOpacity(0.2),
      checkmarkColor: Colors.purple,
    );
  }

  Widget _buildOptionRow({
    required List<Map<String, String>> options,
    required String selectedValue,
    required Function(String) onTap,
  }) {
    return Wrap(
      spacing: 10,
      children: options.map((option) {
        final isSelected = selectedValue == option['value'];
        return ChoiceChip(
          label: Text(option['label']!),
          selected: isSelected,
          onSelected: (_) => onTap(option['value']!),
          selectedColor: Colors.purple,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildColorRow({
    required List<String> colors,
    required String selectedColor,
    required Function(String) onTap,
  }) {
    return Wrap(
      spacing: 10,
      children: colors.map((color) {
        final isSelected = selectedColor == color;
        return GestureDetector(
          onTap: () => onTap(color),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _parseColor(color),
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.purple : Colors.grey,
                width: isSelected ? 3 : 1,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _parseColor(String hexColor) {
    return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
  }

  void _saveAvatar() {
    context.read<AvatarBloc>().add(
          AvatarUpdated(
            userId: widget.userId,
            avatarData: _currentAvatar.toJson(),
          ),
        );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Avatar guardado!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
