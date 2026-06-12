import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/task_database.dart';
import '../data/task_model.dart';
import '../data/daily_reflection_model.dart';
import '../data/discipline_score_model.dart';
import '../data/future_self_letter_model.dart';

enum SyncStatus { idle, syncing, success, error }

class SyncManager {
  static final SyncManager instance = SyncManager._();
  SyncManager._();

  final _firestore = FirebaseFirestore.instance;
  final _localDb = NitePlanDatabase.instance;

  SyncStatus _status = SyncStatus.idle;
  SyncStatus get status => _status;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;
  bool get _isGuest => FirebaseAuth.instance.currentUser?.isAnonymous ?? true;

  // ────────────────────────────────────────────
  // MAIN SYNC ENTRY POINT
  // ────────────────────────────────────────────

  Future<void> syncAll() async {
    if (_uid == null || _isGuest) return; // Guest = local only
    _status = SyncStatus.syncing;

    try {
      await Future.wait([
        _syncTasks(),
        _syncReflections(),
        _syncScores(),
        _syncLetters(),
      ]);
      _status = SyncStatus.success;
    } catch (e) {
      _status = SyncStatus.error;
    }
  }

  // ────────────────────────────────────────────
  // FIRST LOGIN MIGRATION (local → cloud)
  // ────────────────────────────────────────────

  Future<void> migrateLocalToCloud() async {
    if (_uid == null || _isGuest) return;
    final prefs = await SharedPreferences.getInstance();
    final key = 'migrated_$_uid';
    if (prefs.getBool(key) ?? false) return; // Already migrated

    await uploadAllLocalData();
    await prefs.setBool(key, true);
  }

