import 'package:black_sky/core/constants/game_constants.dart';
import 'package:black_sky/domain/entities/player_entity.dart';

/// A single authoritative state update broadcast by the Nakama match handler.
class MatchStateUpdate {
  const MatchStateUpdate({required this.opCode, required this.payload});
  final int opCode;
  final Map<String, dynamic> payload;
}

/// Contract for realtime multiplayer: matchmaking, joining, sending player
/// intents (move/attack orders) and receiving authoritative state back.
abstract class MatchRepository {
  Future<void> connect({required String userId, required String sessionToken});

  Future<MatchTicket> findMatch({required MatchMode mode, required Faction faction});

  Future<void> joinPrivateLobby(String lobbyCode);

  Future<String> createPrivateLobby({required MatchMode mode});

  Stream<MatchStateUpdate> matchStateStream(String matchId);

  /// Sends a player order (move / attack / stop / build) to the authoritative
  /// server. Client never resolves combat locally beyond prediction.
  Future<void> sendPlayerAction({
    required String matchId,
    required int opCode,
    required Map<String, dynamic> payload,
  });

  Future<void> leaveMatch(String matchId);

  Future<void> disconnect();
}
