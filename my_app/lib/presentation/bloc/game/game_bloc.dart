import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/game/fish_entity.dart';
import '../../../domain/entities/game/obstacle_entity.dart';
import '../../../domain/entities/game/game_state_entity.dart';
import '../../../domain/entities/game/score_entity.dart';
import '../../../domain/repositories/game/game_repository.dart';
import '../../../domain/repositories/game/score_repository.dart';
import '../../../domain/usecases/game/play_game_usecase.dart';
import '../../../domain/usecases/game/get_high_score_usecase.dart';
import '../../../domain/usecases/game/save_score_usecase.dart';

part 'game_event.dart';
part 'game_state.dart';

/// BLoC for managing game state and logic
class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRepository gameRepository;
  final ScoreRepository scoreRepository;
  final PlayGameUsecase playGameUsecase;
  final GetHighScoreUsecase getHighScoreUsecase;
  final SaveScoreUsecase saveScoreUsecase;

  // Game loop timer
  Timer? _gameLoopTimer;
  bool _isHoldingInput = false;
  ScoreEntity? _highScore;

  GameBloc({
    required this.gameRepository,
    required this.scoreRepository,
    required this.playGameUsecase,
    required this.getHighScoreUsecase,
    required this.saveScoreUsecase,
  }) : super(const GameInitialState()) {
    on<GameInitializeEvent>(_onInitialize);
    on<GameStartEvent>(_onStart);
    on<GameTickEvent>(_onTick);
    on<GameInputEvent>(_onInput);
    on<GameTogglePauseEvent>(_onTogglePause);
    on<GameCollisionEvent>(_onCollision);
    on<GameResetEvent>(_onReset);
    on<GameLoadHighScoreEvent>(_onLoadHighScore);
    on<GameSaveScoreEvent>(_onSaveScore);
  }

  /// Initialize game
  Future<void> _onInitialize(
    GameInitializeEvent event,
    Emitter<GameState> emit,
  ) async {
    emit(const GameLoadingState());

    try {
      // Initialize game
      final initResult = await gameRepository.initializeGame(
        screenWidth: event.screenWidth,
        screenHeight: event.screenHeight,
      );

      initResult.fold(
        (failure) => emit(GameErrorState(failure.message)),
        (_) async {
          // Load high score
          final highScoreResult = await getHighScoreUsecase();
          highScoreResult.fold(
            (failure) => null,
            (score) => _highScore = score,
          );

          emit(const GameInitialState());
        },
      );
    } catch (e) {
      emit(GameErrorState('Failed to initialize game: $e'));
    }
  }

  /// Start game loop
  Future<void> _onStart(
    GameStartEvent event,
    Emitter<GameState> emit,
  ) async {
    try {
      // Get initial states
      final fishResult = await gameRepository.getFishState();
      final gameStateResult = await gameRepository.getGameState();
      final obstaclesResult = await gameRepository.getObstacles();

      gameStateResult.fold(
        (failure) => emit(GameErrorState(failure.message)),
        (gameState) {
          fishResult.fold(
            (failure) => emit(GameErrorState(failure.message)),
            (fish) {
              obstaclesResult.fold(
                (failure) => emit(GameErrorState(failure.message)),
                (obstacles) {
                  emit(GameRunningState(
                    gameState: gameState,
                    fish: fish,
                    obstacles: obstacles,
                    highScore: _highScore,
                  ));

                  // Start game loop
                  _startGameLoop();
                },
              );
            },
          );
        },
      );
    } catch (e) {
      emit(GameErrorState('Failed to start game: $e'));
    }
  }

  /// Game tick (update)
  Future<void> _onTick(
    GameTickEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameRunningState) return;

    try {
      final currentState = state as GameRunningState;

      // Update game state
      final gameStateResult = await playGameUsecase(event.deltaTime);
      final fishResult = await gameRepository.updateFishWithInput(_isHoldingInput);
      final obstaclesResult = await gameRepository.getObstacles();

      gameStateResult.fold(
        (failure) => emit(GameErrorState(failure.message)),
        (gameState) {
          fishResult.fold(
            (failure) => emit(GameErrorState(failure.message)),
            (fish) {
              obstaclesResult.fold(
                (failure) => emit(GameErrorState(failure.message)),
                (obstacles) async {
                  // Check collision
                  final collisionResult =
                      await gameRepository.checkCollision(fish);

                  collisionResult.fold(
                    (failure) => emit(GameErrorState(failure.message)),
                    (collision) async {
                      if (collision != null) {
                        // Game over
                        add(GameCollisionEvent(collision.id));
                      } else {
                        // Check collectibles
                        final collectiblesResult =
                            await gameRepository.checkCollectibles(fish);

                        collectiblesResult.fold(
                          (failure) => emit(GameErrorState(failure.message)),
                          (collectibles) {
                            emit(GameRunningState(
                              gameState: gameState,
                              fish: fish,
                              obstacles: obstacles,
                              highScore: _highScore,
                            ));
                          },
                        );
                      }
                    },
                  );
                },
              );
            },
          );
        },
      );
    } catch (e) {
      emit(GameErrorState('Tick error: $e'));
    }
  }

  /// Handle player input
  Future<void> _onInput(
    GameInputEvent event,
    Emitter<GameState> emit,
  ) async {
    _isHoldingInput = event.isHolding;
  }

  /// Toggle pause
  Future<void> _onTogglePause(
    GameTogglePauseEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameRunningState) return;

    try {
      final currentState = state as GameRunningState;

      await gameRepository.togglePause();

      if (currentState.gameState.isPaused) {
        emit(GameRunningState(
          gameState: currentState.gameState.copyWith(isPaused: false),
          fish: currentState.fish,
          obstacles: currentState.obstacles,
          highScore: _highScore,
        ));
        _startGameLoop();
      } else {
        _gameLoopTimer?.cancel();
        emit(GamePausedState(
          gameState: currentState.gameState.copyWith(isPaused: true),
          fish: currentState.fish,
          obstacles: currentState.obstacles,
        ));
      }
    } catch (e) {
      emit(GameErrorState('Failed to toggle pause: $e'));
    }
  }

  /// Handle collision (game over)
  Future<void> _onCollision(
    GameCollisionEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameRunningState) return;

    _gameLoopTimer?.cancel();

    try {
      final currentState = state as GameRunningState;

      // End game
      final endResult = await gameRepository.endGame();

      endResult.fold(
        (failure) => emit(GameErrorState(failure.message)),
        (gameState) async {
          // Save score
          final scoreEntity = ScoreEntity.fromGameState(
            score: gameState.score,
            distance: gameState.distanceTraveled,
            timeElapsed: gameState.timeElapsed,
            collectibles: gameState.collectiblesCollected,
            biome: gameState.biome.toString(),
          );

          final saveResult = await saveScoreUsecase(scoreEntity);

          saveResult.fold(
            (failure) => emit(GameErrorState(failure.message)),
            (savedScore) {
              final isNewHighScore =
                  _highScore == null || savedScore.score > _highScore!.score;

              emit(GameOverState(
                gameState: gameState,
                savedScore: savedScore,
                highScore: _highScore,
                isNewHighScore: isNewHighScore,
              ));
            },
          );
        },
      );
    } catch (e) {
      emit(GameErrorState('Collision error: $e'));
    }
  }

  /// Reset game
  Future<void> _onReset(
    GameResetEvent event,
    Emitter<GameState> emit,
  ) async {
    try {
      await gameRepository.resetGame();
      add(const GameStartEvent());
    } catch (e) {
      emit(GameErrorState('Failed to reset game: $e'));
    }
  }

  /// Load high score
  Future<void> _onLoadHighScore(
    GameLoadHighScoreEvent event,
    Emitter<GameState> emit,
  ) async {
    try {
      final result = await getHighScoreUsecase();
      result.fold(
        (failure) => null,
        (score) => _highScore = score,
      );
    } catch (e) {
      // Silently fail - not critical
    }
  }

  /// Save score
  Future<void> _onSaveScore(
    GameSaveScoreEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameOverState) return;

    try {
      final currentState = state as GameOverState;
      final result = await saveScoreUsecase(currentState.savedScore);

      result.fold(
        (failure) => emit(GameErrorState(failure.message)),
        (score) => null,
      );
    } catch (e) {
      emit(GameErrorState('Failed to save score: $e'));
    }
  }

  /// Start game loop timer
  void _startGameLoop() {
    const frameDuration = Duration(milliseconds: 16); // ~60 FPS
    _gameLoopTimer = Timer.periodic(frameDuration, (timer) {
      add(GameTickEvent(frameDuration.inMilliseconds / 1000));
    });
  }

  @override
  Future<void> close() {
    _gameLoopTimer?.cancel();
    return super.close();
  }
}
