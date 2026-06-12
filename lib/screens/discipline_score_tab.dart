import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/task_viewmodel.dart';
import '../data/discipline_score_model.dart';
import '../theme/app_theme.dart';
import '../l10n/language_provider.dart';
import 'weekly_review_screen.dart';

class DisciplineScoreTab extends StatelessWidget {
  const DisciplineScoreTab({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final vm = context.watch<TaskViewModel>();
    final score = vm.currentScore;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        // Header
        Text(lang.tr('score_section_label'), style: const TextStyle(color: kAccent, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(lang.tr('score_subtitle'), style: const TextStyle(color: kTextPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),

        // Big Score Ring
        _ScoreRing(score: score),
        const SizedBox(height: 24),

        // Score Breakdown
        if (score != null) _ScoreBreakdown(score: score),
        const SizedBox(height: 20),

        // 7-day sparkline
        if (vm.scoreHistory.length > 1) _ScoreSparkline(history: vm.scoreHistory),
        const SizedBox(height: 20),

        // Failure Intelligence
        _FailureIntelligenceCard(vm: vm),
        const SizedBox(height: 16),

        // Life Area Stats
        if (vm.lifeAreaStats.isNotEmpty) _LifeAreaCard(vm: vm),
        const SizedBox(height: 16),

        // Weekly CEO Review button
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WeeklyReviewScreen())),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [kAccent.withValues(alpha: 0.3), kDeepNavy.withValues(alpha: 0.8)]),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kAccent.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Text('📊', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lang.tr('score_weekly_btn'), style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(lang.tr('score_weekly_sub'), style: const TextStyle(color: kTextMuted, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: kAccent, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Big Score Ring ──
class _ScoreRing extends StatelessWidget {
  final DisciplineScore? score;
  const _ScoreRing({required this.score});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final total = score?.totalScore ?? 0;
    final rawLabel = score?.label ?? 'Beginner';
    final scoreColor = Color(score?.colorValue ?? 0xFFFF4060);

    String localizedLabel;
    switch (rawLabel) {
      case 'Building':
        localizedLabel = lang.tr('score_building');
        break;
      case 'Consistent':
        localizedLabel = lang.tr('score_consistent');
        break;
      case 'Disciplined':
        localizedLabel = lang.tr('score_disciplined');
        break;
      case 'Elite':
        localizedLabel = lang.tr('score_elite');
        break;
      default:
        localizedLabel = lang.tr('score_beginner');
    }

    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: CustomPaint(
              painter: _RingPainter(fraction: total / 100, color: scoreColor),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${total.toInt()}', style: const TextStyle(color: kTextPrimary, fontSize: 52, fontWeight: FontWeight.w900)),
                    Text(lang.tr('score_out_of'), style: const TextStyle(color: kTextMuted, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: scoreColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: scoreColor.withValues(alpha: 0.4)),
            ),
            child: Text(localizedLabel, style: TextStyle(color: scoreColor, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1)),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double fraction;
  final Color color;
  _RingPainter({required this.fraction, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 18;
    final stroke = 18.0;
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = stroke..strokeCap = StrokeCap.round;

    paint.color = kDivider;
    canvas.drawCircle(center, radius, paint);

    paint.color = color;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * fraction,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.fraction != fraction;
}

// ── Score Breakdown ──
class _ScoreBreakdown extends StatelessWidget {
  final DisciplineScore score;
  const _ScoreBreakdown({required this.score});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: kDivider)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lang.tr('score_breakdown'), style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          _bar(lang.tr('score_execution'), score.executionScore, kSuccess, '40%'),
          _bar(lang.tr('score_consistency'), score.consistencyScore, kAccent, '30%'),
          _bar(lang.tr('score_planning'), score.planningScore, kWarning, '20%'),
          _bar(lang.tr('score_reflection'), score.reflectionScore, const Color(0xFF00BCD4), '10%'),
        ],
      ),
    );
  }

  Widget _bar(String label, double value, Color color, String weight) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: kTextPrimary, fontSize: 13)),
              Row(
                children: [
                  Text(weight, style: const TextStyle(color: kTextMuted, fontSize: 11)),
                  const SizedBox(width: 8),
                  Text('${value.toInt()}%', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          LayoutBuilder(builder: (ctx, c) => Stack(children: [
            Container(height: 6, width: c.maxWidth, decoration: BoxDecoration(color: kDivider, borderRadius: BorderRadius.circular(3))),
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              height: 6,
              width: c.maxWidth * (value / 100).clamp(0, 1),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
            ),
          ])),
        ],
      ),
    );
  }
}

