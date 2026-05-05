# My App - Flutter Best Practices Guide 2026

## 🎯 Visió General

Aquesta aplicació Flutter segueix les millors pràctiques de desenvolupament de 2026. Aquest document serveix com a guia estricta per mantenir alta qualitat de codi, arquitectura escalable i rendiment òptim.

**Nivell:** Senior  
**Data Actualització:** Maig 2026  
**Versió Flutter:** 3.41.9+

---

## 📋 Taula de Continguts

1. [Arquitectura](#arquitectura)
2. [Estructura del Projecte](#estructura-del-projecte)
3. [Convencions de Codificació](#convencions-de-codificació)
4. [Gestió d'Estat](#gestió-destat)
5. [Optimització i Rendiment](#optimització-i-rendiment)
6. [Qualitat de Codi](#qualitat-de-codi)
7. [Testing](#testing)
8. [Dependències](#dependències)
9. [Seguretat](#seguretat)
10. [Git Workflow](#git-workflow)
11. [Documentació](#documentació)

---

## 🏗️ Arquitectura

### Patró: MVVM + BLoC (Recommended 2026)

```
Domain Layer (Models, Repositories, UseCases)
    ↓
Presentation Layer (UI, BLoCs, ViewModels)
    ↓
Data Layer (API, Local Storage, Mappers)
```

**Per què MVVM + BLoC?**

- Separació clara de responsabilitats (SoC)
- Testeable al 100%
- Escalable per a equips grans
- Reactive per defecte
- Community support fort (2026)

### Capes Definides

#### 1. **Domain Layer** (Lògica de negoci pura)

```
lib/
└── domain/
    ├── entities/          # Models de negoci (immutables)
    ├── repositories/      # Contracts (abstract classes)
    └── usecases/          # Casos d'ús (lògica de negoci)
```

- **Regla:** Zero dependències a Flutter/packages externa
- **Format:** Classes immutables amb `@immutable`
- **Excepcions:** Crear classes `Exception` personalitzades

#### 2. **Presentation Layer** (UI + Estado)

```
lib/
└── presentation/
    ├── pages/             # Pantallas/Vistes completes
    ├── widgets/           # Widgets reutilitzables
    ├── bloc/              # BLoCs (gestió d'estat)
    └── theme/             # Temes i estils globals
```

- **BLoC Pattern:** Cada pantalla principal = 1 BLoC
- **Widgets:** Desmuntar en widgets petits (<200 línies)
- **State:** Immutable (usar `equatable` o `freezed`)

#### 3. **Data Layer** (Fonts de dades)

```
lib/
└── data/
    ├── datasources/
    │   ├── remote/        # API REST, WebSocket
    │   └── local/         # SharedPreferences, SQLite, Hive
    ├── models/            # DTOs (Data Transfer Objects)
    ├── mappers/           # Entity ↔ DTO conversions
    └── repositories/      # Implementacions
```

- **Mappers:** Convertir DTO a Entity (SEMPRE)
- **Caching:** Implementar Local First Pattern
- **Erros:** Mappejar Exceptions a Domain Exceptions

---

## 📁 Estructura del Projecte

```
lib/
├── config/
│   ├── routes/
│   │   └── app_routes.dart         # Go Router config (2026 standard)
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   └── app_text_styles.dart
│   └── constants.dart              # Constants globals
│
├── core/
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart           # Result pattern (Either<Failure, Success>)
│   ├── network/
│   │   ├── dio_client.dart         # HTTP client configurat
│   │   └── network_info.dart       # Connectivitat
│   └── utils/
│       ├── logger.dart             # Logging estricte
│       └── validators.dart         # Validacions reutilitzables
│
├── domain/
│   ├── entities/
│   │   └── [feature]/
│   │       └── user_entity.dart
│   ├── repositories/
│   │   └── [feature]/
│   │       └── user_repository.dart
│   └── usecases/
│       └── [feature]/
│           └── get_user_usecase.dart
│
├── data/
│   ├── datasources/
│   │   ├── remote/
│   │   │   └── [feature]/
│   │   │       └── user_remote_datasource.dart
│   │   └── local/
│   │       └── [feature]/
│   │           └── user_local_datasource.dart
│   ├── models/
│   │   └── [feature]/
│   │       └── user_model.dart
│   ├── mappers/
│   │   └── [feature]/
│   │       └── user_mapper.dart
│   └── repositories/
│       └── [feature]/
│           └── user_repository_impl.dart
│
├── presentation/
│   ├── pages/
│   │   └── [feature]/
│   │       └── [page]_page.dart
│   ├── widgets/
│   │   ├── common/                 # Widgets generals (reutilitzables)
│   │   └── [feature]/
│   │       └── [custom_widget].dart
│   ├── bloc/
│   │   └── [feature]/
│   │       ├── [feature]_bloc.dart
│   │       ├── [feature]_event.dart
│   │       └── [feature]_state.dart
│   └── theme/
│       └── app_theme.dart
│
├── service_locator.dart            # Dependency Injection (GetIt)
└── main.dart                        # Entry point

test/
├── domain/                          # Unit tests
├── data/                            # Repository tests + mocking
└── presentation/                    # Widget + BLoC tests
```

---

## 📝 Convencions de Codificació

### Naming Conventions

```dart
// ✅ Classes
class UserEntity { }
class GetUserUsecase { }
class UserBloc { }
class UserPage { }

// ✅ Variables i constants
const String appName = 'MyApp';
final String userName = 'John';
int userAge = 25;

// ✅ Private
String _privateValue = '';
void _privateMethod() { }

// ✅ BLoC Events i States
class UserLoadingState extends UserState { }
class UserFetchEvent extends UserEvent { }

// ✅ Métodes
void calculateUserAge() { }
Future<void> fetchUsers() { }
Stream<UserState> getUserStream() { }
```

### Dart Formatting

```dart
// Run regularment:
dart format lib/ --set-exit-if-changed
dart analyze lib/
```

### Documentation

```dart
/// Fetch user by [id] from remote API.
///
/// Throws [UserException] if user not found.
/// Returns [UserEntity] on success.
Future<UserEntity> getUserById(String id) async {
  // Implementation
}
```

---

## 🔄 Gestió d'Estat

### Pattern: BLoC + Equatable (2026)

#### 1. **Event-Driven Architecture**

```dart
// user_event.dart
part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class UserFetchEvent extends UserEvent {
  final String userId;
  const UserFetchEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class UserUpdateEvent extends UserEvent {
  final UserEntity user;
  const UserUpdateEvent(this.user);

  @override
  List<Object> get props => [user];
}
```

#### 2. **State Management**

```dart
// user_state.dart
part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoaded extends UserState {
  final UserEntity user;
  const UserLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  final String message;
  const UserError(this.message);

  @override
  List<Object> get props => [message];
}
```

#### 3. **BLoC Implementation**

```dart
// user_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserUsecase _getUserUsecase;

  UserBloc({required GetUserUsecase getUserUsecase})
      : _getUserUsecase = getUserUsecase,
        super(UserInitial()) {
    on<UserFetchEvent>(_onUserFetch);
    on<UserUpdateEvent>(_onUserUpdate);
  }

  Future<void> _onUserFetch(
    UserFetchEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final result = await _getUserUsecase(event.userId);
      result.fold(
        (failure) => emit(UserError(failure.message)),
        (user) => emit(UserLoaded(user)),
      );
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUserUpdate(
    UserUpdateEvent event,
    Emitter<UserState> emit,
  ) async {
    // Implementation
  }
}
```

#### 4. **UI Integration**

```dart
// user_page.dart
class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UserLoaded) {
            return UserView(user: state.user);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
```

---

## ⚡ Optimització i Rendiment

### 1. **Widget Optimization**

```dart
// ❌ EVITAR: Rebuilds innecessaris
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => expensiveOperation(), // BAD
      child: Text('Tap'),
    );
  }
}

// ✅ CORRECTE: Separar en widgets
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<MyBloc>().add(MyEvent()),
      child: const _ButtonWidget(),
    );
  }
}

class _ButtonWidget extends StatelessWidget {
  const _ButtonWidget();

  @override
  Widget build(BuildContext context) => const Text('Tap');
}
```

### 2. **Const Constructors (ALWAYS)**

```dart
// ✅ Sempre que sigui possible
const MyWidget(
  child: const Text('Hello'),
  style: const TextStyle(fontSize: 16),
);
```

### 3. **ListView Performance**

```dart
// ✅ CORRECTE: ListView.builder amb itemExtent
ListView.builder(
  itemExtent: 80,  // Height fixe = millor performance
  itemCount: items.length,
  itemBuilder: (context, index) => ListItemWidget(item: items[index]),
)

// ✅ Paginació per a llistes grans
class PaginatedListBloc extends Bloc<PaginatedEvent, PaginatedState> {
  int _page = 1;
  bool _hasMoreData = true;

  // Implementation
}
```

### 4. **Image Caching**

```dart
// ✅ Sempre usar caching
Image.network(
  url,
  cacheHeight: 300,
  cacheWidth: 300,
  memoryCache: true,
)

// ✅ Per a imatges locals
Image.asset(
  'assets/image.png',
  cacheHeight: 300,
  cacheWidth: 300,
)
```

### 5. **Futures i Streams**

```dart
// ❌ EVITAR: Múltiples FutureBuilders
FutureBuilder<User>(
  future: fetchUser(),  // Es cridarà cada rebuild
  builder: ...
)

// ✅ CORRECTE: Usar BLoC o cache
BlocBuilder<UserBloc, UserState>(
  builder: ...
)
```

### 6. **Provider vs BLoC**

- **BLoC:** Aplicacions grans, equips, architects complexes
- **Provider:** Sense estado complicat, CRUD simples
- **Riverpod:** 2026 alternative modern

### 7. **Profiling i Monitoring**

```dart
// Usar Flutter DevTools regularment
// flutter pub global activate devtools
// devtools

// O dins de codi:
import 'package:flutter/foundation.dart';

debugPrint('User loaded: ${stopwatch.elapsedMilliseconds}ms');
```

---

## ✅ Qualitat de Codi

### 1. **DRY - Don't Repeat Yourself**

```dart
// ❌ REPETIT
Text('Welcome', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
Text('Goodbye', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));

// ✅ CORRECTE: Extract a method/class
class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
}

Text('Welcome', style: AppTextStyles.heading);
Text('Goodbye', style: AppTextStyles.heading);
```

### 2. **SOLID Principles**

#### Single Responsibility Principle

```dart
// ❌ BAD: Múltiples responsabilitats
class UserManager {
  void fetchUser() { }        // API call
  void saveToLocal() { }      // Local storage
  void validateData() { }     // Validation
  void showUI() { }           // UI logic
}

// ✅ CORRECTE: Separar responsabilitats
class UserRepository { }      // Data
class UserValidator { }       // Validation
class UserBloc { }            // State management
class UserPage { }            // UI
```

#### Open/Closed Principle

```dart
// ✅ Extensible sense modificar
abstract class Repository<T> {
  Future<Either<Failure, T>> getAll();
  Future<Either<Failure, T>> getById(String id);
}

class UserRepositoryImpl extends Repository<UserEntity> {
  // Implementation
}
```

### 3. **Null Safety (ALWAYS)**

```dart
// ✅ Sempre definir nullability
String? optionalString;
String requiredString = 'value';
List<String> requiredList = [];

// ✅ Null coalescing
String name = user?.name ?? 'Unknown';

// ✅ Late initialization
late String lateValue;
```

### 4. **Error Handling (Result Pattern)**

```dart
// ✅ Either<Failure, Success> Pattern
abstract class Either<L, R> {}

class Left<L, R> extends Either<L, R> {
  final L failure;
  Left(this.failure);
}

class Right<L, R> extends Either<L, R> {
  final R success;
  Right(this.success);
}

// Usage
Future<Either<Failure, UserEntity>> getUser() async {
  try {
    final response = await api.getUser();
    return Right(UserMapper.toDomain(response));
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  }
}
```

### 5. **Code Metrics**

Mantenir aquests estàndards:

- **Cyclomatic Complexity:** < 10
- **Lines per function:** < 50
- **Lines per file:** < 300
- **Code coverage:** > 80%

```bash
# Analitzar
dart analyze lib/

# Metriques (si ús falk_linter)
flutter pub global activate dart_code_metrics
dcm analyze lib/
```

---

## 🧪 Testing

### 1. **Unit Tests (Domain)**

```dart
// test/domain/usecases/get_user_usecase_test.dart
void main() {
  late GetUserUsecase usecase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    usecase = GetUserUsecase(mockRepository);
  });

  group('GetUserUsecase', () {
    test('should return UserEntity when call is successful', () async {
      // Arrange
      const String userId = '1';
      final tUserEntity = UserEntity(id: userId, name: 'John');
      when(mockRepository.getUserById(userId))
          .thenAnswer((_) async => Right(tUserEntity));

      // Act
      final result = await usecase(userId);

      // Assert
      expect(result, Right(tUserEntity));
      verify(mockRepository.getUserById(userId));
    });
  });
}
```

### 2. **Widget Tests**

```dart
// test/presentation/widgets/user_widget_test.dart
void main() {
  testWidgets('UserWidget displays user name', (WidgetTester tester) async {
    const userEntity = UserEntity(id: '1', name: 'John');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserWidget(user: userEntity),
        ),
      ),
    );

    expect(find.text('John'), findsOneWidget);
  });
}
```

### 3. **BLoC Tests**

```dart
// test/presentation/bloc/user_bloc_test.dart
void main() {
  late UserBloc userBloc;
  late MockGetUserUsecase mockGetUserUsecase;

  setUp(() {
    mockGetUserUsecase = MockGetUserUsecase();
    userBloc = UserBloc(getUserUsecase: mockGetUserUsecase);
  });

  tearDown(() => userBloc.close());

  group('UserBloc', () {
    test('emits [UserLoading, UserLoaded] when UserFetchEvent is added',
        () async {
      const userId = '1';
      final tUserEntity = UserEntity(id: userId, name: 'John');

      when(mockGetUserUsecase(userId))
          .thenAnswer((_) async => Right(tUserEntity));

      expectLater(
        userBloc.stream,
        emitsInOrder([
          UserLoading(),
          UserLoaded(tUserEntity),
        ]),
      );

      userBloc.add(UserFetchEvent(userId));
    });
  });
}
```

### 4. **Testing Coverage**

```bash
# Generar coverage
flutter test --coverage

# Visualitzar
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 📦 Dependències

### Essencials (2026)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.0
  equatable: ^2.0.5

  # Navigation & Routing
  go_router: ^13.0.0

  # Dependency Injection
  get_it: ^7.6.0

  # HTTP Client
  dio: ^5.4.0

  # Local Storage
  hive: ^2.2.3

  # JSON Serialization
  json_serializable: ^6.7.0

  # Logging
  logger: ^2.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  # Testing
  mockito: ^3.46.0
  bloc_test: ^9.1.0

  # Code Generation
  build_runner: ^2.4.6
  hive_generator: ^2.0.0
  json_serializable: ^6.7.0

  # Linting
  very_good_analysis: ^6.0.0
```

### Evitar:

- Packages obsoletes o sense manteniment
- Versions flotants (sempre especificar ^X.Y.Z)
- Dependències múltiples del mateix propòsit

---

## 🔐 Seguretat

### 1. **Secrets Management**

```dart
// ❌ NEVER - Secrets en codi
const String apiKey = 'sk_live_abc123...';

// ✅ CORRECTE - Variables d'entorn
const String apiKey = String.fromEnvironment('API_KEY');

// flutter run --dart-define=API_KEY=sk_live_abc123
```

### 2. **HTTPS Only**

```dart
// ✅ Sempre HTTPS
final dio = Dio();
dio.options.baseUrl = 'https://api.example.com';

// ❌ NEVER HTTP en producció
```

### 3. **Validació de Dades**

```dart
// ✅ Validar input sempre
class EmailValidator {
  static bool isValid(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }
}

String? validateEmail(String value) {
  if (!EmailValidator.isValid(value)) {
    return 'Email inválid';
  }
  return null;
}
```

### 4. **Encriptació Sensible**

```dart
// ✅ Usar flutter_secure_storage per a tokens
final storage = FlutterSecureStorage();
await storage.write(key: 'token', value: authToken);
```

---

## 📚 Git Workflow

### Branch Naming

```
feature/feature-name          # Nova funcionalitat
bugfix/bug-description        # Solució de bugs
hotfix/critical-issue         # Hotfixes urgents
refactor/code-area            # Refactorization
docs/documentation-update     # Documentació
```

### Commit Messages

```
feat: add user authentication module
fix: resolve null pointer in user repository
refactor: simplify user bloc logic
docs: update README with architecture guide
test: add user bloc tests
chore: update dependencies
```

### Pull Request Checklist

- [ ] Unit tests afegits/actualitzats
- [ ] Widget tests per a nous widgets
- [ ] Coverage > 80%
- [ ] Code analyzed (no warnings)
- [ ] Documentation actualitzada
- [ ] No hardcoded values
- [ ] Performance reviewed

---

## 📖 Documentació

### Class Documentation

````dart
/// A repository that handles user data operations.
///
/// This repository serves as an intermediary between the data layer
/// and the domain layer, handling both remote and local data sources.
///
/// Example:
/// ```dart
/// final repo = UserRepository(datasource);
/// final user = await repo.getUserById('123');
/// ```
class UserRepository {
  // Implementation
}
````

### README per Feature

```
features/
└── user_management/
    ├── README.md              # Documentació de la feature
    ├── domain/
    ├── data/
    └── presentation/
```

---

## 🚀 Checklist Abans de Commit

```
□ No debug prints (debugPrint)
□ No TODO comments sense data
□ Trailing commas en constructors
□ Const widgets on possible
□ Error handling complet
□ Unit tests > 80% coverage
□ No warnings en análisis
□ Null safety complet
□ Documentació actualitzada
□ Performance profiled
□ Security review completat
```

---

## 📞 Referencies

- [Flutter Best Practices 2026](https://flutter.dev)
- [Clean Code in Flutter](https://resocoder.com)
- [BLoC Pattern](https://bloclibrary.dev)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)
- [Result Pattern](https://www.freecodecamp.org)

---

## 📝 Notes Finals

**"El codi es llegeix més vegades que no es escriu."**

Segueix aquest README com un document viu. Actualitza-ho conforme aprenguis més. La qualitat no es negocia.

**Èxits! 🎉**
