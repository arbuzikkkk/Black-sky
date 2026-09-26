import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:black_sky/domain/entities/unit_entity.dart';

/// Visual + interactive representation of a [UnitInstance] on the map.
/// Placeholder rendering (colored rect + HP bar) until real sprite sheets
/// are produced — swap `render()` for a SpriteAnimationComponent later
/// without touching selection/movement logic below.
class UnitComponent extends PositionComponent with TapCallbacks, HasGameReference {
  UnitComponent({required this.instance, required this.ownerColor})
      : super(
          size: Vector2(28, 28),
          anchor: Anchor.center,
          position: Vector2(instance.position.x, instance.position.y),
        );

  final UnitInstance instance;
  final Color ownerColor;

  bool isSelected = false;
  Vector2? moveTarget;

  static const double _moveEpsilon = 2.0;

  @override
  void render(Canvas canvas) {
    final bodyPaint = Paint()..color = ownerColor;
    final rect = size.toRect();
    canvas.drawRect(rect, bodyPaint);

    if (isSelected) {
      final selectionPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRect(rect.inflate(3), selectionPaint);
    }

    // HP bar
    final hpPercent = instance.hpPercent.clamp(0.0, 1.0);
    final barBg = Paint()..color = Colors.black54;
    final barFg = Paint()..color = Color.lerp(Colors.red, Colors.greenAccent, hpPercent)!;
    final barRect = Rect.fromLTWH(0, -8, size.x, 4);
    canvas.drawRect(barRect, barBg);
    canvas.drawRect(Rect.fromLTWH(0, -8, size.x * hpPercent, 4), barFg);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (instance.isDestroyed) {
      removeFromParent();
      return;
    }

    final target = moveTarget;
    if (target != null) {
      final delta = target - position;
      final distance = delta.length;
      if (distance <= _moveEpsilon) {
        position.setFrom(target);
        moveTarget = null;
      } else {
        final step = delta.normalized() * instance.definition.speed * dt;
        position.add(step.length > distance ? delta : step);
      }
      instance.position = (x: position.x, y: position.y);
    }
  }

  void issueMoveOrder(Vector2 worldTarget) {
    moveTarget = worldTarget.clone();
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Selection handled by SelectionSystem via hit-test on the game's
    // component tree; kept here so per-unit context (e.g. double-tap to
    // select all of type) can be added without refactoring input routing.
  }
}
