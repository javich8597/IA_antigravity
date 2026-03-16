import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/supabase_service.dart';
import 'screens/app_shell.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'theme.dart';

bool _hasSeenOnboarding = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  _hasSeenOnboarding = prefs.getBool('seen_onboarding') ?? false;

  await Supabase.initialize(
    url: 'https://kglawcgwryxrjvorxmbk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtnbGF3Y2d3cnl4cmp2b3J4bWJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI0ODg5ODQsImV4cCI6MjA4ODA2NDk4NH0.qMNhMguri25hY6fFmbuDd9eEPMOXbl27ERbhnYe1oOk',
  );

  runApp(
    const ProviderScope(
      child: ThinkBetterApp(),
    ),
  );
}

class ThinkBetterApp extends StatelessWidget {
  const ThinkBetterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Think Better',
      debugShowCheckedModeBanner: false,
      theme: buildDarkTheme(),
      home: _hasSeenOnboarding ? const AuthGate() : const OnboardingScreen(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: supabaseService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.bgColor,
            body: Center(child: CircularProgressIndicator(color: AppColors.accentColor)),
          );
        }

        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return const AppShell();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
