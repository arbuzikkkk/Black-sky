import 'package:flutter/material.dart';
import 'package:black_sky/core/theme/app_theme.dart';
import 'package:black_sky/game/data/factions.dart';

/// Simplified minimap: draws the map bounds and a placeholder marker for the
/// player's army centroid. Wire real unit-position dots once UnitComponent
/// positions are exposed via a ChangeNotifier/Riverpod bridge from the game.
class MinimapWidget extends StatelessWidget {
  const MinimapWidget({super.key, required this.map});
  final MapDefinition map;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.9),
        border: Border.all(color: AppTheme.accentRed, width: 1.5),
      ),
      child: CustomPaint(painter: _MinimapPainter()),
    );
  }
}

class _MinimapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = AppTheme.surfaceRaised;
    canvas.drawRect(Offset.zero & size, bg);

    // Front line indicator — placeholder until live unit positions feed in.
    final friendlyPaint = Paint()..color = AppTheme.hudGreen;
    canvas.drawCircle(Offset(size.width / 2, size.height * 0.8), 4, friendlyPaint);

    final enemyPaint = Paint()..color = AppTheme.accentRed;
    canvas.drawCircle(Offset(size.width / 2, size.height * 0.2), 4, enemyPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
