import 'package:black_sky/domain/entities/player_entity.dart';

/// Contract for authentication + profile persistence.
/// Implemented by [AuthRepositoryImpl] in the data layer (Firebase Auth + Firestore).
abstract class AuthRepository {
  Stream<PlayerProfile?> authStateChanges();

  Future<PlayerProfile> signInAnonymously();

  Future<PlayerProfile> signInWithEmail({
    required String email,
    required String password,
  });

  Future<PlayerProfile> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  Future<void> signOut();

  Future<PlayerProfile?> currentProfile();

  Future<void> updateProfile(PlayerProfile profile);
}
