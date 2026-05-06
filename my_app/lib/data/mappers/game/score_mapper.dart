import '../models/game/score_model.dart';
import '../../domain/entities/game/score_entity.dart';

/// Mapper for converting between ScoreModel and ScoreEntity
class ScoreMapper {
  /// Convert ScoreModel (DTO) to ScoreEntity (domain)
  static ScoreEntity toDomain(ScoreModel model) {
    return model.toEntity();
  }

  /// Convert ScoreEntity (domain) to ScoreModel (DTO)
  static ScoreModel toModel(ScoreEntity entity) {
    return ScoreModel.fromEntity(entity);
  }

  /// Convert list of models to entities
  static List<ScoreEntity> toDomainList(List<ScoreModel> models) {
    return models.map((model) => toDomain(model)).toList();
  }

  /// Convert list of entities to models
  static List<ScoreModel> toModelList(List<ScoreEntity> entities) {
    return entities.map((entity) => toModel(entity)).toList();
  }
}