  Future<void> uploadAllLocalData() async {
    if (_uid == null) return;
    final uid = _uid!;

    // Upload Tasks
    final tasks = await _localDb.getAllTasks();
    final taskBatch = _firestore.batch();
    for (final t in tasks) {
      final ref = _firestore.collection('users/$uid/tasks').doc(t.id.toString());
      taskBatch.set(ref, _taskToFirestore(t), SetOptions(merge: true));
    }
    await taskBatch.commit();

    // Upload Reflections
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 30));
    final reflections = await _localDb.getReflectionsInRange(
      _dateStr(start), _dateStr(now));
    final reflBatch = _firestore.batch();
    for (final r in reflections) {
      final ref = _firestore.collection('users/$uid/reflections').doc(r.date);
      reflBatch.set(ref, _reflectionToFirestore(r), SetOptions(merge: true));
    }
    await reflBatch.commit();

    // Upload Discipline Scores
    final scores = await _localDb.getScoresInRange(
      _dateStr(now.subtract(const Duration(days: 30))), _dateStr(now));
    final scoreBatch = _firestore.batch();
    for (final s in scores) {
      final ref = _firestore.collection('users/$uid/discipline_scores').doc(s.date);
      scoreBatch.set(ref, _scoreToFirestore(s), SetOptions(merge: true));
    }
    await scoreBatch.commit();

    // Upload Future Letters
    final letters = await _localDb.getAllLetters();
    final letterBatch = _firestore.batch();
    for (final l in letters) {
      final ref = _firestore.collection('users/$uid/future_letters').doc(l.id.toString());
      letterBatch.set(ref, _letterToFirestore(l), SetOptions(merge: true));
    }
    await letterBatch.commit();
  }

  // ────────────────────────────────────────────
  // TASK SYNC
  // ────────────────────────────────────────────

  Future<void> _syncTasks() async {
    final uid = _uid!;
    final localTasks = await _localDb.getAllTasks();

    // Push unsynced local tasks
    final batch = _firestore.batch();
    for (final t in localTasks) {
      final ref = _firestore.collection('users/$uid/tasks').doc(t.id.toString());
      batch.set(ref, _taskToFirestore(t), SetOptions(merge: true));
    }
    await batch.commit();

    // Pull remote tasks newer than local
    final remoteDocs = await _firestore.collection('users/$uid/tasks').get();
    for (final doc in remoteDocs.docs) {
      final remoteTs = (doc['lastModified'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
      final localTask = localTasks.firstWhere(
        (t) => t.id.toString() == doc.id,
        orElse: () => Task(title: '', hour: 0, minute: 0, durationMinutes: 0, createdAt: 0),
      );
      // Remote is newer — update local
      if (remoteTs > (localTask.createdAt)) {
        final updated = _taskFromFirestore(doc.data(), int.tryParse(doc.id));
        if (updated != null) await _localDb.updateTask(updated);
      }
    }
  }

  // ────────────────────────────────────────────
  // REFLECTION SYNC
  // ────────────────────────────────────────────

  Future<void> _syncReflections() async {
    final uid = _uid!;
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 30));
    final localReflections = await _localDb.getReflectionsInRange(
      _dateStr(start), _dateStr(now));

    final batch = _firestore.batch();
    for (final r in localReflections) {
      final ref = _firestore.collection('users/$uid/reflections').doc(r.date);
      batch.set(ref, _reflectionToFirestore(r), SetOptions(merge: true));
    }
    await batch.commit();
  }

  // ────────────────────────────────────────────
  // SCORE SYNC
  // ────────────────────────────────────────────

  Future<void> _syncScores() async {
    final uid = _uid!;
    final now = DateTime.now();
    final scores = await _localDb.getScoresInRange(
      _dateStr(now.subtract(const Duration(days: 30))), _dateStr(now));

    final batch = _firestore.batch();
    for (final s in scores) {
      final ref = _firestore.collection('users/$uid/discipline_scores').doc(s.date);
      batch.set(ref, _scoreToFirestore(s), SetOptions(merge: true));
    }
    await batch.commit();
  }

  // ────────────────────────────────────────────
  // LETTERS SYNC
  // ────────────────────────────────────────────

  Future<void> _syncLetters() async {
    final uid = _uid!;
    final letters = await _localDb.getAllLetters();

    final batch = _firestore.batch();
    for (final l in letters) {
      final ref = _firestore.collection('users/$uid/future_letters').doc(l.id.toString());
      batch.set(ref, _letterToFirestore(l), SetOptions(merge: true));
    }
    await batch.commit();
  }

  // ────────────────────────────────────────────
  // RESTORE FROM CLOUD (new device / reinstall)
  // ────────────────────────────────────────────

  Future<void> restoreFromCloud() async {
    if (_uid == null || _isGuest) return;
    final uid = _uid!;

    // Restore tasks
    final taskDocs = await _firestore.collection('users/$uid/tasks').get();
    for (final doc in taskDocs.docs) {
      final task = _taskFromFirestore(doc.data(), int.tryParse(doc.id));
      if (task != null) await _localDb.insertTask(task);
    }

    // Restore reflections
    final reflDocs = await _firestore.collection('users/$uid/reflections').get();
    for (final doc in reflDocs.docs) {
      final r = _reflectionFromFirestore(doc.data());
      if (r != null) await _localDb.upsertReflection(r);
    }

    // Restore letters
    final letterDocs = await _firestore.collection('users/$uid/future_letters').get();
    for (final doc in letterDocs.docs) {
      final l = _letterFromFirestore(doc.data());
      if (l != null) await _localDb.insertLetter(l);
    }
  }

  // ────────────────────────────────────────────
  // SYNC SINGLE TASK (call after every task change)
  // ────────────────────────────────────────────

  Future<void> syncTask(Task task) async {
    if (_uid == null || _isGuest) return;
    await _firestore
        .collection('users/$_uid/tasks')
        .doc(task.id.toString())
        .set(_taskToFirestore(task), SetOptions(merge: true));
  }

  Future<void> syncReflection(DailyReflection r) async {
    if (_uid == null || _isGuest) return;
    await _firestore
        .collection('users/$_uid/reflections')
        .doc(r.date)
        .set(_reflectionToFirestore(r), SetOptions(merge: true));
  }

  Future<void> syncScore(DisciplineScore s) async {
    if (_uid == null || _isGuest) return;
    await _firestore
        .collection('users/$_uid/discipline_scores')
        .doc(s.date)
        .set(_scoreToFirestore(s), SetOptions(merge: true));
  }

  Future<void> deleteTask(int taskId) async {
    if (_uid == null || _isGuest) return;
    await _firestore.collection('users/$_uid/tasks').doc(taskId.toString()).delete();
  }

  // ────────────────────────────────────────────
  // FIRESTORE CONVERTERS
  // ────────────────────────────────────────────

  Map<String, dynamic> _taskToFirestore(Task t) => {
    'localId': t.id,
    'title': t.title,
    'description': t.description,
    'lifeArea': t.lifeArea,
    'hour': t.hour,
    'minute': t.minute,
    'durationMinutes': t.durationMinutes,
    'plannedDate': t.plannedDate,
    'createdAt': t.createdAt,
    'status': t.status,
    'failureCategory': t.failureCategory,
    'reason': t.reason,
    'completedAt': t.completedAt,
    'actualDurationMinutes': t.actualDurationMinutes,
    'lastModified': FieldValue.serverTimestamp(),
  };

  Task? _taskFromFirestore(Map<String, dynamic> d, int? id) {
    try {
      return Task(
        id: id ?? d['localId'] as int?,
        title: d['title'] as String,
        description: d['description'] as String? ?? '',
        lifeArea: d['lifeArea'] as String? ?? 'general',
        hour: d['hour'] as int,
        minute: d['minute'] as int,
        durationMinutes: d['durationMinutes'] as int,
        plannedDate: d['plannedDate'] as String? ?? '',
        createdAt: d['createdAt'] as int,
        status: d['status'] as String? ?? 'PENDING',
        failureCategory: d['failureCategory'] as String? ?? '',
        reason: d['reason'] as String? ?? '',
        completedAt: d['completedAt'] as int? ?? 0,
        actualDurationMinutes: d['actualDurationMinutes'] as int? ?? 0,
      );
    } catch (_) { return null; }
  }

  Map<String, dynamic> _reflectionToFirestore(DailyReflection r) => {
    'date': r.date,
    'wentWell': r.wentWell,
    'whatFailed': r.whatFailed,
    'whyItFailed': r.whyItFailed,
    'tomorrowImprovement': r.tomorrowImprovement,
    'mood': r.mood,
    'createdAt': r.createdAt,
    'lastModified': FieldValue.serverTimestamp(),
  };

  DailyReflection? _reflectionFromFirestore(Map<String, dynamic> d) {
    try {
      return DailyReflection(
        date: d['date'] as String,
        wentWell: d['wentWell'] as String? ?? '',
        whatFailed: d['whatFailed'] as String? ?? '',
        whyItFailed: d['whyItFailed'] as String? ?? '',
        tomorrowImprovement: d['tomorrowImprovement'] as String? ?? '',
        mood: d['mood'] as int? ?? 3,
        createdAt: d['createdAt'] as int,
      );
    } catch (_) { return null; }
  }

  Map<String, dynamic> _scoreToFirestore(DisciplineScore s) => {
    'date': s.date,
    'executionScore': s.executionScore,
    'consistencyScore': s.consistencyScore,
    'planningScore': s.planningScore,
    'reflectionScore': s.reflectionScore,
    'totalScore': s.totalScore,
    'createdAt': s.createdAt,
    'lastModified': FieldValue.serverTimestamp(),
  };

  Map<String, dynamic> _letterToFirestore(FutureSelfLetter l) => {
    'localId': l.id,
    'title': l.title,
    'content': l.content,
    'writtenAt': l.writtenAt,
    'unlockDays': l.unlockDays,
    'unlockAt': l.unlockAt,
    'isUnlocked': l.isUnlocked,
    'lastModified': FieldValue.serverTimestamp(),
  };

  FutureSelfLetter? _letterFromFirestore(Map<String, dynamic> d) {
    try {
      return FutureSelfLetter(
        id: d['localId'] as int?,
        title: d['title'] as String,
        content: d['content'] as String,
        writtenAt: d['writtenAt'] as int,
        unlockDays: d['unlockDays'] as int,
        unlockAt: d['unlockAt'] as int,
        isUnlocked: d['isUnlocked'] as bool? ?? false,
      );
    } catch (_) { return null; }
  }

  // ────────────────────────────────────────────
  // HELPERS
  // ────────────────────────────────────────────
  String _dateStr(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
