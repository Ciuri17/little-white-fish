import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/game/fish_entity.dart';
import '../entities/game/obstacle_entity.dart';
import '../entities/game/game_state_entity.dart';

/// Repository contract for game logic and state management
abstract class GameRepository {
  /// Initialize game with screen dimensions
  Future<Either<Failure, void>> initializeGame({
    required double screenWidth,
    required double screenHeight,
  });

  /// Update game state with elapsed time
  /// Returns updated game state or failure
  Future<Either<Failure, GameStateEntity>> updateGameState(double deltaTime);

  /// Get current fish entity
  Future<Either<Failure, FishEntity>> getFishState();

  /// Update fish position based on player input
  /// isHolding: true when player holds tap, false when released
  Future<Either<Failure, FishEntity>> updateFishWithInput(bool isHolding);

  /// Get all active obstacles
  Future<Either<Failure, List<ObstacleEntity>>> getObstacles();

  /// Check collision between fish and obstacles
  /// Returns obstacle if collision, null if no collision
  Future<Either<Failure, ObstacleEntity?>> checkCollision(FishEntity fish);

  /// Check if fish collected any collectibles
  /// Returns list of collected obstacles
  Future<Either<Failure, List<ObstacleEntity>>> checkCollectibles(FishEntity fish);

  /// Generate new obstacles based on difficulty
  Future<Either<Failure, List<ObstacleEntity>>> generateObstacles(
    double difficulty,
    double screenHeight,
  );

  /// Pause/Resume game
  Future<Either<Failure, void>> togglePause();

  /// End game
  Future<Either<Failure, GameStateEntity>> endGame();

  /// Reset game state
  Future<Either<Failure, void>> resetGame();

  /// Get current game state
  Future<Either<Failure, GameStateEntity>> getGameState();
}
