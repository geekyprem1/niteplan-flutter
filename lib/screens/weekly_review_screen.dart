import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/task_viewmodel.dart';
import '../theme/app_theme.dart';
import '../l10n/language_provider.dart';

class WeeklyReviewScreen extends StatelessWidget {
  const WeeklyReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<TaskViewModel>();
    final report = vm.generateWeeklyReport();
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: kSurface,
      appBar: AppBar(
        backgroundColor: kSurface,
        title: Text(lang.tr('weekly_title')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Week header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kCardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kDivider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lang.tr('weekly_your_report'), style: const TextStyle(color: kAccentLight, fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(report.weekOf, style: const TextStyle(color: kTextPrimary, fontSize: 22, fontWeight: FontWeight.w900)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _bigStat('${report.tasksCompleted}', lang.tr('weekly_tasks_done'), kSuccess)),
                    Expanded(child: _bigStat('${report.tasksFailed}', lang.tr('weekly_missed'), kDanger)),
                    Expanded(child: _bigStat('${report.successRate}%', lang.tr('weekly_success_rate'), kAccent)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Planning Accuracy
          _ReviewCard(
            emoji: '🎯',
            title: lang.tr('weekly_planning_acc'),
            value: '${report.planningAccuracy}%',
            valueColor: report.planningAccuracy >= 70 ? kSuccess : report.planningAccuracy >= 40 ? kWarning : kDanger,
            subtitle: report.planningAccuracy >= 70
                ? lang.tr('weekly_plan_excellent')
                : report.planningAccuracy >= 40
                    ? lang.tr('weekly_plan_ok')
                    : lang.tr('weekly_plan_low'),
          ),
          const SizedBox(height: 12),

          // Best / Worst day
          Row(
            children: [
              Expanded(child: _SmallReviewCard(emoji: '🌟', label: lang.tr('weekly_best_day'), value: report.bestDay, color: kSuccess)),
              const SizedBox(width: 12),
              Expanded(child: _SmallReviewCard(emoji: '😤', label: lang.tr('weekly_worst_day'), value: report.worstDay, color: kDanger)),
            ],
          ),
          const SizedBox(height: 12),

          // Top failure reason
          _ReviewCard(
            emoji: '🧠',
            title: lang.tr('weekly_top_failure'),
            value: report.topFailureCategory,
            valueColor: kDanger,
            subtitle: lang.tr('weekly_failure_msg'),
          ),
          const SizedBox(height: 12),

          // Discipline Score
          _ReviewCard(
            emoji: '💪',
            title: lang.tr('weekly_avg_score'),
            value: '${report.avgDisciplineScore.toInt()}/100',
            valueColor: report.avgDisciplineScore >= 60 ? kSuccess : kWarning,
            subtitle: report.avgDisciplineScore >= 60
                ? lang.tr('weekly_score_strong')
                : lang.tr('weekly_score_ok'),
          ),
          const SizedBox(height: 12),

          // Biggest Improvement Area
          _ReviewCard(
            emoji: '📈',
            title: lang.tr('weekly_improve_area'),
            value: report.biggestImprovementArea,
            valueColor: kWarning,
            subtitle: lang.tr('weekly_improve_msg'),
          ),
          const SizedBox(height: 24),

          // Motivational closer
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kCardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kDivider),
            ),
            child: Column(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 36)),
                const SizedBox(height: 8),
                const Text(
                  '"Discipline is choosing between what you want now and what you want most."',
                  style: TextStyle(color: kTextPrimary, fontSize: 14, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                const Text('— Abraham Lincoln', style: TextStyle(color: kTextMuted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bigStat(String value, String label, Color color) => Column(
    children: [
      Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 28)),
      Text(label, style: const TextStyle(color: kTextMuted, fontSize: 11)),
    ],
  );
}

class _ReviewCard extends StatelessWidget {
  final String emoji, title, value, subtitle;
  final Color valueColor;
  const _ReviewCard({required this.emoji, required this.title, required this.value, required this.subtitle, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: kDivider)),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: kTextMuted, fontSize: 12)),
                Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.w900, fontSize: 20)),
                Text(subtitle, style: const TextStyle(color: kTextMuted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallReviewCard extends StatelessWidget {
  final String emoji, label, value;
  final Color color;
  const _SmallReviewCard({required this.emoji, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: kTextMuted, fontSize: 11)),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 18)),
        ],
      ),
    );
  }
}
