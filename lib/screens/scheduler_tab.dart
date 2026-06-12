import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/task_viewmodel.dart';
import '../data/task_model.dart';
import '../theme/app_theme.dart';
import '../l10n/language_provider.dart';
import 'weekly_review_screen.dart';

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

    // Calculate progress stats
    final totalPlanned = todayTasks.length;
    final totalCompleted = todayTasks.where((t) => t.status == 'DONE').toList().length;
    final totalRemaining = todayTasks.where((t) => t.status == 'PENDING' || t.status == 'RUNNING').toList().length;
    final progressRatio = totalPlanned > 0 ? totalCompleted / totalPlanned : 0.0;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        // 1. Hero Card (Discipline Score + Behavioral Insight)
        _buildHeroCard(vm, lang),
        const SizedBox(height: 16),

        // 2. Today's Progress Card
        _buildProgressCard(totalPlanned, totalCompleted, totalRemaining, progressRatio, lang),
        const SizedBox(height: 16),

        // 3. Daily Insight Card
        _buildDailyInsightCard(vm, lang),
        const SizedBox(height: 16),

        // 4. Quick Actions Row
        _buildQuickActionsRow(context, vm, lang),
        const SizedBox(height: 24),

        // 5. Reflection Reminder (conditional)
        if (!vm.hasReflectedToday) ...[
          _buildReflectionReminder(lang),
          const SizedBox(height: 24),
        ],

        // 6. Today's Tasks header
        buildSectionHeader(
          lang.tr('home_tasks_title'),
          subtitle: '${lang.tr('scheduler_pending_count')} (${todayTasks.length})',
        ),
        const SizedBox(height: 12),

        // 7. Today's Tasks List
        if (todayTasks.isEmpty)
          _buildEmptyPlanning(context, vm, lang)
        else
          ...todayTasks.map((t) => _HomeTaskCard(task: t, vm: vm, key: ValueKey(t.id))),
      ],
    );
  }

  // ── Dashboard Component Builders ──

  Widget _buildHeroCard(TaskViewModel vm, LanguageProvider lang) {
    final score = vm.currentScore?.totalScore.toInt() ?? 0;
    final label = score == 0
        ? lang.tr('score_empty_level')
        : (vm.currentScore?.label ?? lang.tr('score_beginner'));
    final trend = _getWeeklyTrend(vm);
    final insight = _getMotivationalInsight(vm, lang);

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

  Widget _buildProgressCard(int planned, int completed, int remaining, double ratio, LanguageProvider lang) {
    final isEmpty = planned == 0;

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
                lang.tr('home_progress_title'),
                style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                isEmpty ? lang.tr('progress_empty_label') : '$completed/$planned completed',
                style: TextStyle(color: isEmpty ? kAccent : kSuccess, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isEmpty)
            Text(
              lang.tr('progress_empty_body'),
              style: const TextStyle(color: kTextMuted, fontSize: 12.5, height: 1.4),
            )
          else ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 6,
                backgroundColor: kDivider,
                valueColor: const AlwaysStoppedAnimation<Color>(kSuccess),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _progressMiniStat(planned.toString(), lang.tr('home_planned'), kAccentLight)),
                Container(width: 1, height: 24, color: kDivider),
                Expanded(child: _progressMiniStat(completed.toString(), lang.tr('home_completed'), kSuccess)),
                Container(width: 1, height: 24, color: kDivider),
                Expanded(child: _progressMiniStat(remaining.toString(), lang.tr('home_remaining'), kTextMuted)),
              ],
            ),
          ],
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

  Widget _buildQuickActionsRow(BuildContext context, TaskViewModel vm, LanguageProvider lang) {
    return Row(
      children: [
        // 1. Primary Action: New Task (Indigo solid background + white text/icon + shadow)
        Expanded(
          child: GestureDetector(
            onTap: () => _showAddTaskSheet(context, vm, lang),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: kAccent,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: kAccent.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.add_circle, color: Colors.white, size: 20),
                  const SizedBox(height: 6),
                  Text(
                    lang.tr('home_action_new'),
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // 2. Secondary Action: Reflection (Slate bg + amber border/icon + primary text)
        Expanded(
          child: GestureDetector(
            onTap: () => widget.onTabSelected?.call(2),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: kCardBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kWarning.withValues(alpha: 0.4), width: 1.2),
              ),
              child: Column(
                children: [
                  const Icon(Icons.nights_stay, color: kWarning, size: 20),
                  const SizedBox(height: 6),
                  Text(
                    lang.tr('home_action_reflect'),
                    style: const TextStyle(color: kTextPrimary, fontSize: 11, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // 3. Tertiary Action: Weekly Review (Semi-transparent bg + muted border + muted text)
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WeeklyReviewScreen()),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: kCardBg.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kDivider.withValues(alpha: 0.5)),
              ),
              child: Column(
                children: [
                  Icon(Icons.assignment_outlined, color: kSuccess.withValues(alpha: 0.6), size: 20),
                  const SizedBox(height: 6),
                  Text(
                    lang.tr('home_action_weekly'),
                    style: const TextStyle(color: kTextMuted, fontSize: 11, fontWeight: FontWeight.normal),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReflectionReminder(LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kWarning.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kWarning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Text('🔔', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang.tr('home_reflect_reminder'),
                  style: const TextStyle(color: kTextPrimary, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => widget.onTabSelected?.call(2),
                  child: Text(
                    lang.tr('home_reflect_cta'),
                    style: const TextStyle(color: kWarning, fontSize: 12, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
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

  String _getMotivationalInsight(TaskViewModel vm, LanguageProvider lang) {
    final isHi = lang.isHinglish;

    // 1. Gather all completed/history metrics
    final completedCount = vm.allTasks.where((t) => t.status == 'DONE').length;
    
    final activeStats = List<LifeAreaStat>.from(vm.lifeAreaStats)
      ..sort((a, b) => b.completed.compareTo(a.completed));
    final strongest = activeStats.isNotEmpty && activeStats.first.completed > 0
        ? activeStats.first
        : null;

    final trendStr = _getWeeklyTrend(vm);
    final isImproving = trendStr.startsWith('+') && trendStr != '+0';

    // 2. Build list of applicable motivational insights
    final List<String> availableInsights = [];
    if (isImproving) {
      availableInsights.add(lang.tr('score_insight_consistency'));
    }
    if (strongest != null) {
      availableInsights.add(
        lang.tr('score_insight_strongest_prefix') +
        lang.tr('area_${strongest.area.name}') +
        lang.tr('score_insight_strongest_suffix')
      );
    }
    if (completedCount > 0) {
      availableInsights.add(
        lang.tr('score_insight_milestone_prefix') +
        '$completedCount' +
        lang.tr('score_insight_milestone_suffix')
      );
    }

    // 3. Return a dynamic message if there's sufficient user history/milestone data
    if (availableInsights.isNotEmpty) {
      final day = DateTime.now().day;
      return availableInsights[day % availableInsights.length];
    }

    // 4. Fallback to failure insights or general messaging
    if (vm.failureInsights.isNotEmpty) {
      final top = vm.failureInsights.first;
      final categoryName = top.category.toLowerCase();
      if (categoryName.contains('distract')) {
        return isHi
            ? "Phone scrolling ki wajah se tasks miss ho rahe hain. DND mode use karo!"
            : "Phone scrolling is causing missed tasks. Try using Do-Not-Disturb mode.";
      } else if (categoryName.contains('energy') || categoryName.contains('lowenergy')) {
        return isHi
            ? "Thakaan ke karan kaam ruk rahe hain. Raat 9 PM ke baad simple tasks hi rakho."
            : "Fatigue is leading to missed tasks. Keep plans light and simple after 9 PM.";
      } else if (categoryName.contains('time') || categoryName.contains('timeissues')) {
        return isHi
            ? "Time management issues detected. Do tasks ke beech me buffers badhao."
            : "Time issues detected. Increase buffers between consecutive tasks.";
      } else if (categoryName.contains('planning') || categoryName.contains('poorplanning')) {
        return isHi
            ? "Over-planning ho rahi hai. Aaj raat sirf 2-3 essential tasks hi schedule karo."
            : "Over-planning detected. Schedule only 2-3 essential tasks for tonight.";
      }
    }

    return isHi
        ? "Great momentum! Aaj raat ke tasks time pe start karke consistency maintain rakho."
        : "Great momentum! Start tonight's tasks on time to maintain your consistency.";
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
