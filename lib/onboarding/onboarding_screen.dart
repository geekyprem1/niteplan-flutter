import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../auth/auth_viewmodel.dart';
import '../l10n/language_provider.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback? onComplete;
  const OnboardingScreen({super.key, this.onComplete});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  AppLanguage _selectedLanguage = AppLanguage.english;
  String? _selectedStruggle;
  String? _selectedGoal;

  static const int _totalPages = 5;

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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('main_struggle', _selectedStruggle ?? 'consistency');
    await prefs.setString('primary_goal', _selectedGoal ?? 'career');
    await prefs.setBool('onboarding_done', true);
    // Apply selected language
    if (mounted) {
      await context.read<LanguageProvider>().setLanguage(_selectedLanguage);
    }
  }

  void _onAuthSuccess() {
    widget.onComplete?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSurface,
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: List.generate(_totalPages, (i) => Expanded(
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
                  // Screen 1: Welcome
                  _WelcomePage(onNext: _nextPage),

                  // Screen 2: Language Selection (NEW)
                  _LanguagePage(
                    selected: _selectedLanguage,
                    onSelect: (lang) => setState(() => _selectedLanguage = lang),
                    onNext: _nextPage,
                  ),

                  // Screen 3: Biggest Challenge
                  _SelectPage(
                    title: _selectedLanguage == AppLanguage.hinglish
                        ? 'Aapki sabse badi problem kya hai?'
                        : "What's your biggest challenge?",
                    subtitle: _selectedLanguage == AppLanguage.hinglish
                        ? 'Honest raho — ye app aapko solve karne mein help karegi'
                        : 'Be honest — this app will help you solve it.',
                    items: _struggles,
                    selected: _selectedStruggle,
                    onSelect: (v) => setState(() => _selectedStruggle = v),
                    onNext: _selectedStruggle != null ? _nextPage : null,
                    language: _selectedLanguage,
                  ),

                  // Screen 4: Primary Goal
                  _SelectPage(
                    title: _selectedLanguage == AppLanguage.hinglish
                        ? 'Aapka primary goal kya hai?'
                        : "What's your primary goal?",
                    subtitle: _selectedLanguage == AppLanguage.hinglish
                        ? 'Is area pe sabse zyada focus milega'
                        : 'This area gets maximum focus in the app.',
                    items: _goals,
                    selected: _selectedGoal,
                    onSelect: (v) => setState(() => _selectedGoal = v),
                    onNext: _selectedGoal != null ? _nextPage : null,
                    language: _selectedLanguage,
                  ),

                  // Screen 5: Auth
                  _AuthPage(
                    onFinish: _finishOnboarding,
                    onAuthSuccess: _onAuthSuccess,
                    language: _selectedLanguage,
                  ),
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
            'Plan the night.\nGrow every day.',
            style: TextStyle(color: kTextMuted, fontSize: 18, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: kDivider)),
            child: const Column(children: [
              _FeatureRow('⏱️', 'Focus Timer', 'Work without distraction'),
              SizedBox(height: 12),
              _FeatureRow('🌙', 'Daily Reflection', 'Analyze your night, every night'),
              SizedBox(height: 12),
              _FeatureRow('📊', 'Discipline Score', 'Track your growth 0-100'),
            ]),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text("Let's Begin 🚀", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

// ── Screen 2: Language Selection (NEW) ──
class _LanguagePage extends StatelessWidget {
  final AppLanguage selected;
  final ValueChanged<AppLanguage> onSelect;
  final VoidCallback onNext;
  const _LanguagePage({required this.selected, required this.onSelect, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🌐', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          const Text(
            'How would you like\nNitePlan to guide you?',
            style: TextStyle(color: kTextPrimary, fontSize: 24, fontWeight: FontWeight.w900, height: 1.3),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose the language that feels most natural to you.',
            style: TextStyle(color: kTextMuted, fontSize: 14),
          ),
          const SizedBox(height: 32),

          // English option
          _LangOption(
            flag: '🇺🇸',
            label: 'English',
            sublabel: 'Everything in English',
            preview: '"You completed 4 tasks today."',
            isSelected: selected == AppLanguage.english,
            onTap: () => onSelect(AppLanguage.english),
          ),
          const SizedBox(height: 16),

          // Hinglish option
          _LangOption(
            flag: '🇮🇳',
            label: 'Hinglish',
            sublabel: 'English with natural Hindi coaching',
            preview: '"Aaj tumne 4 tasks complete kiye."',
            isSelected: selected == AppLanguage.hinglish,
            onTap: () => onSelect(AppLanguage.hinglish),
          ),

          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Continue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class _LangOption extends StatelessWidget {
  final String flag, label, sublabel, preview;
  final bool isSelected;
  final VoidCallback onTap;
  const _LangOption({required this.flag, required this.label, required this.sublabel, required this.preview, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? kAccent.withValues(alpha: 0.12) : kCardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? kAccent : kDivider,
            width: isSelected ? 1.2 : 0.8,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 36)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(color: isSelected ? kAccent : kTextPrimary, fontWeight: FontWeight.w900, fontSize: 18)),
                  Text(sublabel, style: const TextStyle(color: kTextMuted, fontSize: 13)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isSelected ? kAccent.withValues(alpha: 0.1) : const Color(0xFF1E1E21),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(preview, style: TextStyle(color: isSelected ? kAccent : kTextMuted, fontSize: 11, fontStyle: FontStyle.italic)),
                  ),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: kAccent, size: 24),
          ],
        ),
      ),
    );
  }
}

