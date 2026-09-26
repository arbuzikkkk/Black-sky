import 'package:equatable/equatable.dart';
import 'package:black_sky/core/constants/game_constants.dart';

class PlayerProfile extends Equatable {
  const PlayerProfile({
    required this.uid,
    required this.displayName,
    required this.level,
    required this.xp,
    required this.favoriteFaction,
    required this.wins,
    required this.losses,
    required this.kills,
    required this.deaths,
    required this.credits,
    required this.gold,
  });

  final String uid;
  final String displayName;
  final int level;
  final int xp;
  final Faction favoriteFaction;
  final int wins;
  final int losses;
  final int kills;
  final int deaths;
  final int credits; // earned in-match currency, no Pay To Win
  final int gold; // premium currency, cosmetics only

  double get winRate => (wins + losses) == 0 ? 0 : wins / (wins + losses);
  double get kdRatio => deaths == 0 ? kills.toDouble() : kills / deaths;

  factory PlayerProfile.newAccount({required String uid, required String displayName}) {
    return PlayerProfile(
      uid: uid,
      displayName: displayName,
      level: 1,
      xp: 0,
      favoriteFaction: Faction.usa,
      wins: 0,
      losses: 0,
      kills: 0,
      deaths: 0,
      credits: 0,
      gold: 0,
    );
  }

  PlayerProfile copyWith({
    int? level,
    int? xp,
    Faction? favoriteFaction,
    int? wins,
    int? losses,
    int? kills,
    int? deaths,
    int? credits,
    int? gold,
  }) {
    return PlayerProfile(
      uid: uid,
      displayName: displayName,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      favoriteFaction: favoriteFaction ?? this.favoriteFaction,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      kills: kills ?? this.kills,
      deaths: deaths ?? this.deaths,
      credits: credits ?? this.credits,
      gold: gold ?? this.gold,
    );
  }

  @override
  List<Object?> get props => [uid, level, xp, wins, losses, kills, deaths, credits, gold];
}

class MatchTicket extends Equatable {
  const MatchTicket({
    required this.matchId,
    required this.mode,
    required this.hostAddress,
  });

  final String matchId;
  final MatchMode mode;
  final String hostAddress; // Nakama match id / node address returned by matchmaker

  @override
  List<Object?> get props => [matchId, mode, hostAddress];
}
