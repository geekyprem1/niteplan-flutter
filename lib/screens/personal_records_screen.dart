import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/task_viewmodel.dart';
import '../data/milestone_model.dart';
import '../theme/app_theme.dart';
import '../l10n/language_provider.dart';

class PersonalRecordsScreen extends StatelessWidget {
  const PersonalRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();
    final lang = context.watch<LanguageProvider>();

    final records = vm.personalRecords;
    final bestScore = records['best_discipline_score'] ?? 0.0;
    final bestStreak = records['best_streak'] ?? 0.0;
    final bestRel = records['best_reliability'] ?? 0.0;
    final bestPlan = records['best_planning_accuracy'] ?? 0.0;
    final totalKept = records['total_promises_kept'] ?? 0.0;
    final totalMade = records['total_promises_made'] ?? 0.0;
    final totalRef = records['total_reflections_logged'] ?? 0.0;

    final unlockedIds = vm.unlockedMilestones;
    final unlockedMilestones = MilestoneRegistry.milestones
        .where((ms) => unlockedIds.contains(ms.id))
        .toList();

    return Scaffold(
      backgroundColor: kSurface,
      appBar: AppBar(
        backgroundColor: kSurface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Records',
              style: TextStyle(color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Your self-trust peaks and milestones',
              style: TextStyle(color: kTextMuted, fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Grid of Records
          const Text(
            'ALL-TIME BESTS',
            style: TextStyle(color: kAccent, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _buildRecordTile('Best Discipline', '${bestScore.toInt()}', '/100', Icons.psychology, kAccent),
              _buildRecordTile('Best Streak', '${bestStreak.toInt()}', ' days', Icons.local_fire_department, kWarning),
              _buildRecordTile('Best Reliability', bestRel.toStringAsFixed(1), '%', Icons.shield, kSuccess),
              _buildRecordTile('Best Planning', bestPlan.toStringAsFixed(1), '%', Icons.edit_calendar, kAccentLight),
            ],
          ),
          const SizedBox(height: 24),

          // Lifetime Stats
          const Text(
            'LIFETIME SUMMARY',
            style: TextStyle(color: kAccent, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: kCardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kDivider),
            ),
            child: Row(
              children: [
                Expanded(child: _buildSummaryStat('${totalMade.toInt()}', 'Promises Made')),
                Container(width: 1, height: 32, color: kDivider),
                Expanded(child: _buildSummaryStat('${totalKept.toInt()}', 'Promises Kept')),
                Container(width: 1, height: 32, color: kDivider),
                Expanded(child: _buildSummaryStat('${totalRef.toInt()}', 'Reflections')),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Milestones Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'UNLOCKED MILESTONES',
                style: TextStyle(color: kAccent, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold),
              ),
              Text(
                '${unlockedMilestones.length}/${MilestoneRegistry.milestones.length}',
                style: const TextStyle(color: kTextMuted, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (unlockedMilestones.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: kCardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kDivider),
              ),
              child: Column(
                children: [
                  const Text('🏆', style: TextStyle(fontSize: 36)),
                  const SizedBox(height: 12),
                  const Text(
                    'No milestones unlocked yet',
                    style: TextStyle(color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Keep your promises and reflect daily to unlock milestones',
                    style: TextStyle(color: kTextMuted, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: unlockedMilestones.length,
              itemBuilder: (context, index) {
                final ms = unlockedMilestones[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: kCardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kSuccess.withValues(alpha: 0.3), width: 1.0),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: kSuccess.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.emoji_events, color: kSuccess, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang.tr(ms.titleKey),
                              style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold, fontSize: 13.5),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              lang.tr(ms.descKey),
                              style: const TextStyle(color: kTextMuted, fontSize: 12, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildRecordTile(String title, String val, String suffix, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: kTextMuted, fontSize: 11, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                val,
                style: const TextStyle(color: kTextPrimary, fontSize: 24, fontWeight: FontWeight.w900, height: 1),
              ),
              Text(
                suffix,
                style: const TextStyle(color: kTextMuted, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String val, String label) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(color: kTextPrimary, fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: kTextMuted, fontSize: 11),
        ),
      ],
    );
  }
}
