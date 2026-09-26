import 'package:black_sky/domain/entities/player_entity.dart';
import 'package:black_sky/domain/repositories/auth_repository.dart';

class SignInAnonymouslyUseCase {
  const SignInAnonymouslyUseCase(this._repo);
  final AuthRepository _repo;

  Future<PlayerProfile> call() => _repo.signInAnonymously();
}

class SignInWithEmailUseCase {
  const SignInWithEmailUseCase(this._repo);
  final AuthRepository _repo;

  Future<PlayerProfile> call({required String email, required String password}) {
    return _repo.signInWithEmail(email: email, password: password);
  }
}

class RegisterWithEmailUseCase {
  const RegisterWithEmailUseCase(this._repo);
  final AuthRepository _repo;

  Future<PlayerProfile> call({
    required String email,
    required String password,
    required String displayName,
  }) {
    return _repo.registerWithEmail(email: email, password: password, displayName: displayName);
  }
}

class SignOutUseCase {
  const SignOutUseCase(this._repo);
  final AuthRepository _repo;

  Future<void> call() => _repo.signOut();
}
