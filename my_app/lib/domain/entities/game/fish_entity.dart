import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Fish entity representing the player's character
@immutable
class FishEntity extends Equatable {
  /// Current X position (0 = left edge, screenWidth = right edge)
  final double x;

  /// Current Y position (0 = top, screenHeight = bottom)
  final double y;

  /// Horizontal velocity
  final double velocityX;

  /// Vertical velocity (positive = downward, negative = upward)
  final double velocityY;

  /// Fish width in pixels
  final double width;

  /// Fish height in pixels
  final double height;

  /// Rotation angle in radians for visual orientation
  final double rotation;

  /// Is fish alive?
  final bool isAlive;

  const FishEntity({
    required this.x,
    required this.y,
    required this.velocityX,
    required this.velocityY,
    required this.width,
    required this.height,
    required this.rotation,
    required this.isAlive,
  });

  /// Create a copy of this entity with modified properties
  FishEntity copyWith({
    double? x,
    double? y,
    double? velocityX,
    double? velocityY,
    double? width,
    double? height,
    double? rotation,
    bool? isAlive,
  }) {
    return FishEntity(
      x: x ?? this.x,
      y: y ?? this.y,
      velocityX: velocityX ?? this.velocityX,
      velocityY: velocityY ?? this.velocityY,
      width: width ?? this.width,
      height: height ?? this.height,
      rotation: rotation ?? this.rotation,
      isAlive: isAlive ?? this.isAlive,
    );
  }

  /// Initial fish state at center of screen
  factory FishEntity.initial({
    required double screenWidth,
    required double screenHeight,
    double fishWidth = 40,
    double fishHeight = 25,
  }) {
    return FishEntity(
      x: screenWidth / 2 - fishWidth / 2,
      y: screenHeight / 2 - fishHeight / 2,
      velocityX: 0,
      velocityY: 0,
      width: fishWidth,
      height: fishHeight,
      rotation: 0,
      isAlive: true,
    );
  }

  /// Get fish center X coordinate
  double get centerX => x + width / 2;

  /// Get fish center Y coordinate
  double get centerY => y + height / 2;

  @override
  List<Object> get props => [
    x,
    y,
    velocityX,
    velocityY,
    width,
    height,
    rotation,
    isAlive,
  ];
}
