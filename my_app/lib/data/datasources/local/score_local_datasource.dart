import '../../../core/error/exceptions.dart';
import '../models/game/score_model.dart';

/// Local data source for score persistence
abstract class ScoreLocalDatasource {
  /// Get the highest score stored locally
  Future<ScoreModel?> getHighScore();

  /// Save a score locally
  Future<void> saveScore(ScoreModel score);

  /// Get all stored scores
  Future<List<ScoreModel>> getAllScores({int limit = 100});

  /// Delete all scores
  Future<void> deleteAllScores();

  /// Get scores from today
  Future<List<ScoreModel>> getScoresToday();

  /// Get average score
  Future<double> getAverageScore();
}

/// Implementation using Hive for local storage
class ScoreLocalDatasourceImpl implements ScoreLocalDatasource {
  // TODO: Implement with Hive
  // For now, we'll use an in-memory list for testing

  static final List<ScoreModel> _scores = [];

  @override
  Future<ScoreModel?> getHighScore() async {
    try {
      if (_scores.isEmpty) return null;
      // Sort by score descending
      final sorted = List<ScoreModel>.from(_scores)
        ..sort((a, b) => b.score.compareTo(a.score));
      return sorted.first;
    } catch (e) {
      throw CacheException('Failed to get high score: $e');
    }
  }

  @override
  Future<void> saveScore(ScoreModel score) async {
    try {
      _scores.add(score);
    } catch (e) {
      throw CacheException('Failed to save score: $e');
    }
  }

  @override
  Future<List<ScoreModel>> getAllScores({int limit = 100}) async {
    try {
      final sorted = List<ScoreModel>.from(_scores)
        ..sort((a, b) => b.score.compareTo(a.score));
      return sorted.take(limit).toList();
    } catch (e) {
      throw CacheException('Failed to get all scores: $e');
    }
  }

  @override
  Future<void> deleteAllScores() async {
    try {
      _scores.clear();
    } catch (e) {
      throw CacheException('Failed to delete scores: $e');
    }
  }

  @override
  Future<List<ScoreModel>> getScoresToday() async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final todayTimestamp = today.millisecondsSinceEpoch;

      return _scores
          .where((score) => score.timestamp >= todayTimestamp)
          .toList();
    } catch (e) {
      throw CacheException('Failed to get today scores: $e');
    }
  }

  @override
  Future<double> getAverageScore() async {
    try {
      if (_scores.isEmpty) return 0;
      final total = _scores.fold<int>(0, (sum, score) => sum + score.score);
      return total / _scores.length;
    } catch (e) {
      throw CacheException('Failed to calculate average score: $e');
    }
  }
}
