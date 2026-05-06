import 'dart:math';
import '../../../core/error/exceptions.dart';
import '../../../domain/entities/game/fish_entity.dart';
import '../../../domain/entities/game/obstacle_entity.dart';
import '../../../domain/entities/game/game_state_entity.dart';

/// Game logic and state management
abstract class GameLocalDatasource {
  /// Initialize game
  Future<void> initialize({
    required double screenWidth,
    required double screenHeight,
  });

  /// Update game state
  Future<GameStateEntity> updateGameState(double deltaTime);

  /// Get current fish state
  Future<FishEntity> getFishState();

  /// Update fish based on input
  Future<FishEntity> updateFishWithInput(bool isHolding);

  /// Get all obstacles
  Future<List<ObstacleEntity>> getObstacles();

  /// Check collision
  Future<ObstacleEntity?> checkCollision(FishEntity fish);

  /// Check collectibles
  Future<List<ObstacleEntity>> checkCollectibles(FishEntity fish);

  /// Generate obstacles
  Future<List<ObstacleEntity>> generateObstacles(
    double difficulty,
    double screenHeight,
  );

  /// Toggle pause
  Future<void> togglePause();

  /// End game
  Future<GameStateEntity> endGame();

  /// Reset game
  Future<void> resetGame();

  /// Get game state
  Future<GameStateEntity> getGameState();
}

/// Implementation of game logic
class GameLocalDatasourceImpl implements GameLocalDatasource {
  // Game state
  late FishEntity _fish;
  late GameStateEntity _gameState;
  late List<ObstacleEntity> _obstacles;
  late double _screenWidth;
  late double _screenHeight;

  // Physics constants
  static const double _gravity = 300; // pixels/second²
  static const double _maxFallVelocity = 400;
  static const double _thrustForce = -600; // negative = upward
  static const double _dampingFactor = 0.95;
  static const double _rotationSpeed = 4; // radians/second

  @override
  Future<void> initialize({
    required double screenWidth,
    required double screenHeight,
  }) async {
    try {
      _screenWidth = screenWidth;
      _screenHeight = screenHeight;
      _fish = FishEntity.initial(
        screenWidth: screenWidth,
        screenHeight: screenHeight,
      );
      _gameState = GameStateEntity.initial();
      _obstacles = [];
    } catch (e) {
      throw GameException('Failed to initialize game: $e');
    }
  }

  @override
  Future<GameStateEntity> updateGameState(double deltaTime) async {
    try {
      if (_gameState.isGameOver || _gameState.isPaused) {
        return _gameState;
      }

      // Update game time
      final newTime = _gameState.timeElapsed + deltaTime;
      final newDistance = _gameState.distanceTraveled + (deltaTime * 50);

      // Update biome based on distance
      final newBiome = GameStateEntity.getBiomeFromDistance(newDistance);

      // Update difficulty
      final newDifficulty =
          GameStateEntity.getDifficultyFromScore(_gameState.score);

      // Update parallax for visual effect
      final newParallax =
          (_gameState.parallaxOffset + deltaTime * 30) % _screenHeight;

      _gameState = _gameState.copyWith(
        timeElapsed: newTime,
        distanceTraveled: newDistance,
        biome: newBiome,
        difficultyLevel: newDifficulty,
        parallaxOffset: newParallax,
        speedMultiplier: 1.0 + (newDifficulty - 1.0) * 0.3,
      );

      // Generate new obstacles if needed
      if (_obstacles.isEmpty) {
        _obstacles = await generateObstacles(newDifficulty, _screenHeight);
      }

      // Move obstacles
      _obstacles = _obstacles.map((obstacle) {
        if (!obstacle.isActive) return obstacle;

        double newX = obstacle.x - deltaTime * 100 * _gameState.speedMultiplier;
        double newY = obstacle.y;

        // Handle jellyfish vertical movement
        if (obstacle.type == ObstacleType.jellyfish) {
          final range = obstacle.parameters['range'] as double? ?? 50;
          final speed = obstacle.parameters['speed'] as double? ?? 50;
          final centerY = obstacle.parameters['centerY'] as double? ?? newY;

          final oscillation = sin(newTime * speed / 1000) * range;
          newY = centerY + oscillation;
        }

        // Remove if off-screen
        if (newX < -obstacle.width) {
          return obstacle.copyWith(isActive: false);
        }

        return obstacle.copyWith(x: newX, y: newY);
      }).toList();

      return _gameState;
    } catch (e) {
      throw GameException('Failed to update game state: $e');
    }
  }

  @override
  Future<FishEntity> getFishState() async {
    return _fish;
  }

  @override
  Future<FishEntity> updateFishWithInput(bool isHolding) async {
    try {
      // Update velocity
      double newVelocityY = _fish.velocityY + _gravity * 0.016; // deltaTime ~= 16ms
      if (isHolding) {
        newVelocityY += _thrustForce * 0.016;
      }

      // Clamp velocity
      newVelocityY = newVelocityY.clamp(-300, _maxFallVelocity);

      // Apply damping
      newVelocityY *= _dampingFactor;

      // Update position
      double newY = _fish.y + newVelocityY * 0.016;

      // Screen boundaries
      if (newY < 0) newY = 0;
      if (newY + _fish.height > _screenHeight) {
        newY = _screenHeight - _fish.height;
      }

      // Calculate rotation based on velocity
      double targetRotation = newVelocityY / _maxFallVelocity * (pi / 3); // Max 60 degrees
      double newRotation =
          _fish.rotation + (_rotationSpeed * (targetRotation - _fish.rotation)) * 0.016;

      _fish = _fish.copyWith(
        y: newY,
        velocityY: newVelocityY,
        rotation: newRotation,
      );

      return _fish;
    } catch (e) {
      throw GameException('Failed to update fish: $e');
    }
  }

