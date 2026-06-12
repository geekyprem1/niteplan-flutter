class DailyReflection {
  final int? id;
  final String date; // "2024-01-15"
  final String wentWell;
  final String whatFailed;
  final String whyItFailed;
  final String tomorrowImprovement;
  final int mood; // 1-5
  final int createdAt;
  final int updatedAt;

  DailyReflection({
    this.id,
    required this.date,
    this.wentWell = '',
    this.whatFailed = '',
    this.whyItFailed = '',
    this.tomorrowImprovement = '',
    this.mood = 3,
    int? createdAt,
    int? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch,
        updatedAt = updatedAt ?? DateTime.now().millisecondsSinceEpoch;

  DailyReflection copyWith({
    int? id,
    String? date,
    String? wentWell,
    String? whatFailed,
    String? whyItFailed,
    String? tomorrowImprovement,
    int? mood,
    int? createdAt,
    int? updatedAt,
  }) {
    return DailyReflection(
      id: id ?? this.id,
      date: date ?? this.date,
      wentWell: wentWell ?? this.wentWell,
      whatFailed: whatFailed ?? this.whatFailed,
      whyItFailed: whyItFailed ?? this.whyItFailed,
      tomorrowImprovement: tomorrowImprovement ?? this.tomorrowImprovement,
      mood: mood ?? this.mood,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isComplete =>
      wentWell.isNotEmpty &&
      whatFailed.isNotEmpty &&
      whyItFailed.isNotEmpty &&
      tomorrowImprovement.isNotEmpty;

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'date': date,
        'wentWell': wentWell,
        'whatFailed': whatFailed,
        'whyItFailed': whyItFailed,
        'tomorrowImprovement': tomorrowImprovement,
        'mood': mood,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  factory DailyReflection.fromMap(Map<String, dynamic> map) => DailyReflection(
        id: map['id'] as int?,
        date: map['date'] as String,
        wentWell: map['wentWell'] as String? ?? '',
        whatFailed: map['whatFailed'] as String? ?? '',
        whyItFailed: map['whyItFailed'] as String? ?? '',
        tomorrowImprovement: map['tomorrowImprovement'] as String? ?? '',
        mood: map['mood'] as int? ?? 3,
        createdAt: map['createdAt'] as int,
        updatedAt: map['updatedAt'] as int,
      );

  static String todayDate() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
