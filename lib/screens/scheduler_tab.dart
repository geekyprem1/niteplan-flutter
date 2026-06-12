import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/task_viewmodel.dart';
import '../data/task_model.dart';
import '../theme/app_theme.dart';
import '../l10n/language_provider.dart';
import '../data/identity_level_model.dart';
import '../l10n/motivation_messages.dart';


class SchedulerTab extends StatefulWidget {
  final Function(int)? onTabSelected;
  const SchedulerTab({super.key, this.onTabSelected});

  @override
  State<SchedulerTab> createState() => _SchedulerTabState();
}

class _SchedulerTabState extends State<SchedulerTab> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();
    final lang = context.watch<LanguageProvider>();
    final todayTasks = vm.todayTasks;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        // 1. Hero Card (Discipline Score + Behavioral Insight)
        _buildHeroCard(vm, lang),
        const SizedBox(height: 16),

        // 2. Reliability Score Card
        _buildReliabilityCard(vm, lang),
        const SizedBox(height: 16),

        // 3. Identity Level Card
        _buildIdentityCard(vm, lang),
        const SizedBox(height: 16),

        // 4. Daily Insight Card (Behavioral Insights)
        _buildDailyInsightCard(vm, lang),
        const SizedBox(height: 24),

        // 5. Today's Tasks header
        buildSectionHeader(
          lang.tr('home_tasks_title'),
          subtitle: '${lang.tr('scheduler_pending_count')} (${todayTasks.length})',
          trailing: TextButton.icon(
            icon: const Icon(Icons.add, size: 16, color: kAccent),
            label: Text(
              lang.tr('scheduler_add_task_short'),
              style: const TextStyle(color: kAccent, fontWeight: FontWeight.bold, fontSize: 13),
            ),
            onPressed: () => _showAddTaskSheet(context, vm, lang),
          ),
        ),
        const SizedBox(height: 12),

        // 6. Today's Tasks List
        if (todayTasks.isEmpty)
          _buildEmptyPlanning(context, vm, lang)
        else
          ...todayTasks.map((t) => _HomeTaskCard(task: t, vm: vm, key: ValueKey(t.id))),
        const SizedBox(height: 24),

        // 7. Reflection Card (Dedicated "Understanding Yourself" Card)
        _buildReflectionCard(context, vm, lang),
      ],
    );
  }

  // ── Dashboard Component Builders ──

  Widget _buildHeroCard(TaskViewModel vm, LanguageProvider lang) {
    final score = vm.currentScore?.totalScore.toInt() ?? 0;
    final label = score == 0
        ? lang.tr('score_empty_level')
        : "Level ${vm.currentLevel.level} • ${lang.tr(vm.currentLevel.nameKey)}";
    final trend = _getWeeklyTrend(vm);
    
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final insight = score == 0
        ? lang.tr('score_empty_body')
        : MotivationMessages.getMessage(lang.language, vm.currentLevel.level, dayOfYear);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lang.tr('score_section_label'),
                style: const TextStyle(color: kTextMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: trend.startsWith('+') ? kSuccess.withValues(alpha: 0.12) : kTextMuted.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$trend ${lang.tr("home_trend_title")}',
                  style: TextStyle(
                    color: trend.startsWith('+') ? kSuccess : kTextMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$score', style: const TextStyle(color: kTextPrimary, fontSize: 48, fontWeight: FontWeight.w900)),
              const Text('/100', style: TextStyle(color: kTextMuted, fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: kAccent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kAccent.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(color: kAccent, fontSize: 12, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.psychology, color: kAccent, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: score == 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang.tr('score_empty_title'),
                            style: const TextStyle(color: kTextPrimary, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lang.tr('score_empty_body'),
                            style: const TextStyle(color: kTextMuted, fontSize: 12.5, height: 1.4),
                          ),
                        ],
                      )
                    : Text(
                        insight,
                        style: const TextStyle(color: kTextMuted, fontSize: 12.5, height: 1.4),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReliabilityCard(TaskViewModel vm, LanguageProvider lang) {
    final made = vm.promisesMadeCount;
    final kept = vm.promisesKeptCount;
    final rel = vm.reliabilityScore;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lang.tr('weekly_success_rate').toUpperCase(),
                style: const TextStyle(color: kTextMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.bold),
              ),
              Text(
                '${rel.toStringAsFixed(1)}% Reliability',
                style: TextStyle(
                  color: rel >= 70 ? kSuccess : (rel >= 40 ? kWarning : kDanger),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: rel / 100,
              minHeight: 8,
              backgroundColor: kDivider,
              valueColor: AlwaysStoppedAnimation<Color>(
                rel >= 70 ? kSuccess : (rel >= 40 ? kWarning : kDanger),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _progressMiniStat(
                  made.toString(),
                  'Promises Made',
                  kAccentLight,
                ),
              ),
              Container(width: 1, height: 28, color: kDivider),
              Expanded(
                child: _progressMiniStat(
                  kept.toString(),
                  'Promises Kept',
                  kSuccess,
                ),
              ),
              Container(width: 1, height: 28, color: kDivider),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${(made - kept).clamp(0, 99999)}',
                      style: const TextStyle(color: kDanger, fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    const Text('Broken', style: TextStyle(color: kTextMuted, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.shield_outlined, color: kAccent, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  rel >= 70
                      ? 'Your reliability indicates high self-trust. You keep the promises you make.'
                      : 'Every broken promise damages self-trust. Focus on completing what you plan.',
                  style: const TextStyle(color: kTextMuted, fontSize: 11.5, height: 1.3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityCard(TaskViewModel vm, LanguageProvider lang) {
    final currentLevel = vm.currentLevel;
    final nextLevelNum = currentLevel.level < 20 ? currentLevel.level + 1 : 20;
    final nextLevel = IdentityLevelRegistry.getLevel(nextLevelNum);
    final isMax = currentLevel.level == 20;

    List<Widget> reqWidgets = [];
    if (!isMax) {
      Widget buildCheckItem(String label, bool met) {
        return Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            children: [
              Icon(
                met ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                size: 14,
                color: met ? kSuccess : kTextMuted,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: met ? kTextPrimary : kTextMuted,
                  fontSize: 12,
                  decoration: met ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ],
          ),
        );
      }

      final double bestDiscipline = vm.personalRecords['best_discipline_score'] ?? 0.0;
      switch (nextLevel.level) {
        case 2:
          reqWidgets.add(buildCheckItem('Log ${vm.reflectionsLoggedCount}/3 Reflections', vm.reflectionsLoggedCount >= 3));
          break;
        case 3:
          reqWidgets.add(buildCheckItem('Keep ${vm.promisesKeptCount}/5 Promises', vm.promisesKeptCount >= 5));
          break;
        case 4:
          reqWidgets.add(buildCheckItem('Log ${vm.reflectionsLoggedCount}/5 Reflections', vm.reflectionsLoggedCount >= 5));
          reqWidgets.add(buildCheckItem('Reach ${vm.reliabilityScore.toStringAsFixed(1)}%/40.0% Reliability', vm.reliabilityScore >= 40.0));
          break;
        case 5:
          reqWidgets.add(buildCheckItem('Keep ${vm.promisesKeptCount}/10 Promises', vm.promisesKeptCount >= 10));
          reqWidgets.add(buildCheckItem('Log ${vm.reflectionsLoggedCount}/7 Reflections', vm.reflectionsLoggedCount >= 7));
          break;
        case 6:
          reqWidgets.add(buildCheckItem('Keep ${vm.promisesKeptCount}/15 Promises', vm.promisesKeptCount >= 15));
          reqWidgets.add(buildCheckItem('Reach ${vm.reliabilityScore.toStringAsFixed(1)}%/45.0% Reliability', vm.reliabilityScore >= 45.0));
          break;
        case 7:
          reqWidgets.add(buildCheckItem('Keep ${vm.promisesKeptCount}/25 Promises', vm.promisesKeptCount >= 25));
          break;
        case 8:
          reqWidgets.add(buildCheckItem('Keep ${vm.promisesKeptCount}/35 Promises', vm.promisesKeptCount >= 35));
          reqWidgets.add(buildCheckItem('Reach ${vm.reliabilityScore.toStringAsFixed(1)}%/50.0% Reliability', vm.reliabilityScore >= 50.0));
          break;
        case 9:
          reqWidgets.add(buildCheckItem('Log ${vm.reflectionsLoggedCount}/15 Reflections', vm.reflectionsLoggedCount >= 15));
          break;
        case 10:
          reqWidgets.add(buildCheckItem('Keep ${vm.promisesKeptCount}/45 Promises', vm.promisesKeptCount >= 45));
          reqWidgets.add(buildCheckItem('Reach ${vm.reliabilityScore.toStringAsFixed(1)}%/55.0% Reliability', vm.reliabilityScore >= 55.0));
          break;
        case 11:
          reqWidgets.add(buildCheckItem('Keep ${vm.promisesKeptCount}/60 Promises', vm.promisesKeptCount >= 60));
          reqWidgets.add(buildCheckItem('Log ${vm.reflectionsLoggedCount}/20 Reflections', vm.reflectionsLoggedCount >= 20));
          break;
        case 12:
          reqWidgets.add(buildCheckItem('Log ${vm.reflectionsLoggedCount}/30 Reflections', vm.reflectionsLoggedCount >= 30));
          break;
        case 13:
          reqWidgets.add(buildCheckItem('Keep ${vm.promisesKeptCount}/80 Promises', vm.promisesKeptCount >= 80));
          reqWidgets.add(buildCheckItem('Reach ${vm.reliabilityScore.toStringAsFixed(1)}%/60.0% Reliability', vm.reliabilityScore >= 60.0));
          break;
        case 14:
          reqWidgets.add(buildCheckItem('Keep ${vm.promisesKeptCount}/100 Promises', vm.promisesKeptCount >= 100));
          reqWidgets.add(buildCheckItem('Best Discipline Score ${bestDiscipline.toStringAsFixed(1)}/65.0', bestDiscipline >= 65.0));
          break;
        case 15:
          reqWidgets.add(buildCheckItem('Keep ${vm.promisesKeptCount}/125 Promises', vm.promisesKeptCount >= 125));
          reqWidgets.add(buildCheckItem('Log ${vm.reflectionsLoggedCount}/40 Reflections', vm.reflectionsLoggedCount >= 40));
          break;
        case 16:
          reqWidgets.add(buildCheckItem('Keep ${vm.promisesKeptCount}/150 Promises', vm.promisesKeptCount >= 150));
          reqWidgets.add(buildCheckItem('Reach ${vm.reliabilityScore.toStringAsFixed(1)}%/70.0% Reliability', vm.reliabilityScore >= 70.0));
          break;
        case 17:
          reqWidgets.add(buildCheckItem('Reach ${vm.reliabilityScore.toStringAsFixed(1)}%/75.0% Reliability', vm.reliabilityScore >= 75.0));
          reqWidgets.add(buildCheckItem('Keep ${vm.promisesKeptCount}/175 Promises', vm.promisesKeptCount >= 175));
          break;
        case 18:
          reqWidgets.add(buildCheckItem('Keep ${vm.promisesKeptCount}/200 Promises', vm.promisesKeptCount >= 200));
          reqWidgets.add(buildCheckItem('Best Discipline Score ${bestDiscipline.toStringAsFixed(1)}/75.0', bestDiscipline >= 75.0));
          break;
        case 19:
          reqWidgets.add(buildCheckItem('Log ${vm.reflectionsLoggedCount}/60 Reflections', vm.reflectionsLoggedCount >= 60));
          reqWidgets.add(buildCheckItem('Keep ${vm.promisesKeptCount}/225 Promises', vm.promisesKeptCount >= 225));
          break;
        case 20:
          reqWidgets.add(buildCheckItem('Keep ${vm.promisesKeptCount}/250 Promises', vm.promisesKeptCount >= 250));
          reqWidgets.add(buildCheckItem('Reach ${vm.reliabilityScore.toStringAsFixed(1)}%/80.0% Reliability', vm.reliabilityScore >= 80.0));
          reqWidgets.add(buildCheckItem('Best Discipline Score ${bestDiscipline.toStringAsFixed(1)}/80.0', bestDiscipline >= 80.0));
          break;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_user_outlined, color: kAccent, size: 20),
              const SizedBox(width: 8),
              Text(
                'Identity Level ${currentLevel.level}/20'.toUpperCase(),
                style: const TextStyle(color: kTextMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            lang.tr(currentLevel.nameKey),
            style: const TextStyle(color: kTextPrimary, fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            lang.tr(currentLevel.descKey),
            style: const TextStyle(color: kTextMuted, fontSize: 12.5, height: 1.4),
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          if (isMax)
            const Text(
              '🏆 Maximum identity reached. You are an Unstoppable Force.',
              style: TextStyle(color: kSuccess, fontSize: 13, fontWeight: FontWeight.bold),
            )
          else ...[
            Text(
              'Next Path: ${lang.tr(nextLevel.nameKey)} (Level ${nextLevel.level})',
              style: const TextStyle(color: kTextPrimary, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            ...reqWidgets,
          ]
        ],
      ),
    );
  }

  Widget _progressMiniStat(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 16)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: kTextMuted, fontSize: 11)),
      ],
    );
  }


  Widget _buildDailyInsightCard(TaskViewModel vm, LanguageProvider lang) {
    final isHi = lang.isHinglish;

    // Calculate completed count and days of usage
    final completedCount = vm.allTasks.where((t) => t.status == 'DONE').length;
    int daysOfUsage = 0;
    if (vm.allTasks.isNotEmpty) {
      DateTime oldest = DateTime.now();
      for (final t in vm.allTasks) {
        final d = DateTime.tryParse(t.plannedDate);
        if (d != null && d.isBefore(oldest)) {
          oldest = d;
        }
      }
      daysOfUsage = DateTime.now().difference(oldest).inDays + 1;
    }

    final hasSufficientData = completedCount >= 3 || daysOfUsage >= 7;

    final String titleText;
    final String insightText;

    if (!hasSufficientData) {
      titleText = lang.tr('insight_empty_title');
      insightText = completedCount == 0
          ? lang.tr('insight_empty_body_1')
          : lang.tr('insight_empty_body_2');
    } else {
      titleText = lang.tr('home_insight_title');
      
      String realInsight = isHi
          ? "Aaj ke focus hours 8 PM se 10 PM ke beech hain. Mobile side me rakh dena."
          : "Your scheduled focus hours are between 8 PM and 10 PM. Put your phone away.";

      if (vm.failureInsights.isNotEmpty) {
        final top = vm.failureInsights.first;
        final pct = (top.percentage * 100).toInt();
        realInsight = isHi
            ? "${top.emoji} ${top.category.replaceAll('distraction', 'Distraction').replaceAll('lowEnergy', 'Thakaan').replaceAll('timeIssues', 'Time conflicts')} ki wajah se is hafte $pct% tasks complete nahi ho paye."
            : "${top.emoji} ${top.category.replaceAll('distraction', 'Distraction').replaceAll('lowEnergy', 'Low energy').replaceAll('timeIssues', 'Time conflicts')} caused $pct% of your missed tasks this week.";
      } else if (vm.todayTasks.isNotEmpty) {
        final healthTasks = vm.todayTasks.where((t) => t.lifeArea == 'health').length;
        if (healthTasks > 0) {
          realInsight = isHi
              ? "💪 Health ke tasks aap sabse consistently complete karte hain. Aaj bhi target poora karo!"
              : "💪 You complete health-related tasks more consistently. Crush your target today!";
        }
      }
      insightText = realInsight;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kDivider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, color: kWarning, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleText,
                  style: const TextStyle(color: kWarning, fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  insightText,
                  style: const TextStyle(color: kTextPrimary, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReflectionCard(BuildContext context, TaskViewModel vm, LanguageProvider lang) {
    final hasReflected = vm.hasReflectedToday;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasReflected ? kSuccess.withValues(alpha: 0.3) : kWarning.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Text(hasReflected ? '✅' : '🔔', style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang.tr('reflect_title_card'),
                  style: const TextStyle(color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  hasReflected
                      ? lang.tr('reflect_card_done')
                      : lang.tr('reflect_card_pending'),
                  style: const TextStyle(color: kTextMuted, fontSize: 12.5, height: 1.4),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => widget.onTabSelected?.call(2), // Navigate to Reflection Tab
                  child: Text(
                    hasReflected ? lang.tr('reflect_card_cta_edit') : lang.tr('reflect_card_cta_start'),
                    style: TextStyle(
                      color: hasReflected ? kSuccess : kWarning,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPlanning(BuildContext context, TaskViewModel vm, LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kDivider),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kAccent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Text('✨', style: TextStyle(fontSize: 32)),
          ),
          const SizedBox(height: 16),
          Text(
            lang.tr('tasks_empty_title'),
            style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(
            lang.tr('tasks_empty_desc'),
            style: const TextStyle(color: kTextMuted, fontSize: 12.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _showAddTaskSheet(context, vm, lang),
            icon: const Icon(Icons.add, size: 18),
            label: Text(
              lang.tr('tasks_empty_cta'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ──

  String _getWeeklyTrend(TaskViewModel vm) {
    if (vm.scoreHistory.length < 2) return "0";
    final latest = vm.scoreHistory.last.totalScore;
    final previousIndex = vm.scoreHistory.length >= 7 ? vm.scoreHistory.length - 7 : 0;
    final prev = vm.scoreHistory[previousIndex].totalScore;
    final diff = (latest - prev).toInt();
    if (diff >= 0) return "+$diff";
    return "$diff";
  }


  void _showAddTaskSheet(BuildContext context, TaskViewModel vm, LanguageProvider lang) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kCardBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: _AddTaskSheetContent(vm: vm, lang: lang),
          ),
        );
      },
    );
  }
}

// ── Supporting Add Task Sheet Widget ──

class _AddTaskSheetContent extends StatefulWidget {
  final TaskViewModel vm;
  final LanguageProvider lang;
  const _AddTaskSheetContent({required this.vm, required this.lang});

  @override
  State<_AddTaskSheetContent> createState() => _AddTaskSheetContentState();
}

class _AddTaskSheetContentState extends State<_AddTaskSheetContent> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  int _hour = 21, _minute = 0;
  double _durationHr = 2.0;
  LifeArea _selectedArea = LifeArea.general;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.lang;
    final vm = widget.vm;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(lang.tr('scheduler_add_task'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kTextPrimary)),
              IconButton(icon: const Icon(Icons.close, color: kTextMuted), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 16),
          // Title
          TextField(
            controller: _titleCtrl,
            style: const TextStyle(color: kTextPrimary),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: lang.tr('scheduler_task_title'),
              prefixIcon: const Icon(Icons.edit, color: kTextMuted, size: 18),
            ),
          ),
          const SizedBox(height: 12),
          // Description
          TextField(
            controller: _descCtrl,
            style: const TextStyle(color: kTextPrimary),
            maxLines: 2,
            decoration: InputDecoration(
              labelText: lang.tr('scheduler_details'),
              prefixIcon: const Icon(Icons.notes, color: kTextMuted, size: 18),
            ),
          ),
          const SizedBox(height: 16),
          // Life Area
          Text(lang.tr('scheduler_life_area'), style: const TextStyle(color: kTextMuted, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: LifeArea.values.map((area) {
              final isSelected = _selectedArea == area;
              return GestureDetector(
                onTap: () => setState(() => _selectedArea = area),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(area.colorValue).withValues(alpha: 0.15) : const Color(0xFF1E1E21),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? Color(area.colorValue) : kDivider,
                      width: isSelected ? 1.2 : 0.8,
                    ),
                  ),
                  child: Text(
                    '${area.emoji} ${area.label}',
                    style: TextStyle(
                      color: isSelected ? Color(area.colorValue) : kTextMuted,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          // Time picker
          Text(lang.tr('scheduler_when'), style: const TextStyle(color: kTextMuted, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _TimeStepper(label: lang.tr('hour'), value: _hour, max: 23, step: 1, onChanged: (v) => setState(() => _hour = v))),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(':', style: TextStyle(color: kTextPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              Expanded(child: _TimeStepper(label: lang.tr('minute'), value: _minute, max: 55, step: 5, onChanged: (v) => setState(() => _minute = v))),
            ],
          ),
          const SizedBox(height: 16),
          // Duration
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(lang.tr('scheduler_duration'), style: const TextStyle(color: kTextMuted, fontSize: 12, fontWeight: FontWeight.w600)),
              Text(
                _durationHr == 0.5 ? '30 ${lang.tr("mins_label")}' : '${_durationHr == _durationHr.floorToDouble() ? _durationHr.toInt() : _durationHr} ${lang.tr("hrs_label")}',
                style: const TextStyle(color: kAccent, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [0.5, 1.0, 1.5, 2.0, 3.0].map((hr) {
              final sel = _durationHr == hr;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _durationHr = hr),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: sel ? kAccent : const Color(0xFF1E1E21),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      hr == 0.5 ? '30m' : '${hr == hr.floorToDouble() ? hr.toInt() : hr}h',
                      style: TextStyle(color: sel ? Colors.white : kTextMuted, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          // Save
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _titleCtrl.text.trim().isEmpty ? null : () async {
                await vm.scheduleTask(
                  title: _titleCtrl.text.trim(),
                  description: _descCtrl.text.trim(),
                  lifeArea: _selectedArea,
                  hour: _hour,
                  minute: _minute,
                  durationHr: _durationHr,
                );
                if (context.mounted) Navigator.pop(context);
              },
              icon: const Icon(Icons.alarm_add),
              label: Text(lang.tr('scheduler_save_btn'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Time Stepper ──

class _TimeStepper extends StatelessWidget {
  final String label;
  final int value, max, step;
  final ValueChanged<int> onChanged;
  const _TimeStepper({required this.label, required this.value, required this.max, required this.step, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: kTextMuted, fontSize: 11)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(icon: const Icon(Icons.remove, color: kTextMuted, size: 18), onPressed: () => onChanged(value - step < 0 ? max : value - step)),
            Text(value.toString().padLeft(2, '0'), style: const TextStyle(color: kTextPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
            IconButton(icon: const Icon(Icons.add, color: kTextMuted, size: 18), onPressed: () => onChanged(value + step > max ? 0 : value + step)),
          ],
        ),
      ],
    );
  }
}

// ── Home Screen Task Card ──

class _HomeTaskCard extends StatelessWidget {
  final Task task;
  final TaskViewModel vm;
  const _HomeTaskCard({required this.task, required this.vm, super.key});

  @override
  Widget build(BuildContext context) {
    final areaColor = Color(task.lifeAreaEnum.colorValue);
    final isDone = task.status == 'DONE';
    final isFailed = task.status == 'NOT_DONE';

    Widget statusIcon;
    Color titleColor = kTextPrimary;
    TextDecoration? textDecoration;

    if (isDone) {
      statusIcon = const Icon(Icons.check_circle, color: kSuccess, size: 22);
      titleColor = kTextMuted;
      textDecoration = TextDecoration.lineThrough;
    } else if (isFailed) {
      statusIcon = const Icon(Icons.cancel, color: kDanger, size: 22);
      titleColor = kTextMuted;
    } else {
      statusIcon = const Icon(Icons.radio_button_unchecked, color: kTextMuted, size: 22);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kDivider),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 70,
            decoration: BoxDecoration(
              color: areaColor,
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
            ),
          ),
          const SizedBox(width: 14),
          statusIcon,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(fontWeight: FontWeight.bold, color: titleColor, decoration: textDecoration, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('${task.lifeAreaEnum.emoji} ${task.lifeAreaEnum.label}', style: TextStyle(color: areaColor, fontSize: 10.5, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 12),
                    const Icon(Icons.access_time, size: 11, color: kTextMuted),
                    const SizedBox(width: 2),
                    Text(
                      '${task.hour.toString().padLeft(2, '0')}:${task.minute.toString().padLeft(2, '0')} · ${task.durationMinutes}m',
                      style: const TextStyle(color: kTextMuted, fontSize: 10.5),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (task.status == 'PENDING') ...[
            IconButton(
              icon: const Icon(Icons.play_circle_outline, color: kSuccess, size: 26),
              onPressed: () => vm.triggerTaskAlert(task),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: kDanger, size: 20),
              onPressed: () => vm.deleteTask(task),
            ),
          ],
          if (isFailed && task.failureCategory.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: kDanger.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  FailureCategory.values.firstWhere((c) => c.name == task.failureCategory, orElse: () => FailureCategory.none).emoji,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
