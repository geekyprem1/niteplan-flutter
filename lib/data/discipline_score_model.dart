class DisciplineScore {
  final int? id;
  final String date; // "2024-01-15"
  final double executionScore;     // 0-100, weight 40%
  final double consistencyScore;   // 0-100, weight 30%
  final double planningScore;      // 0-100, weight 20%
  final double reflectionScore;    // 0-100, weight 10%
  final double totalScore;         // 0-100
  final int createdAt;

  DisciplineScore({
    this.id,
    required this.date,
    this.executionScore = 0,
    this.consistencyScore = 0,
    this.planningScore = 0,
    this.reflectionScore = 0,
    this.totalScore = 0,
    int? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  static double calculate({
    required double execution,
    required double consistency,
    required double planning,
    required double reflection,
  }) {
    return (execution * 0.40) +
        (consistency * 0.30) +
        (planning * 0.20) +
        (reflection * 0.10);
  }

  String get label {
    if (totalScore >= 80) return 'Elite';
    if (totalScore >= 60) return 'Consistent';
    if (totalScore >= 40) return 'Developing';
    return 'Beginner';
  }

  int get colorValue {
    if (totalScore >= 80) return 0xFF00C896;
    if (totalScore >= 60) return 0xFF7C4DFF;
    if (totalScore >= 40) return 0xFFFF9100;
    return 0xFFFF4060;
  }

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'date': date,
        'executionScore': executionScore,
        'consistencyScore': consistencyScore,
        'planningScore': planningScore,
        'reflectionScore': reflectionScore,
        'totalScore': totalScore,
        'createdAt': createdAt,
      };

  factory DisciplineScore.fromMap(Map<String, dynamic> map) => DisciplineScore(
        id: map['id'] as int?,
        date: map['date'] as String,
        executionScore: (map['executionScore'] as num).toDouble(),
        consistencyScore: (map['consistencyScore'] as num).toDouble(),
        planningScore: (map['planningScore'] as num).toDouble(),
        reflectionScore: (map['reflectionScore'] as num).toDouble(),
        totalScore: (map['totalScore'] as num).toDouble(),
        createdAt: map['createdAt'] as int,
      );
}
