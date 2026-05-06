# Little White Fish - Implementation Guide

## Overview
This is a complete Flutter game implementation following clean architecture principles with BLoC state management. The game is a physics-based underwater adventure where players guide a little white fish through three distinct biomes while avoiding obstacles and collecting treasures.

## Project Structure

### Architecture Layers

```
lib/
├── domain/                 # Business logic (entities, repositories, use cases)
│   ├── entities/          # Pure data objects
│   │   └── game/
│   │       ├── fish_entity.dart          # Player character
│   │       ├── obstacle_entity.dart      # All 6 obstacle types
│   │       ├── game_state_entity.dart    # Game progression state
│   │       └── score_entity.dart         # High score records
│   └── repositories/      # Abstract contracts
│       └── game/
│           ├── game_repository.dart      # Game logic interface
│           └── score_repository.dart     # Score persistence interface
│   └── usecases/          # Application logic
│       └── game/
│           ├── play_game_usecase.dart
│           ├── get_high_score_usecase.dart
│           └── save_score_usecase.dart
│
├── data/                  # Data sources & repositories
│   ├── models/           # DTOs with JSON serialization
│   ├── datasources/      # Local/remote data access
│   ├── mappers/          # Entity ↔ Model conversion
│   └── repositories/     # Concrete repository implementations
│
├── presentation/         # UI & state management
│   ├── bloc/            # BLoC state machine
│   │   └── game/
│   │       ├── game_bloc.dart    # Main event handler & game loop
│   │       ├── game_event.dart   # 9 event types
│   │       └── game_state.dart   # 6 state types
│   ├── pages/           # Full-screen widgets
│   │   └── game/
│   │       ├── menu_page.dart     # Start screen
│   │       ├── game_page.dart     # Main gameplay
│   │       └── game_over_page.dart # End screen
│   └── widgets/         # Reusable components
│       └── game/
│           ├── fish_widget.dart       # Player rendering
│           ├── obstacle_widget.dart   # All 6 obstacle visuals
│           └── game_canvas.dart       # Main rendering system
│
├── config/              # Theme & routing
│   ├── theme/
│   │   ├── app_colors.dart      # Palette
│   │   ├── app_text_styles.dart # Typography
│   │   └── app_theme.dart       # Material Design theme
│   └── routes/
│       └── app_routes.dart      # Navigation configuration
│
├── core/               # Shared utilities
│   └── error/
│       ├── exceptions.dart      # Custom exceptions
│       └── failures.dart        # Either<Failure, Success> pattern
│
├── service_locator.dart # Dependency injection (GetIt)
└── main.dart           # App entry point

```

## Game Architecture

### Three-Layer Clean Architecture

**Domain Layer** (Business Rules)
- Pure Dart code, no frameworks
- Entities: `FishEntity`, `ObstacleEntity`, `GameStateEntity`, `ScoreEntity`
- Repositories: Abstract interfaces defining contracts
- UseCases: Application-specific business logic

**Data Layer** (Data Access)
- Implements domain repositories
- Models: JSON-serializable DTOs
- DataSources: Local storage access (Hive, in-memory for now)
- Mappers: Convert between models ↔ entities

**Presentation Layer** (UI & User Interaction)
- BLoC: Event-driven state machine with game loop
- Pages: Full-screen widgets
- Widgets: Reusable UI components
- Theme: Centralized design system

### BLoC Game Loop

```
Events → GameBloc → (update physics/collision/state) → States → UI Updates
```

The game runs at ~60 FPS via `Timer.periodic(Duration(milliseconds: 16))`:

1. `GameInitializeEvent` - Set up screen dimensions, load high score
2. `GameStartEvent` - Begin game loop, emit `GameRunningState`
3. `GameTickEvent` (60x per second) - Update game state, physics, collisions
4. `GameInputEvent` - Player holding/releasing screen (fish thrust)
5. `GameTogglePauseEvent` - Pause/resume
6. `GameCollisionEvent` - Obstacle hit → `GameOverState`
7. `GameResetEvent` - Return to menu

### Physics Model

```dart
// Per-frame updates (deltaTime = ~0.016 seconds)
velocityY += gravity * deltaTime              // Acceleration downward
if (isHolding) velocityY += thrustForce * dt   // Apply upward thrust
velocityY *= dampingFactor                    // Air resistance
velocityY = clamp(velocityY, -maxFallVelocity, +maxFallVelocity)
y += velocityY * deltaTime                    // Update position
rotation = atan2(velocityY, velocityX) * 1.5 // Face direction of travel

Physics Constants:
- gravity = 300 px/s²
- thrustForce = -600 (negative = upward)
- maxFallVelocity = 400 px/s
- dampingFactor = 0.95
```