// ── Score Sparkline ──
class _ScoreSparkline extends StatelessWidget {
  final List<DisciplineScore> history;
  const _ScoreSparkline({required this.history});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final last7 = history.length > 7 ? history.sublist(history.length - 7) : history;
    final maxScore = last7.map((s) => s.totalScore).fold(1.0, (a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: kDivider)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lang.tr('score_history'), style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: last7.map((s) {
                final fraction = maxScore > 0 ? s.totalScore / maxScore : 0.0;
                final color = Color(s.colorValue);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${s.totalScore.toInt()}', style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        FractionallySizedBox(
                          heightFactor: fraction.toDouble().clamp(0.05, 1),
                          child: Container(
                            decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(s.date.substring(8), style: const TextStyle(color: kTextMuted, fontSize: 9)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Failure Intelligence ──
class _FailureIntelligenceCard extends StatelessWidget {
  final TaskViewModel vm;
  const _FailureIntelligenceCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final insights = vm.failureInsights;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: kDivider)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🧠', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(lang.tr('score_failure_title'), style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 4),
          Text(lang.tr('score_failure_sub'), style: const TextStyle(color: kTextMuted, fontSize: 12)),
          const SizedBox(height: 14),
          if (insights.isEmpty)
            Text(lang.tr('score_no_failure'), style: const TextStyle(color: kTextMuted, fontSize: 13))
          else ...[
            // Top insight banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kDanger.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kDanger.withValues(alpha: 0.3)),
              ),
              child: Text(
                '${insights.first.emoji} ${insights.first.percentage.toInt()}% failures come from ${insights.first.category}',
                style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
            const SizedBox(height: 12),
            ...insights.map((ins) => _InsightBar(insight: ins)),
          ],
        ],
      ),
    );
  }
}

class _InsightBar extends StatelessWidget {
  final FailureInsight insight;
  const _InsightBar({required this.insight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${insight.emoji} ${insight.category}', style: const TextStyle(color: kTextPrimary, fontSize: 13)),
              Text('${insight.percentage.toInt()}% · ${insight.count}x', style: const TextStyle(color: kDanger, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          LayoutBuilder(builder: (ctx, c) => Stack(children: [
            Container(height: 5, width: c.maxWidth, decoration: BoxDecoration(color: kDivider, borderRadius: BorderRadius.circular(3))),
            Container(height: 5, width: c.maxWidth * insight.percentage / 100, decoration: BoxDecoration(color: kDanger, borderRadius: BorderRadius.circular(3))),
          ])),
        ],
      ),
    );
  }
}

// ── Life Area Card ──
class _LifeAreaCard extends StatelessWidget {
  final TaskViewModel vm;
  const _LifeAreaCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: kDivider)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lang.tr('score_life_area'), style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          ...vm.lifeAreaStats.map((stat) {
            final color = Color(stat.area.colorValue);
            final rate = stat.rate;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${stat.area.emoji} ${stat.area.label}', style: const TextStyle(color: kTextPrimary, fontSize: 13)),
                      Text('${stat.completed}/${stat.planned} · ${(rate * 100).toInt()}%', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LayoutBuilder(builder: (ctx, c) => Stack(children: [
                    Container(height: 5, width: c.maxWidth, decoration: BoxDecoration(color: kDivider, borderRadius: BorderRadius.circular(3))),
                    Container(height: 5, width: c.maxWidth * rate.clamp(0, 1), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
                  ])),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
