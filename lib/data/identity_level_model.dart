class IdentityLevel {
  final int level;
  final String nameKey;
  final String descKey;
  final String reqKey;

  const IdentityLevel({
    required this.level,
    required this.nameKey,
    required this.descKey,
    required this.reqKey,
  });

  bool canUnlock({
    required int promisesKept,
    required int reflectionsLogged,
    required double reliability,
    required double bestDisciplineScore,
  }) {
    switch (level) {
      case 1:
        return true; // The Observer (Unlocked at start)
      case 2:
        return reflectionsLogged >= 3; // Curious Wanderer
      case 3:
        return promisesKept >= 5; // Intent Starter
      case 4:
        return reflectionsLogged >= 5 && reliability >= 40.0; // Mirror Seeker
      case 5:
        return promisesKept >= 10 && reflectionsLogged >= 7; // Pattern Spotter
      case 6:
        return promisesKept >= 15 && reliability >= 45.0; // Promise Keeper
      case 7:
        return promisesKept >= 25; // Quiet Architect
      case 8:
        return promisesKept >= 35 && reliability >= 50.0; // Habit Builder
      case 9:
        return reflectionsLogged >= 15; // Honest Evaluator
      case 10:
        return promisesKept >= 45 && reliability >= 55.0; // Focused Mind
      case 11:
        return promisesKept >= 60 && reflectionsLogged >= 20; // Consistent Executor
      case 12:
        return reflectionsLogged >= 30; // Pattern Master
      case 13:
        return promisesKept >= 80 && reliability >= 60.0; // Self-Adjuster
      case 14:
        return promisesKept >= 100 && bestDisciplineScore >= 65.0; // Resilient Planner
      case 15:
        return promisesKept >= 125 && reflectionsLogged >= 40; // Discipline Practitioner
      case 16:
        return promisesKept >= 150 && reliability >= 70.0; // Mindful Doer
      case 17:
        return reliability >= 75.0 && promisesKept >= 175; // Reliable Shield
      case 18:
        return promisesKept >= 200 && bestDisciplineScore >= 75.0; // Unyielding Will
      case 19:
        return reflectionsLogged >= 60 && promisesKept >= 225; // Behavioral Master
      case 20:
        return promisesKept >= 250 && reliability >= 80.0 && bestDisciplineScore >= 80.0; // Unstoppable Force
      default:
        return false;
    }
  }
}

class IdentityLevelRegistry {
  static const List<IdentityLevel> levels = [
    IdentityLevel(level: 1, nameKey: 'level_1_name', descKey: 'level_1_desc', reqKey: 'level_1_req'),
    IdentityLevel(level: 2, nameKey: 'level_2_name', descKey: 'level_2_desc', reqKey: 'level_2_req'),
    IdentityLevel(level: 3, nameKey: 'level_3_name', descKey: 'level_3_desc', reqKey: 'level_3_req'),
    IdentityLevel(level: 4, nameKey: 'level_4_name', descKey: 'level_4_desc', reqKey: 'level_4_req'),
    IdentityLevel(level: 5, nameKey: 'level_5_name', descKey: 'level_5_desc', reqKey: 'level_5_req'),
    IdentityLevel(level: 6, nameKey: 'level_6_name', descKey: 'level_6_desc', reqKey: 'level_6_req'),
    IdentityLevel(level: 7, nameKey: 'level_7_name', descKey: 'level_7_desc', reqKey: 'level_7_req'),
    IdentityLevel(level: 8, nameKey: 'level_8_name', descKey: 'level_8_desc', reqKey: 'level_8_req'),
    IdentityLevel(level: 9, nameKey: 'level_9_name', descKey: 'level_9_desc', reqKey: 'level_9_req'),
    IdentityLevel(level: 10, nameKey: 'level_10_name', descKey: 'level_10_desc', reqKey: 'level_10_req'),
    IdentityLevel(level: 11, nameKey: 'level_11_name', descKey: 'level_11_desc', reqKey: 'level_11_req'),
    IdentityLevel(level: 12, nameKey: 'level_12_name', descKey: 'level_12_desc', reqKey: 'level_12_req'),
    IdentityLevel(level: 13, nameKey: 'level_13_name', descKey: 'level_13_desc', reqKey: 'level_13_req'),
    IdentityLevel(level: 14, nameKey: 'level_14_name', descKey: 'level_14_desc', reqKey: 'level_14_req'),
    IdentityLevel(level: 15, nameKey: 'level_15_name', descKey: 'level_15_desc', reqKey: 'level_15_req'),
    IdentityLevel(level: 16, nameKey: 'level_16_name', descKey: 'level_16_desc', reqKey: 'level_16_req'),
    IdentityLevel(level: 17, nameKey: 'level_17_name', descKey: 'level_17_desc', reqKey: 'level_17_req'),
    IdentityLevel(level: 18, nameKey: 'level_18_name', descKey: 'level_18_desc', reqKey: 'level_18_req'),
    IdentityLevel(level: 19, nameKey: 'level_19_name', descKey: 'level_19_desc', reqKey: 'level_19_req'),
    IdentityLevel(level: 20, nameKey: 'level_20_name', descKey: 'level_20_desc', reqKey: 'level_20_req'),
  ];

  static IdentityLevel getLevel(int levelNum) {
    if (levelNum < 1) return levels.first;
    if (levelNum > 20) return levels.last;
    return levels[levelNum - 1];
  }
}
