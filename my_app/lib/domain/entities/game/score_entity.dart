import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// High score record
@immutable
class ScoreEntity extends Equatable {
  /// Unique identifier
  final String id;

  /// Final score achieved
  final int score;

  /// Timestamp when score was achieved (milliseconds since epoch)
  final int timestamp;

  /// Distance traveled
  final double distance;

  /// Time survived (in seconds)
  final double timeSurvived;

  /// Number of collectibles gathered
  final int collectiblesGathered;

  /// Which biome reached
  final String biomeReached;

  /// Device/Player identifier
  final String playerId;

  const ScoreEntity({
    required this.id,
    required this.score,
    required this.timestamp,
    required this.distance,
    required this.timeSurvived,
    required this.collectiblesGathered,
    required this.biomeReached,
    required this.playerId,
  });

  /// Create from current game state
  factory ScoreEntity.fromGameState({
    required int score,
    required double distance,
    required double timeElapsed,
    required int collectibles,
    required String biome,
  }) {
    return ScoreEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      score: score,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      distance: distance,
      timeSurvived: timeElapsed,
      collectiblesGathered: collectibles,
      biomeReached: biome,
      playerId: 'local_player', // Can be extended later for multiplayer
    );
  }

  /// Copy with modifications
  ScoreEntity copyWith({
    String? id,
    int? score,
    int? timestamp,
    double? distance,
    double? timeSurvived,
    int? collectiblesGathered,
    String? biomeReached,
    String? playerId,
  }) {
    return ScoreEntity(
      id: id ?? this.id,
      score: score ?? this.score,
      timestamp: timestamp ?? this.timestamp,
      distance: distance ?? this.distance,
      timeSurvived: timeSurvived ?? this.timeSurvived,
      collectiblesGathered: collectiblesGathered ?? this.collectiblesGathered,
      biomeReached: biomeReached ?? this.biomeReached,
      playerId: playerId ?? this.playerId,
    );
  }

  /// Get readable timestamp
  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp);

  @override
  List<Object> get props => [
    id,
    score,
    timestamp,
    distance,
    timeSurvived,
    collectiblesGathered,
    biomeReached,
    playerId,
  ];
}
