/// Global, engine-wide constants for PROJECT BLACK SKY.
/// Kept centralized so balance passes touch one file, not scattered magic numbers.
library game_constants;

enum Faction { usa, russia, europe, asiaAlliance }

extension FactionLabel on Faction {
  String get displayName => switch (this) {
        Faction.usa => 'USA',
        Faction.russia => 'RUSSIA',
        Faction.europe => 'EUROPE',
        Faction.asiaAlliance => 'ASIA ALLIANCE',
      };

  String get colorHex => switch (this) {
        Faction.usa => '#3B6FE0',
        Faction.russia => '#C0392B',
        Faction.europe => '#F1C40F',
        Faction.asiaAlliance => '#2ECC71',
      };
}

enum UnitCategory {
  recon,
  infantry,
  apc,
  ifv,
  mbt,
  support,
  artillery,
  antiAir,
  helicopter,
  fighter,
  bomber,
  drone,
  naval,
}

enum MatchMode { oneVOne, twoVTwo, threeVThree, fiveVFive, ranked, casual, privateLobby, spectator, pve, coop, training }

enum GameSpeed { normal, fast }

class GameConstants {
  GameConstants._();

  // Camera
  static const double minZoom = 0.5;
  static const double maxZoom = 3.0;
  static const double cameraPanSpeed = 420.0;

  // Match economy
  static const int startingCredits = 1500;
  static const int creditsTickIntervalSeconds = 5;
  static const int creditsPerTick = 45;

  // Battle group (deck) limits
  static const int maxDeckSlots = 12;
  static const int maxDeckPointCost = 100;

  // Tick rate for authoritative state reconciliation with Nakama match handler
  static const int netTickRateHz = 10;

  // Progression
  static const int maxAccountLevel = 150;
}
