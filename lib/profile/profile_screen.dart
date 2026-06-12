import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_viewmodel.dart';
import '../sync/sync_manager.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final user = authVm.currentUser;
    final isGuest = authVm.isGuest;

    return Scaffold(
      backgroundColor: kSurface,
      appBar: AppBar(backgroundColor: kSurface, title: const Text('Profile & Settings')),
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
                        isGuest ? 'Guest User' : (user?.displayName ?? 'NitePlanner'),
                        style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        isGuest ? 'Guest Mode — Data local hai' : (user?.email ?? ''),
                        style: const TextStyle(color: kTextMuted, fontSize: 13),
                      ),
                      if (isGuest) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: kWarning.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6), border: Border.all(color: kWarning.withValues(alpha: 0.4))),
                          child: const Text('⚠️ Cloud sync off', style: TextStyle(color: kWarning, fontSize: 10, fontWeight: FontWeight.bold)),
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
              title: 'Google Se Link Karo',
              subtitle: 'Data cloud pe save hoga — kabhi nahi jayega',
              onTap: () async {
                final ok = await authVm.signInWithGoogle();
                if (ok && context.mounted) {
                  await SyncManager.instance.uploadAllLocalData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ Account linked! Data synced.'), backgroundColor: kSuccess),
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
            title: 'Abhi Sync Karo',
            subtitle: 'Manually cloud se sync karo',
            onTap: () async {
              await SyncManager.instance.syncAll();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ Sync complete!'), backgroundColor: kSuccess),
                );
              }
            },
          ),
          const SizedBox(height: 12),

          // Logout
          _ActionCard(
            icon: Icons.logout,
            iconColor: kWarning,
            title: 'Logout',
            subtitle: isGuest ? 'Guest session khatam karein' : 'Account se sign out karein',
            onTap: () => _confirmAction(
              context,
              title: 'Logout Karna Chahte Ho?',
              content: isGuest
                  ? 'Guest mode ka data device pe rahega. Cloud sync nahi hoga.'
                  : 'Aap signed out ho jaoge. Data cloud pe safe hai.',
              onConfirm: () async {
                await authVm.signOut();
              },
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
