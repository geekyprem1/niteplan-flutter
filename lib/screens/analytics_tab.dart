import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/task_viewmodel.dart';
import '../data/task_model.dart';
import '../theme/app_theme.dart';

class AnalyticsTab extends StatefulWidget {
  const AnalyticsTab({super.key});

  @override
  State<AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends State<AnalyticsTab> {
  bool _showCompletedDialog = false;
  bool _showFailedDialog = false;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();
    final analytics = vm.analyticsData;
    final theme = Theme.of(context);

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pragati & Analytics (Performance Report)',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // Summary stats row
              Row(
                children: [
                  _StatCard(
                    label: 'Success Rate',
                    value: '${analytics.completionRatePercentage}%',
                    color: theme.colorScheme.primary,
                    bgColor: theme.colorScheme.primaryContainer
                        .withValues(alpha: 0.15),
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    label: 'Completed',
                    value: '${analytics.completedCount}',
                    color: kGreenDone,
                    bgColor: kGreenDone.withValues(alpha: 0.12),
                    onTap: () => setState(() => _showCompletedDialog = true),
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    label: 'Nahi Hua',
                    value: '${analytics.failedCount}',
                    color: theme.colorScheme.error,
                    bgColor: theme.colorScheme.errorContainer
                        .withValues(alpha: 0.15),
                    onTap: () => setState(() => _showFailedDialog = true),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Bar Chart
              Container(
                decoration: BoxDecoration(
                    color: const Color(0xFF1C1B1F),
                    borderRadius: BorderRadius.circular(28)),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Last 7 Days Ki Progress',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            _Legend(color: kPrimary, label: 'Done'),
                            const SizedBox(width: 8),
                            _Legend(color: kErrorContainer, label: 'Not Done'),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    _WeeklyBarChart(dayProgresses: analytics.weeklyDayProgress),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Reasons card
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                    side: BorderSide(
                        color: theme.colorScheme.outline.withValues(alpha: 0.4))),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('🚨 Kyun Nahi Hua? (Incompletion Reasons)',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.error)),
                      const SizedBox(height: 12),
                      if (analytics.topFailureReasons.isEmpty)
                        Text(
                            'Koi incompletion logs nahi hain. Har kaam dhang se ho raha hai!',
                            style: theme.textTheme.bodySmall)
                      else
                        ...analytics.topFailureReasons
                            .take(4)
                            .map((r) => _ReasonBar(
                                reason: r.reason,
                                count: r.count,
                                maxCount: analytics.topFailureReasons
                                    .map((e) => e.count)
                                    .reduce((a, b) => a > b ? a : b),
                                color: theme.colorScheme.error)),
                      const Divider(height: 24),
                      Text('🌟 Kaise Hua? (Success Reasons)',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold, color: kGreenDone)),
                      const SizedBox(height: 12),
                      if (analytics.topSuccessReasons.isEmpty)
                        Text(
                            'Koi success logs nahi hain. Aane wale kaamo ko mark done karein reasons ke sath!',
                            style: theme.textTheme.bodySmall)
                      else
                        ...analytics.topSuccessReasons
                            .take(4)
                            .map((r) => _ReasonBar(
                                reason: r.reason,
                                count: r.count,
                                maxCount: analytics.topSuccessReasons
                                    .map((e) => e.count)
                                    .reduce((a, b) => a > b ? a : b),
                                color: kGreenDone)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Completed Dialog
        if (_showCompletedDialog)
          _TaskListDialog(
            title: 'Completed Kaam (Done Tasks)',
            titleColor: kGreenDone,
            tasks: vm.allTasks
                .where((t) => t.status == 'DONE')
                .toList()
              ..sort((a, b) =>
                  (b.completedAt > 0 ? b.completedAt : b.createdAt)
                      .compareTo(a.completedAt > 0 ? a.completedAt : a.createdAt)),
            cardColor: kGreenDone.withValues(alpha: 0.08),
            borderColor: kGreenDone.withValues(alpha: 0.2),
            textColor: kGreenDark,
            onClose: () => setState(() => _showCompletedDialog = false),
          ),

        // Failed Dialog
        if (_showFailedDialog)
          _TaskListDialog(
            title: 'Nahi Hua Kaam (Incomplete Tasks)',
            titleColor: Theme.of(context).colorScheme.error,
            tasks: vm.allTasks
                .where((t) => t.status == 'NOT_DONE')
                .toList()
              ..sort((a, b) =>
                  (b.completedAt > 0 ? b.completedAt : b.createdAt)
                      .compareTo(a.completedAt > 0 ? a.completedAt : a.createdAt)),
            cardColor: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1),
            borderColor: Theme.of(context).colorScheme.error.withValues(alpha: 0.2),
            textColor: Theme.of(context).colorScheme.error,
            onClose: () => setState(() => _showFailedDialog = false),
          ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Color(0xFFCAC4D0), fontSize: 9)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final Color color, bgColor;
  final VoidCallback? onTap;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: bgColor, borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(label,
                  style: TextStyle(color: color, fontSize: 11)),
              const SizedBox(height: 4),
              Text(value,
                  style: TextStyle(
                      color: color,
                      fontSize: 28,
                      fontWeight: FontWeight.w900)),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeeklyBarChart extends StatelessWidget {
  final List<DayProgress> dayProgresses;
  const _WeeklyBarChart({required this.dayProgresses});

  @override
  Widget build(BuildContext context) {
    if (dayProgresses.isEmpty) return const SizedBox(height: 100);
    final maxVal = dayProgresses
        .map((d) => d.completedCount + d.failedCount)
        .fold(3, (a, b) => a > b ? a : b);

    return SizedBox(
      height: 160,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: dayProgresses.map((day) {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (day.completedCount > 0)
                        Flexible(
                          child: FractionallySizedBox(
                            heightFactor: day.completedCount / maxVal,
                            child: Container(
                                width: 8,
                                decoration: BoxDecoration(
                                    color: kPrimary,
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(4)))),
                          ),
                        ),
                      const SizedBox(width: 3),
                      if (day.failedCount > 0)
                        Flexible(
                          child: FractionallySizedBox(
                            heightFactor: day.failedCount / maxVal,
                            child: Container(
                                width: 8,
                                decoration: BoxDecoration(
                                    color: kErrorContainer,
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(4)))),
                          ),
                        ),
                      if (day.completedCount == 0 && day.failedCount == 0)
                        Container(
                            width: 12,
                            height: 8,
                            decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4)))),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(day.dayLabel,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold)),
                Text(day.dateLabel,
                    style:
                        const TextStyle(color: Color(0xFFCAC4D0), fontSize: 8)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ReasonBar extends StatelessWidget {
  final String reason;
  final int count, maxCount;
  final Color color;

  const _ReasonBar(
      {required this.reason,
      required this.count,
      required this.maxCount,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final fraction = maxCount > 0 ? count / maxCount : 0.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(reason,
                      style: Theme.of(context).textTheme.bodySmall)),
              Text('$count task${count > 1 ? 's' : ''}',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: color)),
            ],
          ),
          const SizedBox(height: 4),
          LayoutBuilder(builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                    height: 8,
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4))),
                Container(
                    height: 8,
                    width: constraints.maxWidth * fraction,
                    decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4))),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _TaskListDialog extends StatelessWidget {
  final String title;
  final Color titleColor, cardColor, borderColor, textColor;
  final List<Task> tasks;
  final VoidCallback onClose;

  const _TaskListDialog({
    required this.title,
    required this.titleColor,
    required this.tasks,
    required this.cardColor,
    required this.borderColor,
    required this.textColor,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 360),
                  child: tasks.isEmpty
                      ? const Text('Abhi tak koi task nahi hai.')
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: tasks.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, i) {
                            final task = tasks[i];
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: borderColor)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(task.title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: textColor)),
                                  if (task.description.isNotEmpty)
                                    Text(task.description,
                                        style: const TextStyle(fontSize: 12)),
                                  Text('Duration: ${task.durationMinutes} mins',
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: textColor)),
                                  if (task.reason.isNotEmpty)
                                    Text('Reason: ${task.reason}',
                                        style: TextStyle(
                                            fontSize: 11, color: textColor)),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 12),
                TextButton(
                    onPressed: onClose,
                    child: const Text('OK',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