  @override
  Future<List<ObstacleEntity>> getObstacles() async {
    return _obstacles.where((o) => o.isActive).toList();
  }

  @override
  Future<ObstacleEntity?> checkCollision(FishEntity fish) async {
    try {
      for (var obstacle in _obstacles) {
        if (!obstacle.isActive || !obstacle.isDangerous) continue;

        // Simple AABB collision detection with smaller hitbox
        final fishHitboxMargin = 5;
        const fishRect = (
          x: fish.x + fishHitboxMargin,
          y: fish.y + fishHitboxMargin,
          width: fish.width - 2 * fishHitboxMargin,
          height: fish.height - 2 * fishHitboxMargin,
        );

        if (fishRect.x < obstacle.x + obstacle.width &&
            fishRect.x + fishRect.width > obstacle.x &&
            fishRect.y < obstacle.y + obstacle.height &&
            fishRect.y + fishRect.height > obstacle.y) {
          return obstacle;
        }
      }
      return null;
    } catch (e) {
      throw GameException('Failed to check collision: $e');
    }
  }

  @override
  Future<List<ObstacleEntity>> checkCollectibles(FishEntity fish) async {
    try {
      final collected = <ObstacleEntity>[];

      for (var i = 0; i < _obstacles.length; i++) {
        final obstacle = _obstacles[i];
        if (!obstacle.isActive ||
            obstacle.type != ObstacleType.collectible ||
            obstacle.isCollected) {
          continue;
        }

        // Larger hitbox for collectibles
        if ((fish.centerX - obstacle.centerX).abs() < 40 &&
            (fish.centerY - obstacle.centerY).abs() < 40) {
          collected.add(obstacle);
          _obstacles[i] = obstacle.copyWith(isCollected: true, isActive: false);

          // Update score
          _gameState = _gameState.copyWith(
            score: _gameState.score + 10,
            collectiblesCollected: _gameState.collectiblesCollected + 1,
            comboCounter: _gameState.comboCounter + 1,
          );
        }
      }

      return collected;
    } catch (e) {
      throw GameException('Failed to check collectibles: $e');
    }
  }

  @override
  Future<List<ObstacleEntity>> generateObstacles(
    double difficulty,
    double screenHeight,
  ) async {
    try {
      final random = Random();
      final obstacles = <ObstacleEntity>[];
      const obstacleGap = 200;

      for (int i = 0; i < 5; i++) {
        final x = _screenWidth + (i * obstacleGap);
        final y = random.nextDouble() * (screenHeight - 60);

        // Randomly choose obstacle type
        final typeIndex = random.nextInt(3);
        final type = [
          ObstacleType.coral,
          ObstacleType.mine,
          ObstacleType.jellyfish,
        ][typeIndex];

        obstacles.add(
          ObstacleEntity(
            id: 'obs_${DateTime.now().millisecondsSinceEpoch}_$i',
            type: type,
            x: x,
            y: y,
            width: 40,
            height: 40,
            velocityX: -100 * difficulty,
            velocityY: 0,
            variant: 'default',
            parameters: type == ObstacleType.jellyfish
                ? {
                    'centerY': y,
                    'range': 50,
                    'speed': 100,
                  }
                : {},
            isActive: true,
            isCollected: false,
          ),
        );

        // Add collectible
        if (random.nextDouble() > 0.5) {
          obstacles.add(
            ObstacleEntity(
              id: 'col_${DateTime.now().millisecondsSinceEpoch}_$i',
              type: ObstacleType.collectible,
              x: x + 100,
              y: y - 80,
              width: 15,
              height: 15,
              velocityX: -100 * difficulty,
              velocityY: 0,
              variant: 'pearl',
              parameters: {},
              isActive: true,
              isCollected: false,
            ),
          );
        }
      }

      return obstacles;
    } catch (e) {
      throw GameException('Failed to generate obstacles: $e');
    }
  }

  @override
  Future<void> togglePause() async {
    try {
      _gameState = _gameState.copyWith(isPaused: !_gameState.isPaused);
    } catch (e) {
      throw GameException('Failed to toggle pause: $e');
    }
  }

  @override
  Future<GameStateEntity> endGame() async {
    try {
      _gameState = _gameState.copyWith(isGameOver: true);
      return _gameState;
    } catch (e) {
      throw GameException('Failed to end game: $e');
    }
  }

  @override
  Future<void> resetGame() async {
    try {
      await initialize(screenWidth: _screenWidth, screenHeight: _screenHeight);
    } catch (e) {
      throw GameException('Failed to reset game: $e');
    }
  }

  @override
  Future<GameStateEntity> getGameState() async {
    return _gameState;
  }
}
