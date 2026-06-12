import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/auth_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../sync/sync_manager.dart';
import '../sync/background_sync.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthGate extends StatefulWidget {
  final Widget home;
  const AuthGate({super.key, required this.home});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool? _onboardingDone;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _onboardingDone = prefs.getBool('onboarding_done') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_onboardingDone == null) {
      // Still checking
      return const Scaffold(
        backgroundColor: Color(0xFF12121E),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF7C4DFF))),
      );
    }

    if (!_onboardingDone!) {
      return OnboardingScreen(
        onComplete: () => setState(() => _onboardingDone = true),
      );
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF12121E),
            body: Center(child: CircularProgressIndicator(color: Color(0xFF7C4DFF))),
          );
        }

        if (snapshot.data != null) {
          // Logged in — trigger sync in background
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await SyncManager.instance.migrateLocalToCloud();
            await BackgroundSync.registerPeriodicSync();
            // Fire-and-forget sync
            SyncManager.instance.syncAll();
          });
          return widget.home;
        }

        // Not logged in
        return const AuthScreen();
      },
    );
  }
}
