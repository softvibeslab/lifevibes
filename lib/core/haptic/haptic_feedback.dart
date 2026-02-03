import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

/// Sistema de feedback háptico para LifeVibes
/// Proporciona respuestas táctiles a las acciones del usuario

class HapticFeedbackService {
  /// Vibrate leve - para acciones sutiles
  static Future<void> lightImpact() async {
    try {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 50);
      }
    } catch (e) {
      // Silently fail if haptics not available
    }
  }

  /// Vibrate medio - para acciones moderadas
  static Future<void> mediumImpact() async {
    try {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 100);
      }
    } catch (e) {
      // Silently fail
    }
  }

  /// Vibrate fuerte - para acciones importantes
  static Future<void> heavyImpact() async {
    try {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 200);
      }
    } catch (e) {
      // Silently fail
    }
  }

  /// Vibrate con patron de éxito
  static Future<void> success() async {
    try {
      if (await Vibration.hasVibrator()) {
        // Vibrate pattern: short, short, long
        await Vibration.vibrate(duration: 50);
        await Future.delayed(const Duration(milliseconds: 50));
        await Vibration.vibrate(duration: 50);
        await Future.delayed(const Duration(milliseconds: 50));
        await Vibration.vibrate(duration: 150);
      }
    } catch (e) {
      // Silently fail
    }
  }

  /// Vibrate con patron de error
  static Future<void> error() async {
    try {
      if (await Vibration.hasVibrator()) {
        // Vibrate pattern: long, short
        await Vibration.vibrate(duration: 200);
        await Future.delayed(const Duration(milliseconds: 100));
        await Vibration.vibrate(duration: 100);
      }
    } catch (e) {
      // Silently fail
    }
  }

  /// Vibrate con patron de advertencia
  static Future<void> warning() async {
    try {
      if (await Vibration.hasVibrator()) {
        // Vibrate pattern: medium, medium
        await Vibration.vibrate(duration: 100);
        await Future.delayed(const Duration(milliseconds: 100));
        await Vibration.vibrate(duration: 100);
      }
    } catch (e) {
      // Silently fail
    }
  }

  /// Vibrate para swipe (como Tinder)
  static Future<void> swipe({required bool isLike}) async {
    try {
      if (await Vibration.hasVibrator()) {
        if (isLike) {
          // Success pattern for like
          await success();
        } else {
          // Light impact for pass
          await lightImpact();
        }
      }
    } catch (e) {
      // Silently fail
    }
  }

  /// Vibrate para logro (badge desbloqueado, level up)
  static Future<void> achievement() async {
    try {
      if (await Vibration.hasVibrator()) {
        // Vibrate pattern: short, medium, short, long
        await Vibration.vibrate(duration: 50);
        await Future.delayed(const Duration(milliseconds: 50));
        await Vibration.vibrate(duration: 100);
        await Future.delayed(const Duration(milliseconds: 100));
        await Vibration.vibrate(duration: 50);
        await Future.delayed(const Duration(milliseconds: 100));
        await Vibration.vibrate(duration: 200);
      }
    } catch (e) {
      // Silently fail
    }
  }

  /// Vibrate para nivel nuevo
  static Future<void> levelUp() async {
    try {
      if (await Vibration.hasVibrator()) {
        // Vibrate pattern: short, short, short, long, long, long
        for (var i = 0; i < 3; i++) {
          await Vibration.vibrate(duration: 50);
          await Future.delayed(const Duration(milliseconds: 50));
        }
        await Future.delayed(const Duration(milliseconds: 100));
        for (var i = 0; i < 3; i++) {
          await Vibration.vibrate(duration: 100);
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }
    } catch (e) {
      // Silently fail
    }
  }

  /// Vibrate para completar quest
  static Future<void> questComplete() async {
    try {
      if (await Vibration.hasVibrator()) {
        // Vibrate pattern: medium, short, medium
        await Vibration.vibrate(duration: 100);
        await Future.delayed(const Duration(milliseconds: 50));
        await Vibration.vibrate(duration: 50);
        await Future.delayed(const Duration(milliseconds: 50));
        await Vibration.vibrate(duration: 100);
      }
    } catch (e) {
      // Silently fail
    }
  }

  /// Vibrate para XP ganado
  static Future<void> xpGained({required int xpAmount}) async {
    try {
      if (await Vibration.hasVibrator()) {
        // Vibrate intensity based on XP amount
        final intensity = (xpAmount / 100).clamp(1, 5).toInt();
        final duration = 50 * intensity;
        await Vibration.vibrate(duration: duration);
      }
    } catch (e) {
      // Silently fail
    }
  }

  /// Vibrate para notificación de push
  static Future<void> notification() async {
    try {
      if (await Vibration.hasVibrator()) {
        // Vibrate pattern: short, medium, medium
        await Vibration.vibrate(duration: 50);
        await Future.delayed(const Duration(milliseconds: 100));
        await Vibration.vibrate(duration: 100);
        await Future.delayed(const Duration(milliseconds: 100));
        await Vibration.vibrate(duration: 100);
      }
    } catch (e) {
      // Silently fail
    }
  }

  /// Vibrate continuo (para efectos especiales)
  static Future<void> continuous({
    required int durationMs,
    int? amplitude,
    int? pattern,
  }) async {
    try {
      if (await Vibration.hasVibrator()) {
        await Vibration.vibrate(duration: durationMs);
      }
    } catch (e) {
      // Silently fail
    }
  }

  /// Cancelar vibración
  static Future<void> cancel() async {
    try {
      await Vibration.cancel();
    } catch (e) {
      // Silently fail
    }
  }
}

/// Sistema de sonidos para LifeVibes
class SoundEffectService {
  /// Nota: Esto requiere archivos de audio en assets/audio/
  /// Por ahora, usaremos solo feedback háptico

  /// Reproducir sonido de click
  static Future<void> playClick() async {
    // TODO: Implement audio playback
    // await _playSound('click.mp3');
    await HapticFeedbackService.lightImpact();
  }

  /// Reproducir sonido de éxito
  static Future<void> playSuccess() async {
    // TODO: Implement audio playback
    // await _playSound('success.mp3');
    await HapticFeedbackService.success();
  }

  /// Reproducir sonido de error
  static Future<void> playError() async {
    // TODO: Implement audio playback
    // await _playSound('error.mp3');
    await HapticFeedbackService.error();
  }

  /// Reproducir sonido de level up
  static Future<void> playLevelUp() async {
    // TODO: Implement audio playback
    // await _playSound('level_up.mp3');
    await HapticFeedbackService.levelUp();
  }

  /// Reproducir sonido de badge desbloqueado
  static Future<void> playBadgeUnlocked() async {
    // TODO: Implement audio playback
    // await _playSound('badge_unlocked.mp3');
    await HapticFeedbackService.achievement();
  }

  /// Reproducir sonido de swipe
  static Future<void> playSwipe({required bool isLike}) async {
    // TODO: Implement audio playback
    // await _playSound(isLike ? 'swipe_like.mp3' : 'swipe_pass.mp3');
    await HapticFeedbackService.swipe(isLike: isLike);
  }
}
