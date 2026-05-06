import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'data/datasources/local/game_local_datasource.dart';
import 'data/datasources/local/score_local_datasource.dart';
import 'data/repositories/game/game_repository_impl.dart';
import 'data/repositories/game/score_repository_impl.dart';
import 'domain/repositories/game/game_repository.dart';
import 'domain/repositories/game/score_repository.dart';
import 'domain/usecases/game/play_game_usecase.dart';
import 'domain/usecases/game/get_high_score_usecase.dart';
import 'domain/usecases/game/save_score_usecase.dart';
import 'presentation/bloc/game/game_bloc.dart';

final getIt = GetIt.instance;

/// Setup Service Locator
void setupServiceLocator() {
  // Network
  _setupNetwork();

  // Data Sources
  _setupDataSources();

  // Repositories
  _setupRepositories();

  // Use Cases
  _setupUseCases();

  // BLoCs
  _setupBLoCs();
}

void _setupNetwork() {
  // Dio HTTP Client
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.example.com',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
    ),
  );

  // Add interceptors
  dio.interceptors.add(
    LoggingInterceptor(),
  );

  getIt.registerSingleton<Dio>(dio);
}

void _setupDataSources() {
  // Game datasource
  getIt.registerSingleton<GameLocalDatasource>(
    GameLocalDatasourceImpl(),
  );

  // Score datasource
  getIt.registerSingleton<ScoreLocalDatasource>(
    ScoreLocalDatasourceImpl(),
  );
}

void _setupRepositories() {
  // Game repository
  getIt.registerSingleton<GameRepository>(
    GameRepositoryImpl(
      localDatasource: getIt<GameLocalDatasource>(),
    ),
  );

  // Score repository
  getIt.registerSingleton<ScoreRepository>(
    ScoreRepositoryImpl(
      localDatasource: getIt<ScoreLocalDatasource>(),
    ),
  );
}

void _setupUseCases() {
  // Game use cases
  getIt.registerSingleton<PlayGameUsecase>(
    PlayGameUsecase(getIt<GameRepository>()),
  );

  getIt.registerSingleton<GetHighScoreUsecase>(
    GetHighScoreUsecase(getIt<ScoreRepository>()),
  );

  getIt.registerSingleton<SaveScoreUsecase>(
    SaveScoreUsecase(getIt<ScoreRepository>()),
  );
}

void _setupBLoCs() {
  // Game BLoC
  getIt.registerSingleton<GameBloc>(
    GameBloc(
      gameRepository: getIt<GameRepository>(),
      scoreRepository: getIt<ScoreRepository>(),
      playGameUsecase: getIt<PlayGameUsecase>(),
      getHighScoreUsecase: getIt<GetHighScoreUsecase>(),
      saveScoreUsecase: getIt<SaveScoreUsecase>(),
    ),
  );
}

/// Logging Interceptor for Dio
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    handler.next(err);
  }
}
