import 'package:black_sky/core/constants/game_constants.dart';
import 'package:black_sky/domain/entities/unit_entity.dart';
import 'package:black_sky/game/data/units/usa_units.dart';
import 'package:black_sky/game/data/units/russia_units.dart';

/// Central lookup so the game layer never imports per-faction files directly.
/// EUROPE and ASIA ALLIANCE rosters are stubbed empty on purpose — added the
/// same way (see usa_units.dart / russia_units.dart as the pattern) once the
/// vertical slice is validated in a real match.
class FactionRegistry {
  FactionRegistry._();

  static const Map<Faction, List<UnitEntity>> rosters = {
    Faction.usa: UsaUnits.roster,
    Faction.russia: RussiaUnits.roster,
    Faction.europe: [],
    Faction.asiaAlliance: [],
  };

  static List<UnitEntity> rosterFor(Faction faction) => rosters[faction] ?? const [];

  static UnitEntity? unitById(String id) {
    for (final roster in rosters.values) {
      for (final unit in roster) {
        if (unit.id == id) return unit;
      }
    }
    return null;
  }
}

class MapDefinition {
  const MapDefinition({
    required this.id,
    required this.name,
    required this.biome,
    required this.widthMeters,
    required this.heightMeters,
  });

  final String id;
  final String name;
  final String biome;
  final double widthMeters;
  final double heightMeters;
}

/// Two playable maps for the slice, out of the 20 the full design calls for.
class MapRegistry {
  MapRegistry._();

  static const desertOutpost = MapDefinition(
    id: 'map_desert_outpost',
    name: 'Desert Outpost',
    biome: 'desert',
    widthMeters: 900,
    heightMeters: 900,
  );

  static const industrialZone = MapDefinition(
    id: 'map_industrial_zone',
    name: 'Industrial Zone',
    biome: 'industrial',
    widthMeters: 1000,
    heightMeters: 800,
  );

  static const List<MapDefinition> all = [desertOutpost, industrialZone];
}
