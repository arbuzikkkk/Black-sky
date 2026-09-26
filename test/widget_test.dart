import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:black_sky/core/theme/app_theme.dart';
import 'package:black_sky/core/config/build_flags.dart';

/// Placeholder smoke test. The real BlackSkyApp widget needs
/// setupServiceLocator() (GetIt) run first, which in turn needs Firebase
/// initialized when kFirebaseEnabled is true — full widget pumping is a
/// follow-up once DI has a test-friendly bootstrap path. For now this just
/// verifies the theme builds and the offline-mode flag is readable, so
/// `flutter analyze`/`flutter test` in CI have something real to check
/// rather than the stock counter-app test flutter create scaffolds by default.
void main() {
  testWidgets('AppTheme.dark builds a valid ThemeData', (tester) async {
    expect(AppTheme.dark, isA<ThemeData>());
  });

  test('kFirebaseEnabled flag is defined', () {
    expect(kFirebaseEnabled, isA<bool>());
  });
}
