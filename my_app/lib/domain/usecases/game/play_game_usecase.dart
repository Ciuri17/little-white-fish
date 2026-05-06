import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/game/game_state_entity.dart';
import '../repositories/game/game_repository.dart';

/// UseCase to initialize and update game state
class PlayGameUsecase {
  final GameRepository repository;

  const PlayGameUsecase(this.repository);

  /// Call the usecase
  /// Returns updated GameStateEntity or Failure
  Future<Either<Failure, GameStateEntity>> call(double deltaTime) async {
    return await repository.updateGameState(deltaTime);
  }
}
