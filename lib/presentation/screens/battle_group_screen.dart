import 'package:flutter/material.dart';
import 'package:black_sky/core/constants/game_constants.dart';
import 'package:black_sky/core/theme/app_theme.dart';
import 'package:black_sky/domain/entities/unit_entity.dart';
import 'package:black_sky/game/data/factions.dart';

/// Battle Group (deck) editor: pick units from the faction roster into a
/// limited-cost loadout. Persisting the saved deck to Firestore/local Hive
/// is a follow-up (see TODO) — this screen owns the selection logic and UI.
class BattleGroupScreen extends StatefulWidget {
  const BattleGroupScreen({super.key, this.faction = Faction.usa});
  final Faction faction;

  @override
  State<BattleGroupScreen> createState() => _BattleGroupScreenState();
}

class _BattleGroupScreenState extends State<BattleGroupScreen> {
  final List<UnitEntity> _deck = [];

  int get _totalCost => _deck.fold(0, (sum, u) => sum + u.deckCost);

  void _toggleUnit(UnitEntity unit) {
    setState(() {
      if (_deck.contains(unit)) {
        _deck.remove(unit);
        return;
      }
      if (_deck.length >= GameConstants.maxDeckSlots) return;
      if (_totalCost + unit.deckCost > GameConstants.maxDeckPointCost) return;
      _deck.add(unit);
    });
    // TODO(persistence): write _deck (as unit ids) to the player's Firestore
    // profile or a local Hive box once a `battleGroups` collection schema
    // is decided — deliberately out of scope for this pass.
  }

  @override
  Widget build(BuildContext context) {
    final roster = FactionRegistry.rosterFor(widget.faction);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text('BATTLE GROUP — ${widget.faction.displayName}')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: AppTheme.surface,
            child: Row(
              children: [
                Text('DECK COST', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: _totalCost / GameConstants.maxDeckPointCost,
                      minHeight: 8,
                      backgroundColor: AppTheme.surfaceRaised,
                      color: _totalCost >= GameConstants.maxDeckPointCost ? AppTheme.accentRed : AppTheme.hudGreen,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text('$_totalCost / ${GameConstants.maxDeckPointCost}'),
              ],
            ),
          ),
          Expanded(
            child: roster.isEmpty
                ? const Center(
                    child: Text('Roster for this faction is not built yet.', style: TextStyle(color: AppTheme.textSecondary)),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.6,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: roster.length,
                    itemBuilder: (context, index) {
                      final unit = roster[index];
                      final selected = _deck.contains(unit);
                      return _UnitCard(unit: unit, selected: selected, onTap: () => _toggleUnit(unit));
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _UnitCard extends StatelessWidget {
  const _UnitCard({required this.unit, required this.selected, required this.onTap});
  final UnitEntity unit;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppTheme.accentRedDim : AppTheme.surfaceRaised,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(unit.name, style: const TextStyle(fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(unit.category.name.toUpperCase(), style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('HP ${unit.maxHp}', style: const TextStyle(fontSize: 11, color: AppTheme.hudGreen)),
                  Text('COST ${unit.deckCost}', style: const TextStyle(fontSize: 11, color: AppTheme.hudAmber)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
