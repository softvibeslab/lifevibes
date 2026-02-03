import 'package:flutter/material.dart';

/// Sistema de animaciones mejorado para LifeVibes
/// Proporciona animaciones predefinidas con performance optimizado

class LifeVibesAnimations {
  /// Animación de entrada desde la izquierda
  static SlideAnimation slideInLeft({
    Duration duration = const Duration(milliseconds: 300),
    Offset begin = const Offset(-1.0, 0.0),
    Offset end = Offset.zero,
    Curve curve = Curves.easeOut,
  }) {
    return SlideAnimation(
      duration: duration,
      begin: begin,
      end: end,
      curve: curve,
    );
  }

  /// Animación de entrada desde la derecha
  static SlideAnimation slideInRight({
    Duration duration = const Duration(milliseconds: 300),
    Offset begin = const Offset(1.0, 0.0),
    Offset end = Offset.zero,
    Curve curve = Curves.easeOut,
  }) {
    return SlideAnimation(
      duration: duration,
      begin: begin,
      end: end,
      curve: curve,
    );
  }

  /// Animación de entrada desde arriba
  static SlideAnimation slideInUp({
    Duration duration = const Duration(milliseconds: 300),
    Offset begin = const Offset(0.0, -1.0),
    Offset end = Offset.zero,
    Curve curve = Curves.easeOut,
  }) {
    return SlideAnimation(
      duration: duration,
      begin: begin,
      end: end,
      curve: curve,
    );
  }

  /// Animación de entrada desde abajo
  static SlideAnimation slideInDown({
    Duration duration = const Duration(milliseconds: 300),
    Offset begin = const Offset(0.0, 1.0),
    Offset end = Offset.zero,
    Curve curve = Curves.easeOut,
  }) {
    return SlideAnimation(
      duration: duration,
      begin: begin,
      end: end,
      curve: curve,
    );
  }

  /// Animación de fade in
  static FadeAnimation fadeIn({
    Duration duration = const Duration(milliseconds: 300),
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.easeIn,
  }) {
    return FadeAnimation(
      duration: duration,
      begin: begin,
      end: end,
      curve: curve,
    );
  }

  /// Animación de fade out
  static FadeAnimation fadeOut({
    Duration duration = const Duration(milliseconds: 300),
    double begin = 1.0,
    double end = 0.0,
    Curve curve = Curves.easeOut,
  }) {
    return FadeAnimation(
      duration: duration,
      begin: begin,
      end: end,
      curve: curve,
    );
  }

  /// Animación de escala
  static ScaleAnimation scale({
    Duration duration = const Duration(milliseconds: 300),
    double begin = 0.8,
    double end = 1.0,
    Curve curve = Curves.elasticOut,
  }) {
    return ScaleAnimation(
      duration: duration,
      begin: begin,
      end: end,
      curve: curve,
    );
  }

  /// Animación de rotación
  static RotationAnimation rotation({
    Duration duration = const Duration(milliseconds: 500),
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.easeInOut,
  }) {
    return RotationAnimation(
      duration: duration,
      begin: begin,
      end: end,
      curve: curve,
    );
  }

  /// Animación combinada: slide + fade
  static CombinedAnimation slideFade({
    Duration duration = const Duration(milliseconds: 300),
    Offset slideBegin = const Offset(-1.0, 0.0),
    Offset slideEnd = Offset.zero,
    double fadeBegin = 0.0,
    double fadeEnd = 1.0,
    Curve curve = Curves.easeOut,
  }) {
    return CombinedAnimation(
      duration: duration,
      slideBegin: slideBegin,
      slideEnd: slideEnd,
      fadeBegin: fadeBegin,
      fadeEnd: fadeEnd,
      curve: curve,
    );
  }

  /// Animación combinada: scale + fade
  static CombinedAnimation scaleFade({
    Duration duration = const Duration(milliseconds: 300),
    double scaleBegin = 0.8,
    double scaleEnd = 1.0,
    double fadeBegin = 0.0,
    double fadeEnd = 1.0,
    Curve curve = Curves.easeOut,
  }) {
    return CombinedAnimation(
      duration: duration,
      scaleBegin: scaleBegin,
      scaleEnd: scaleEnd,
      fadeBegin: fadeBegin,
      fadeEnd: fadeEnd,
      curve: curve,
    );
  }

  /// Animación de bouncing (para botones, etc.)
  static BounceAnimation bounce({
    Duration duration = const Duration(milliseconds: 400),
    double begin = 0.8,
    double end = 1.0,
  }) {
    return BounceAnimation(
      duration: duration,
      begin: begin,
      end: end,
    );
  }

  /// Animación de shimmer (para loading)
  static ShimmerAnimation shimmer({
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return ShimmerAnimation(
      duration: duration,
    );
  }

  /// Animación de celebración (para logros)
  static CelebrationAnimation celebration({
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    return CelebrationAnimation(
      duration: duration,
    );
  }

  /// Animación de confeti (para logros importantes)
  static ConfettiAnimation confetti({
    Duration duration = const Duration(milliseconds: 2000),
  }) {
    return ConfettiAnimation(
      duration: duration,
    );
  }
}

/// Clases de animación personalizadas

class SlideAnimation extends StatelessWidget {
  final Duration duration;
  final Offset begin;
  final Offset end;
  final Curve curve;
  final Widget child;

  const SlideAnimation({
    super.key,
    required this.duration,
    required this.begin,
    required this.end,
    required this.curve,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: begin, end: end),
      duration: duration,
      curve: curve,
      builder: (context, offset, child) {
        return Transform.translate(
          offset: offset,
          child: child,
        );
      },
      child: child,
    );
  }
}

class FadeAnimation extends StatelessWidget {
  final Duration duration;
  final double begin;
  final double end;
  final Curve curve;
  final Widget child;

