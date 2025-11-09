import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/core/routes/app_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project_management/core/services/dio_client.dart';
import 'package:project_management/core/services/secure_storage_service.dart';
import 'package:project_management/features/authentication/data/data_sources/auth_local_data_source_impl.dart';
import 'package:project_management/features/authentication/data/data_sources/authentication_remote_data_source_impl.dart';
import 'package:project_management/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:project_management/features/authentication/presentation/blocs/login_bloc.dart';
import 'package:project_management/features/card/data/data_sources/card_remote_data_source_impl.dart';
import 'package:project_management/features/card/data/repositories/card_repository_impl.dart';
import 'package:project_management/features/card/domain/use_cases/create_card_use_case.dart';
import 'package:project_management/features/card/domain/use_cases/delete_card_use_case.dart';
import 'package:project_management/features/card/domain/use_cases/get_cards_use_case.dart';
import 'package:project_management/features/card/domain/use_cases/update_card_use_case.dart';
import 'package:project_management/features/card/presentation/cubits/card_cubit.dart';
import 'package:project_management/features/time_log/data/datasources/time_log_remote_data_source.dart';
import 'package:project_management/features/time_log/data/repositories/time_log_repository_impl.dart';
import 'package:project_management/features/time_log/domain/usecases/start_time_log_use_case.dart';
import 'package:project_management/features/time_log/domain/usecases/stop_time_log_use_case.dart';
import 'package:project_management/features/time_log/presentation/cubits/time_log_cubit.dart';
import 'package:project_management/features/dashboard/data/data_sources/dashboard_remote_data_source_impl.dart';
import 'package:project_management/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:project_management/features/dashboard/presentation/cubits/dashboard_cubit.dart';
import 'package:project_management/features/profile/data/data_sources/profile_remote_data_source_impl.dart';
import 'package:project_management/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:project_management/features/profile/presentation/cubits/profile_cubit.dart';

void main() {
  // atur supaya Flutter Web pakai PathUrlStrategy (tanpa #)
  usePathUrlStrategy();

  // Setup Local Data Source untuk akses token
  final localDataSource = AuthLocalDataSourceImpl(SecureStorageService());

  // Setup Dio Client dengan konfigurasi lengkap dan interceptors
  // Penjelasan bayi: Kita bikin alat buat ngomong sama server dengan aturan yang jelas
  // Token akan otomatis ditambahkan oleh AuthInterceptor
  // Kalau token expired (401), akan otomatis dihapus dan redirect dihandle oleh GoRouter
  final dioClient = DioClient(
    baseUrl: "http://127.0.0.1:8000/api",
    localDataSource: localDataSource,
    onTokenExpired: () {
      // Callback ketika token expired
      // Redirect akan dihandle otomatis oleh GoRouter redirect logic
      print('⚠️ Token expired, GoRouter akan redirect ke login page');
    },
  );

  // Setup Remote Data Source dengan Dio instance dari DioClient
  final remoteDataSource = AuthenticationRemoteDataSourceImpl(
    dioClient.instance,
  );

  // Setup Repository
  final authRepository = AuthenticationRepositoryImpl(
    authRemoteDataSource: remoteDataSource,
    authLocalDataSource: localDataSource,
  );

  // ==================== CARD FEATURE DEPENDENCIES ====================
  // Setup Card Remote Data Source untuk fetch cards dari API
  final cardRemoteDataSource = CardRemoteDataSourceImpl(dioClient.instance);

  // Setup Card Repository untuk mengelola data cards
  final cardRepository = CardRepositoryImpl(
    remoteDataSource: cardRemoteDataSource,
  );

  // Setup Use Cases untuk business logic
  final getCardsUseCase = GetCardsUseCase(repository: cardRepository);
  final createCardUseCase = CreateCardUseCase(repository: cardRepository);
  final updateCardUseCase = UpdateCardUseCase(repository: cardRepository);
  final deleteCardUseCase = DeleteCardUseCase(repository: cardRepository);
  // ====================================================================

  // ==================== TIME LOG FEATURE DEPENDENCIES =================
  // Setup Time Log Remote Data Source untuk time tracking
  final timeLogRemoteDataSource = TimeLogRemoteDataSource(dioClient.instance);

  // Setup Time Log Repository
  final timeLogRepository = TimeLogRepositoryImpl(timeLogRemoteDataSource);

  // Setup Use Cases untuk start/stop time log
  final startTimeLogUseCase = StartTimeLogUseCase(timeLogRepository);
  final stopTimeLogUseCase = StopTimeLogUseCase(timeLogRepository);
  // ====================================================================

  // ==================== DASHBOARD FEATURE DEPENDENCIES ================
  // Setup Dashboard Remote Data Source
  final dashboardRemoteDataSource = DashboardRemoteDataSourceImpl(
    dioClient.instance,
  );

  // Setup Dashboard Repository
  final dashboardRepository = DashboardRepositoryImpl(
    remoteDataSource: dashboardRemoteDataSource,
  );
  // ====================================================================

  // ==================== PROFILE FEATURE DEPENDENCIES ==================
  // Setup Profile Remote Data Source
  final profileRemoteDataSource = ProfileRemoteDataSourceImpl(
    dio: dioClient.instance,
  );

  // Setup Profile Repository
  final profileRepository = ProfileRepositoryImpl(
    remoteDataSource: profileRemoteDataSource,
  );
  // ====================================================================

  runApp(
    MultiBlocProvider(
      providers: [
        // Provider untuk Authentication (Login)
        BlocProvider(create: (_) => LoginBloc(repository: authRepository)),

        // Provider untuk Card Feature (Fetch Cards + CRUD)
        BlocProvider(
          create: (_) => CardCubit(
            getCardsUseCase: getCardsUseCase,
            createCardUseCase: createCardUseCase,
            updateCardUseCase: updateCardUseCase,
            deleteCardUseCase: deleteCardUseCase,
          ),
        ),

        // Provider untuk Time Log Feature (Start/Stop Timer)
        BlocProvider(
          create: (_) => TimeLogCubit(
            startTimeLogUseCase: startTimeLogUseCase,
            stopTimeLogUseCase: stopTimeLogUseCase,
          ),
        ),

        // Provider untuk Dashboard Feature
        BlocProvider(
          create: (_) => DashboardCubit(
            dashboardRepository: dashboardRepository,
            cardRepository: cardRepository,
          ),
        ),

        // Provider untuk Profile Feature
        BlocProvider(
          create: (_) => ProfileCubit(
            repository: profileRepository,
            localDataSource: localDataSource,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // Inggris
        Locale('id'), // Indonesia
      ],
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // ),
      routerConfig: AppRouter.router,
    );
  }
}
