import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/avatar_model.dart';

/// Widget para mostrar el avatar del usuario
/// Muestra el avatar con animaciones suaves
class AvatarDisplayWidget extends StatelessWidget {
  final AvatarModel avatar;
  final double size;
  final bool animate;

  const AvatarDisplayWidget({
    super.key,
    required this.avatar,
    this.size = 120,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: _buildAvatar(),
      ),
    ).then((value) => animate ? value.animate().fadeIn(duration: 500.ms) : value);
  }

  Widget _buildAvatar() {
    return CustomPaint(
      size: Size(size, size),
      painter: AvatarPainter(avatar),
    );
  }
}

/// Custom painter to draw avatar programmatically
class AvatarPainter extends CustomPainter {
  final AvatarModel avatar;

  AvatarPainter(this.avatar);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;
    final outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Background
    paint.color = Colors.grey[100]!;
    canvas.drawCircle(center, size.width / 2, paint);

    // Face shape based on faceType
    paint.color = _parseColor(avatar.skinColor);
    if (avatar.faceType == 'round') {
      _drawRoundFace(canvas, center, size, paint);
    } else if (avatar.faceType == 'oval') {
      _drawOvalFace(canvas, center, size, paint);
    } else {
      _drawSquareFace(canvas, center, size, paint);
    }

    // Eyes
    _drawEyes(canvas, center, size);

    // Mouth
    _drawMouth(canvas, center, size);

    // Hair
    _drawHair(canvas, center, size);

