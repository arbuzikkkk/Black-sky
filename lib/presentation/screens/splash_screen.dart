import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:black_sky/core/config/build_flags.dart';
import 'package:black_sky/core/theme/app_theme.dart';
import 'package:black_sky/presentation/providers/auth_provider.dart';
import 'package:black_sky/presentation/screens/login_screen.dart';
import 'package:black_sky/presentation/screens/main_menu_screen.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kFirebaseEnabled) {
      // No Firebase configured in this build (see build_flags.dart) — skip
      // auth entirely and drop straight into an offline guest session.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainMenuScreen()),
        );
      });
      return const _SplashBody();
    }

    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () => const _SplashBody(),
      error: (err, st) => _SplashBody(errorText: 'Auth error: $err'),
      data: (profile) {
        // Defer navigation to after first frame to avoid build-phase errors.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => profile == null ? const LoginScreen() : const MainMenuScreen(),
            ),
          );
        });
        return const _SplashBody();
      },
    );
  }
}

class _SplashBody extends StatelessWidget {
  const _SplashBody({this.errorText});
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shield_moon_outlined, color: AppTheme.accentRed, size: 64),
            const SizedBox(height: 16),
            Text(
              'PROJECT BLACK SKY',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    letterSpacing: 3,
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: AppTheme.accentRed),
            if (errorText != null) ...[
              const SizedBox(height: 16),
              Text(errorText!, style: const TextStyle(color: AppTheme.accentRed)),
            ],
          ],
        ),
      ),
    );
  }
}
