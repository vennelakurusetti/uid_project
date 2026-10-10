import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/custom_button.dart';
import 'dart:math' as math;

/// Result screen showing game statistics after completion.
class ResultScreen extends StatefulWidget {
  static const String routeName = '/result';

  ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with TickerProviderStateMixin {
  late AnimationController _confettiController;
  final List<ConfettiParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    
    // Create confetti animation
    _confettiController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Generate confetti particles
    _generateConfetti();
    
    // Start animation
    _confettiController.forward();
  }

  void _generateConfetti() {
    final random = math.Random();
    for (int i = 0; i < 50; i++) {
      _particles.add(ConfettiParticle(
        x: random.nextDouble() * 400,
        y: -random.nextDouble() * 100,
        color: Color.fromRGBO(
          random.nextInt(255),
          random.nextInt(255),
          random.nextInt(255),
          1,
        ),
        size: random.nextDouble() * 10 + 5,
        rotation: random.nextDouble() * math.pi * 2,
        velocity: random.nextDouble() * 200 + 100,
      ));
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFE91E63),
                  const Color(0xFF03A9F4),
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '🎉',
                            style: TextStyle(fontSize: 60),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Congratulations!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${provider.playerName}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                _buildResultRow('Difficulty', provider.getDifficultyName(), Icons.class_outlined),
                                const Divider(height: 16),
                                _buildResultRow('Pairs Found', '${provider.pairsFound} / ${provider.numPairs}', Icons.view_agenda),
                                const Divider(height: 16),
                                _buildResultRow('Total Moves', '${provider.moves}', Icons.shuffle),
                                const Divider(height: 16),
                                _buildResultRow('Time Taken', provider.formatTime(provider.timer), Icons.timer),
                                const Divider(height: 16),
                                _buildResultRow('Final Score', '${provider.finalScore}', Icons.score),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: 'Play Again',
                            width: double.infinity,
                            height: 48,
                            onPressed: () {
                              provider.restartGame();
                              Navigator.pushReplacementNamed(context, '/game');
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomOutlineButton(
                            text: 'Change Difficulty',
                            width: double.infinity,
                            height: 46,
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/difficulty');
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomOutlineButton(
                            text: 'Home',
                            width: double.infinity,
                            height: 46,
                            onPressed: () {
                              provider.resetGame();
                              Navigator.pushReplacementNamed(context, '/');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Confetti overlay
          IgnorePointer(
            child: AnimatedBuilder(
              animation: _confettiController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ConfettiPainter(
                    particles: _particles,
                    progress: _confettiController.value,
                  ),
                  size: Size.infinite,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class ConfettiParticle {
  final double x;
  final double y;
  final Color color;
  final double size;
  final double rotation;
  final double velocity;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.rotation,
    required this.velocity,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(1 - progress)
        ..style = PaintingStyle.fill;

      final dy = particle.y + (particle.velocity * progress);
      final rotation = particle.rotation + (progress * math.pi * 4);

      canvas.save();
      canvas.translate(particle.x, dy);
      canvas.rotate(rotation);
      
      // Draw confetti as small rectangles
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size,
          height: particle.size * 0.5,
        ),
        paint,
      );
      
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) => true;
}
