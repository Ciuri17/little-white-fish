import 'package:flutter/material.dart';
import '../../../domain/entities/game/obstacle_entity.dart';

/// Widget to render obstacles with 6 different types
class ObstacleWidget extends StatelessWidget {
  final ObstacleEntity obstacle;
  final double screenWidth;
  final double screenHeight;
  final double elapsedTime; // For animations

  const ObstacleWidget({
    super.key,
    required this.obstacle,
    required this.screenWidth,
    required this.screenHeight,
    this.elapsedTime = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: obstacle.x,
      top: obstacle.y,
      child: _buildObstacleByType(),
    );
  }

  /// Build widget based on obstacle type
  Widget _buildObstacleByType() {
    switch (obstacle.type) {
      case ObstacleType.coral:
        return _buildCoral();
      case ObstacleType.mine:
        return _buildMine();
      case ObstacleType.jellyfish:
        return _buildJellyfish();
      case ObstacleType.predator:
        return _buildPredator();
      case ObstacleType.geyser:
        return _buildGeyser();
      case ObstacleType.collectible:
        return _buildCollectible();
    }
  }

  /// Brown coral shape - static
  Widget _buildCoral() {
    return Container(
      width: obstacle.width,
      height: obstacle.height,
      decoration: BoxDecoration(
        color: const Color(0xFF8B4513), // Brown
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(obstacle.width * 0.3),
          topRight: Radius.circular(obstacle.width * 0.3),
          bottomLeft: Radius.circular(obstacle.width * 0.15),
          bottomRight: Radius.circular(obstacle.width * 0.15),
        ),
      ),
      child: Stack(
        children: [
          // Coral texture
          Positioned(
            left: obstacle.width * 0.1,
            top: obstacle.height * 0.1,
            child: Container(
              width: obstacle.width * 0.2,
              height: obstacle.height * 0.3,
              decoration: BoxDecoration(
                color: Colors.brown[700],
                borderRadius: BorderRadius.circular(obstacle.width * 0.1),
              ),
            ),
          ),
          Positioned(
            right: obstacle.width * 0.1,
            top: obstacle.height * 0.15,
            child: Container(
              width: obstacle.width * 0.25,
              height: obstacle.height * 0.25,
              decoration: BoxDecoration(
                color: Colors.brown[700],
                borderRadius: BorderRadius.circular(obstacle.width * 0.12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Gray mine with spikes - static
  Widget _buildMine() {
    return Container(
      width: obstacle.width,
      height: obstacle.height,
      decoration: BoxDecoration(
        color: const Color(0xFF808080), // Gray
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Spikes around the mine
          ..._generateMineSpikes(),
        ],
      ),
    );
  }

  /// Generate spike decorations for mine
  List<Widget> _generateMineSpikes() {
    final spikes = <Widget>[];
    final spikeCount = 12;
    final spikeLength = obstacle.width * 0.3;

    for (int i = 0; i < spikeCount; i++) {
      final angle = (i / spikeCount) * 3.14159 * 2;
      final dx = (obstacle.width / 2 + spikeLength / 2) * 0.7;
      final dy = (obstacle.height / 2 + spikeLength / 2) * 0.7;

      spikes.add(
        Positioned(
          left: obstacle.width / 2 + dx * 0.4,
          top: obstacle.height / 2 + dy * 0.4,
          child: Transform.rotate(
            angle: angle,
            child: Container(
              width: spikeLength,
              height: obstacle.height * 0.08,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(obstacle.height * 0.04),
              ),
            ),
          ),
        ),
      );
    }
    return spikes;
  }

  /// Jellyfish with wavy animated tentacles
  Widget _buildJellyfish() {
    final waveOffset = (elapsedTime * 2).sin() * 5; // Oscillate 5px
    final oscillationParams = obstacle.parameters;
    final minOscillation = (oscillationParams['minOscillation'] ?? 0.5) as double;
    final maxOscillation = (oscillationParams['maxOscillation'] ?? 2.0) as double;
    final frequency = (oscillationParams['frequency'] ?? 1.0) as double;

    return Container(
      width: obstacle.width,
      height: obstacle.height,
      child: Stack(
        children: [
          // Jellyfish head
          Positioned(
            top: 0,
            left: obstacle.width * 0.25,
            child: Container(
              width: obstacle.width * 0.5,
              height: obstacle.height * 0.3,
              decoration: BoxDecoration(
                color: const Color(0xFFFF69B4), // Pink
                borderRadius: BorderRadius.circular(obstacle.width * 0.25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.4),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
          // Tentacles
          ..._generateJellyfishTentacles(
            waveOffset,
            minOscillation,
            maxOscillation,
            frequency,
          ),
        ],
      ),
    );
  }

  /// Generate wavy tentacles for jellyfish
  List<Widget> _generateJellyfishTentacles(
    double waveOffset,
    double minOsc,
    double maxOsc,
    double frequency,
  ) {
    final tentacles = <Widget>[];
    final tentacleCount = 5;
    final tentacleHeight = obstacle.height * 0.7;

    for (int i = 0; i < tentacleCount; i++) {
      final xOffset = (i - tentacleCount / 2) * (obstacle.width / tentacleCount);
      final wobble = (elapsedTime * frequency * (i + 1)).sin() * (maxOsc - minOsc) + minOsc;

      tentacles.add(
        Positioned(
          left: obstacle.width / 2 + xOffset + wobble,
          top: obstacle.height * 0.3,
          child: Container(
            width: obstacle.width * 0.12,
            height: tentacleHeight,
            decoration: BoxDecoration(
              color: Colors.pink.withOpacity(0.7),
              borderRadius: BorderRadius.circular(obstacle.width * 0.06),
            ),
          ),
        ),
      );
    }
    return tentacles;
  }

  /// Dark predator fish moving horizontally
  Widget _buildPredator() {
    return Container(
      width: obstacle.width,
      height: obstacle.height,
      decoration: BoxDecoration(
        color: const Color(0xFF2C3E50), // Dark gray-blue
        borderRadius: BorderRadius.circular(obstacle.width * 0.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Body
          Center(
            child: Container(
              width: obstacle.width * 0.7,
              height: obstacle.height * 0.6,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(obstacle.width * 0.3),
              ),
            ),
          ),
          // Eye (red for danger)
          Positioned(
            right: obstacle.width * 0.1,
            top: obstacle.height * 0.25,
            child: Container(
              width: obstacle.width * 0.15,
              height: obstacle.height * 0.25,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.5),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
          // Fin
          Positioned(
            left: -obstacle.width * 0.15,
            top: obstacle.height * 0.35,
            child: Container(
              width: obstacle.width * 0.3,
              height: obstacle.height * 0.3,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(obstacle.width * 0.1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Vertical burst effect for geyser
  Widget _buildGeyser() {
    final burstScale = (elapsedTime * 3).sin() * 0.3 + 0.7; // Oscillate 0.7-1.0

    return Container(
      width: obstacle.width,
      height: obstacle.height,
      child: Stack(
        children: [
          // Base rock
          Positioned(
            bottom: 0,
            left: obstacle.width * 0.15,
            child: Container(
              width: obstacle.width * 0.7,
              height: obstacle.height * 0.3,
              decoration: BoxDecoration(
                color: const Color(0xFF696969), // Gray rock
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(obstacle.width * 0.2),
                  bottomRight: Radius.circular(obstacle.width * 0.2),
                ),
              ),
            ),
          ),
          // Burst particles
          Center(
            child: Transform.scale(
              scale: burstScale,
              child: Container(
                width: obstacle.width * 0.6,
                height: obstacle.height * 0.8,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF87CEEB).withOpacity(0.8),
                      const Color(0xFF87CEEB).withOpacity(0.3),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Small rotating collectible (pearl/plankton)
  Widget _buildCollectible() {
    final rotation = elapsedTime * 3; // Rotate based on time

    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: obstacle.width,
        height: obstacle.height,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Colors.yellow[200]!,
              Colors.yellow[600]!,
            ],
            stops: const [0.3, 1.0],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.yellow.withOpacity(0.7),
              blurRadius: 12,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Inner sparkle
            Center(
              child: Container(
                width: obstacle.width * 0.4,
                height: obstacle.height * 0.4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Decorative sparkles
            ..._generateCollectibleSparkles(),
          ],
        ),
      ),
    );
  }

  /// Generate sparkle decorations for collectible
  List<Widget> _generateCollectibleSparkles() {
    final sparkles = <Widget>[];
    const sparkleCount = 4;

    for (int i = 0; i < sparkleCount; i++) {
      final angle = (i / sparkleCount) * 3.14159 * 2;
      final distance = obstacle.width * 0.35;
      final dx = distance * angle.cos();
      final dy = distance * angle.sin();

      sparkles.add(
        Positioned(
          left: obstacle.width / 2 + dx - obstacle.width * 0.06,
          top: obstacle.height / 2 + dy - obstacle.height * 0.06,
          child: Container(
            width: obstacle.width * 0.12,
            height: obstacle.height * 0.12,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }
    return sparkles;
  }
}
