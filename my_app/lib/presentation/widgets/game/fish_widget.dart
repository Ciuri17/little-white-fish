import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../domain/entities/game/fish_entity.dart';

/// Widget to render the fish
class FishWidget extends StatelessWidget {
  final FishEntity fish;
  final double screenHeight;
  final double screenWidth;

  const FishWidget({
    super.key,
    required this.fish,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: fish.x,
      top: fish.y,
      child: Transform.rotate(
        angle: fish.rotation,
        child: Container(
          width: fish.width,
          height: fish.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(fish.width / 2),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Body
              Center(
                child: Container(
                  width: fish.width * 0.8,
                  height: fish.height * 0.6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(fish.width / 3),
                  ),
                ),
              ),
              // Eye
              Positioned(
                right: fish.width * 0.15,
                top: fish.height * 0.2,
                child: Container(
                  width: fish.width * 0.15,
                  height: fish.height * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              // Fin
              Positioned(
                right: -fish.width * 0.2,
                top: fish.height * 0.3,
                child: Transform.rotate(
                  angle: 0.3,
                  child: Container(
                    width: fish.width * 0.3,
                    height: fish.height * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
