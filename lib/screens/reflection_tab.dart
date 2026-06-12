import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/daily_reflection_model.dart';
import '../viewmodel/task_viewmodel.dart';
import '../theme/app_theme.dart';
import '../l10n/language_provider.dart';

class ReflectionTab extends StatefulWidget {
  const ReflectionTab({super.key});
  @override
  State<ReflectionTab> createState() => _ReflectionTabState();
}

class _ReflectionTabState extends State<ReflectionTab> {
  final _q1 = TextEditingController(); // went well
  final _q2 = TextEditingController(); // what failed
  final _q3 = TextEditingController(); // why failed
  final _q4 = TextEditingController(); // tomorrow improvement
  int _mood = 3;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prefill());
  }

  void _prefill() {
    final existing = context.read<TaskViewModel>().todayReflection;
    if (existing != null) {
      _q1.text = existing.wentWell;
      _q2.text = existing.whatFailed;
      _q3.text = existing.whyItFailed;
      _q4.text = existing.tomorrowImprovement;
      setState(() { _mood = existing.mood; _saved = existing.isComplete; });
    }
  }

  @override
  void dispose() {
    _q1.dispose(); _q2.dispose(); _q3.dispose(); _q4.dispose();
    super.dispose();
  }

  Future<void> _save(TaskViewModel vm) async {
    final reflection = DailyReflection(
      date: DailyReflection.todayDate(),
      wentWell: _q1.text.trim(),
      whatFailed: _q2.text.trim(),
      whyItFailed: _q3.text.trim(),
      tomorrowImprovement: _q4.text.trim(),
      mood: _mood,
    );
    await vm.saveReflection(reflection);
    setState(() => _saved = true);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();
    final lang = context.watch<LanguageProvider>();
    final todayStr = _formatDate(DateTime.now());

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        // Header
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lang.tr('reflect_section_label'), style: const TextStyle(color: kAccent, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(todayStr, style: const TextStyle(color: kTextPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            if (_saved)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: kSuccess.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: kSuccess.withValues(alpha: 0.4))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: kSuccess, size: 14),
                    const SizedBox(width: 4),
                    Text(lang.tr('reflect_saved'), style: const TextStyle(color: kSuccess, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),

        // Mood
        _buildMoodPicker(lang),
        const SizedBox(height: 20),

        // Today's quick stats
        _TodayStats(vm: vm),
        const SizedBox(height: 20),

        // Questions
        _buildQuestion(
          number: '01',
          emoji: '✅',
          question: lang.tr('reflect_q1'),
          hint: lang.tr('reflect_q1_hint'),
          controller: _q1,
          color: kSuccess,
        ),
        const SizedBox(height: 12),

        _buildQuestion(
          number: '02',
          emoji: '❌',
          question: lang.tr('reflect_q2'),
          hint: lang.tr('reflect_q2_hint'),
          controller: _q2,
          color: kDanger,
        ),
        const SizedBox(height: 12),

        _buildQuestion(
          number: '03',
          emoji: '🔍',
          question: lang.tr('reflect_q3'),
          hint: lang.tr('reflect_q3_hint'),
          controller: _q3,
          color: kWarning,
        ),
        const SizedBox(height: 12),

        _buildQuestion(
          number: '04',
          emoji: '🚀',
          question: lang.tr('reflect_q4'),
          hint: lang.tr('reflect_q4_hint'),
          controller: _q4,
          color: kAccent,
        ),
        const SizedBox(height: 24),

        // Save button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _save(vm),
            icon: const Icon(Icons.save_alt),
            label: Text(_saved ? lang.tr('reflect_update_btn') : lang.tr('reflect_save_btn'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ),
        const SizedBox(height: 32),

        // Past Reflections
        if (vm.recentReflections.isNotEmpty) ...[
          buildSectionHeader(lang.tr('reflect_past_title'), subtitle: lang.tr('reflect_past_sub')),
          const SizedBox(height: 12),
          ...vm.recentReflections.take(5).map((r) => _PastReflectionCard(reflection: r)),
        ],
      ],
    );
  }

  Widget _buildMoodPicker(LanguageProvider lang) {
    final moods = ['😞', '😕', '😐', '🙂', '😊'];
    final labels = ['Rough', 'Off', 'Okay', 'Good', 'Great'];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: kDivider)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lang.tr('reflect_mood'), style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (i) {
              final selected = _mood == i + 1;
              return GestureDetector(
                onTap: () => setState(() => _mood = i + 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? kAccent.withValues(alpha: 0.2) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: selected ? kAccent : Colors.transparent),
                  ),
                  child: Column(
                    children: [
                      Text(moods[i], style: TextStyle(fontSize: selected ? 28 : 22)),
                      Text(labels[i], style: TextStyle(color: selected ? kAccent : kTextMuted, fontSize: 10)),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion({
    required String number,
    required String emoji,
    required String question,
    required String hint,
    required TextEditingController controller,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(child: Text(question, style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold, fontSize: 14))),
              Text(number, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            maxLines: 3,
            style: const TextStyle(color: kTextPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: kTextMuted, fontSize: 13),
              filled: true,
              fillColor: color.withValues(alpha: 0.05),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: color.withValues(alpha: 0.2))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: color.withValues(alpha: 0.2))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: color, width: 1.5)),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    const days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    return '${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

class _TodayStats extends StatelessWidget {
  final TaskViewModel vm;
  const _TodayStats({required this.vm});

  @override
  Widget build(BuildContext context) {
    final today = vm.todayTasks;
    final done = today.where((t) => t.status == 'DONE').length;
    final failed = today.where((t) => t.status == 'NOT_DONE').length;
    final planned = today.where((t) => t.status != 'RUNNING').length;
    final accuracy = planned > 0 ? (done / planned * 100).toInt() : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kAccent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kAccent.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _mini('$planned', 'Planned', kTextMuted),
          _mini('$done', 'Done', kSuccess),
          _mini('$failed', 'Failed', kDanger),
          _mini('$accuracy%', 'Accuracy', kAccent),
        ],
      ),
    );
  }

  Widget _mini(String value, String label, Color color) => Column(
    children: [
      Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 22)),
      Text(label, style: const TextStyle(color: kTextMuted, fontSize: 10)),
    ],
  );
}

class _PastReflectionCard extends StatelessWidget {
  final DailyReflection reflection;
  const _PastReflectionCard({required this.reflection});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final moods = ['', '😞', '😕', '😐', '🙂', '😊'];
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: kDivider)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(reflection.date, style: const TextStyle(color: kAccent, fontWeight: FontWeight.bold, fontSize: 12)),
              Text(moods[reflection.mood], style: const TextStyle(fontSize: 18)),
            ],
          ),
          if (reflection.wentWell.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('✅ ${reflection.wentWell}', style: const TextStyle(color: kTextPrimary, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
          if (reflection.tomorrowImprovement.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('🚀 ${reflection.tomorrowImprovement}', style: const TextStyle(color: kTextMuted, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
          const SizedBox(height: 4),
          Text(lang.tr('reflect_tap_read'), style: const TextStyle(color: kTextMuted, fontSize: 11)),
        ],
      ),
    );
  }
}
