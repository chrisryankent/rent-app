import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rental_connect/tenant_screens/bottom_navbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final List<ExplosionParticle> _explosionParticles = [];
  bool _showText = false;
  bool _showTagline = false;
  Timer? _navigationTimer;
  bool _explosionTriggered = false;
  final int _particleCount = 40;
  final int _explosionCount = 80;

  @override
  void initState() {
    super.initState();
    
    // Initialize rotating particles
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(Particle(
        color: _getRandomColor(),
        radius: Random().nextDouble() * 6 + 4,
        angle: 2 * pi * i / _particleCount,
        distance: Random().nextDouble() * 150 + 100,
      ));
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() => setState(() {}));

    // Start animation sequence
    _startAnimationSequence();
  }

  void _startAnimationSequence() {
    // Phase 1: Particle rotation (0-4s)
    _controller.animateTo(0.4, duration: const Duration(seconds: 4));

    // Phase 2: Convergence (4-6s)
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) _controller.animateTo(0.6, duration: const Duration(seconds: 2));
    });

    // Phase 3: Logo reveal (6-7s)
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) setState(() => _showText = true);
    });

    // Phase 4: Text explosion (7-9s)
    Future.delayed(const Duration(seconds: 7), () {
      if (mounted) {
        setState(() {
          _showText = false;
          _explosionTriggered = true;
          _initExplosionParticles();
        });
        _controller.animateTo(0.8, duration: const Duration(seconds: 2));
      }
    });

    // Phase 5: Tagline reveal (9-10s)
    Future.delayed(const Duration(seconds: 9), () {
      if (mounted) setState(() => _showTagline = true);
      _controller.animateTo(1.0, duration: const Duration(seconds: 1));
    });

    // Navigate after completion
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToNextScreen();
      }
    });
  }

  void _initExplosionParticles() {
    _explosionParticles.clear();
    final screenSize = MediaQuery.of(context).size;
    final center = Offset(screenSize.width / 2, screenSize.height / 2);
    
    for (int i = 0; i < _explosionCount; i++) {
      _explosionParticles.add(ExplosionParticle(
        color: _getRandomColor(),
        radius: Random().nextDouble() * 6 + 3,
        center: center,
        angle: 2 * pi * Random().nextDouble(),
        distance: Random().nextDouble() * 300 + 150,
      ));
    }
  }

  Color _getRandomColor() {
    final colors = [
      const Color(0xFF4CA1AF),
      const Color(0xFF2C3E50),
      const Color(0xFFF0C27B),
      const Color(0xFFC06C84),
      const Color(0xFF1F3A5F),
      const Color(0xFFF8B195),
    ];
    return colors[Random().nextInt(colors.length)];
  }

  void _navigateToNextScreen() {
    if (_navigationTimer?.isActive ?? false) return;
    
    _navigationTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainApp()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final center = Offset(screenSize.width / 2, screenSize.height / 2);
    final progress = _controller.value;

    // Update particles only in their active phases
    if (progress <= 0.6) {
      for (final particle in _particles) {
        particle.update(progress, center);
      }
    }
    
    if (_explosionTriggered) {
      for (final particle in _explosionParticles) {
        particle.update((progress - 0.7) / 0.3);
      }
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: const [
              Color(0xFF0A0E21),
              Color(0xFF1D2671),
            ],
            stops: const [0.3, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Rotating particles (first phase)
            if (progress <= 0.6)
              for (final particle in _particles)
                Positioned(
                  left: particle.position.dx - particle.radius,
                  top: particle.position.dy - particle.radius,
                  child: Opacity(
                    opacity: particle.opacity,
                    child: Container(
                      width: particle.radius * 2,
                      height: particle.radius * 2,
                      decoration: BoxDecoration(
                        color: particle.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: particle.color.withOpacity(0.7),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            
            // Explosion particles (final phase)
            if (_explosionTriggered)
              for (final particle in _explosionParticles)
                Positioned(
                  left: particle.position.dx - particle.radius,
                  top: particle.position.dy - particle.radius,
                  child: Opacity(
                    opacity: particle.opacity,
                    child: Container(
                      width: particle.radius * 2,
                      height: particle.radius * 2,
                      decoration: BoxDecoration(
                        color: particle.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: particle.color.withOpacity(0.7),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            
            // RoomFinder Text
            if (_showText)
              Center(
                child: Transform.translate(
                  offset: const Offset(0, -50),
                  child: AnimatedOpacity(
                    opacity: _showText ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      'RoomFinder',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'PlayfairDisplay',
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [
                              Color(0xFFf6d365),
                              Color(0xFFfda085),
                            ],
                          ).createShader(const Rect.fromLTWH(0.0, 0.0, 300.0, 100.0)),
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            
            // Luxury tagline
            if (_showTagline)
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  opacity: _showTagline ? 1.0 : 0.0,
                  duration: const Duration(seconds: 1),
                  child: const Text(
                    'Luxury Living, Effortlessly Found',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            
            // Luxury icons
            Positioned(
              top: 100,
              left: 30,
              child: Transform.rotate(
                angle: progress * pi,
                child: Opacity(
                  opacity: 0.6,
                  child: Icon(
                    Icons.diamond,
                    color: Colors.white.withOpacity(0.4),
                    size: 28,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 150,
              right: 40,
              child: Transform.rotate(
                angle: -progress * pi,
                child: Opacity(
                  opacity: 0.6,
                  child: Icon(
                    Icons.star,
                    color: Colors.white.withOpacity(0.4),
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Particle {
  final Color color;
  final double radius;
  final double angle;
  final double distance;
  late double opacity;
  late double scale;
  Offset position = Offset.zero;
  final double startDistance;

  Particle({
    required this.color,
    required this.radius,
    required this.angle,
    required this.distance,
  }) : startDistance = distance {
    opacity = 1.0;
    scale = 1.0;
  }

  void update(double progress, Offset center) {
    final phase = progress * 10;
    
    if (progress < 0.4) {
      // Rotation phase
      final currentDistance = startDistance * (1 - progress * 2.5);
      position = Offset(
        center.dx + currentDistance * cos(angle + phase),
        center.dy + currentDistance * sin(angle + phase),
      );
      opacity = 1.0;
      scale = 0.8 + 0.2 * sin(phase);
    } else if (progress < 0.6) {
      // Convergence phase
      final convergeProgress = (progress - 0.4) / 0.2;
      final currentDistance = startDistance * (1 - convergeProgress);
      position = Offset(
        center.dx + currentDistance * cos(angle),
        center.dy + currentDistance * sin(angle),
      );
      opacity = 1.0 - convergeProgress * 0.5;
      scale = 1.0;
    }
  }
}

class ExplosionParticle {
  final Color color;
  final double radius;
  final Offset center;
  final double angle;
  final double distance;
  late double opacity;
  Offset position;
  double speed;

  ExplosionParticle({
    required this.color,
    required this.radius,
    required this.center,
    required this.angle,
    required this.distance,
  }) : position = center,
       speed = Random().nextDouble() * 0.8 + 0.2 {
    opacity = 1.0;
  }

  void update(double progress) {
    if (progress < 1.0) {
      final currentDistance = distance * progress;
      position = Offset(
        center.dx + currentDistance * cos(angle),
        center.dy + currentDistance * sin(angle),
      );
      opacity = 1.0 - progress;
    }
  }
}