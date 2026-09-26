import 'package:black_sky/data/datasources/firebase_auth_datasource.dart';
import 'package:black_sky/data/datasources/firestore_profile_datasource.dart';
import 'package:black_sky/domain/entities/player_entity.dart';
import 'package:black_sky/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required FirebaseAuthDataSource authSource,
    required FirestoreProfileDataSource profileSource,
  })  : _authSource = authSource,
        _profileSource = profileSource;

  final FirebaseAuthDataSource _authSource;
  final FirestoreProfileDataSource _profileSource;

  @override
  Stream<PlayerProfile?> authStateChanges() async* {
    await for (final user in _authSource.authStateChanges) {
      if (user == null) {
        yield null;
      } else {
        yield await _profileSource.fetchOrCreate(
          uid: user.uid,
          displayName: user.displayName ?? 'Commander',
        );
      }
    }
  }

  @override
  Future<PlayerProfile> signInAnonymously() async {
    final user = await _authSource.signInAnonymously();
    return _profileSource.fetchOrCreate(uid: user.uid, displayName: 'Commander');
  }

  @override
  Future<PlayerProfile> signInWithEmail({required String email, required String password}) async {
    final user = await _authSource.signInWithEmail(email: email, password: password);
    return _profileSource.fetchOrCreate(uid: user.uid, displayName: user.displayName ?? 'Commander');
  }

  @override
  Future<PlayerProfile> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final user = await _authSource.registerWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );
    return _profileSource.fetchOrCreate(uid: user.uid, displayName: displayName);
  }

  @override
  Future<void> signOut() => _authSource.signOut();

  @override
  Future<PlayerProfile?> currentProfile() async {
    final user = _authSource.currentUser;
    if (user == null) return null;
    return _profileSource.fetchOrCreate(uid: user.uid, displayName: user.displayName ?? 'Commander');
  }

  @override
  Future<void> updateProfile(PlayerProfile profile) => _profileSource.save(profile);
}
