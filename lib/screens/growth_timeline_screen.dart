import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodel/task_viewmodel.dart';
import '../data/identity_level_model.dart';
import '../data/discipline_score_model.dart';
import '../theme/app_theme.dart';
import '../l10n/language_provider.dart';

class GrowthTimelineScreen extends StatelessWidget {
  const GrowthTimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();
    final lang = context.watch<LanguageProvider>();
    final points = vm.growthTimelinePoints.reversed.toList(); // Newest first

    return Scaffold(
      backgroundColor: kSurface,
      appBar: AppBar(
        backgroundColor: kSurface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Growth Timeline',
              style: TextStyle(color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Snapshots of your consistency journey',
              style: TextStyle(color: kTextMuted, fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: points.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('📈', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 16),
                    const Text(
                      'No timeline records yet',
                      style: TextStyle(color: kTextPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Complete your plans and reflections. Daily snapshots of your scores will populate this timeline.',
                      style: TextStyle(color: kTextMuted, fontSize: 13, height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: points.length,
              itemBuilder: (context, index) {
                final pt = points[index];
                final dateStr = pt['dateStr'] as String? ?? '';
                final discipline = (pt['disciplineScore'] as num? ?? 0.0).toDouble();
                final reliability = (pt['reliabilityScore'] as num? ?? 0.0).toDouble();
                final levelNum = pt['levelNumber'] as int? ?? 1;
                final kept = pt['promisesKept'] as int? ?? 0;

                String formattedDate = dateStr;
                try {
                  final dt = DateTime.tryParse(dateStr);
                  if (dt != null) {
                    formattedDate = DateFormat('MMM dd, yyyy').format(dt);
                  }
                } catch (_) {}

                final level = IdentityLevelRegistry.getLevel(levelNum);
                final scoreColor = Color(DisciplineScore(
                  date: '',
                  executionScore: 0,
                  consistencyScore: 0,
                  planningScore: 0,
                  reflectionScore: 0,
                  totalScore: discipline,
                ).colorValue);

                return Stack(
                  children: [
                    Positioned(
                      left: 19,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 2,
                        color: kDivider,
                      ),
                    ),
                    Positioned(
                      left: 12,
                      top: 22,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: scoreColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: kSurface, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: scoreColor.withValues(alpha: 0.3),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 45, bottom: 24),
                      child: Container(
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
                                  formattedDate,
                                  style: const TextStyle(color: kTextMuted, fontSize: 11.5, fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: scoreColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${discipline.toInt()} Score',
                                    style: TextStyle(color: scoreColor, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Level $levelNum • ${lang.tr(level.nameKey)}',
                              style: const TextStyle(color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              lang.tr(level.descKey),
                              style: const TextStyle(color: kTextMuted, fontSize: 12, height: 1.3),
                            ),
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildIndicatorTile(
                                  Icons.shield_outlined,
                                  'Reliability',
                                  '${reliability.toStringAsFixed(1)}%',
                                  reliability >= 70 ? kSuccess : (reliability >= 40 ? kWarning : kDanger),
                                ),
                                _buildIndicatorTile(
                                  Icons.done_all,
                                  'Promises Kept',
                                  '$kept kept',
                                  kAccent,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildIndicatorTile(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: kTextMuted, fontSize: 10)),
            const SizedBox(height: 1),
            Text(value, style: const TextStyle(color: kTextPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
