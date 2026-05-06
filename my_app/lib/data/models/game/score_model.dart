import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/game/score_entity.dart';

part 'score_model.g.dart';

/// Score data model (DTO - Data Transfer Object)
@JsonSerializable()
class ScoreModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'score')
  final int score;

  @JsonKey(name: 'timestamp')
  final int timestamp;

  @JsonKey(name: 'distance')
  final double distance;

  @JsonKey(name: 'timeSurvived')
  final double timeSurvived;

  @JsonKey(name: 'collectiblesGathered')
  final int collectiblesGathered;

  @JsonKey(name: 'biomeReached')
  final String biomeReached;

  @JsonKey(name: 'playerId')
  final String playerId;

  const ScoreModel({
    required this.id,
    required this.score,
    required this.timestamp,
    required this.distance,
    required this.timeSurvived,
    required this.collectiblesGathered,
    required this.biomeReached,
    required this.playerId,
  });

  /// Convert JSON to model
  factory ScoreModel.fromJson(Map<String, dynamic> json) =>
      _$ScoreModelFromJson(json);

  /// Convert model to JSON
  Map<String, dynamic> toJson() => _$ScoreModelToJson(this);

  /// Convert ScoreModel to ScoreEntity
  ScoreEntity toEntity() {
    return ScoreEntity(
      id: id,
      score: score,
      timestamp: timestamp,
      distance: distance,
      timeSurvived: timeSurvived,
      collectiblesGathered: collectiblesGathered,
      biomeReached: biomeReached,
      playerId: playerId,
    );
  }

  /// Create model from entity
  factory ScoreModel.fromEntity(ScoreEntity entity) {
    return ScoreModel(
      id: entity.id,
      score: entity.score,
      timestamp: entity.timestamp,
      distance: entity.distance,
      timeSurvived: entity.timeSurvived,
      collectiblesGathered: entity.collectiblesGathered,
      biomeReached: entity.biomeReached,
      playerId: entity.playerId,
    );
  }
}
