enum LifeArea {
  health,
  business,
  career,
  learning,
  finance,
  relationships,
  general;

  String get label {
    switch (this) {
      case LifeArea.health: return 'Health';
      case LifeArea.business: return 'Business';
      case LifeArea.career: return 'Career';
      case LifeArea.learning: return 'Learning';
      case LifeArea.finance: return 'Finance';
      case LifeArea.relationships: return 'Relationships';
      case LifeArea.general: return 'General';
    }
  }

  String get emoji {
    switch (this) {
      case LifeArea.health: return '💪';
      case LifeArea.business: return '💼';
      case LifeArea.career: return '🚀';
      case LifeArea.learning: return '📚';
      case LifeArea.finance: return '💰';
      case LifeArea.relationships: return '❤️';
      case LifeArea.general: return '⭐';
    }
  }

  int get colorValue {
    switch (this) {
      case LifeArea.health: return 0xFF00C896;
      case LifeArea.business: return 0xFF7C4DFF;
      case LifeArea.career: return 0xFF2979FF;
      case LifeArea.learning: return 0xFFFF9100;
      case LifeArea.finance: return 0xFFFFD600;
      case LifeArea.relationships: return 0xFFFF4081;
      case LifeArea.general: return 0xFF9090AA;
    }
  }
}

enum FailureCategory {
  distraction,
  lowEnergy,
  timeIssues,
  poorPlanning,
  motivation,
  external,
  none;

  String get label {
    switch (this) {
      case FailureCategory.distraction: return 'Distraction';
      case FailureCategory.lowEnergy: return 'Low Energy';
      case FailureCategory.timeIssues: return 'Time Issues';
      case FailureCategory.poorPlanning: return 'Poor Planning';
      case FailureCategory.motivation: return 'Motivation';
      case FailureCategory.external: return 'External Events';
      case FailureCategory.none: return '';
    }
  }

  String get emoji {
    switch (this) {
      case FailureCategory.distraction: return '📱';
      case FailureCategory.lowEnergy: return '😴';
      case FailureCategory.timeIssues: return '⏰';
      case FailureCategory.poorPlanning: return '📋';
      case FailureCategory.motivation: return '💔';
      case FailureCategory.external: return '🌍';
      case FailureCategory.none: return '';
    }
  }
}

class Task {
  final int? id;
  final String title;
  final String description;
  final String lifeArea;
  final int hour;
  final int minute;
  final int durationMinutes;
  final String plannedDate; // "2024-01-15"
  final int createdAt;
  final String status; // PENDING, RUNNING, DONE, NOT_DONE
  final String failureCategory;
  final String reason;
  final int completedAt;
  final int actualDurationMinutes;

  Task({
    this.id,
    required this.title,
    this.description = '',
    this.lifeArea = 'general',
    required this.hour,
    required this.minute,
    required this.durationMinutes,
    String? plannedDate,
    int? createdAt,
    this.status = 'PENDING',
    this.failureCategory = '',
    this.reason = '',
    this.completedAt = 0,
    this.actualDurationMinutes = 0,
  })  : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch,
        plannedDate = plannedDate ?? _todayString();

  static String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? lifeArea,
    int? hour,
    int? minute,
    int? durationMinutes,
    String? plannedDate,
    int? createdAt,
    String? status,
    String? failureCategory,
    String? reason,
    int? completedAt,
    int? actualDurationMinutes,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      lifeArea: lifeArea ?? this.lifeArea,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      plannedDate: plannedDate ?? this.plannedDate,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      failureCategory: failureCategory ?? this.failureCategory,
      reason: reason ?? this.reason,
      completedAt: completedAt ?? this.completedAt,
      actualDurationMinutes: actualDurationMinutes ?? this.actualDurationMinutes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'lifeArea': lifeArea,
      'hour': hour,
      'minute': minute,
      'durationMinutes': durationMinutes,
      'plannedDate': plannedDate,
      'createdAt': createdAt,
      'status': status,
      'failureCategory': failureCategory,
      'reason': reason,
      'completedAt': completedAt,
      'actualDurationMinutes': actualDurationMinutes,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      lifeArea: map['lifeArea'] as String? ?? 'general',
      hour: map['hour'] as int,
      minute: map['minute'] as int,
      durationMinutes: map['durationMinutes'] as int,
      plannedDate: map['plannedDate'] as String? ?? '',
      createdAt: map['createdAt'] as int,
      status: map['status'] as String? ?? 'PENDING',
      failureCategory: map['failureCategory'] as String? ?? '',
      reason: map['reason'] as String? ?? '',
      completedAt: map['completedAt'] as int? ?? 0,
      actualDurationMinutes: map['actualDurationMinutes'] as int? ?? 0,
    );
  }

  LifeArea get lifeAreaEnum =>
      LifeArea.values.firstWhere((e) => e.name == lifeArea, orElse: () => LifeArea.general);
}
