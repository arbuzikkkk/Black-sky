import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Visual rubber-band selection box, drawn in screen space (fixed to the
/// viewport, not the world) while the player drags to multi-select units.
class SelectionBoxComponent extends PositionComponent with HasPaint {
  Vector2? dragStart;
  Vector2? dragCurrent;

  Rect? get currentRect {
    final start = dragStart;
    final current = dragCurrent;
    if (start == null || current == null) return null;
    return Rect.fromPoints(start.toOffset(), current.toOffset());
  }

  void beginDrag(Vector2 screenPosition) {
    dragStart = screenPosition.clone();
    dragCurrent = screenPosition.clone();
  }

  void updateDrag(Vector2 screenPosition) {
    dragCurrent = screenPosition.clone();
  }

  void endDrag() {
    dragStart = null;
    dragCurrent = null;
  }

  @override
  void render(Canvas canvas) {
    final rect = currentRect;
    if (rect == null) return;

    canvas.drawRect(rect, Paint()..color = Colors.redAccent.withValues(alpha: 0.15));
    canvas.drawRect(
      rect,
      Paint()
        ..color = Colors.redAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }
}
