import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/game/game_bloc.dart';
import '../widgets/game/game_canvas.dart';

/// Main game page
class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool _isHolding = false;

  @override
  void initState() {
    super.initState();
    // Start the game
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameBloc>().add(const GameStartEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocListener<GameBloc, GameState>(
        listener: (context, state) {
          if (state is GameOverState) {
            // Navigate to game over screen
            Navigator.of(context).pushReplacementNamed(
              '/game-over',
              arguments: state,
            );
          }
        },
        child: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            if (state is GameRunningState) {
              return GestureDetector(
                onTapDown: (_) {
                  setState(() => _isHolding = true);
                  context.read<GameBloc>().add(const GameInputEvent(true));
                },
                onTapUp: (_) {
                  setState(() => _isHolding = false);
                  context.read<GameBloc>().add(const GameInputEvent(false));
                },
                onTapCancel: () {
                  setState(() => _isHolding = false);
                  context.read<GameBloc>().add(const GameInputEvent(false));
                },
                child: GameCanvas(
                  gameState: state.gameState,
                  fish: state.fish,
                  obstacles: state.obstacles,
                  screenWidth: screenSize.width,
                  screenHeight: screenSize.height,
                  onTap: () {
                    // Pause button
                    context.read<GameBloc>().add(const GameTogglePauseEvent());
                  },
                  isGameOver: false,
                ),
              );
            } else if (state is GamePausedState) {
              return GameCanvas(
                gameState: state.gameState,
                fish: state.fish,
                obstacles: state.obstacles,
                screenWidth: screenSize.width,
                screenHeight: screenSize.height,
                onTap: () {
                  context.read<GameBloc>().add(const GameTogglePauseEvent());
                },
                isGameOver: false,
              );
            } else if (state is GameErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/');
                      },
                      child: const Text('Back to Menu'),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _isHolding = false;
    super.dispose();
  }
}
