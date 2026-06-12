import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../auth/auth_viewmodel.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  String? _selectedStruggle;
  String? _selectedGoal;

  final _struggles = [
    ('procrastination', '😴', 'Procrastination', 'Kaam kal pe dalta rehta hoon'),
    ('distraction', '📱', 'Distraction', 'Phone/social media control nahi hota'),
    ('consistency', '📉', 'Consistency', 'Start karta hoon, continue nahi kar pata'),
    ('time_management', '⏰', 'Time Management', 'Waqt kabhi kaafi nahi lagta'),
    ('focus', '🎯', 'Focus', 'Kaam karte waqt dhyan bhatakta hai'),
  ];

  final _goals = [
    ('health', '💪', 'Health', 'Fit rehna, workout, diet'),
    ('business', '💼', 'Business', 'Apna business grow karna'),
    ('career', '🚀', 'Career', 'Job, skills, promotions'),
    ('learning', '📚', 'Learning', 'Naya seekhna, courses, books'),
    ('finance', '💰', 'Finance', 'Paisa bachana, invest karna'),
  ];

  @override
  void dispose() { _pageController.dispose(); super.dispose(); }

  void _nextPage() {
    _pageController.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('main_struggle', _selectedStruggle ?? 'consistency');
    await prefs.setString('primary_goal', _selectedGoal ?? 'career');
    await prefs.setBool('onboarding_done', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSurface,
      body: SafeArea(
        child: Column(
          children: [
            // Progress dots
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: List.generate(4, (i) => Expanded(
                  child: Container(
                    height: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: i <= _currentPage ? kAccent : kDivider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                )),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (p) => setState(() => _currentPage = p),
                children: [
                  _WelcomePage(onNext: _nextPage),
                  _SelectPage(
                    title: 'Aapki sabse badi problem kya hai?',
                    subtitle: 'Honest raho — ye app aapko yahi solve karne mein help karegi',
                    items: _struggles,
                    selected: _selectedStruggle,
                    onSelect: (v) => setState(() => _selectedStruggle = v),
                    onNext: _selectedStruggle != null ? _nextPage : null,
                  ),
                  _SelectPage(
                    title: 'Aapka primary goal kya hai?',
                    subtitle: 'Is area pe aap sabse zyada focus karna chahte ho',
                    items: _goals,
                    selected: _selectedGoal,
                    onSelect: (v) => setState(() => _selectedGoal = v),
                    onNext: _selectedGoal != null ? _nextPage : null,
                  ),
                  _AuthPage(onFinish: _finishOnboarding),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Screen 1: Welcome ──
class _WelcomePage extends StatelessWidget {
  final VoidCallback onNext;
  const _WelcomePage({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🌙', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 24),
          const Text('NitePlan', style: TextStyle(color: kTextPrimary, fontSize: 36, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          const Text(
            'Raat ko plan karo.\nSubah grow karo.',
            style: TextStyle(color: kTextMuted, fontSize: 18, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(20), border: Border.all(color: kDivider)),
            child: const Column(children: [
              _FeatureRow('⏱️', 'Focus Timer', 'Kaam karo bina distraction ke'),
              SizedBox(height: 12),
              _FeatureRow('🌙', 'Daily Reflection', 'Raat ko apne din ka analysis karo'),
              SizedBox(height: 12),
              _FeatureRow('📊', 'Discipline Score', 'Apni growth track karo 0-100'),
            ]),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Shuru Karte Hain 🚀', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String emoji, title, subtitle;
  const _FeatureRow(this.emoji, this.title, this.subtitle);
  @override
  Widget build(BuildContext context) => Row(children: [
    Text(emoji, style: const TextStyle(fontSize: 24)),
    const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold)),
      Text(subtitle, style: const TextStyle(color: kTextMuted, fontSize: 12)),
    ])),
  ]);
}

// ── Screen 2 & 3: Selection pages ──
class _SelectPage extends StatelessWidget {
  final String title, subtitle;
  final List<(String, String, String, String)> items;
  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback? onNext;

  const _SelectPage({required this.title, required this.subtitle, required this.items, required this.selected, required this.onSelect, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: kTextPrimary, fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: kTextMuted, fontSize: 13)),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: items.map((item) {
                final key = item.$1;
                final emoji = item.$2;
                final label = item.$3;
                final desc = item.$4;
                final sel = selected == key;
                return GestureDetector(
                  onTap: () => onSelect(key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: sel ? kAccent.withValues(alpha: 0.15) : kCardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: sel ? kAccent : kDivider, width: sel ? 1.5 : 1),
                    ),
                    child: Row(children: [
                      Text(emoji, style: const TextStyle(fontSize: 26)),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(label, style: TextStyle(color: sel ? kAccent : kTextPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(desc, style: const TextStyle(color: kTextMuted, fontSize: 12)),
                      ])),
                      if (sel) const Icon(Icons.check_circle, color: kAccent, size: 22),
                    ]),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Aage Badho', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Screen 4: Auth ──
class _AuthPage extends StatelessWidget {
  final Future<void> Function() onFinish;
  const _AuthPage({required this.onFinish});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();

    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Text('🔐', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 20),
          const Text('Apna Account Banao', style: TextStyle(color: kTextPrimary, fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('Cloud sync se aapka data kabhi nahi jayega — chahe phone badlo ya app delete karo', style: TextStyle(color: kTextMuted, fontSize: 13), textAlign: TextAlign.center),
          const Spacer(),

          if (authVm.errorMessage != null)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: kDanger.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: kDanger.withValues(alpha: 0.3))),
              child: Text(authVm.errorMessage!, style: const TextStyle(color: kDanger, fontSize: 13)),
            ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: authVm.isLoading ? null : () async {
                await onFinish();
                await context.read<AuthViewModel>().signInWithGoogle();
              },
              child: authVm.isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: kAccent))
                  : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('G', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF4285F4))),
                      SizedBox(width: 10),
                      Text('Google Se Sign In Karo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ]),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: kTextMuted,
                side: const BorderSide(color: kDivider),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: authVm.isLoading ? null : () async {
                await onFinish();
                await context.read<AuthViewModel>().signInAsGuest();
              },
              child: const Text('Guest Mode Se Continue Karo', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Guest mode mein data sirf is device pe rahega', style: TextStyle(color: kTextMuted, fontSize: 11), textAlign: TextAlign.center),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
