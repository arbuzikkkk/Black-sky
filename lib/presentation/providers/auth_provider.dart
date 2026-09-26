import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:black_sky/core/di/service_locator.dart';
import 'package:black_sky/domain/entities/player_entity.dart';
import 'package:black_sky/domain/repositories/auth_repository.dart';
import 'package:black_sky/domain/usecases/auth_usecases.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) => sl<AuthRepository>());

/// Live auth/profile state — null while signed out, otherwise the current
/// player's profile document, kept in sync with Firestore.
final authStateProvider = StreamProvider<PlayerProfile?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

final signInAnonymouslyProvider = Provider((ref) => sl<SignInAnonymouslyUseCase>());
final signInWithEmailProvider = Provider((ref) => sl<SignInWithEmailUseCase>());
final registerWithEmailProvider = Provider((ref) => sl<RegisterWithEmailUseCase>());
final signOutProvider = Provider((ref) => sl<SignOutUseCase>());
