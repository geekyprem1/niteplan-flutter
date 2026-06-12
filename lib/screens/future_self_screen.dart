import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/future_self_letter_model.dart';
import '../viewmodel/task_viewmodel.dart';
import '../theme/app_theme.dart';
import '../l10n/language_provider.dart';
import '../l10n/language_provider.dart';

class FutureSelfScreen extends StatefulWidget {
  const FutureSelfScreen({super.key});
  @override
  State<FutureSelfScreen> createState() => _FutureSelfScreenState();
}

class _FutureSelfScreenState extends State<FutureSelfScreen> {
  bool _showForm = false;
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  int _unlockDays = 30;

  @override
  void dispose() { _titleCtrl.dispose(); _contentCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();
    final lang = context.watch<LanguageProvider>();
    final letters = vm.letters;
    final unlocked = letters.where((l) => l.isUnlocked).toList();
    final locked = letters.where((l) => !l.isUnlocked).toList();

    return Scaffold(
      backgroundColor: kSurface,
      appBar: AppBar(
        title: Text(lang.tr('letter_screen_title')),
        backgroundColor: kSurface,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 18), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            icon: Icon(_showForm ? Icons.close : Icons.add, color: kAccent),
            onPressed: () => setState(() => _showForm = !_showForm),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Intro
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kAccent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kAccent.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lang.tr('letter_intro_title'), style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(lang.tr('letter_intro_sub'), style: const TextStyle(color: kTextMuted, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Write Form
          if (_showForm) ...[
            _buildWriteForm(vm, lang),
            const SizedBox(height: 20),
          ],

          // Unlocked Letters
          if (unlocked.isNotEmpty) ...[
            Text(lang.tr('letter_unlocked_section'), style: const TextStyle(color: kSuccess, fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 10),
            ...unlocked.map((l) => _LetterCard(letter: l, vm: vm, isUnlocked: true)),
            const SizedBox(height: 20),
          ],

          // Locked Letters
          if (locked.isNotEmpty) ...[
            Text(lang.tr('letter_locked_section'), style: const TextStyle(color: kTextMuted, fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 10),
            ...locked.map((l) => _LetterCard(letter: l, vm: vm, isUnlocked: false)),
          ],

          if (letters.isEmpty && !_showForm)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    const Text('✉️', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    Text(lang.tr('letter_empty_title'), style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold)),
                    Text(lang.tr('letter_empty_sub'), style: const TextStyle(color: kTextMuted, fontSize: 13)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWriteForm(TaskViewModel vm, LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kCardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: kAccent.withValues(alpha: 0.3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lang.tr('letter_new_title'), style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 14),
          TextField(
            controller: _titleCtrl,
            style: const TextStyle(color: kTextPrimary),
            decoration: InputDecoration(labelText: lang.tr('letter_title_field'), prefixIcon: const Icon(Icons.title, color: kTextMuted, size: 18)),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _contentCtrl,
            maxLines: 6,
            style: const TextStyle(color: kTextPrimary, fontSize: 14),
            decoration: InputDecoration(
              labelText: lang.tr('letter_content_field'),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 14),
          Text(lang.tr('letter_unlock_when'), style: const TextStyle(color: kTextMuted, fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            children: [30, 90, 180].map((days) {
              final sel = _unlockDays == days;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _unlockDays = days),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: sel ? kAccent : const Color(0xFF252535),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text('$days', style: TextStyle(color: sel ? Colors.white : kTextMuted, fontWeight: FontWeight.bold, fontSize: 18)),
                        Text(lang.tr('letter_days'), style: TextStyle(color: sel ? Colors.white70 : kTextMuted, fontSize: 10)),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _titleCtrl.text.trim().isEmpty || _contentCtrl.text.trim().isEmpty ? null : () async {
                await vm.saveLetter(FutureSelfLetter(
                  title: _titleCtrl.text.trim(),
                  content: _contentCtrl.text.trim(),
                  unlockDays: _unlockDays,
                ));
                _titleCtrl.clear();
                _contentCtrl.clear();
                setState(() => _showForm = false);
              },
              icon: const Icon(Icons.lock_clock),
              label: Text('${lang.tr('letter_lock_btn_days')} $_unlockDays ${lang.tr('letter_days')}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class _LetterCard extends StatelessWidget {
  final FutureSelfLetter letter;
  final TaskViewModel vm;
  final bool isUnlocked;
  const _LetterCard({required this.letter, required this.vm, required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final borderColor = isUnlocked ? kSuccess.withValues(alpha: 0.4) : kDivider;
    final date = DateTime.fromMillisecondsSinceEpoch(letter.writtenAt);

    return GestureDetector(
      onTap: isUnlocked ? () => _showLetter(context) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Text(isUnlocked ? '📬' : '🔒', style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(letter.title, style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(
                    isUnlocked
                        ? '${lang.tr('letter_unlocked_tap')} · ${date.day}/${date.month}/${date.year}'
                        : letter.remainingLabel,
                    style: TextStyle(color: isUnlocked ? kSuccess : kTextMuted, fontSize: 12),
                  ),
                  Text('${letter.unlockDays}-day lock', style: const TextStyle(color: kTextMuted, fontSize: 11)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: kDanger, size: 20),
              onPressed: () => vm.deleteLetter(letter.id!),
            ),
          ],
        ),
      ),
    );
  }

  void _showLetter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kCardBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, ctrl) => Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(controller: ctrl, children: [
            const Text('📬', style: TextStyle(fontSize: 40), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(letter.title, style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.w900, fontSize: 22), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Text(letter.content, style: const TextStyle(color: kTextPrimary, fontSize: 15, height: 1.7)),
          ]),
        ),
      ),
    );
  }
}
