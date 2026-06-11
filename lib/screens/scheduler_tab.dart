import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/task_viewmodel.dart';
import '../data/task_model.dart';
import '../theme/app_theme.dart';

class SchedulerTab extends StatefulWidget {
  const SchedulerTab({super.key});

  @override
  State<SchedulerTab> createState() => _SchedulerTabState();
}

class _SchedulerTabState extends State<SchedulerTab> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  int _schedHour = 21;
  int _schedMinute = 0;
  double _durationHr = 2.0;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();
    final pendingTasks =
        vm.allTasks.where((t) => t.status == 'PENDING').toList();
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Motivation Card
        _MotivationCard(vm: vm),
        const SizedBox(height: 20),

        // Header Card
        Card(
          color: theme.colorScheme.secondary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primary,
                  child: Icon(Icons.bedtime,
                      color: theme.colorScheme.onPrimary),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Raat Ka Planning Desk',
                        style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSecondary)),
                    Text('Likhein aur schedule karein',
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSecondary
                                .withValues(alpha: 0.8))),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Add Task Card
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Naya Kaam Jo Schedule Karna Hai',
                    style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary)),
                const SizedBox(height: 16),

                // Title
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Kya kaam karna hai? (Title)',
                    prefixIcon: const Icon(Icons.assignment),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                TextField(
                  controller: _descController,
                  decoration: InputDecoration(
                    labelText: 'Kaam ka details bharo',
                    prefixIcon: const Icon(Icons.notes),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                Text('Timing aur Schedule Time',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),

                // Time Picker Row
                Row(
                  children: [
                    Expanded(
                      child: _TimeDialStepper(
                        label: 'Hour (Ghenta)',
                        value: _schedHour,
                        max: 23,
                        step: 1,
                        onChanged: (v) => setState(() => _schedHour = v),
                      ),
                    ),
                    Text(':',
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    Expanded(
                      child: _TimeDialStepper(
                        label: 'Minute',
                        value: _schedMinute,
                        max: 55,
                        step: 5,
                        onChanged: (v) => setState(() => _schedMinute = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Duration
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Kaam ka samay (Duration):',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Text(
                        _durationHr == _durationHr.roundToDouble()
                            ? '${_durationHr.toInt()} Hours'
                            : '$_durationHr Hours',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [0.5, 1.0, 1.5, 2.0, 3.0].map((hr) {
                    final isSelected = _durationHr == hr;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _durationHr = hr),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            hr == 0.5
                                ? '30m'
                                : '${hr == hr.roundToDouble() ? hr.toInt() : hr}h',
                            style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _titleController.text.trim().isEmpty
                        ? null
                        : () async {
                            await vm.scheduleTask(
                              title: _titleController.text.trim(),
                              description: _descController.text.trim(),
                              hour: _schedHour,
                              minute: _schedMinute,
                              durationHr: _durationHr,
                            );
                            _titleController.clear();
                            _descController.clear();
                          },
                    icon: const Icon(Icons.alarm_add),
                    label: const Text('Schedule Karein',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Upcoming Tasks
        Text('Upcoming Scheduled Tasks (${pendingTasks.length})',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        if (pendingTasks.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Icon(Icons.timer_outlined,
                      size: 54,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
                  const SizedBox(height: 8),
                  Text('Koi scheduled kaam nahi hai',
                      style: theme.textTheme.bodyMedium),
                  Text('Upar se aaj raat ke liye naya kaam schedule karein!',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5)),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ),

        ...pendingTasks.map((task) => _PendingTaskCard(task: task, vm: vm)),
      ],
    );
  }
}

class _MotivationCard extends StatefulWidget {
  final TaskViewModel vm;
  const _MotivationCard({required this.vm});

  @override
  State<_MotivationCard> createState() => _MotivationCardState();
}

class _MotivationCardState extends State<_MotivationCard> {
  bool _isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: widget.vm.motivationText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
              color: theme.colorScheme.primary.withValues(alpha: 0.25))),
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.15),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.star,
                        color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text('MERA AAJ KA MOTIVATION',
                        style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                            letterSpacing: 1)),
                  ],
                ),
                IconButton(
                  icon: Icon(_isEditing ? Icons.check : Icons.edit,
                      size: 18,
                      color: _isEditing
                          ? kGreenDone
                          : theme.colorScheme.primary),
                  onPressed: () async {
                    if (_isEditing) {
                      await vm.saveMotivationText(_controller.text);
                    }
                    setState(() => _isEditing = !_isEditing);
                  },
                ),
              ],
            ),
            if (_isEditing)
              TextField(
                controller: _controller,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Apna motivation quote ya focus point likhein...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              )
            else
              GestureDetector(
                onTap: () => setState(() => _isEditing = true),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    vm.motivationText.isEmpty
                        ? 'Apna aaj ka motivational quote likhne ke liye edit karein...'
                        : '"${vm.motivationText}"',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontStyle: vm.motivationText.isEmpty
                          ? FontStyle.italic
                          : FontStyle.normal,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.85),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TimeDialStepper extends StatelessWidget {
  final String label;
  final int value;
  final int max;
  final int step;
  final ValueChanged<int> onChanged;

  const _TimeDialStepper({
    required this.label,
    required this.value,
    required this.max,
    required this.step,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: Theme.of(context).textTheme.labelSmall),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () =>
                  onChanged(value - step < 0 ? max : value - step),
            ),
            Text(value.toString().padLeft(2, '0'),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () =>
                  onChanged(value + step > max ? 0 : value + step),
            ),
          ],
        ),
      ],
    );
  }
}

class _PendingTaskCard extends StatelessWidget {
  final Task task;
  final TaskViewModel vm;

  const _PendingTaskCard({required this.task, required this.vm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.3))),
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  if (task.description.isNotEmpty)
                    Text(task.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 14, color: theme.colorScheme.primary),
                      const SizedBox(width: 4),
                      Text(
                          '${task.hour.toString().padLeft(2, '0')}:${task.minute.toString().padLeft(2, '0')}',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 12),
                      Icon(Icons.hourglass_empty,
                          size: 14,
                          color: theme.colorScheme.secondary
                              .withValues(alpha: 0.8)),
                      const SizedBox(width: 4),
                      Text('${task.durationMinutes} mins',
                          style: theme.textTheme.bodySmall),
                    ],
                  )
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.play_arrow,
                  color: theme.colorScheme.primary),
              onPressed: () => vm.triggerTaskAlert(task),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: theme.colorScheme.error),
              onPressed: () => vm.deleteTask(task),
            ),
          ],
        ),
      ),
    );
  }
}
