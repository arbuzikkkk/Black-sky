import 'package:equatable/equatable.dart';
import 'package:black_sky/core/constants/game_constants.dart';

/// Static definition of a unit type (the "card"), shared by every instance
/// spawned in a match. Runtime, per-instance state lives in [UnitInstance].
class UnitEntity extends Equatable {
  const UnitEntity({
    required this.id,
    required this.name,
    required this.faction,
    required this.category,
    required this.deckCost,
    required this.maxHp,
    required this.armorFront,
    required this.armorSide,
    required this.armorRear,
    required this.speed,
    required this.sightRange,
    required this.stealth,
    required this.ammoCapacity,
    required this.fuelCapacity,
    required this.canRepairSelf,
    this.attackDamage = 0,
    this.attackRange = 0,
    this.reloadSeconds = 1.5,
    this.isAirUnit = false,
    this.isNavalUnit = false,
  });

  final String id; // stable content id, e.g. "usa_mbt_m1a3"
  final String name;
  final Faction faction;
  final UnitCategory category;

  /// Cost in Battle Group deck points (not in-match credits).
  final int deckCost;

  final int maxHp;
  final int armorFront;
  final int armorSide;
  final int armorRear;

  final double speed; // meters/second, map units
  final double sightRange;
  final double stealth; // 0..1, chance to avoid detection outside sightRange overlap

  final int ammoCapacity;
  final int fuelCapacity;
  final bool canRepairSelf;

  final int attackDamage;
  final double attackRange;
  final double reloadSeconds;

  final bool isAirUnit;
  final bool isNavalUnit;

  @override
  List<Object?> get props => [id, name, faction, category, deckCost];
}

/// Mutable, per-match runtime state for a spawned unit.
class UnitInstance {
  UnitInstance({
    required this.instanceId,
    required this.definition,
    required this.position,
    this.currentHp = -1,
    this.currentAmmo = -1,
    this.currentFuel = -1,
    this.morale = 100,
    this.suppression = 0,
    this.isDestroyed = false,
  })  : currentHp = currentHp < 0 ? definition.maxHp : currentHp,
        currentAmmo = currentAmmo < 0 ? definition.ammoCapacity : currentAmmo,
        currentFuel = currentFuel < 0 ? definition.fuelCapacity : currentFuel;

  final String instanceId;
  final UnitEntity definition;

  ({double x, double y}) position;
  int currentHp;
  int currentAmmo;
  int currentFuel;
  int morale; // 0..100, low morale triggers retreat/route AI behavior
  int suppression; // 0..100, reduces accuracy and speed while high
  bool isDestroyed;

  double get hpPercent => currentHp / definition.maxHp;

  void applyDamage(int amount, {required bool fromFront}) {
    final armor = fromFront ? definition.armorFront : definition.armorSide;
    final mitigated = (amount - armor).clamp(1, amount);
    currentHp = (currentHp - mitigated).clamp(0, definition.maxHp);
    suppression = (suppression + 15).clamp(0, 100);
    if (currentHp == 0) isDestroyed = true;
  }
}
