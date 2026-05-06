import 'package:dartz/dartz.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../domain/entities/game/fish_entity.dart';
import '../../domain/entities/game/obstacle_entity.dart';
import '../../domain/entities/game/game_state_entity.dart';
import '../../domain/repositories/game/game_repository.dart';
import '../datasources/local/game_local_datasource.dart';

/// Implementation of GameRepository
class GameRepositoryImpl implements GameRepository {
  final GameLocalDatasource localDatasource;

  const GameRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, void>> initializeGame({
    required double screenWidth,
    required double screenHeight,
  }) async {
    try {
      await localDatasource.initialize(
        screenWidth: screenWidth,
        screenHeight: screenHeight,
      );
      return const Right(null);
    } on GameException catch (e) {
      return Left(GameFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GameStateEntity>> updateGameState(
      double deltaTime) async {
    try {
      final result = await localDatasource.updateGameState(deltaTime);
      return Right(result);
    } on GameException catch (e) {
      return Left(GameFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FishEntity>> getFishState() async {
    try {
      final result = await localDatasource.getFishState();
      return Right(result);
    } on GameException catch (e) {
      return Left(GameFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FishEntity>> updateFishWithInput(
      bool isHolding) async {
    try {
      final result = await localDatasource.updateFishWithInput(isHolding);
      return Right(result);
    } on GameException catch (e) {
      return Left(GameFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ObstacleEntity>>> getObstacles() async {
    try {
      final result = await localDatasource.getObstacles();
      return Right(result);
    } on GameException catch (e) {
      return Left(GameFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ObstacleEntity?>> checkCollision(
      FishEntity fish) async {
    try {
      final result = await localDatasource.checkCollision(fish);
      return Right(result);
    } on GameException catch (e) {
      return Left(GameFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ObstacleEntity>>> checkCollectibles(
      FishEntity fish) async {
    try {
      final result = await localDatasource.checkCollectibles(fish);
      return Right(result);
    } on GameException catch (e) {
      return Left(GameFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ObstacleEntity>>> generateObstacles(
    double difficulty,
    double screenHeight,
  ) async {
    try {
      final result =
          await localDatasource.generateObstacles(difficulty, screenHeight);
      return Right(result);
    } on GameException catch (e) {
      return Left(GameFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> togglePause() async {
    try {
      await localDatasource.togglePause();
      return const Right(null);
    } on GameException catch (e) {
      return Left(GameFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GameStateEntity>> endGame() async {
    try {
      final result = await localDatasource.endGame();
      return Right(result);
    } on GameException catch (e) {
      return Left(GameFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetGame() async {
    try {
      await localDatasource.resetGame();
      return const Right(null);
    } on GameException catch (e) {
      return Left(GameFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GameStateEntity>> getGameState() async {
    try {
      final result = await localDatasource.getGameState();
      return Right(result);
    } on GameException catch (e) {
      return Left(GameFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
