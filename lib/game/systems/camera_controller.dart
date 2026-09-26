import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:black_sky/core/constants/game_constants.dart';

/// Wraps Flame's CameraComponent with RTS-specific behavior: pinch-to-zoom,
/// two-finger drag pan, and clamping to the current map's world bounds so
/// players can never pan into empty void outside the battlefield.
class CameraController {
  CameraController({required this.camera, required this.worldWidth, required this.worldHeight});

  final CameraComponent camera;
  final double worldWidth;
  final double worldHeight;

  double _zoom = 1.0;

  void applyPinchZoom(double scaleDelta) {
    _zoom = (_zoom * scaleDelta).clamp(GameConstants.minZoom, GameConstants.maxZoom);
    camera.viewfinder.zoom = _zoom;
    _clampPosition();
  }

  void pan(Vector2 screenDelta) {
    final worldDelta = screenDelta / _zoom;
    camera.viewfinder.position -= worldDelta;
    _clampPosition();
  }

  void jumpTo(Vector2 worldPosition) {
    camera.viewfinder.position = worldPosition.clone();
    _clampPosition();
  }

  void _clampPosition() {
    final halfViewW = (camera.viewport.size.x / 2) / _zoom;
    final halfViewH = (camera.viewport.size.y / 2) / _zoom;

    final pos = camera.viewfinder.position;
    final clampedX = pos.x.clamp(halfViewW, (worldWidth - halfViewW).clamp(halfViewW, double.infinity));
    final clampedY = pos.y.clamp(halfViewH, (worldHeight - halfViewH).clamp(halfViewH, double.infinity));
    camera.viewfinder.position = Vector2(clampedX, clampedY);
  }
}