### Collision Detection

**Obstacles** (5px hitbox margin around fish)
- Rectangle-Rectangle intersection (AABB)
- Triggers `GameOverState` on hit

**Collectibles** (40px detection radius)
- Circle proximity check
- Awards +10 score, increments combo

### Biome Progression

| Biome | Distance | Difficulty | Background | Decoration |
|-------|----------|------------|------------|-----------|
| Shallow | 0-1000m | Easy (1.0x) | Light blue gradient | Bubbles |
| Twilight | 1000-2000m | Medium (1.5x) | Green-indigo gradient | Algae |
| Abyss | 2000m+ | Hard (2.0x) | Black-purple gradient | Bioluminescence |

## UI/UX Design

### MenuPage
- Title: 🐟 "Little White Fish" with subtitle "Dive into the abyss"
- Best Score display (loads from persistent storage)
- PLAY button (white, rounded)
- Settings: Sound toggle, Language selector (EN/Català)
- Blue gradient background

### GamePage
- **Main Rendering**: `GameCanvas` widget
  - Biome-aware background gradient
  - Parallax scrolling decoration layer
  - Game objects (obstacles + fish)
  - UI overlay: Score, Depth (distance/100 as meters), Pause button
  - Pause overlay: Semi-transparent black with "PAUSED" text
- **Input**: Tap-down to apply thrust, tap-up to release
- **Navigation**: On game over, navigate to `/game-over`

### GameOverPage
- 💀 "GAME OVER" or 🎉 "NEW RECORD!" badge
- **Final Score**: Large, prominent display
- **Stats Grid** (2x2):
  - ⏱️ Time Survived (seconds)
  - 📏 Distance Traveled (meters)
  - 💎 Collectibles Gathered
  - 🌊 Biome Reached
- **Previous Best Score** (if not new record)
- Buttons:
  - "PLAY AGAIN" → Reset game, navigate to `/game`
  - "MENU" → Navigate to `/`
- Gradient background (indigo → purple → black)

## Obstacle Types

| Type | Visual | Behavior | Danger |
|------|--------|----------|--------|
| Coral | Brown rounded shape | Static | ✓ Deadly |
| Mine | Gray circle with spikes | Static, spins | ✓ Deadly |
| Jellyfish | Pink head + tentacles | Wavy sine oscillation | ✓ Deadly |
| Predator | Dark body + red eye | Static, menacing | ✓ Deadly |
| Geyser | Rock base + burst effect | Animated scale pulse | ✓ Deadly |
| Collectible | Yellow sphere + sparkles | Rotating, glowing | ✗ Beneficial |

## Dependencies

```yaml
flutter: 3.41.9
flutter_bloc: 8.1.0        # State management
equatable: 2.0.5           # Value equality
dartz: 0.10.1              # Either<L,R> for functional error handling
get_it: 7.6.0              # Service locator (DI)
go_router: 13.0.0          # Navigation
dio: 5.4.0                 # HTTP client (prepared)
hive: 2.2.3                # Local storage (configured)
json_annotation: 4.8.0     # JSON serialization metadata
```

## How to Run

### Prerequisites
1. Flutter 3.41.9+ installed
2. Dart SDK 3.1+
3. A mobile device or emulator (Android/iOS)

### Setup & Run

```bash
# Navigate to project
cd c:\Users\jciur\Desktop\Martí\my_app

# Install dependencies
flutter pub get

# Generate JSON serialization code
flutter pub run build_runner build

# Run on device/emulator
flutter run

# Run in verbose mode (for debugging)
flutter run -v
```

### Expected Behavior

1. **Menu Screen**
   - Fish emoji and title visible
   - "Best Score: 0" (or previous high score)
   - White PLAY button
   - Settings with Sound toggle and Language selector

2. **Tap PLAY**
   - Transitions to game screen
   - Game initializes with screen dimensions

3. **Game Screen**
   - White fish in center-left
   - Blue gradient background (shallow biome)
   - Bubbles floating upward
   - Score "0", Depth "0m" visible
   - Obstacles appear from right side, move left

4. **Input**
   - Hold screen → fish rises (yellow fin visible, rotates upward)
   - Release → fish falls (rotates downward)
   - 
5. **Collision**
   - Hit obstacle → screen shakes (optional), game ends
   - Collect gold sphere → score +10
   - Game transitions to Game Over screen

6. **Game Over Screen**
   - Shows final score prominently
   - Displays stats (time, distance, collectibles, biome)
   - Shows "NEW RECORD!" if beat previous high score
   - "PLAY AGAIN" button → Reset & restart
   - "MENU" button → Back to menu

7. **Return to Menu**
   - Best score updated if new record

