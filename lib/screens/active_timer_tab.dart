import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/task_viewmodel.dart';
import '../theme/app_theme.dart';
import '../l10n/language_provider.dart';

class ActiveTimerTab extends StatelessWidget {
  const ActiveTimerTab({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();
    final lang = context.watch<LanguageProvider>();

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lang.tr('timer_section_label'), style: const TextStyle(color: kAccent, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(lang.tr('timer_title'), style: const TextStyle(color: kTextPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              if (vm.runningTask != null) ...[
                _RunningTaskCard(vm: vm),
                const SizedBox(height: 20),
                _TimerRing(vm: vm),
                const SizedBox(height: 20),
                _TimerControls(vm: vm),
                const SizedBox(height: 16),
                _QuickCompleteButtons(vm: vm),
              ] else ...[
                _NoTaskCard(),
                const SizedBox(height: 20),
                if (vm.pendingTasks.isNotEmpty) _PendingTasksRow(vm: vm),
              ],

              _FinishedTasksHistory(vm: vm),
            ],
          ),
        ),
        if (vm.feedbackDialogTask != null) _FeedbackDialog(vm: vm),
      ],
    );
  }
}

class _RunningTaskCard extends StatelessWidget {
  final TaskViewModel vm;
  const _RunningTaskCard({required this.vm});
  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final task = vm.runningTask!;
    final areaColor = Color(task.lifeAreaEnum.colorValue);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: areaColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(width: 4, height: 60, decoration: BoxDecoration(color: areaColor, borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${task.lifeAreaEnum.emoji} ${task.lifeAreaEnum.label}', style: TextStyle(color: areaColor, fontSize: 11, fontWeight: FontWeight.w600)),
              Text(task.title, style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
              Text('${task.durationMinutes} ${lang.tr('timer_target')}', style: const TextStyle(color: kTextMuted, fontSize: 12)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: kSuccess.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.circle, size: 8, color: kSuccess),
              const SizedBox(width: 4),
              Text(lang.tr('timer_live'), style: const TextStyle(color: kSuccess, fontSize: 11, fontWeight: FontWeight.bold)),
            ]),
          ),
        ],
      ),
    );
  }
}

class _TimerRing extends StatelessWidget {
  final TaskViewModel vm;
  const _TimerRing({required this.vm});
  @override
  Widget build(BuildContext context) {
    final task = vm.runningTask!;
    final total = task.durationMinutes * 60;
    final remaining = vm.timerSecondsRemaining;
    final fraction = total > 0 ? (total - remaining) / total : 0.0;
    final pct = (fraction * 100).toInt();
    final h = remaining ~/ 3600;
    final m = (remaining % 3600) ~/ 60;
    final s = remaining % 60;
    final timeStr = h > 0
        ? '${h.toString().padLeft(2,'0')}:${m.toString().padLeft(2,'0')}:${s.toString().padLeft(2,'0')}'
        : '${m.toString().padLeft(2,'0')}:${s.toString().padLeft(2,'0')}';

    return Center(
      child: SizedBox(
        width: 240, height: 240,
        child: CustomPaint(
          painter: _TimerPainter(fraction: fraction.toDouble(), color: kAccent),
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(timeStr, style: const TextStyle(color: kTextPrimary, fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: 1)),
              Text('$pct% done', style: const TextStyle(color: kAccent, fontSize: 13, fontWeight: FontWeight.bold)),
              Text(vm.timerIsRunning ? 'Running...' : 'Paused', style: TextStyle(color: vm.timerIsRunning ? kSuccess : kWarning, fontSize: 11)),
            ]),
          ),
        ),
      ),
    );
  }
}

class _TimerPainter extends CustomPainter {
  final double fraction;
  final Color color;
  _TimerPainter({required this.fraction, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    final p = Paint()..style = PaintingStyle.stroke..strokeWidth = 16..strokeCap = StrokeCap.round;
    p.color = kDivider;
    canvas.drawCircle(center, radius, p);
    p.color = color;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2, 2 * math.pi * fraction, false, p);
  }
  @override
  bool shouldRepaint(covariant _TimerPainter old) => old.fraction != fraction;
}

class _TimerControls extends StatelessWidget {
  final TaskViewModel vm;
  const _TimerControls({required this.vm});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          heroTag: 'pr',
          backgroundColor: vm.timerIsRunning ? kCardBg : kAccent,
          foregroundColor: vm.timerIsRunning ? kTextPrimary : Colors.white,
          onPressed: vm.togglePauseResumeTimer,
          child: Icon(vm.timerIsRunning ? Icons.pause : Icons.play_arrow, size: 28),
        ),
        const SizedBox(width: 20),
        FloatingActionButton.small(
          heroTag: 'stop',
          backgroundColor: kDanger.withValues(alpha: 0.15),
          foregroundColor: kDanger,
          onPressed: vm.stopAndCompleteTaskEarly,
          child: const Icon(Icons.stop),
        ),
      ],
    );
  }
}

class _QuickCompleteButtons extends StatelessWidget {
  final TaskViewModel vm;
  const _QuickCompleteButtons({required this.vm});
  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final task = vm.runningTask!;
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: Text(lang.tr('timer_done_btn'), style: const TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(backgroundColor: kSuccess, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), padding: const EdgeInsets.symmetric(vertical: 12)),
            onPressed: () => vm.presentFeedbackDialogManually(task, isDone: true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.close),
            label: Text(lang.tr('timer_fail_btn'), style: const TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(backgroundColor: kDanger.withValues(alpha: 0.15), foregroundColor: kDanger, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), padding: const EdgeInsets.symmetric(vertical: 12)),
            onPressed: () => vm.presentFeedbackDialogManually(task, isDone: false),
          ),
        ),
      ],
    );
  }
}

