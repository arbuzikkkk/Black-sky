import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:black_sky/core/theme/app_theme.dart';
import 'package:black_sky/game/black_sky_game.dart';
import 'package:black_sky/presentation/providers/match_provider.dart';
import 'package:black_sky/presentation/widgets/hud/command_bar_widget.dart';
import 'package:black_sky/presentation/widgets/hud/minimap_widget.dart';

/// Hosts the live [BlackSkyGame] via Flame's GameWidget, with the RTS HUD
/// (minimap, command bar) layered on top as Flutter widgets. This screen is
/// intentionally local-sim only (training/skirmish) — connecting it to a
/// live Nakama match means: on init, call MatchRepository.connect() +
/// findMatch(), then feed MatchStateUpdate events into the game's units
/// instead of (or alongside) local UnitComponent movement. That wiring is
/// the next concrete milestone after this vertical slice.
class MatchScreen extends ConsumerStatefulWidget {
  const MatchScreen({super.key});

  @override
  ConsumerState<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends ConsumerState<MatchScreen> {
  late final BlackSkyGame _game;

  @override
  void initState() {
    super.initState();
    final setup = ref.read(matchSetupProvider);
    _game = BlackSkyGame(
      mapDefinition: setup.map,
      playerFaction: setup.playerFaction,
      enemyFaction: setup.enemyFaction,
    );
  }

  void _issueStop() {
    for (final unit in _game.selectionSystem.selected) {
      unit.moveTarget = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final setup = ref.watch(matchSetupProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          Positioned.fill(child: GameWidget(game: _game)),

          // Top status bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: AppTheme.surface.withValues(alpha: 0.85),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: AppTheme.textPrimary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        '${setup.map.name.toUpperCase()} — ${setup.mode.name.toUpperCase()}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),

          // Minimap
          Positioned(
            top: 70,
            right: 12,
            child: MinimapWidget(map: setup.map),
          ),

          // Command bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: CommandBarWidget(
                onStop: _issueStop,
                onHold: _issueStop, // TODO: distinct hold-position behavior vs full stop
                onAttackMove: () {}, // TODO: requires target-acquisition logic in selection_system
                onRetreat: () {}, // TODO: requires a designated rally/retreat point per player
              ),
            ),
          ),
        ],
      ),
    );
  }
}
