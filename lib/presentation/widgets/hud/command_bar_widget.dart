import 'package:flutter/material.dart';
import 'package:black_sky/core/theme/app_theme.dart';

/// Bottom command bar: quick-order icons (stop/hold/attack-move/retreat).
/// Wired to callbacks so MatchScreen decides how each maps to a
/// MatchRepository.sendPlayerAction() call once a live match session exists.
class CommandBarWidget extends StatelessWidget {
  const CommandBarWidget({
    super.key,
    required this.onStop,
    required this.onHold,
    required this.onAttackMove,
    required this.onRetreat,
  });

  final VoidCallback onStop;
  final VoidCallback onHold;
  final VoidCallback onAttackMove;
  final VoidCallback onRetreat;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: AppTheme.surface.withValues(alpha: 0.92),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _CommandButton(icon: Icons.stop_circle_outlined, label: 'STOP', onTap: onStop),
          _CommandButton(icon: Icons.shield_outlined, label: 'HOLD', onTap: onHold),
          _CommandButton(icon: Icons.gps_fixed, label: 'ATK-MOVE', onTap: onAttackMove),
          _CommandButton(icon: Icons.arrow_back, label: 'RETREAT', onTap: onRetreat),
        ],
      ),
    );
  }
}

class _CommandButton extends StatelessWidget {
  const _CommandButton({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppTheme.textPrimary, size: 22),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
