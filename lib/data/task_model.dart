class Task {
  final int? id;
  final String title;
  final String description;
  final int hour;
  final int minute;
  final int durationMinutes;
  final int createdAt;
  final String status; // PENDING, RUNNING, DONE, NOT_DONE
  final String reason;
  final int completedAt;

  Task({
    this.id,
    required this.title,
    this.description = '',
    required this.hour,
    required this.minute,
    required this.durationMinutes,
    int? createdAt,
    this.status = 'PENDING',
    this.reason = '',
    this.completedAt = 0,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  Task copyWith({
    int? id,
    String? title,
    String? description,
    int? hour,
    int? minute,
    int? durationMinutes,
    int? createdAt,
    String? status,
    String? reason,
    int? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'hour': hour,
      'minute': minute,
      'durationMinutes': durationMinutes,
      'createdAt': createdAt,
      'status': status,
      'reason': reason,
      'completedAt': completedAt,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      hour: map['hour'] as int,
      minute: map['minute'] as int,
      durationMinutes: map['durationMinutes'] as int,
      createdAt: map['createdAt'] as int,
      status: map['status'] as String? ?? 'PENDING',
      reason: map['reason'] as String? ?? '',
      completedAt: map['completedAt'] as int? ?? 0,
    );
  }
}