// ── Screen 3 & 4: Selection pages ──
class _SelectPage extends StatelessWidget {
  final String title, subtitle;
  final List<(String, String, String, String)> items;
  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback? onNext;
  final AppLanguage language;

  const _SelectPage({required this.title, required this.subtitle, required this.items, required this.selected, required this.onSelect, required this.onNext, required this.language});

  @override
  Widget build(BuildContext context) {
    final btnLabel = language == AppLanguage.hinglish ? 'Aage Badho' : 'Continue';
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
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: sel ? kAccent : kDivider, width: sel ? 1.2 : 0.8),
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
              child: Text(btnLabel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Screen 5: Auth ──
class _AuthPage extends StatelessWidget {
  final Future<void> Function() onFinish;
  final VoidCallback onAuthSuccess;
  final AppLanguage language;
  const _AuthPage({required this.onFinish, required this.onAuthSuccess, required this.language});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final isHi = language == AppLanguage.hinglish;

    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Text('🔐', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 20),
          Text(
            isHi ? 'Apna Account Banao' : 'Create Your Account',
            style: const TextStyle(color: kTextPrimary, fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            isHi
                ? 'Cloud sync se aapka data kabhi nahi jayega — chahe phone badlo ya app delete karo'
                : 'Cloud sync ensures your data is never lost — even if you change phones.',
            style: const TextStyle(color: kTextMuted, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const Spacer(),

          if (authVm.errorMessage != null)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: kDanger.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: kDanger.withValues(alpha: 0.3))),
              child: Text(authVm.errorMessage!, style: const TextStyle(color: kDanger, fontSize: 13)),
            ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: authVm.isLoading ? null : () async {
                await onFinish();
                if (context.mounted) {
                  final ok = await context.read<AuthViewModel>().signInWithGoogle();
                  if (ok) onAuthSuccess();
                }
              },
              child: authVm.isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: kAccent))
                  : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text('G', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF4285F4))),
                      const SizedBox(width: 10),
                      Text(isHi ? 'Google Se Sign In Karo' : 'Sign in with Google', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ]),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: kTextMuted, side: const BorderSide(color: kDivider, width: 0.8),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: authVm.isLoading ? null : () async {
                await onFinish();
                if (context.mounted) {
                  final ok = await context.read<AuthViewModel>().signInAsGuest();
                  if (ok) onAuthSuccess();
                }
              },
              child: Text(isHi ? 'Guest Mode Se Continue Karo' : 'Continue as Guest', style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isHi ? 'Guest mode mein data sirf is device pe rahega' : 'In guest mode, data stays on this device only.',
            style: const TextStyle(color: kTextMuted, fontSize: 11),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
