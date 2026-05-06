part of 'game_bloc.dart';

/// Base state for game
abstract class GameState extends Equatable {
  const GameState();
}

/// Initial state
class GameInitialState extends GameState {
  const GameInitialState();

  @override
  List<Object> get props => [];
}

/// Game loading
class GameLoadingState extends GameState {
  const GameLoadingState();

  @override
  List<Object> get props => [];
}

/// Game is running
class GameRunningState extends GameState {
  final GameStateEntity gameState;
  final FishEntity fish;
  final List<ObstacleEntity> obstacles;
  final ScoreEntity? highScore;

  const GameRunningState({
    required this.gameState,
    required this.fish,
    required this.obstacles,
    required this.highScore,
  });

  @override
  List<Object> get props => [gameState, fish, obstacles, highScore ?? ''];
}

/// Game is paused
class GamePausedState extends GameState {
  final GameStateEntity gameState;
  final FishEntity fish;
  final List<ObstacleEntity> obstacles;

  const GamePausedState({
    required this.gameState,
    required this.fish,
    required this.obstacles,
  });

  @override
  List<Object> get props => [gameState, fish, obstacles];
}

/// Game over
class GameOverState extends GameState {
  final GameStateEntity gameState;
  final ScoreEntity savedScore;
  final ScoreEntity? highScore;
  final bool isNewHighScore;

  const GameOverState({
    required this.gameState,
    required this.savedScore,
    required this.highScore,
    required this.isNewHighScore,
  });

  @override
  List<Object> get props => [gameState, savedScore, highScore ?? '', isNewHighScore];
}

/// Error state
class GameErrorState extends GameState {
  final String message;

  const GameErrorState(this.message);

  @override
  List<Object> get props => [message];
}
