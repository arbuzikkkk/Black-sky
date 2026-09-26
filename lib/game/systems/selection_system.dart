import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:black_sky/game/components/unit_component.dart';
import 'package:black_sky/game/components/selection_box_component.dart';

/// Owns the set of currently-selected [UnitComponent]s and turns box-drags
/// and taps into selection changes / move orders. Kept independent of Flame's
/// game class so it can be unit-tested without booting a full FlameGame.
class SelectionSystem {
  SelectionSystem({required this.world, required this.selectionBox});

  final World world;
  final SelectionBoxComponent selectionBox;

  final Set<UnitComponent> selected = {};

  Iterable<UnitComponent> get _allUnits => world.children.whereType<UnitComponent>();

  void selectSingle(UnitComponent unit) {
    clearSelection();
    unit.isSelected = true;
    selected.add(unit);
  }

  void selectWithinScreenRect(Rect screenRect, CameraComponent camera) {
    clearSelection();
    for (final unit in _allUnits) {
      final screenPos = camera.viewfinder.globalToLocal(unit.absolutePosition);
      if (screenRect.contains(screenPos.toOffset())) {
        unit.isSelected = true;
        selected.add(unit);
      }
    }
  }

  void clearSelection() {
    for (final unit in selected) {
      unit.isSelected = false;
    }
    selected.clear();
  }

  /// Issues a move order to every selected unit, spread in a shallow
  /// formation around [target] rather than stacking on one point.
  void issueMoveOrder(Vector2 target) {
    const spread = 18.0;
    var i = 0;
    final count = selected.length;
    for (final unit in selected) {
      final angle = (2 * math.pi * i) / (count == 0 ? 1 : count);
      final offset = Vector2(spread * math.cos(angle), spread * math.sin(angle));
      unit.issueMoveOrder(target + offset);
      i++;
    }
  }
}
