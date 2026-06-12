class PersonalRecord {
  final String key;
  final double value;
  final int timestamp;
  final String detail;

  PersonalRecord({
    required this.key,
    required this.value,
    required this.timestamp,
    required this.detail,
  });

  Map<String, dynamic> toMap() => {
        'key': key,
        'value': value,
        'timestamp': timestamp,
        'detail': detail,
      };

  factory PersonalRecord.fromMap(Map<String, dynamic> map) => PersonalRecord(
        key: map['key'] as String,
        value: (map['value'] as num).toDouble(),
        timestamp: map['timestamp'] as int,
        detail: map['detail'] as String? ?? '',
      );
}