class _NoTaskCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(20), border: Border.all(color: kDivider)),
      child: Column(
        children: [
          const Text('🎯', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(lang.tr('timer_no_task'), style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(lang.tr('timer_no_task_sub'), style: const TextStyle(color: kTextMuted, fontSize: 13), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _PendingTasksRow extends StatelessWidget {
  final TaskViewModel vm;
  const _PendingTasksRow({required this.vm});
  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lang.tr('timer_pending_title'), style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: vm.pendingTasks.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final t = vm.pendingTasks[i];
              final color = Color(t.lifeAreaEnum.colorValue);
              return GestureDetector(
                onTap: () => vm.triggerTaskAlert(t),
                child: Container(
                  width: 180,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withValues(alpha: 0.3))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${t.lifeAreaEnum.emoji} ${t.lifeAreaEnum.label}', style: TextStyle(color: color, fontSize: 11)),
                      Text(t.title, style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text('${t.hour.toString().padLeft(2,'0')}:${t.minute.toString().padLeft(2,'0')} · ${t.durationMinutes}m', style: const TextStyle(color: kTextMuted, fontSize: 11)),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(lang.tr('timer_tap_start'), style: const TextStyle(color: kAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                          const Icon(Icons.play_arrow, color: kAccent, size: 16),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _FinishedTasksHistory extends StatelessWidget {
  final TaskViewModel vm;
  const _FinishedTasksHistory({required this.vm});
  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final finished = vm.allTasks.where((t) => t.status == 'DONE' || t.status == 'NOT_DONE').toList();
    if (finished.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Divider(color: kDivider),
        const SizedBox(height: 8),
        Text(lang.tr('timer_today_result'), style: const TextStyle(color: kTextMuted, fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 10),
        ...finished.map((t) {
          final isOk = t.status == 'DONE';
          final color = isOk ? kSuccess : kDanger;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                Icon(isOk ? Icons.check_circle : Icons.cancel, color: color, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
                      if (t.reason.isNotEmpty) Text(t.reason, style: const TextStyle(color: kTextMuted, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Text('${t.durationMinutes}m', style: const TextStyle(color: kTextMuted, fontSize: 11)),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _FeedbackDialog extends StatefulWidget {
  final TaskViewModel vm;
  const _FeedbackDialog({required this.vm});
  @override
  State<_FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<_FeedbackDialog> {
  late bool _isDone;
  String _reason = '';
  final _reasonCtrl = TextEditingController();
  @override
  void initState() { super.initState(); _isDone = widget.vm.feedbackDefaultIsDone; }
  @override
  void dispose() { _reasonCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final vm = widget.vm;
    final task = vm.feedbackDialogTask!;
    final suggestionKeys = _isDone
        ? [
            'reason_success_focused',
            'reason_success_early',
            'reason_success_easy',
            'reason_success_energy',
            'reason_success_no_distract',
          ]
        : [
            'reason_fail_distracted',
            'reason_fail_tired',
            'reason_fail_external',
            'reason_fail_planning',
            'reason_fail_motivation',
            'reason_fail_time',
          ];
    final suggestions = suggestionKeys.map((key) => lang.tr(key)).toList();

    return Material(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(24), border: Border.all(color: kDivider)),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lang.tr('feedback_title'), style: const TextStyle(color: kAccent, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(task.title, style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() { _isDone = true; _reason = ''; }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isDone ? kSuccess.withValues(alpha: 0.2) : const Color(0xFF252535),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _isDone ? kSuccess : kDivider),
                          ),
                          alignment: Alignment.center,
                          child: Text('✅ ${lang.tr('feedback_done')}', style: TextStyle(color: _isDone ? kSuccess : kTextMuted, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() { _isDone = false; _reason = ''; }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isDone ? kDanger.withValues(alpha: 0.2) : const Color(0xFF252535),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: !_isDone ? kDanger : kDivider),
                          ),
                          alignment: Alignment.center,
                          child: Text('❌ ${lang.tr('feedback_not_done')}', style: TextStyle(color: !_isDone ? kDanger : kTextMuted, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(_isDone ? lang.tr('feedback_how') : lang.tr('feedback_why'), style: const TextStyle(color: kTextMuted, fontSize: 12)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6, runSpacing: 6,
                  children: suggestions.map((s) {
                    final cleaned = s.contains(' (') ? s.substring(0, s.indexOf(' (')) : s;
                    final sel = _reason == cleaned;
                    return GestureDetector(
                      onTap: () => setState(() { _reason = cleaned; _reasonCtrl.text = cleaned; }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: sel ? (_isDone ? kSuccess.withValues(alpha: 0.2) : kDanger.withValues(alpha: 0.2)) : const Color(0xFF252535),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: sel ? (_isDone ? kSuccess : kDanger) : kDivider),
                        ),
                        child: Text(s, style: TextStyle(color: sel ? (_isDone ? kSuccess : kDanger) : kTextMuted, fontSize: 11)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _reasonCtrl,
                  style: const TextStyle(color: kTextPrimary, fontSize: 13),
                  onChanged: (v) => setState(() => _reason = v),
                  decoration: InputDecoration(labelText: lang.tr('feedback_write')),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    TextButton(
                      onPressed: vm.cancelFeedbackDialog,
                      child: Text(lang.tr('alert_later'), style: const TextStyle(color: kTextMuted)),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        final finalReason = _reason.isEmpty ? (_isDone ? 'Completed' : 'Could not finish') : _reason;
                        await vm.submitTaskFeedback(task, _isDone, finalReason);
                      },
                      child: Text(lang.tr('feedback_save'), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
