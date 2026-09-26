import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:black_sky/core/theme/app_theme.dart';
import 'package:black_sky/presentation/providers/auth_provider.dart';
import 'package:black_sky/presentation/screens/main_menu_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegisterMode = false;
  bool _isLoading = false;
  String? _errorText;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailAuth() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });
    try {
      if (_isRegisterMode) {
        await ref.read(registerWithEmailProvider).call(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              displayName: _emailController.text.split('@').first,
            );
      } else {
        await ref.read(signInWithEmailProvider).call(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            );
      }
      _goToMenu();
    } catch (e) {
      setState(() => _errorText = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGuestSignIn() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });
    try {
      await ref.read(signInAnonymouslyProvider).call();
      _goToMenu();
    } catch (e) {
      setState(() => _errorText = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _goToMenu() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainMenuScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.shield_moon_outlined, color: AppTheme.accentRed, size: 56),
                const SizedBox(height: 12),
                Text(
                  'PROJECT BLACK SKY',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        letterSpacing: 3,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                if (_errorText != null) ...[
                  const SizedBox(height: 12),
                  Text(_errorText!, style: const TextStyle(color: AppTheme.accentRed)),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleEmailAuth,
                  child: Text(_isRegisterMode ? 'REGISTER' : 'SIGN IN'),
                ),
                TextButton(
                  onPressed: () => setState(() => _isRegisterMode = !_isRegisterMode),
                  child: Text(
                    _isRegisterMode ? 'Already have an account? Sign in' : 'New commander? Register',
                    style: const TextStyle(color: AppTheme.textSecondary),
                  ),
                ),
                const Divider(height: 32),
                OutlinedButton(
                  onPressed: _isLoading ? null : _handleGuestSignIn,
                  child: const Text('CONTINUE AS GUEST'),
                ),
                if (_isLoading) ...[
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(color: AppTheme.accentRed),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
