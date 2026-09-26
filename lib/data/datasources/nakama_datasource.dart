import 'dart:async';
import 'package:nakama/nakama.dart';
import 'package:black_sky/core/utils/logger.dart';

/// Wraps the `nakama` pub package (client + realtime socket) behind an
/// interface the rest of the app depends on. NOTE: the nakama-dart client
/// API has changed across versions — verify method names against the exact
/// `nakama: ^1.4.0` release once `flutter pub get` actually runs (no network
/// in this environment to confirm signatures at generation time). Treat this
/// file as the integration point to fix up first if the build fails there.
class NakamaDataSource {
  NakamaDataSource({
    required this.host,
    required this.port,
    required this.serverKey,
    required this.useSsl,
  });

  final String host;
  final int port;
  final String serverKey;
  final bool useSsl;

  late final Client _client = getNakamaClient(
    host: host,
    ssl: useSsl,
    serverKey: serverKey,
    httpPort: port,
    grpcPort: port,
  );

  Session? _session;
  WebSocketClient? _socket;

  final _matchStateController = StreamController<MatchData>.broadcast();
  Stream<MatchData> get matchStateStream => _matchStateController.stream;

  Future<Session> authenticateDevice(String deviceId) async {
    final session = await _client.authenticateDevice(deviceId: deviceId);
    _session = session;
    return session;
  }

  Future<void> connectSocket() async {
    final session = _session;
    if (session == null) {
      throw StateError('Must authenticate before opening the realtime socket');
    }
    final socket = _client.createWebSocketClient();
    await socket.connect(session);
    socket.onMatchData.listen(
      _matchStateController.add,
      onError: (Object e, StackTrace st) => AppLogger.e('Nakama socket error', e, st),
    );
    _socket = socket;
  }

  Future<Match> findMatch({required String query, Map<String, String>? properties}) async {
    final matchmakerTicket = await _requireSocket().addMatchmaker(
      query: query,
      minCount: 2,
      maxCount: 2,
      stringProperties: properties,
    );
    // In a full implementation this resolves via onMatchmakerMatched stream;
    // simplified to direct match creation for the vertical slice / training
    // mode so the flow is testable without a paired opponent.
    final match = await _requireSocket().createMatch();
    AppLogger.i('Matchmaker ticket issued: ${matchmakerTicket.ticket}, fallback match: ${match.matchId}');
    return match;
  }

  Future<Match> joinMatch(String matchId) => _requireSocket().joinMatch(matchId);

  Future<void> sendMatchState({
    required String matchId,
    required int opCode,
    required List<int> data,
  }) {
    return _requireSocket().sendMatchState(matchId: matchId, opCode: opCode, data: data);
  }

  Future<void> leaveMatch(String matchId) => _requireSocket().leaveMatch(matchId);

  WebSocketClient _requireSocket() {
    final socket = _socket;
    if (socket == null) throw StateError('Socket not connected — call connectSocket() first');
    return socket;
  }

  Future<void> disconnect() async {
    await _socket?.close();
    _socket = null;
    _session = null;
  }
}
