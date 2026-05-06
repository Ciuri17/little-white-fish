import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../domain/entities/game/game_state_entity.dart';
import '../../../domain/entities/game/fish_entity.dart';
import '../../../domain/entities/game/obstacle_entity.dart';
import 'fish_widget.dart';
import 'obstacle_widget.dart';

/// Main game canvas - renders fish, obstacles, and background
class GameCanvas extends StatelessWidget {
  final GameStateEntity gameState;
  final FishEntity fish;
  final List<ObstacleEntity> obstacles;
  final double screenWidth;
  final double screenHeight;
  final VoidCallback onTap;
  final bool isGameOver;

  const GameCanvas({
    super.key,
    required this.gameState,
    required this.fish,
    required this.obstacles,
    required this.screenWidth,
    required this.screenHeight,
    required this.onTap,
    this.isGameOver = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isGameOver ? null : onTap,
      onTapDown: (_) {
        // Input is handled by bloc
      },
      child: Stack(
        children: [
          // Background with gradient based on biome
          _buildBackground(),

          // Parallax background elements
          _buildParallaxLayer(),

          // Game objects
          SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Stack(
              children: [
                // Render obstacles
                ...obstacles.where((o) => o.isActive).map(
                  (obstacle) => ObstacleWidget(
                    obstacle: obstacle,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    elapsedTime: gameState.timeElapsed,
                  ),
                ),

                // Render fish
                FishWidget(
                  fish: fish,
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),
              ],
            ),
          ),

          // UI Overlay
          _buildUIOverlay(),

          // Pause overlay if paused
          if (gameState.isPaused)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'PAUSED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Tap to resume',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build background gradient based on biome
  Widget _buildBackground() {
    List<Color> colors;
    switch (gameState.biome) {
      case BiomeType.shallow:
        colors = [
          Colors.blue.shade200,
          Colors.blue.shade300,
          Colors.blue.shade400,
        ];
        break;
      case BiomeType.twilight:
        colors = [
          Colors.green.shade700,
          Colors.blue.shade800,
          Colors.indigo.shade900,
        ];
        break;
      case BiomeType.abyss:
        colors = [
          Colors.indigo.shade900,
          Colors.black,
          Colors.purple.shade900,
        ];
        break;
    }

    return Container(
      width: screenWidth,
      height: screenHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
    );
  }

  /// Parallax scrolling background elements
  Widget _buildParallaxLayer() {
    final offset = gameState.parallaxOffset;
    final biome = gameState.biome;

    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        children: [
          // Animated background shapes (bubbles, particles, etc)
          if (biome == BiomeType.shallow)
            _buildBubbles(offset)
          else if (biome == BiomeType.twilight)
            _buildAlgae(offset)
          else
            _buildBioluminescence(offset),
        ],
      ),
    );
  }

  /// Render floating bubbles for shallow biome
  Widget _buildBubbles(double offset) {
    return Positioned(
      top: offset % screenHeight,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBubble(40, 0.2),
          SizedBox(height: screenHeight * 0.15),
          _buildBubble(25, 0.3),
          SizedBox(height: screenHeight * 0.2),
          _buildBubble(35, 0.15),
          SizedBox(height: screenHeight * 0.15),
          _buildBubble(20, 0.25),
        ],
      ),
    );
  }

  /// Single bubble widget
  Widget _buildBubble(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white.withOpacity(opacity),
          width: 2,
        ),
        shape: BoxShape.circle,
      ),
    );
  }

  /// Render moving algae for twilight biome
  Widget _buildAlgae(double offset) {
    return Positioned(
      left: offset % screenWidth,
      top: 0,
      bottom: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildAlgaeStrand(40, 60),
          _buildAlgaeStrand(60, 45),
          _buildAlgaeStrand(50, 55),
        ],
      ),
    );
  }

  /// Single algae strand
  Widget _buildAlgaeStrand(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.3),
        borderRadius: BorderRadius.circular(width / 2),
      ),
    );
  }

  /// Render bioluminescent particles for abyss biome
  Widget _buildBioluminescence(double offset) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Stack(
        children: [
          _buildBioParticle(screenWidth * 0.2, screenHeight * 0.3, Colors.cyan),
          _buildBioParticle(
              screenWidth * 0.7, screenHeight * 0.5, Colors.purple),
          _buildBioParticle(
              screenWidth * 0.4, screenHeight * 0.7, Colors.green),
          _buildBioParticle(
              screenWidth * 0.85, screenHeight * 0.2, Colors.blue),
        ],
      ),
    );
  }

  /// Single bioluminescent particle
  Widget _buildBioParticle(double x, double y, Color color) {
    return Positioned(
      left: x,
      top: y,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.6),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
      ),
    );
  }

  /// Build top UI with score and pause button
  Widget _buildUIOverlay() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Score
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Score: ${gameState.score}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Distance/Depth
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Depth: ${(gameState.distanceTraveled / 100).toInt()}m',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Pause button
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.pause,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
