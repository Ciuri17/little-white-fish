import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../bloc/game/game_bloc.dart';

/// Menu page - Initial screen with high score and settings
class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool _isSoundEnabled = true;
  String _selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    // Load high score on menu load
    context.read<GameBloc>().add(const GameLoadHighScoreEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade200,
              Colors.blue.shade400,
              Colors.blue.shade600,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top spacing
                SizedBox(height: screenSize.height * 0.1),

                // Title
                Column(
                  children: [
                    Text(
                      '🐟',
                      style: TextStyle(fontSize: 80),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Little White Fish',
                      style: AppTextStyles.displayLarge.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Dive into the abyss',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // High score display
                BlocBuilder<GameBloc, GameState>(
                  builder: (context, state) {
                    String highScoreText = '0';
                    if (state is GameRunningState && state.highScore != null) {
                      highScoreText = state.highScore!.score.toString();
                    } else if (state is GameOverState &&
                        state.highScore != null) {
                      highScoreText = state.highScore!.score.toString();
                    }

                    return Container(
                      padding: const EdgeInsets.all(20),
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
                            'Best Score',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            highScoreText,
                            style: AppTextStyles.displayMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Play button
                SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      // Initialize game
                      context.read<GameBloc>().add(
                            GameInitializeEvent(
                              screenWidth: screenSize.width,
                              screenHeight: screenSize.height,
                            ),
                          );
                      // Navigate to game page
                      Navigator.of(context).pushReplacementNamed('/game');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 8,
                    ),
                    child: Text(
                      'PLAY',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Settings
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // Sound toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sound',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Switch(
                            value: _isSoundEnabled,
                            onChanged: (value) {
                              setState(() {
                                _isSoundEnabled = value;
                              });
                            },
                            activeColor: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Language selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Language',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          DropdownButton<String>(
                            value: _selectedLanguage,
                            dropdownColor: Colors.blue.shade600,
                            items: [
                              DropdownMenuItem(
                                value: 'en',
                                child: Text(
                                  'English',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'ca',
                                child: Text(
                                  'Català',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedLanguage = value;
                                });
                              }
                            },
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            underline: const SizedBox(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
