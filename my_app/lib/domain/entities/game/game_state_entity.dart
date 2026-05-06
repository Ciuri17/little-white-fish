import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Game biomes with different visual and difficulty characteristics
enum BiomeType {
  /// Clear blue waters - easy, relaxing
  shallow,
  
  /// Green waters with caves - medium difficulty
  twilight,
  
  /// Dark abyss - hard, bioluminescent only
  abyss,
}

/// Represents the overall state and progression of the game
@immutable
class GameStateEntity extends Equatable {
  /// Current score
  final int score;

  /// Current game difficulty level (increases with score)
  final double difficultyLevel;

  /// Current biome based on progression
  final BiomeType biome;

  /// Base game speed multiplier (1.0 = normal)
  final double speedMultiplier;

  /// Game time elapsed in seconds
  final double timeElapsed;

  /// Distance traveled (used for biome progression)
  final double distanceTraveled;

  /// Is game paused?
  final bool isPaused;

  /// Is game over?
  final bool isGameOver;

  /// Combo counter for consecutive collectibles
  final int comboCounter;

  /// Total collectibles collected
  final int collectiblesCollected;

  /// Background parallax offset
  final double parallaxOffset;

  /// Settings: is sound enabled?
  final bool isSoundEnabled;

  /// Current language code (e.g., 'en', 'ca')
  final String languageCode;

  const GameStateEntity({
    required this.score,
    required this.difficultyLevel,
    required this.biome,
    required this.speedMultiplier,
    required this.timeElapsed,
    required this.distanceTraveled,
    required this.isPaused,
    required this.isGameOver,
    required this.comboCounter,
    required this.collectiblesCollected,
    required this.parallaxOffset,
    required this.isSoundEnabled,
    required this.languageCode,
  });

  /// Create initial game state
  factory GameStateEntity.initial({
    bool isSoundEnabled = true,
    String languageCode = 'en',
  }) {
    return GameStateEntity(
      score: 0,
      difficultyLevel: 1.0,
      biome: BiomeType.shallow,
      speedMultiplier: 1.0,
      timeElapsed: 0,
      distanceTraveled: 0,
      isPaused: false,
      isGameOver: false,
      comboCounter: 0,
      collectiblesCollected: 0,
      parallaxOffset: 0,
      isSoundEnabled: isSoundEnabled,
      languageCode: languageCode,
    );
  }

  /// Copy with modifications
  GameStateEntity copyWith({
    int? score,
    double? difficultyLevel,
    BiomeType? biome,
    double? speedMultiplier,
    double? timeElapsed,
    double? distanceTraveled,
    bool? isPaused,
    bool? isGameOver,
    int? comboCounter,
    int? collectiblesCollected,
    double? parallaxOffset,
    bool? isSoundEnabled,
    String? languageCode,
  }) {
    return GameStateEntity(
      score: score ?? this.score,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      biome: biome ?? this.biome,
      speedMultiplier: speedMultiplier ?? this.speedMultiplier,
      timeElapsed: timeElapsed ?? this.timeElapsed,
      distanceTraveled: distanceTraveled ?? this.distanceTraveled,
      isPaused: isPaused ?? this.isPaused,
      isGameOver: isGameOver ?? this.isGameOver,
      comboCounter: comboCounter ?? this.comboCounter,
      collectiblesCollected: collectiblesCollected ?? this.collectiblesCollected,
      parallaxOffset: parallaxOffset ?? this.parallaxOffset,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  /// Calculate biome based on distance
  static BiomeType getBiomeFromDistance(double distance) {
    if (distance < 1000) return BiomeType.shallow;
    if (distance < 2000) return BiomeType.twilight;
    return BiomeType.abyss;
  }

  /// Calculate difficulty multiplier based on score
  static double getDifficultyFromScore(int score) {
    // Starts at 1.0, increases by 0.1 every 500 points
    return 1.0 + (score / 500) * 0.1;
  }

  @override
  List<Object> get props => [
    score,
    difficultyLevel,
    biome,
    speedMultiplier,
    timeElapsed,
    distanceTraveled,
    isPaused,
    isGameOver,
    comboCounter,
    collectiblesCollected,
    parallaxOffset,
    isSoundEnabled,
    languageCode,
  ];
}