    // Accessories
    _drawAccessories(canvas, center, size);
  }

  void _drawRoundFace(Canvas canvas, Offset center, Size size, Paint paint) {
    canvas.drawCircle(center, size.width * 0.35, paint);
  }

  void _drawOvalFace(Canvas canvas, Offset center, Size size, Paint paint) {
    final rect = Rect.fromCenter(
      center: center,
      width: size.width * 0.6,
      height: size.height * 0.75,
    );
    canvas.drawOval(rect, paint);
  }

  void _drawSquareFace(Canvas canvas, Offset center, Size size, Paint paint) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: size.width * 0.6,
        height: size.height * 0.65,
      ),
      const Radius.circular(15),
    );
    canvas.drawRRect(rect, paint);
  }

  void _drawEyes(Canvas canvas, Offset center, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = Colors.white;
    const eyeSize = 15.0;
    const eyeYOffset = 0.05;
    const eyeSpacing = 0.2;

    final leftEye = Offset(
      center.dx - size.width * eyeSpacing,
      center.dy - size.height * eyeYOffset,
    );
    final rightEye = Offset(
      center.dx + size.width * eyeSpacing,
      center.dy - size.height * eyeYOffset,
    );

    // Eye whites
    canvas.drawCircle(leftEye, eyeSize, paint);
    canvas.drawCircle(rightEye, eyeSize, paint);

    // Pupils
    paint.color = _parseColor(avatar.eyeColor);
    const pupilSize = 8.0;
    if (avatar.eyeStyle == 'normal') {
      canvas.drawCircle(leftEye, pupilSize, paint);
      canvas.drawCircle(rightEye, pupilSize, paint);
    } else if (avatar.eyeStyle == 'wide') {
      canvas.drawCircle(
        Offset(leftEye.dx - 2, leftEye.dy - 2),
        pupilSize + 2,
        paint,
      );
      canvas.drawCircle(
        Offset(rightEye.dx + 2, rightEye.dy - 2),
        pupilSize + 2,
        paint,
      );
    } else {
      // Small eyes
      canvas.drawCircle(leftEye, pupilSize - 2, paint);
      canvas.drawCircle(rightEye, pupilSize - 2, paint);
    }
  }

  void _drawMouth(Canvas canvas, Offset center, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = const Color(0xFF2D3748);

    final mouthY = center.dy + size.height * 0.15;
    final mouthWidth = size.width * 0.15;

    if (avatar.mouthStyle == 'smile') {
      final path = Path();
      path.moveTo(center.dx - mouthWidth, mouthY);
      path.quadraticBezierTo(
        center.dx,
        mouthY + 15,
        center.dx + mouthWidth,
        mouthY,
      );
      canvas.drawPath(path, paint);
    } else if (avatar.mouthStyle == 'neutral') {
      canvas.drawLine(
        Offset(center.dx - mouthWidth, mouthY + 5),
        Offset(center.dx + mouthWidth, mouthY + 5),
        paint,
      );
    } else {
      // Frown
      final path = Path();
      path.moveTo(center.dx - mouthWidth, mouthY + 5);
      path.quadraticBezierTo(
        center.dx,
        mouthY - 10,
        center.dx + mouthWidth,
        mouthY + 5,
      );
      canvas.drawPath(path, paint);
    }
  }

  void _drawHair(Canvas canvas, Offset center, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = _parseColor(avatar.hairColor);

    if (avatar.hairStyle == 'short') {
      final rect = Rect.fromCenter(
        center: Offset(center.dx, center.dy - size.height * 0.25),
        width: size.width * 0.7,
        height: size.height * 0.25,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(15)),
        paint,
      );
    } else if (avatar.hairStyle == 'long') {
      final path = Path();
      path.moveTo(center.dx - size.width * 0.4, center.dy - size.height * 0.4);
      path.quadraticBezierTo(
        center.dx,
        center.dy - size.height * 0.5,
        center.dx + size.width * 0.4,
        center.dy - size.height * 0.4,
      );
      path.lineTo(center.dx + size.width * 0.45, size.height * 0.8);
      path.quadraticBezierTo(
        center.dx,
        size.height * 0.7,
        center.dx - size.width * 0.45,
        size.height * 0.8,
      );
      path.close();
      canvas.drawPath(path, paint);
    } else {
      // Bald
      final rect = Rect.fromCenter(
        center: Offset(center.dx, center.dy - size.height * 0.35),
        width: size.width * 0.6,
        height: size.height * 0.15,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(10)),
        paint,
      );
    }
  }

  void _drawAccessories(Canvas canvas, Offset center, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Glasses
    if (avatar.accessories.contains('glasses')) {
      paint.color = Colors.black.withOpacity(0.3);
      const glassSize = 18.0;
      const eyeYOffset = 0.05;
      const eyeSpacing = 0.2;

      final leftGlass = Offset(
        center.dx - size.width * eyeSpacing,
        center.dy - size.height * eyeYOffset,
      );
      final rightGlass = Offset(
        center.dx + size.width * eyeSpacing,
        center.dy - size.height * eyeYOffset,
      );

      // Left lens
      canvas.drawCircle(leftGlass, glassSize, paint);
      // Right lens
      canvas.drawCircle(rightGlass, glassSize, paint);
      // Bridge
      canvas.drawLine(
        Offset(leftGlass.dx + glassSize, leftGlass.dy),
        Offset(rightGlass.dx - glassSize, rightGlass.dy),
        paint,
      );
    }

    // Hat
    if (avatar.accessories.contains('hat')) {
      paint.color = Colors.purple;
      final rect = Rect.fromCenter(
        center: Offset(center.dx, center.dy - size.height * 0.35),
        width: size.width * 0.8,
        height: size.height * 0.3,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(20)),
        paint,
      );
    }
  }

  Color _parseColor(String hexColor) {
    return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
  }

  @override
  bool shouldRepaint(AvatarPainter oldDelegate) {
    return oldDelegate.avatar != avatar;
  }
}

/// Widget to show XP progress bar
class AvatarLevelProgress extends StatelessWidget {
  final AvatarModel avatar;

  const AvatarLevelProgress({
    super.key,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Level badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.purple, width: 2),
          ),
          child: Text(
            'Lvl ${avatar.level}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.purple,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // XP progress bar
        SizedBox(
          width: 150,
          child: LinearProgressIndicator(
            value: avatar.levelProgress,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${avatar.xp}/${avatar.xpToNextLevel} XP',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
