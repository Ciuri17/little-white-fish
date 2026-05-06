import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../bloc/game/game_bloc.dart';

/// Game over screen showing final score and stats
class GameOverPage extends StatelessWidget {
  const GameOverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          if (state is! GameOverState) {
            return const SizedBox.shrink();
          }

          final isNewRecord = state.isNewHighScore;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.indigo.shade900,
                  Colors.purple.shade900,
                  Colors.black,
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 30),

                    // Game Over Title
                    Column(
                      children: [
                        if (isNewRecord)
                          Column(
                            children: [
                              const Text(
                                '🎉',
                                style: TextStyle(fontSize: 80),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'NEW RECORD!',
                                style: AppTextStyles.displayLarge.copyWith(
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              const Text(
                                '💀',
                                style: TextStyle(fontSize: 80),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'GAME OVER',
                                style: AppTextStyles.displayLarge.copyWith(
                                  color: Colors.red[300],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Score Display
                    Container(
                      padding: const EdgeInsets.all(24),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white30,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Final Score',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            state.gameState.score.toString(),
                            style: AppTextStyles.displayMedium.copyWith(
                              color: Colors.white,
                              fontSize: 56,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Stats Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildStatCard(
                            icon: '⏱️',
                            label: 'Time Survived',
                            value:
                                '${state.gameState.timeElapsed.toStringAsFixed(1)}s',
                          ),
                          _buildStatCard(
                            icon: '📏',
                            label: 'Distance',
                            value:
                                '${(state.gameState.distanceTraveled / 100).toInt()}m',
                          ),
                          _buildStatCard(
                            icon: '💎',
                            label: 'Collectibles',
                            value: state.gameState.collectiblesCollected
                                .toString(),
                          ),
                          _buildStatCard(
                            icon: '🌊',
                            label: 'Biome Reached',
                            value: _getBiomeName(
                              state.gameState.biome.toString(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Best Score
                    if (state.highScore != null && !isNewRecord)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Text(
                              'Best Score',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.highScore!.score.toString(),
                              style: AppTextStyles.headlineMedium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 40),

                    // Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Play Again
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<GameBloc>().add(
                                      const GameResetEvent(),
                                    );
                                Navigator.of(context)
                                    .pushReplacementNamed('/game');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'PLAY AGAIN',
                                style: AppTextStyles.headlineMedium.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Back to Menu
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed('/');
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'MENU',
                                style: AppTextStyles.headlineMedium.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          );
        },
      ),
    );
  }

  /// Build individual stat card
  Widget _buildStatCard({
    required String icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white20,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Get readable biome name
  String _getBiomeName(String biomeString) {
    if (biomeString.contains('shallow')) return 'Shallow';
    if (biomeString.contains('twilight')) return 'Twilight';
    if (biomeString.contains('abyss')) return 'Abyss';
    return 'Unknown';
  }
}
