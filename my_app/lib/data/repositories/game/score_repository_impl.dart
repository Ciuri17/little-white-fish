import 'package:dartz/dartz.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../domain/entities/game/score_entity.dart';
import '../../domain/repositories/game/score_repository.dart';
import '../datasources/local/score_local_datasource.dart';
import '../mappers/game/score_mapper.dart';

/// Implementation of ScoreRepository
class ScoreRepositoryImpl implements ScoreRepository {
  final ScoreLocalDatasource localDatasource;

  const ScoreRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, ScoreEntity?>> getHighScore() async {
    try {
      final result = await localDatasource.getHighScore();
      return Right(result != null ? ScoreMapper.toDomain(result) : null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ScoreEntity>> saveScore(ScoreEntity score) async {
    try {
      final model = ScoreMapper.toModel(score);
      await localDatasource.saveScore(model);
      return Right(score);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ScoreEntity>>> getAllScores({
    int limit = 100,
  }) async {
    try {
      final models = await localDatasource.getAllScores(limit: limit);
      return Right(ScoreMapper.toDomainList(models));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllScores() async {
    try {
      await localDatasource.deleteAllScores();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ScoreEntity>>> getScoresToday() async {
    try {
      final models = await localDatasource.getScoresToday();
      return Right(ScoreMapper.toDomainList(models));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getAverageScore() async {
    try {
      final average = await localDatasource.getAverageScore();
      return Right(average);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isNewHighScore(int score) async {
    try {
      final highScore = await localDatasource.getHighScore();
      final isNew = highScore == null || score > highScore.score;
      return Right(isNew);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
