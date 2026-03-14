import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/supabase_service.dart';
import 'screens/app_shell.dart';
import 'screens/login_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kglawcgwryxrjvorxmbk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtnbGF3Y2d3cnl4cmp2b3J4bWJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI0ODg5ODQsImV4cCI6MjA4ODA2NDk4NH0.qMNhMguri25hY6fFmbuDd9eEPMOXbl27ERbhnYe1oOk',
  );

  runApp(
    const ProviderScope(
      child: FinanceProApp(),
    ),
  );
}

class FinanceProApp extends StatelessWidget {
  const FinanceProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinancePro',
      debugShowCheckedModeBanner: false,
      theme: buildDarkTheme(),
      home: const AuthGate(),
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
          return Scaffold(
            backgroundColor: AppColors.bgColor,
            body: const Center(child: CircularProgressIndicator(color: AppColors.accentColor)),
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