## Code Quality Features

✅ **Clean Architecture**: 3 layers, strict separation of concerns
✅ **Type Safety**: Full Dart type annotations, no `dynamic`
✅ **Error Handling**: `Either<Failure, Success>` pattern throughout
✅ **Dependency Injection**: GetIt service locator, testable structure
✅ **State Management**: BLoC event-driven, single source of truth
✅ **Material Design**: Comprehensive theme configuration
✅ **Responsive**: Works on all screen sizes
✅ **Performance**: 60 FPS physics, optimized collision detection
✅ **Maintainability**: Clear folder structure, documented code

## Testing Structure (Ready for Implementation)

The codebase is prepared for unit/widget testing:

```dart
// Example unit test structure
test('Fish falls due to gravity', () {
  final fish = FishEntity.initial();
  // Call updateFishWithInput with gravity
  // Verify velocityY increased
});

test('Collision detected on AABB overlap', () {
  final fish = FishEntity(x: 100, y: 100, width: 30, height: 30);
  final obstacle = ObstacleEntity(x: 120, y: 110, width: 40, height: 40);
  // Call checkCollision()
  // Verify returns true
});
```

## Known Limitations & Future Improvements

**Current**:
- Score persistence: In-memory only (ready for Hive integration)
- No sound effects (structure prepared for audio manager)
- No animations (ready for transition/particle effects)
- No multiplayer/network (Dio prepared for future API calls)

**Next Steps**:
- Implement Hive local storage
- Add sound effect manager
- Create particle effect system
- Add difficulty tiers/endless leaderboard
- Implement ads/IAP

## Debugging Tips

**Game loop not running?**
- Check BLoC `_onStart` handler
- Verify `GameStartEvent` is fired
- Check Timer initialization

**Fish not moving?**
- Verify `GameInputEvent(true/false)` is sent on tap
- Check `_isHoldingInput` flag in BLoC
- Verify physics constants in `GameLocalDatasource`

**Obstacles not appearing?**
- Check `generateObstacles()` spawning logic
- Verify obstacle removal when off-screen
- Check screen dimensions passed to BLoC

**Navigation not working?**
- Check `app_routes.dart` route definitions
- Verify page constructors match route builders
- Check `BlocListener` navigation logic

## Files & Line References

### Core BLoC (~200 lines)
- [game_bloc.dart](lib/presentation/bloc/game/game_bloc.dart)

### Physics Engine (~300 lines)
- [game_local_datasource.dart](lib/data/datasources/local/game_local_datasource.dart)

### Rendering System (~350 lines)
- [game_canvas.dart](lib/presentation/widgets/game/game_canvas.dart)

### Obstacle Rendering (~400 lines)
- [obstacle_widget.dart](lib/presentation/widgets/game/obstacle_widget.dart)

### Main Pages
- [menu_page.dart](lib/presentation/pages/game/menu_page.dart) - Start screen
- [game_page.dart](lib/presentation/pages/game/game_page.dart) - Gameplay
- [game_over_page.dart](lib/presentation/pages/game/game_over_page.dart) - Results screen

## Key Insights

**Why Clean Architecture?**
- Business logic (physics, collision) lives in `GameLocalDatasource` (data layer)
- UI doesn't know about physics - changes via BLoC events/states
- Easy to test: mock repositories, inject test data
- Easy to refactor: change implementation without touching domain

**Why BLoC?**
- Game loop as event stream: `Timer` emits `GameTickEvent` at 60 FPS
- All state changes go through `emit()`, single source of truth
- Built-in error handling via error states
- Testable: record events, verify state outputs

**Why Either Pattern?**
- All operations can fail: disk read, calculation error, etc.
- `Either<Failure, Success>` forces handling both cases
- No silent failures or null surprises
- Clear error propagation through layers

**Physics Feel**
- Gravity = 300: Slow fall, feels floaty (underwater)
- Thrust = -600: Strong upward push, responsive control
- Damping = 0.95: Slight air resistance, prevents oscillation
- Rotation = atan2(vy, vx): Fish faces direction, natural look

## Next Development Sessions

1. **Persistence**: Integrate Hive for score storage
2. **Audio**: Add SFX manager for thrust, collectibles, collisions
3. **Effects**: Particle system for collectibles, collision impacts
4. **Polish**: Screen shake, bloom glow, post-processing
5. **Analytics**: Track player behavior, difficulty metrics
6. **Social**: Share scores, leaderboards

---

**Total Implementation**: ~3000 lines of Dart code
**Architecture Pattern**: Clean Architecture + BLoC
**Complexity Level**: Senior (intermediate advanced)
**Time to Runnable**: ~30 minutes (setup + first compile)
