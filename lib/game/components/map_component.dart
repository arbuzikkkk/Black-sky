import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:black_sky/game/data/factions.dart';

/// Placeholder terrain renderer: flat biome-tinted ground with a reference
/// grid. Swap for a TiledComponent (.tmx) once real map art exists — the
/// map's world bounds (`definition.widthMeters/heightMeters`) are already
/// what camera clamping and unit pathing use, so nothing downstream changes.
class MapComponent extends PositionComponent {
  MapComponent({required this.definition})
      : super(size: Vector2(definition.widthMeters, definition.heightMeters));

  final MapDefinition definition;

  static const double _gridSpacing = 50.0;

  Color get _groundColor => switch (definition.biome) {
        'desert' => const Color(0xFF6B5A3A),
        'industrial' => const Color(0xFF3A3D42),
        'forest' => const Color(0xFF2E4A2E),
        'snow' => const Color(0xFFCFD8DC),
        _ => const Color(0xFF444444),
      };

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), Paint()..color = _groundColor);

    final gridPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..strokeWidth = 1;

    for (double x = 0; x <= size.x; x += _gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.y), gridPaint);
    }
    for (double y = 0; y <= size.y; y += _gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.x, y), gridPaint);
    }

    final borderPaint = Paint()
      ..color = Colors.redAccent.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRect(size.toRect(), borderPaint);
  }
}
