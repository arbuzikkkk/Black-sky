import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:black_sky/core/di/service_locator.dart';
import 'package:black_sky/core/theme/app_theme.dart';
import 'package:black_sky/presentation/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env is optional at first boot (e.g. fresh checkout without secrets yet);
  // fail soft so the app still launches into an explanatory error state
  // rather than crashing before Flutter even paints a frame.
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    debugPrint('No .env found — copy .env.example to .env and fill in Firebase/Nakama config.');
  }

  await Firebase.initializeApp();
  await setupServiceLocator();

  runApp(const ProviderScope(child: BlackSkyApp()));
}

class BlackSkyApp extends StatelessWidget {
  const BlackSkyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PROJECT BLACK SKY',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const SplashScreen(),
    );
  }
}