  const FadeAnimation({
    super.key,
    required this.duration,
    required this.begin,
    required this.end,
    required this.curve,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: end),
      duration: duration,
      curve: curve,
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
      child: child,
    );
  }
}

class ScaleAnimation extends StatelessWidget {
  final Duration duration;
  final double begin;
  final double end;
  final Curve curve;
  final Widget child;

  const ScaleAnimation({
    super.key,
    required this.duration,
    required this.begin,
    required this.end,
    required this.curve,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: end),
      duration: duration,
      curve: curve,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: child,
    );
  }
}

class RotationAnimation extends StatelessWidget {
  final Duration duration;
  final double begin;
  final double end;
  final Curve curve;
  final Widget child;

  const RotationAnimation({
    super.key,
    required this.duration,
    required this.begin,
    required this.end,
    required this.curve,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: end),
      duration: duration,
      curve: curve,
      builder: (context, rotation, child) {
        return Transform.rotate(
          angle: rotation * 6.28, // 2 * PI
          child: child,
        );
      },
      child: child,
    );
  }
}

class CombinedAnimation extends StatefulWidget {
  final Duration duration;
  final Offset slideBegin;
  final Offset slideEnd;
  final double scaleBegin;
  final double scaleEnd;
  final double fadeBegin;
  final double fadeEnd;
  final Curve curve;
  final Widget child;

  const CombinedAnimation({
    super.key,
    required this.duration,
    required this.slideBegin,
    required this.slideEnd,
    this.scaleBegin = 1.0,
    this.scaleEnd = 1.0,
    this.fadeBegin = 1.0,
    this.fadeEnd = 1.0,
    required this.curve,
    required this.child,
  });

  @override
  State<CombinedAnimation> createState() => _CombinedAnimationState();
}

class _CombinedAnimationState extends State<CombinedAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final curve = widget.curve.transform(_controller.value);

        return Transform.translate(
          offset: Offset.lerp(
            widget.slideBegin,
            widget.slideEnd,
            curve,
          )!,
          child: Transform.scale(
            scale: double.lerp(
              widget.scaleBegin,
              widget.scaleEnd,
              curve,
            )!,
            child: Opacity(
              opacity: double.lerp(
                widget.fadeBegin,
                widget.fadeEnd,
                curve,
              )!,
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

class BounceAnimation extends StatefulWidget {
  final Duration duration;
  final double begin;
  final double end;
  final Widget child;

  const BounceAnimation({
    super.key,
    required this.duration,
    required this.begin,
    required this.end,
    required this.child,
  });

  @override
  State<BounceAnimation> createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<BounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: widget.begin, end: widget.end),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.end, end: widget.begin * 0.95),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.begin * 0.95, end: widget.end),
        weight: 20,
      ),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class ShimmerAnimation extends StatefulWidget {
  final Duration duration;

  const ShimmerAnimation({
    super.key,
    required this.duration,
  });

  @override
  State<ShimmerAnimation> createState() => _ShimmerAnimationState();
}

class _ShimmerAnimationState extends State<ShimmerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();

    _animation = Tween<double>(begin: -2.0, end: 2.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.grey[100]!,
            Colors.grey[300]!,
            Colors.grey[100]!,
          ],
          stops: const [-1.0, 0.0, 1.0],
          transform: _animation.value == null
              ? null
              : GradientRotation(_animation.value * 3.1415926 / 180),
        ),
      ),
    );
  }
}

class CelebrationAnimation extends StatefulWidget {
  final Duration duration;

  const CelebrationAnimation({
    super.key,
    required this.duration,
  });

  @override
  State<CelebrationAnimation> createState() => _CelebrationAnimationState();
}

class _CelebrationAnimationState extends State<CelebrationAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
    );
  }
}

class ConfettiAnimation extends StatefulWidget {
  final Duration duration;

  const ConfettiAnimation({
    super.key,
    required this.duration,
  });

  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Create particles
    particles = List.generate(50, (index) {
      return _Particle.random();
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ConfettiPainter(
            particles: particles,
            progress: _controller.value,
          ),
          child: child,
        );
      },
    );
  }
}

class _Particle {
  final double x;
  final double y;
  final Color color;
  final double size;
  final double speedX;
  final double speedY;
  final double rotation;
  final double rotationSpeed;

  _Particle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.rotation,
    required this.rotationSpeed,
  });

  factory _Particle.random() {
    final random = DateTime.now().millisecond;
    return _Particle(
      x: 0.5,
      y: 0.5,
      color: [
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.yellow,
        Colors.purple,
        Colors.orange,
        Colors.pink,
      ][random % 7],
      size: 5.0 + (random % 10),
      speedX: (random - 500) / 1000.0,
      speedY: (random - 500) / 1000.0 - 1.0, // Upwards
      rotation: random.toDouble(),
      rotationSpeed: (random - 500) / 1000.0,
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()..color = particle.color;

      // Update position
      final x = particle.x + (particle.speedX * progress);
      final y = particle.y + (particle.speedY * progress);
      final rotation = particle.rotation + (particle.rotationSpeed * progress * 6.28);

      canvas.save();
      canvas.translate(size.width * x, size.height * y);
      canvas.rotate(rotation);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size,
          height: particle.size,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
