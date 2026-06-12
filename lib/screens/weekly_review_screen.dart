import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/task_viewmodel.dart';
import '../theme/app_theme.dart';

class WeeklyReviewScreen extends StatelessWidget {
  const WeeklyReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<TaskViewModel>();
    final report = vm.generateWeeklyReport();

    return Scaffold(
      backgroundColor: kSurface,
      appBar: AppBar(
        backgroundColor: kSurface,
        title: const Text('Weekly CEO Review'),
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
              gradient: LinearGradient(
                colors: [kAccent.withValues(alpha: 0.4), const Color(0xFF1A1A3E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: kAccent.withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('YOUR WEEKLY REPORT', style: TextStyle(color: kAccentLight, fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(report.weekOf, style: const TextStyle(color: kTextPrimary, fontSize: 22, fontWeight: FontWeight.w900)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _bigStat('${report.tasksCompleted}', 'Tasks Done', kSuccess)),
                    Expanded(child: _bigStat('${report.tasksFailed}', 'Missed', kDanger)),
                    Expanded(child: _bigStat('${report.successRate}%', 'Success Rate', kAccent)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Planning Accuracy
          _ReviewCard(
            emoji: '🎯',
            title: 'Planning Accuracy',
            value: '${report.planningAccuracy}%',
            valueColor: report.planningAccuracy >= 70 ? kSuccess : report.planningAccuracy >= 40 ? kWarning : kDanger,
            subtitle: report.planningAccuracy >= 70
                ? 'Excellent! You plan realistically.'
                : report.planningAccuracy >= 40
                    ? 'Room for improvement. Plan fewer, do more.'
                    : 'Over-planning detected. Start smaller.',
          ),
          const SizedBox(height: 12),

          // Best / Worst day
          Row(
            children: [
              Expanded(child: _SmallReviewCard(emoji: '🌟', label: 'Best Day', value: report.bestDay, color: kSuccess)),
              const SizedBox(width: 12),
              Expanded(child: _SmallReviewCard(emoji: '😤', label: 'Worst Day', value: report.worstDay, color: kDanger)),
            ],
          ),
          const SizedBox(height: 12),

          // Top failure reason
          _ReviewCard(
            emoji: '🧠',
            title: 'Top Failure Reason',
            value: report.topFailureCategory,
            valueColor: kDanger,
            subtitle: 'This pattern is hurting your execution most.',
          ),
          const SizedBox(height: 12),

          // Discipline Score
          _ReviewCard(
            emoji: '💪',
            title: 'Avg Discipline Score',
            value: '${report.avgDisciplineScore.toInt()}/100',
            valueColor: report.avgDisciplineScore >= 60 ? kSuccess : kWarning,
            subtitle: report.avgDisciplineScore >= 60
                ? 'Strong week! Keep the momentum.'
                : 'Focus on consistency this coming week.',
          ),
          const SizedBox(height: 12),

          // Biggest Improvement Area
          _ReviewCard(
            emoji: '📈',
            title: 'Improve This Week',
            value: report.biggestImprovementArea,
            valueColor: kWarning,
            subtitle: 'This life area needs your attention most.',
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
