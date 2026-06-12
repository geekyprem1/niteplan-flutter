import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_viewmodel.dart';
import '../sync/sync_manager.dart';
import '../theme/app_theme.dart';
import '../l10n/language_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final lang = context.watch<LanguageProvider>();
    final user = authVm.currentUser;
    final isGuest = authVm.isGuest;

    return Scaffold(
      backgroundColor: kSurface,
      appBar: AppBar(backgroundColor: kSurface, title: Text(lang.tr('profile_title'))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [kAccent.withValues(alpha: 0.2), kDeepNavy.withValues(alpha: 0.5)]),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: kAccent.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: kAccent.withValues(alpha: 0.2),
                  backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                  child: user?.photoURL == null ? Text(
                    isGuest ? '👤' : (user?.displayName?.substring(0, 1).toUpperCase() ?? '?'),
                    style: const TextStyle(fontSize: 28),
                  ) : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isGuest ? lang.tr('profile_guest') : (user?.displayName ?? 'NitePlanner'),
                        style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        isGuest ? lang.tr('profile_guest_sub') : (user?.email ?? ''),
                        style: const TextStyle(color: kTextMuted, fontSize: 13),
                      ),
                      if (isGuest) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: kWarning.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6), border: Border.all(color: kWarning.withValues(alpha: 0.4))),
                          child: Text(lang.tr('profile_cloud_off'), style: const TextStyle(color: kWarning, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Guest upgrade
          if (isGuest) ...[
            _ActionCard(
              icon: Icons.cloud_upload,
              iconColor: kSuccess,
              title: lang.tr('profile_link_google'),
              subtitle: lang.tr('profile_link_sub'),
              onTap: () async {
                final ok = await authVm.signInWithGoogle();
                if (ok && context.mounted) {
                  await SyncManager.instance.uploadAllLocalData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(lang.tr('link_google_success')), backgroundColor: kSuccess),
                  );
                }
              },
            ),
            const SizedBox(height: 12),
          ],

          // Sync now
          if (!isGuest) _ActionCard(
            icon: Icons.sync,
            iconColor: kAccent,
            title: lang.tr('profile_sync_now'),
            subtitle: lang.tr('profile_sync_sub'),
            onTap: () async {
              await SyncManager.instance.syncAll();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(lang.tr('profile_sync_done')), backgroundColor: kSuccess),
                );
              }
            },
          ),
          const SizedBox(height: 12),

          // Language switcher
          _LanguageCard(lang: lang),
          const SizedBox(height: 12),

          // Logout
          _ActionCard(
            icon: Icons.logout,
            iconColor: kWarning,
            title: lang.tr('profile_logout'),
            subtitle: isGuest ? lang.tr('dialog_logout_guest') : lang.tr('profile_logout_sub'),
            onTap: () => _confirmAction(
              context,
              title: lang.tr('dialog_logout_title'),
              content: isGuest ? lang.tr('dialog_logout_guest') : lang.tr('dialog_logout_user'),
              onConfirm: () async { await authVm.signOut(); },
            ),
          ),
          const SizedBox(height: 12),

          // Delete account
          _ActionCard(
            icon: Icons.delete_forever,
            iconColor: kDanger,
            title: 'Account Delete Karo',
            subtitle: 'Sab data permanently delete ho jayega',
            onTap: () => _confirmAction(
              context,
              title: '⚠️ Account Delete?',
              content: 'Aapka saara data — tasks, reflections, scores — permanently delete ho jayega. Ye wapas nahi aayega.',
              onConfirm: () async {
                final ok = await authVm.deleteAccount();
                if (!ok && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(authVm.errorMessage ?? 'Delete failed'), backgroundColor: kDanger),
                  );
                }
              },
              isDanger: true,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmAction(BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onConfirm,
    bool isDanger = false,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: kCardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold)),
        content: Text(content, style: const TextStyle(color: kTextMuted)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: kTextMuted))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: isDanger ? kDanger : kAccent),
            onPressed: () { Navigator.pop(context); onConfirm(); },
            child: Text(isDanger ? 'Delete' : 'Confirm'),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title, subtitle;
  final VoidCallback onTap;

  const _ActionCard({required this.icon, required this.iconColor, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kDivider),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: kTextMuted, fontSize: 12)),
              ]),
            ),
            Icon(Icons.chevron_right, color: iconColor.withValues(alpha: 0.6)),
          ],
        ),
      ),
    );
  }
}

// ── Language Switcher Card ──
class _LanguageCard extends StatelessWidget {
  final LanguageProvider lang;
  const _LanguageCard({required this.lang});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLanguageSheet(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kDivider),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: kAccent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.language, color: kAccent, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(lang.tr('profile_language'), style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold)),
                Text(lang.tr('profile_language_sub'), style: const TextStyle(color: kTextMuted, fontSize: 12)),
              ]),
            ),
            // Current language badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: kAccent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: kAccent.withValues(alpha: 0.3)),
              ),
              child: Text(
                lang.isHinglish ? '🇮🇳 Hinglish' : '🇺🇸 English',
                style: const TextStyle(color: kAccent, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: kAccent.withValues(alpha: 0.6)),
          ],
        ),
      ),
    );
  }

  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kCardBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Consumer<LanguageProvider>(
        builder: (ctx, langProv, _) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: kDivider, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              const Text('Choose Language', style: TextStyle(color: kTextPrimary, fontWeight: FontWeight.w900, fontSize: 20)),
              const SizedBox(height: 6),
              const Text('Instantly switches the entire app', style: TextStyle(color: kTextMuted, fontSize: 13)),
              const SizedBox(height: 24),

              // English
              _LangSheetOption(
                flag: '🇺🇸',
                label: 'English',
                sublabel: 'Everything in English',
                isSelected: langProv.isEnglish,
                onTap: () async {
                  await langProv.setLanguage(AppLanguage.english);
                  if (ctx.mounted) Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 12),

              // Hinglish
              _LangSheetOption(
                flag: '🇮🇳',
                label: 'Hinglish',
                sublabel: 'English with natural Hindi coaching',
                isSelected: langProv.isHinglish,
                onTap: () async {
                  await langProv.setLanguage(AppLanguage.hinglish);
                  if (ctx.mounted) Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _LangSheetOption extends StatelessWidget {
  final String flag, label, sublabel;
  final bool isSelected;
  final VoidCallback onTap;
  const _LangSheetOption({required this.flag, required this.label, required this.sublabel, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? kAccent.withValues(alpha: 0.12) : kSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? kAccent : kDivider, width: isSelected ? 1.5 : 1),
        ),
        child: Row(children: [
          Text(flag, style: const TextStyle(fontSize: 30)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(color: isSelected ? kAccent : kTextPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
            Text(sublabel, style: const TextStyle(color: kTextMuted, fontSize: 12)),
          ])),
          if (isSelected) const Icon(Icons.check_circle, color: kAccent, size: 22),
        ]),
      ),
    );
  }
}

