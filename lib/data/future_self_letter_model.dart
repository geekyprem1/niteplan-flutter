class FutureSelfLetter {
  final int? id;
  final String title;
  final String content;
  final int writtenAt;
  final int unlockDays; // 30, 90, 180
  final int unlockAt;
  final bool isUnlocked;

  FutureSelfLetter({
    this.id,
    required this.title,
    required this.content,
    int? writtenAt,
    required this.unlockDays,
    int? unlockAt,
    this.isUnlocked = false,
  })  : writtenAt = writtenAt ?? DateTime.now().millisecondsSinceEpoch,
        unlockAt = unlockAt ??
            DateTime.now()
                .add(Duration(days: unlockDays))
                .millisecondsSinceEpoch;

  bool get shouldUnlock =>
      !isUnlocked && DateTime.now().millisecondsSinceEpoch >= unlockAt;

  Duration get remainingTime {
    final remaining = unlockAt - DateTime.now().millisecondsSinceEpoch;
    return remaining > 0 ? Duration(milliseconds: remaining) : Duration.zero;
  }

  String get remainingLabel {
    final d = remainingTime;
    if (d.inDays > 0) return '${d.inDays} days remaining';
    if (d.inHours > 0) return '${d.inHours} hours remaining';
    return 'Ready to unlock!';
  }

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'title': title,
        'content': content,
        'writtenAt': writtenAt,
        'unlockDays': unlockDays,
        'unlockAt': unlockAt,
        'isUnlocked': isUnlocked ? 1 : 0,
      };

  factory FutureSelfLetter.fromMap(Map<String, dynamic> map) =>
      FutureSelfLetter(
        id: map['id'] as int?,
        title: map['title'] as String,
        content: map['content'] as String,
        writtenAt: map['writtenAt'] as int,
        unlockDays: map['unlockDays'] as int,
        unlockAt: map['unlockAt'] as int,
        isUnlocked: (map['isUnlocked'] as int? ?? 0) == 1,
      );

  FutureSelfLetter copyWith({bool? isUnlocked}) => FutureSelfLetter(
        id: id,
        title: title,
        content: content,
        writtenAt: writtenAt,
        unlockDays: unlockDays,
        unlockAt: unlockAt,
        isUnlocked: isUnlocked ?? this.isUnlocked,
      );
}
