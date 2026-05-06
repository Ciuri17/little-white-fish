part of 'game_bloc.dart';

/// Base event for game
abstract class GameEvent extends Equatable {
  const GameEvent();
}

/// Initialize game with screen dimensions
class GameInitializeEvent extends GameEvent {
  final double screenWidth;
  final double screenHeight;

  const GameInitializeEvent({
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  List<Object> get props => [screenWidth, screenHeight];
}

/// Start the game loop
class GameStartEvent extends GameEvent {
  const GameStartEvent();

  @override
  List<Object> get props => [];
}

/// Update game state on each frame
class GameTickEvent extends GameEvent {
  final double deltaTime;

  const GameTickEvent(this.deltaTime);

  @override
  List<Object> get props => [deltaTime];
}

/// Player input - holding the screen
class GameInputEvent extends GameEvent {
  final bool isHolding;

  const GameInputEvent(this.isHolding);

  @override
  List<Object> get props => [isHolding];
}

/// Pause/Resume game
class GameTogglePauseEvent extends GameEvent {
  const GameTogglePauseEvent();

  @override
  List<Object> get props => [];
}

/// Handle collision
class GameCollisionEvent extends GameEvent {
  final String obstacleId;

  const GameCollisionEvent(this.obstacleId);

  @override
  List<Object> get props => [obstacleId];
}

/// Reset game
class GameResetEvent extends GameEvent {
  const GameResetEvent();

  @override
  List<Object> get props => [];
}

/// Load high score
class GameLoadHighScoreEvent extends GameEvent {
  const GameLoadHighScoreEvent();

  @override
  List<Object> get props => [];
}

/// Save current score
class GameSaveScoreEvent extends GameEvent {
  const GameSaveScoreEvent();

  @override
  List<Object> get props => [];
}
