import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:black_sky/core/theme/app_theme.dart';
import 'package:black_sky/presentation/providers/auth_provider.dart';
import 'package:black_sky/presentation/screens/battle_group_screen.dart';
import 'package:black_sky/presentation/screens/match_screen.dart';
import 'package:black_sky/presentation/providers/match_provider.dart';

class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              authState.when(
                loading: () => const SizedBox(height: 72),
                error: (_, __) => const SizedBox(height: 72),
                data: (profile) => _ProfileHeader(profile: profile),
              ),
              const SizedBox(height: 32),
              Text(
                'PROJECT BLACK SKY',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
              ),
              const SizedBox(height: 4),
              const Text('Modern Real-Time Strategy', style: TextStyle(color: AppTheme.textSecondary)),
              const Spacer(),
              _MenuButton(
                label: 'SKIRMISH / TRAINING',
                icon: Icons.local_fire_department_outlined,
                onTap: () {
                  ref.read(matchSetupProvider.notifier);
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MatchScreen()));
                },
              ),
              const SizedBox(height: 12),
              _MenuButton(
                label: 'BATTLE GROUP',
                icon: Icons.style_outlined,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BattleGroupScreen()),
                ),
              ),
              const SizedBox(height: 12),
              const _MenuButton(label: 'RANKED (coming online)', icon: Icons.emoji_events_outlined, onTap: null),
              const SizedBox(height: 12),
              const _MenuButton(label: 'CLANS (coming online)', icon: Icons.groups_outlined, onTap: null),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});
  final dynamic profile;

  @override
  Widget build(BuildContext context) {
    if (profile == null) return const SizedBox.shrink();
    return Row(
      children: [
        const CircleAvatar(
          backgroundColor: AppTheme.surfaceRaised,
          child: Icon(Icons.person, color: AppTheme.accentRed),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(profile.displayName as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                'LVL ${profile.level}  •  ${profile.credits} CR',
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Material(
      color: disabled ? AppTheme.surface : AppTheme.surfaceRaised,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: BoxDecoration(border: Border(left: BorderSide(color: disabled ? Colors.transparent : AppTheme.accentRed, width: 3))),
          child: Row(
            children: [
              Icon(icon, color: disabled ? AppTheme.textSecondary : AppTheme.textPrimary),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  color: disabled ? AppTheme.textSecondary : AppTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
