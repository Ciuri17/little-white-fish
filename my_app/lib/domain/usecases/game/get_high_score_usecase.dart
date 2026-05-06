import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/game/score_entity.dart';
import '../repositories/game/score_repository.dart';

/// UseCase to get the highest score
class GetHighScoreUsecase {
  final ScoreRepository repository;

  const GetHighScoreUsecase(this.repository);

  /// Call the usecase
  /// Returns the highest ScoreEntity or null if no scores exist, or Failure
  Future<Either<Failure, ScoreEntity?>> call() async {
    return await repository.getHighScore();
  }
}
