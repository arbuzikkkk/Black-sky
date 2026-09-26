import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:black_sky/core/constants/game_constants.dart';
import 'package:black_sky/domain/entities/unit_entity.dart';
import 'package:black_sky/game/components/map_component.dart';
import 'package:black_sky/game/components/unit_component.dart';
import 'package:black_sky/game/components/selection_box_component.dart';
import 'package:black_sky/game/data/factions.dart';
import 'package:black_sky/game/systems/camera_controller.dart';
import 'package:black_sky/game/systems/selection_system.dart';

/// Root Flame game for a single skirmish match. One instance is created per
/// [MatchScreen]; it owns local prediction/rendering only — combat and
/// movement are authoritative on the Nakama match handler in a real match,
/// this local sim is what runs while offline/training or before server
/// reconciliation packets are wired in (see match_repository.dart TODOs).
// NOTE: ScaleDetector + DragCallbacks both claim pan/drag gestures in Flame's
// gesture layer. This skeleton resolves it manually inside onScaleUpdate
// (single-pointer scale == pan), which works but is fragile long-term —
// before adding more gesture-driven features (rally-point drag, formation
// drag), replace with a single custom GestureRecognizer.
class BlackSkyGame extends FlameGame
    with ScaleDetector, TapDetector, DragCallbacks, HasCollisionDetection {
  BlackSkyGame({required this.mapDefinition, required this.playerFaction, required this.enemyFaction});

  final MapDefinition mapDefinition;
  final Faction playerFaction;
  final Faction enemyFaction;

  late final CameraController cameraController;
  late final SelectionSystem selectionSystem;
  late final SelectionBoxComponent _selectionBox;

  double _lastScaleFactor = 1.0;

  @override
  Color backgroundColor() => const Color(0xFF0A0A0A);

  @override
  Future<void> onLoad() async {
    final map = MapComponent(definition: mapDefinition);
    world.add(map);

    camera.viewfinder.anchor = Anchor.center;
    cameraController = CameraController(
      camera: camera,
      worldWidth: mapDefinition.widthMeters,
      worldHeight: mapDefinition.heightMeters,
    );
    cameraController.jumpTo(Vector2(mapDefinition.widthMeters / 2, mapDefinition.heightMeters * 0.75));

    _selectionBox = SelectionBoxComponent();
    camera.viewport.add(_selectionBox);

    selectionSystem = SelectionSystem(world: world, selectionBox: _selectionBox);

    _spawnStartingArmy(
      faction: playerFaction,
      isEnemy: false,
      originX: mapDefinition.widthMeters / 2,
      originY: mapDefinition.heightMeters - 120,
    );
    _spawnStartingArmy(
      faction: enemyFaction,
      isEnemy: true,
      originX: mapDefinition.widthMeters / 2,
      originY: 120,
    );
  }

  void _spawnStartingArmy({
    required Faction faction,
    required bool isEnemy,
    required double originX,
    required double originY,
  }) {
    final roster = FactionRegistry.rosterFor(faction);
    if (roster.isEmpty) return;

    const spacing = 40.0;
    final startX = originX - (roster.length * spacing) / 2;

    for (var i = 0; i < roster.length; i++) {
      final def = roster[i];
      final instance = UnitInstance(
        instanceId: '${def.id}_${isEnemy ? "e" : "p"}_$i',
        definition: def,
        position: (x: startX + i * spacing, y: originY),
      );
      final component = UnitComponent(
        instance: instance,
        ownerColor: isEnemy ? Colors.redAccent.shade700 : Color(int.parse(faction.colorHex.replaceFirst('#', '0xFF'))),
      );
      world.add(component);
    }
  }

  // --- Pinch to zoom ---
  @override
  void onScaleStart(ScaleStartInfo info) {
    _lastScaleFactor = 1.0;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final scale = info.scale.global;
    if (scale.x == 1.0 && scale.y == 1.0) {
      // Single-pointer drag => pan camera.
      cameraController.pan(info.delta.global);
      return;
    }
    final factor = scale.x / _lastScaleFactor;
    cameraController.applyPinchZoom(factor);
    _lastScaleFactor = scale.x;
  }

  // --- Tap select / move order ---
  @override
  void onTapUp(TapUpInfo info) {
    final world_ = componentsAtPoint(info.eventPosition.widget).whereType<UnitComponent>();
    if (world_.isNotEmpty) {
      selectionSystem.selectSingle(world_.first);
    } else if (selectionSystem.selected.isNotEmpty) {
      final worldPos = camera.globalToLocal(info.eventPosition.widget);
      selectionSystem.issueMoveOrder(worldPos);
    } else {
      selectionSystem.clearSelection();
    }
  }

  // --- Drag box select (two-finger free area handled by onScaleUpdate) ---
  @override
  void onDragStart(DragStartEvent event) {
    _selectionBox.beginDrag(event.localPosition);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    _selectionBox.updateDrag(event.localPosition);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    final rect = _selectionBox.currentRect;
    if (rect != null) {
      selectionSystem.selectWithinScreenRect(rect, camera);
    }
    _selectionBox.endDrag();
  }
}
