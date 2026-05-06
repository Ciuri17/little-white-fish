import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/game/fish_entity.dart';

part 'fish_model.g.dart';

/// Fish data model (DTO - Data Transfer Object)
/// Used for API responses and local storage
@JsonSerializable()
class FishModel {
  @JsonKey(name: 'x')
  final double x;

  @JsonKey(name: 'y')
  final double y;

  @JsonKey(name: 'velocityX')
  final double velocityX;

  @JsonKey(name: 'velocityY')
  final double velocityY;

  @JsonKey(name: 'width')
  final double width;

  @JsonKey(name: 'height')
  final double height;

  @JsonKey(name: 'rotation')
  final double rotation;

  @JsonKey(name: 'isAlive')
  final bool isAlive;

  const FishModel({
    required this.x,
    required this.y,
    required this.velocityX,
    required this.velocityY,
    required this.width,
    required this.height,
    required this.rotation,
    required this.isAlive,
  });

  /// Convert JSON to model
  factory FishModel.fromJson(Map<String, dynamic> json) =>
      _$FishModelFromJson(json);

  /// Convert model to JSON
  Map<String, dynamic> toJson() => _$FishModelToJson(this);

  /// Convert FishModel to FishEntity (domain layer)
  FishEntity toEntity() {
    return FishEntity(
      x: x,
      y: y,
      velocityX: velocityX,
      velocityY: velocityY,
      width: width,
      height: height,
      rotation: rotation,
      isAlive: isAlive,
    );
  }

  /// Create model from entity
  factory FishModel.fromEntity(FishEntity entity) {
    return FishModel(
      x: entity.x,
      y: entity.y,
      velocityX: entity.velocityX,
      velocityY: entity.velocityY,
      width: entity.width,
      height: entity.height,
      rotation: entity.rotation,
      isAlive: entity.isAlive,
    );
  }
}
