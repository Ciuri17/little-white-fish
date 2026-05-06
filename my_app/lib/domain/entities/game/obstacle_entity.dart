import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Types of obstacles in the game
enum ObstacleType {
  /// Static coral or rock
  coral,
  
  /// Static mine
  mine,
  
  /// Jellyfish that moves vertically
  jellyfish,
  
  /// Predator fish that swims horizontally
  predator,
  
  /// Geyser that shoots water at intervals
  geyser,
  
  /// Collectible (pearl/plankton)
  collectible,
}

/// Obstacle entity representing dangers or collectibles in the game
@immutable
class ObstacleEntity extends Equatable {
  /// Unique identifier
  final String id;

  /// Type of obstacle
  final ObstacleType type;

  /// X position
  final double x;

  /// Y position
  final double y;

  /// Width in pixels
  final double width;

  /// Height in pixels
  final double height;

  /// Horizontal velocity (for dynamic obstacles)
  final double velocityX;

  /// Vertical velocity (for dynamic obstacles like jellyfish)
  final double velocityY;

  /// Color/variant identifier
  final String variant;

  /// Additional parameters (e.g., movement range for jellyfish)
  final Map<String, dynamic> parameters;

  /// Is this obstacle still active in game?
  final bool isActive;

  /// Has player collected this? (for collectibles)
  final bool isCollected;

  const ObstacleEntity({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.velocityX,
    required this.velocityY,
    required this.variant,
    required this.parameters,
    required this.isActive,
    required this.isCollected,
  });

  /// Create a copy with modified properties
  ObstacleEntity copyWith({
    String? id,
    ObstacleType? type,
    double? x,
    double? y,
    double? width,
    double? height,
    double? velocityX,
    double? velocityY,
    String? variant,
    Map<String, dynamic>? parameters,
    bool? isActive,
    bool? isCollected,
  }) {
    return ObstacleEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      velocityX: velocityX ?? this.velocityX,
      velocityY: velocityY ?? this.velocityY,
      variant: variant ?? this.variant,
      parameters: parameters ?? this.parameters,
      isActive: isActive ?? this.isActive,
      isCollected: isCollected ?? this.isCollected,
    );
  }

  /// Get obstacle center X
  double get centerX => x + width / 2;

  /// Get obstacle center Y
  double get centerY => y + height / 2;

  /// Check if obstacle is dangerous (not collectible)
  bool get isDangerous => type != ObstacleType.collectible;

  @override
  List<Object> get props => [
    id,
    type,
    x,
    y,
    width,
    height,
    velocityX,
    velocityY,
    variant,
    parameters,
    isActive,
    isCollected,
  ];
}
