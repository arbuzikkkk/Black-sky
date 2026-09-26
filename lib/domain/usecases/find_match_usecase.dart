import 'package:black_sky/core/constants/game_constants.dart';
import 'package:black_sky/domain/entities/player_entity.dart';
import 'package:black_sky/domain/repositories/match_repository.dart';

class FindMatchUseCase {
  const FindMatchUseCase(this._repo);
  final MatchRepository _repo;

  Future<MatchTicket> call({required MatchMode mode, required Faction faction}) {
    return _repo.findMatch(mode: mode, faction: faction);
  }
}
