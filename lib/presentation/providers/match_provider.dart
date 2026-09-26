import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:black_sky/core/constants/game_constants.dart';
import 'package:black_sky/game/data/factions.dart';

class MatchSetup {
  const MatchSetup({
    required this.mode,
    required this.playerFaction,
    required this.enemyFaction,
    required this.map,
  });

  final MatchMode mode;
  final Faction playerFaction;
  final Faction enemyFaction;
  final MapDefinition map;

  MatchSetup copyWith({
    MatchMode? mode,
    Faction? playerFaction,
    Faction? enemyFaction,
    MapDefinition? map,
  }) {
    return MatchSetup(
      mode: mode ?? this.mode,
      playerFaction: playerFaction ?? this.playerFaction,
      enemyFaction: enemyFaction ?? this.enemyFaction,
      map: map ?? this.map,
    );
  }
}

class MatchSetupNotifier extends StateNotifier<MatchSetup> {
  MatchSetupNotifier()
      : super(MatchSetup(
          mode: MatchMode.training,
          playerFaction: Faction.usa,
          enemyFaction: Faction.russia,
          map: MapRegistry.desertOutpost,
        ));

  void setMode(MatchMode mode) => state = state.copyWith(mode: mode);
  void setPlayerFaction(Faction faction) => state = state.copyWith(playerFaction: faction);
  void setEnemyFaction(Faction faction) => state = state.copyWith(enemyFaction: faction);
  void setMap(MapDefinition map) => state = state.copyWith(map: map);
}

final matchSetupProvider = StateNotifierProvider<MatchSetupNotifier, MatchSetup>(
  (ref) => MatchSetupNotifier(),
);
