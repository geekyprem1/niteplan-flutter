import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/task_viewmodel.dart';
import '../data/task_model.dart';
import '../theme/app_theme.dart';

class ActiveTimerTab extends StatelessWidget {
  const ActiveTimerTab({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();
    final theme = Theme.of(context);

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Abhi Ka Focus & Tracker Board',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
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
                _PendingTasksRow(vm: vm),
              ],

              // History
              _FinishedTasksHistory(vm: vm),
            ],
          ),
        ),

        // Feedback Dialog
        if (vm.feedbackDialogTask != null)
          _FeedbackDialog(vm: vm),
      ],
    );
  }
}

// --- Running Task Card ---
class _RunningTaskCard extends StatelessWidget {
  final TaskViewModel vm;
  const _RunningTaskCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    final task = vm.runningTask!;
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.secondary,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(
              color: theme.colorScheme.primary.withValues(alpha: 0.15))),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.directions_run,
                color: theme.colorScheme.primary, size: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSecondary)),
                  if (task.description.isNotEmpty)
                    Text(task.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSecondary
                                .withValues(alpha: 0.8))),
                  const SizedBox(height: 4),
                  Text('Target Duration (Samay): ${task.durationMinutes} mins',
                      style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSecondary
                              .withValues(alpha: 0.9),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Timer Ring ---
class _TimerRing extends StatelessWidget {
  final TaskViewModel vm;
  const _TimerRing({required this.vm});

  @override
  Widget build(BuildContext context) {
    final task = vm.runningTask!;
    final totalSeconds = task.durationMinutes * 60;
    final secondsRemaining = vm.timerSecondsRemaining;
    final fraction = totalSeconds > 0
        ? (totalSeconds - secondsRemaining) / totalSeconds
        : 0.0;
    final progressPct = (fraction * 100).toInt();
    final theme = Theme.of(context);

    final hours = secondsRemaining ~/ 3600;
    final mins = (secondsRemaining % 3600) ~/ 60;
    final secs = secondsRemaining % 60;
    final timeString = hours > 0
        ? '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}'
        : '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';

    return Center(
      child: SizedBox(
        width: 230,
        height: 230,
        child: CustomPaint(
          painter: _TimerRingPainter(
            fraction: fraction.toDouble(),
            trackColor: theme.colorScheme.surfaceContainerHighest,
            progressColor: theme.colorScheme.primary,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(timeString,
                    style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1)),
                Text('$progressPct% Poora Hua',
                    style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimerRingPainter extends CustomPainter {
  final double fraction;
  final Color trackColor;
  final Color progressColor;

  _TimerRingPainter({
    required this.fraction,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 16;
    final stroke = 16.0;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    // Track
    paint.color = trackColor;
    canvas.drawCircle(center, radius, paint);

    // Progress
    paint.color = progressColor;
    final sweepAngle = 2 * math.pi * (1 - fraction);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _TimerRingPainter old) =>
      old.fraction != fraction;
}

// --- Timer Controls ---
class _TimerControls extends StatelessWidget {
  final TaskViewModel vm;
  const _TimerControls({required this.vm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          heroTag: 'pauseresume',
          onPressed: vm.togglePauseResumeTimer,
          backgroundColor: vm.timerIsRunning
              ? theme.colorScheme.secondaryContainer
              : theme.colorScheme.primary,
          foregroundColor: vm.timerIsRunning
              ? theme.colorScheme.onSecondaryContainer
              : theme.colorScheme.onPrimary,
          child: Icon(vm.timerIsRunning ? Icons.pause : Icons.play_arrow,
              size: 28),
        ),
        const SizedBox(width: 20),
        FloatingActionButton(
          heroTag: 'stop',
          mini: true,
          onPressed: vm.stopAndCompleteTaskEarly,
          backgroundColor: theme.colorScheme.errorContainer,
          foregroundColor: theme.colorScheme.onErrorContainer,
          child: const Icon(Icons.stop),
        ),
      ],
    );
  }
}

// --- Quick Complete / Not Done ---
class _QuickCompleteButtons extends StatelessWidget {
  final TaskViewModel vm;
  const _QuickCompleteButtons({required this.vm});

  @override
  Widget build(BuildContext context) {
    final task = vm.runningTask!;
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: const Text('Poora Ho Gaya!',
                style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: kGreenDone,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () =>
                vm.presentFeedbackDialogManually(task, isDone: true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.close),
            label: const Text('Nahi Ho Paya',
                style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.error,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () =>
                vm.presentFeedbackDialogManually(task, isDone: false),
          ),
        ),
      ],
    );
  }
}

// --- No Task Card ---
class _NoTaskCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.check_circle_outline,
                size: 64,
                color: theme.colorScheme.primary.withValues(alpha: 0.6)),
            const SizedBox(height: 16),
            Text('Abhi koi kaam chalu nahi hai',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
                'Niche di gayi list me se koi scheduled kaam start kar sakte hain, ya planning page par ja kar naya schedule karein.',
                style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// --- Pending tasks horizontal row ---
class _PendingTasksRow extends StatelessWidget {
  final TaskViewModel vm;
  const _PendingTasksRow({required this.vm});

  @override
  Widget build(BuildContext context) {
    final pending =
        vm.allTasks.where((t) => t.status == 'PENDING').toList();
    if (pending.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pehle Se Scheduled Kaam Shuru Karein',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: pending.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final task = pending[i];
              return GestureDetector(
                onTap: () => vm.triggerTaskAlert(task),
                child: SizedBox(
                  width: 200,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(task.title,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          Text(
                              'Scheduled: ${task.hour.toString().padLeft(2, '0')}:${task.minute.toString().padLeft(2, '0')}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6))),
                          Text('Duration: ${task.durationMinutes} mins',
                              style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Shuru Karein',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold)),
                              Icon(Icons.play_arrow,
                                  color: theme.colorScheme.primary, size: 16),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// --- Finished tasks history ---
class _FinishedTasksHistory extends StatelessWidget {
  final TaskViewModel vm;
  const _FinishedTasksHistory({required this.vm});

  @override
  Widget build(BuildContext context) {
    final finished = vm.allTasks
        .where((t) => t.status == 'DONE' || t.status == 'NOT_DONE')
        .toList();
    if (finished.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 4),
        Text('Aaj Ki Performance Reports & Logs',
            style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary)),
        const SizedBox(height: 12),
        ...finished.map((t) => _HistoryCard(task: t)),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Task task;
  const _HistoryCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final isSuccess = task.status == 'DONE';
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: isSuccess
          ? kGreenDone.withValues(alpha: 0.08)
          : theme.colorScheme.errorContainer.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
              color: isSuccess
                  ? kGreenDone.withValues(alpha: 0.25)
                  : theme.colorScheme.error.withValues(alpha: 0.2))),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor:
                  isSuccess ? kGreenDone : theme.colorScheme.error,
              child: Icon(isSuccess ? Icons.check : Icons.close,
                  color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(task.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isSuccess
                                    ? kGreenDark
                                    : theme.colorScheme.error)),
                      ),
                      Text('${task.durationMinutes} mins',
                          style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6))),
                    ],
                  ),
                  if (task.reason.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    RichText(
                        text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Vajah: ',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isSuccess
                                    ? kGreenDark
                                    : theme.colorScheme.error)),
                        TextSpan(
                            text: task.reason,
                            style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6))),
                      ],
                    )),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Feedback Dialog ---
class _FeedbackDialog extends StatefulWidget {
  final TaskViewModel vm;
  const _FeedbackDialog({required this.vm});

  @override
  State<_FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<_FeedbackDialog> {
  late bool _isDone;
  String _reason = '';

  @override
  void initState() {
    super.initState();
    _isDone = widget.vm.feedbackDefaultIsDone;
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.vm;
    final task = vm.feedbackDialogTask!;
    final theme = Theme.of(context);
    final suggestions =
        _isDone ? vm.successReasonsSuggestion : vm.failureReasonsSuggestion;

    return Material(
      color: Colors.black54,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kaam Ka Report & Feedback',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text("Kaam: '${task.title}'",
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Kya yeh kaam poora ho gaya?',
                      style: theme.textTheme.bodySmall),
                  const SizedBox(height: 12),

                  // Done / Not Done toggle
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.check),
                          label: const Text('Haan, Ho Gaya',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _isDone ? kGreenDone : theme.colorScheme.surfaceContainerHighest,
                            foregroundColor: _isDone
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                          ),
                          onPressed: () =>
                              setState(() {
                                _isDone = true;
                                _reason = '';
                              }),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.close),
                          label: const Text('Nahi Hua',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !_isDone
                                ? theme.colorScheme.error
                                : theme.colorScheme.surfaceContainerHighest,
                            foregroundColor: !_isDone
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                          ),
                          onPressed: () =>
                              setState(() {
                                _isDone = false;
                                _reason = '';
                              }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Reason chips
                  Text(
                      _isDone
                          ? 'Kaise poora hua? (Vajah chunein)'
                          : 'Kyun nahi ho paya? (Vajah chunein)',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: suggestions.map((s) {
                      final cleaned = s.contains(' (') ? s.substring(0, s.indexOf(' (')) : s;
                      final isSelected = _reason == cleaned;
                      return GestureDetector(
                        onTap: () => setState(() => _reason = cleaned),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (_isDone ? kGreenDark : const Color(0xFFC62828))
                                : theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : theme.colorScheme.outline
                                        .withValues(alpha: 0.5)),
                          ),
                          child: Text(s,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: isSelected
                                      ? Colors.white
                                      : theme.colorScheme.onSurface
                                          .withValues(alpha: 0.7))),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),

                  // Custom reason text
                  TextField(
                    onChanged: (v) => setState(() => _reason = v),
                    decoration: InputDecoration(
                      labelText: 'Apna khud ka vajah likhein',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: vm.cancelFeedbackDialog,
                          child: const Text('Radd Karein')),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white),
                        onPressed: () async {
                          final finalReason = _reason.isEmpty
                              ? (_isDone
                                  ? 'Completed successfully'
                                  : 'Could not finish')
                              : _reason;
                          await vm.submitTaskFeedback(
                              task, _isDone, finalReason);
                        },
                        child: const Text('Log Save Karein',
                            style:
                                TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
