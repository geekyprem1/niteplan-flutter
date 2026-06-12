import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import 'auth_viewmodel.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: kSurface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Spacer(),
              // Logo
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: kAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: kAccent.withValues(alpha: 0.4)),
                ),
                child: const Center(child: Text('🌙', style: TextStyle(fontSize: 40))),
              ),
              const SizedBox(height: 24),
              const Text('NitePlan', style: TextStyle(color: kTextPrimary, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 1)),
              const SizedBox(height: 8),
              const Text('Apne plans ko reality banao', style: TextStyle(color: kTextMuted, fontSize: 15)),
              const Spacer(),

              // Error
              if (vm.errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kDanger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kDanger.withValues(alpha: 0.3)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.error_outline, color: kDanger, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(vm.errorMessage!, style: const TextStyle(color: kDanger, fontSize: 13))),
                    GestureDetector(onTap: vm.clearError, child: const Icon(Icons.close, color: kDanger, size: 16)),
                  ]),
                ),

              // Google Sign In
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: vm.isLoading ? null : () async {
                    await context.read<AuthViewModel>().signInWithGoogle();
                  },
                  child: vm.isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: kAccent))
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('G', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF4285F4))),
                            SizedBox(width: 10),
                            Text('Google Se Sign In Karo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 14),

              // Guest Mode
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kTextMuted,
                    side: const BorderSide(color: kDivider),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: vm.isLoading ? null : () async {
                    await context.read<AuthViewModel>().signInAsGuest();
                  },
                  child: const Text('Guest Mode Se Continue Karo', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Guest mode mein data sirf is device pe rahega.',
                style: TextStyle(color: kTextMuted, fontSize: 11),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
