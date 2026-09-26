import 'dart:convert';
import 'package:black_sky/core/constants/game_constants.dart';
import 'package:black_sky/data/datasources/nakama_datasource.dart';
import 'package:black_sky/domain/entities/player_entity.dart';
import 'package:black_sky/domain/repositories/match_repository.dart';

class MatchRepositoryImpl implements MatchRepository {
  MatchRepositoryImpl(this._nakama);
  final NakamaDataSource _nakama;

  @override
  Future<void> connect({required String userId, required String sessionToken}) async {
    await _nakama.authenticateDevice(userId);
    await _nakama.connectSocket();
  }

  @override
  Future<MatchTicket> findMatch({required MatchMode mode, required Faction faction}) async {
    final query = '+properties.mode:${mode.name} +properties.faction:${faction.name}';
    final match = await _nakama.findMatch(query: query, properties: {
      'mode': mode.name,
      'faction': faction.name,
    });
    return MatchTicket(matchId: match.matchId, mode: mode, hostAddress: match.authoritative ? 'authoritative' : 'relayed');
  }

  @override
  Future<void> joinPrivateLobby(String lobbyCode) async {
    await _nakama.joinMatch(lobbyCode);
  }

  @override
  Future<String> createPrivateLobby({required MatchMode mode}) async {
    final match = await _nakama.findMatch(query: '+properties.mode:${mode.name} +properties.private:true');
    return match.matchId;
  }

  @override
  Stream<MatchStateUpdate> matchStateStream(String matchId) {
    return _nakama.matchStateStream
        .where((data) => data.matchId == matchId)
        .map((data) => MatchStateUpdate(
              opCode: data.opCode,
              payload: jsonDecode(utf8.decode(data.data)) as Map<String, dynamic>,
            ));
  }

  @override
  Future<void> sendPlayerAction({
    required String matchId,
    required int opCode,
    required Map<String, dynamic> payload,
  }) {
    return _nakama.sendMatchState(
      matchId: matchId,
      opCode: opCode,
      data: utf8.encode(jsonEncode(payload)),
    );
  }

  @override
  Future<void> leaveMatch(String matchId) => _nakama.leaveMatch(matchId);

  @override
  Future<void> disconnect() => _nakama.disconnect();
}

/// Op codes for client<->server match messages. Mirrors what the (separate,
/// server-side) Nakama Go/TS match handler module must implement — that
/// authoritative match logic is not part of this Flutter client and needs
/// its own project (Nakama runtime modules aren't Dart).
class MatchOpCode {
  MatchOpCode._();
  static const int moveOrder = 1;
  static const int attackOrder = 2;
  static const int stopOrder = 3;
  static const int stateSync = 100;
  static const int matchEnded = 101;
}
