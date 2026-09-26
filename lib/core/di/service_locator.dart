import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:black_sky/data/datasources/firebase_auth_datasource.dart';
import 'package:black_sky/data/datasources/firestore_profile_datasource.dart';
import 'package:black_sky/data/datasources/nakama_datasource.dart';
import 'package:black_sky/data/repositories/auth_repository_impl.dart';
import 'package:black_sky/data/repositories/match_repository_impl.dart';
import 'package:black_sky/domain/repositories/auth_repository.dart';
import 'package:black_sky/domain/repositories/match_repository.dart';
import 'package:black_sky/domain/usecases/auth_usecases.dart';
import 'package:black_sky/domain/usecases/find_match_usecase.dart';

final GetIt sl = GetIt.instance;

/// Registers every dependency once, at app start. Call `setupServiceLocator()`
/// from `main()` before `runApp`. Kept as a single flat function rather than
/// Riverpod providers for the data/domain layer so use cases stay framework-
/// agnostic and unit-testable outside of widget/provider machinery.
Future<void> setupServiceLocator() async {
  // --- External SDKs ---
  sl.registerLazySingleton<fb.FirebaseAuth>(() => fb.FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  sl.registerLazySingleton<NakamaDataSource>(() => NakamaDataSource(
        host: dotenv.env['NAKAMA_HOST'] ?? '127.0.0.1',
        port: int.tryParse(dotenv.env['NAKAMA_PORT'] ?? '7350') ?? 7350,
        serverKey: dotenv.env['NAKAMA_SERVER_KEY'] ?? 'defaultkey',
        useSsl: (dotenv.env['NAKAMA_USE_SSL'] ?? 'false') == 'true',
      ));

  // --- Data sources ---
  sl.registerLazySingleton(() => FirebaseAuthDataSource(sl()));
  sl.registerLazySingleton(() => FirestoreProfileDataSource(sl()));

  // --- Repositories ---
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authSource: sl(), profileSource: sl()),
  );
  sl.registerLazySingleton<MatchRepository>(() => MatchRepositoryImpl(sl()));

  // --- Use cases ---
  sl.registerFactory(() => SignInAnonymouslyUseCase(sl()));
  sl.registerFactory(() => SignInWithEmailUseCase(sl()));
  sl.registerFactory(() => RegisterWithEmailUseCase(sl()));
  sl.registerFactory(() => SignOutUseCase(sl()));
  sl.registerFactory(() => FindMatchUseCase(sl()));
}
