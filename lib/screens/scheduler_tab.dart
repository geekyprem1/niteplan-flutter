import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/task_viewmodel.dart';
import '../data/task_model.dart';
import '../theme/app_theme.dart';
import '../l10n/language_provider.dart';

class SchedulerTab extends StatefulWidget {
  const SchedulerTab({super.key});
  @override
  State<SchedulerTab> createState() => _SchedulerTabState();
}

class _SchedulerTabState extends State<SchedulerTab> {
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
    final vm = context.watch<TaskViewModel>();
    final lang = context.watch<LanguageProvider>();
    final pending = vm.pendingTasks;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        _TopBanner(vm: vm),
        const SizedBox(height: 16),
        _buildAddTaskCard(vm, context, lang),
        const SizedBox(height: 24),
        buildSectionHeader(
          '${lang.tr("scheduler_pending_count")} (${pending.length})',
          subtitle: lang.tr('scheduler_title'),
        ),
        const SizedBox(height: 12),
        if (pending.isEmpty) _buildEmptyPlanning(lang)
        else ...pending.map((t) => _PendingTaskCard(task: t, vm: vm, key: ValueKey(t.id))),
      ],
    );
  }

  Widget _buildAddTaskCard(TaskViewModel vm, BuildContext context, LanguageProvider lang) {
    return Container(
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kDivider),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: kAccent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.add_task, color: kAccent, size: 20),
              ),
              const SizedBox(width: 10),
              Text(lang.tr('scheduler_add_task'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: kTextPrimary)),
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
          const SizedBox(height: 10),

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
                    color: isSelected ? Color(area.colorValue).withValues(alpha: 0.25) : const Color(0xFF252535),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Color(area.colorValue) : kDivider,
                      width: isSelected ? 1.5 : 1,
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
                child: Text(':', style: TextStyle(color: kTextPrimary, fontSize: 28, fontWeight: FontWeight.bold)),
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
                      color: sel ? kAccent : const Color(0xFF252535),
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
          const SizedBox(height: 20),

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
                _titleCtrl.clear();
                _descCtrl.clear();
                setState(() { _selectedArea = LifeArea.general; });
              },
              icon: const Icon(Icons.alarm_add),
              label: Text(lang.tr('scheduler_save_btn'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPlanning(LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kDivider),
      ),
      child: Column(
        children: [
          const Text('🌙', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(lang.tr('scheduler_empty_title'), style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(lang.tr('scheduler_empty_sub'), style: const TextStyle(color: kTextMuted, fontSize: 12), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _TopBanner extends StatelessWidget {
  final TaskViewModel vm;
  const _TopBanner({required this.vm});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final score = vm.currentScore?.totalScore.toInt() ?? 0;
    final label = vm.currentScore?.label ?? lang.tr('score_beginner');
    final streak = vm.currentStreak;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kAccent.withValues(alpha: 0.2), kDeepNavy.withValues(alpha: 0.5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lang.tr('score_section_label'), style: const TextStyle(color: kAccentLight, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('$score', style: const TextStyle(color: kTextPrimary, fontSize: 36, fontWeight: FontWeight.w900)),
                    Text('/${lang.tr("score_out_of").split(" ").last}', style: const TextStyle(color: kTextMuted, fontSize: 14)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: kAccent.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                      child: Text(label, style: const TextStyle(color: kAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 28)),
              Text('$streak ${lang.tr("banner_streak")}', style: const TextStyle(color: kTextMuted, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

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

class _PendingTaskCard extends StatelessWidget {
  final Task task;
  final TaskViewModel vm;
  const _PendingTaskCard({required this.task, required this.vm, super.key});

  @override
  Widget build(BuildContext context) {
    final areaColor = Color(task.lifeAreaEnum.colorValue);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kDivider),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 80,
            decoration: BoxDecoration(
              color: areaColor,
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(18)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold, color: kTextPrimary)),
                if (task.description.isNotEmpty) Text(task.description, style: const TextStyle(color: kTextMuted, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text('${task.lifeAreaEnum.emoji} ${task.lifeAreaEnum.label}', style: TextStyle(color: areaColor, fontSize: 11, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 12),
                    const Icon(Icons.access_time, size: 12, color: kTextMuted),
                    const SizedBox(width: 2),
                    Text('${task.hour.toString().padLeft(2, '0')}:${task.minute.toString().padLeft(2, '0')} · ${task.durationMinutes}m', style: const TextStyle(color: kTextMuted, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.play_circle, color: kSuccess, size: 28), onPressed: () => vm.triggerTaskAlert(task)),
          IconButton(icon: const Icon(Icons.delete_outline, color: kDanger, size: 22), onPressed: () => vm.deleteTask(task)),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
