import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/game/score_entity.dart';

/// Repository contract for score management
abstract class ScoreRepository {
  /// Get the highest score ever achieved
  Future<Either<Failure, ScoreEntity?>> getHighScore();

  /// Save a new score
  Future<Either<Failure, ScoreEntity>> saveScore(ScoreEntity score);

  /// Get all scores (for leaderboard)
  /// limit: maximum number of scores to retrieve
  Future<Either<Failure, List<ScoreEntity>>> getAllScores({int limit = 100});

  /// Delete all scores (for testing/reset)
  Future<Either<Failure, void>> deleteAllScores();

  /// Get scores from today
  Future<Either<Failure, List<ScoreEntity>>> getScoresToday();

  /// Get average score
  Future<Either<Failure, double>> getAverageScore();

  /// Check if score is a new personal record
  Future<Either<Failure, bool>> isNewHighScore(int score);
}
