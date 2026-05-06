import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/game/score_entity.dart';
import '../repositories/game/score_repository.dart';

/// UseCase to save a score
class SaveScoreUsecase {
  final ScoreRepository repository;

  const SaveScoreUsecase(this.repository);

  /// Call the usecase
  /// Returns the saved ScoreEntity or Failure
  Future<Either<Failure, ScoreEntity>> call(ScoreEntity score) async {
    return await repository.saveScore(score);
  }
}
