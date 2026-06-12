import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/task_database.dart';
import '../data/task_model.dart';
import '../data/daily_reflection_model.dart';
import '../data/discipline_score_model.dart';
import '../data/future_self_letter_model.dart';

// ─────────────────────────────────────────────
// Supporting Data Classes
// ─────────────────────────────────────────────

class PlanningAccuracy {
  final int planned;
  final int completed;
  final int failed;
  double get accuracy => planned > 0 ? (completed / planned * 100) : 0;
  PlanningAccuracy({required this.planned, required this.completed, required this.failed});
}

class DayProgress {
  final String dayLabel;
  final String dateLabel;
  final int completedCount;
  final int failedCount;
  DayProgress({required this.dayLabel, required this.dateLabel, required this.completedCount, required this.failedCount});
}

class FailureInsight {
  final String category;
  final String categoryKey;
  final String emoji;
  final int count;
  final double percentage;
  FailureInsight({required this.category, required this.categoryKey, required this.emoji, required this.count, required this.percentage});
}

class LifeAreaStat {
  final LifeArea area;
  final int planned;
  final int completed;
  double get rate => planned > 0 ? completed / planned : 0;
  LifeAreaStat({required this.area, required this.planned, required this.completed});
}

class WeeklyCEOReport {
  final String weekOf;
  final int successRate;
  final int planningAccuracy;
  final String bestDay;
  final String worstDay;
  final String topFailureCategory;
  final String topFailureCategoryKey;
  final double avgDisciplineScore;
  final String biggestImprovementArea;
  final int tasksCompleted;
  final int tasksFailed;

  WeeklyCEOReport({
    required this.weekOf,
    required this.successRate,
    required this.planningAccuracy,
    required this.bestDay,
    required this.worstDay,
    required this.topFailureCategory,
    required this.topFailureCategoryKey,
    required this.avgDisciplineScore,
    required this.biggestImprovementArea,
    required this.tasksCompleted,
    required this.tasksFailed,
  });
}

// ─────────────────────────────────────────────
// Failure Categorization Engine
// ─────────────────────────────────────────────

FailureCategory categorizeReason(String reason) {
  final r = reason.toLowerCase();
  if (r.isEmpty) return FailureCategory.none;

  if (r.contains('phone') || r.contains('social') || r.contains('instagram') ||
      r.contains('youtube') || r.contains('distract') || r.contains('reels') ||
      r.contains('netflix') || r.contains('game') || r.contains('twitter') ||
      r.contains('scroll')) return FailureCategory.distraction;

  if (r.contains('tired') || r.contains('thak') || r.contains('neend') ||
      r.contains('sleep') || r.contains('energy') || r.contains('exhausted') ||
      r.contains('weak') || r.contains('sick') || r.contains('bimar')) return FailureCategory.lowEnergy;

  if (r.contains('time') || r.contains('late') || r.contains('busy') ||
      r.contains('schedule') || r.contains('waqt') || r.contains('der') ||
      r.contains('khatam') || r.contains('finish')) return FailureCategory.timeIssues;

  if (r.contains('big') || r.contains('bada') || r.contains('zyada') ||
      r.contains('unrealistic') || r.contains('overestimate') ||
      r.contains('plan') || r.contains('too much')) return FailureCategory.poorPlanning;

  if (r.contains('motivat') || r.contains('feel') || r.contains('mood') ||
      r.contains('boring') || r.contains('interest') || r.contains('mann') ||
      r.contains('dil')) return FailureCategory.motivation;

  if (r.contains('family') || r.contains('urgent') || r.contains('call') ||
      r.contains('baahar') || r.contains('outside') || r.contains('ghar') ||
      r.contains('guest') || r.contains('mehmaan') || r.contains('work') ||
      r.contains('office')) return FailureCategory.external;

  return FailureCategory.none;
}

// ─────────────────────────────────────────────
// Main ViewModel
// ─────────────────────────────────────────────

class TaskViewModel extends ChangeNotifier {
  final _db = NitePlanDatabase.instance;

  // ── Tasks State ──
  List<Task> _allTasks = [];
  List<Task> get allTasks => _allTasks;
  List<Task> get todayTasks => _tasksByDate(DailyReflection.todayDate());
  List<Task> get pendingTasks => _allTasks.where((t) => t.status == 'PENDING').toList();

  // ── Timer State ──
  Task? _runningTask;
  Task? get runningTask => _runningTask;
  int _timerSecondsRemaining = 0;
  int get timerSecondsRemaining => _timerSecondsRemaining;
  bool _timerIsRunning = false;
  bool get timerIsRunning => _timerIsRunning;
  Task? _notificationAlertTask;
  Task? get notificationAlertTask => _notificationAlertTask;
  Task? _feedbackDialogTask;
  Task? get feedbackDialogTask => _feedbackDialogTask;
  bool _feedbackDefaultIsDone = true;
  bool get feedbackDefaultIsDone => _feedbackDefaultIsDone;

  // ── Reflection State ──
  DailyReflection? _todayReflection;
  DailyReflection? get todayReflection => _todayReflection;
  bool get hasReflectedToday => _todayReflection?.isComplete ?? false;
  List<DailyReflection> _recentReflections = [];
  List<DailyReflection> get recentReflections => _recentReflections;

  // ── Score State ──
  DisciplineScore? _currentScore;
  DisciplineScore? get currentScore => _currentScore;
  List<DisciplineScore> _scoreHistory = [];
  List<DisciplineScore> get scoreHistory => _scoreHistory;

  // ── Analytics ──
  PlanningAccuracy _dailyAccuracy = PlanningAccuracy(planned: 0, completed: 0, failed: 0);
  PlanningAccuracy get dailyAccuracy => _dailyAccuracy;
  PlanningAccuracy _weeklyAccuracy = PlanningAccuracy(planned: 0, completed: 0, failed: 0);
  PlanningAccuracy get weeklyAccuracy => _weeklyAccuracy;
  PlanningAccuracy _monthlyAccuracy = PlanningAccuracy(planned: 0, completed: 0, failed: 0);
  PlanningAccuracy get monthlyAccuracy => _monthlyAccuracy;
  List<DayProgress> _weeklyDayProgress = [];
  List<DayProgress> get weeklyDayProgress => _weeklyDayProgress;
  List<FailureInsight> _failureInsights = [];
  List<FailureInsight> get failureInsights => _failureInsights;
  List<LifeAreaStat> _lifeAreaStats = [];
  List<LifeAreaStat> get lifeAreaStats => _lifeAreaStats;

  // ── Letters ──
  List<FutureSelfLetter> _letters = [];
  List<FutureSelfLetter> get letters => _letters;

  // ── Misc ──
  String _motivationText = '';
  String get motivationText => _motivationText;
  int _currentStreak = 0;
  int get currentStreak => _currentStreak;

  Timer? _timerTick;
  Timer? _scheduleObserver;

  final List<String> successReasonsSuggestion = [
    'Puri tarah focused tha (Fully Focused)',
    'Time se pehle khatam (Finished Early)',
    'Asan kaam tha (Easy Task)',
    'Energy high thi (High Energy)',
    'Koi distraction nahi thi (No Distractions)',
  ];

  final List<String> failureReasonsSuggestion = [
    'Phone/Social Media (Distracted)',
    'Thaka hua tha (Tired/Sleepy)',
    'Urgent kaam aa gaya (External Event)',
    'Kaam zyada bada tha (Poor Planning)',
    'Mann nahi tha (Motivation Low)',
    'Time nahi mila (Time Issues)',
  ];

  TaskViewModel() { _init(); }

  Future<void> _init() async {
    await _loadMotivation();
    await _loadAllData();
    _startScheduleObserver();
  }

  Future<void> _loadAllData() async {
    await Future.wait([
      _loadTasks(),
      _loadTodayReflection(),
      _loadRecentReflections(),
      _loadScoreHistory(),
      _loadLetters(),
    ]);
    _buildAllAnalytics();
    await _snapshotDailyScore();
    notifyListeners();
  }

  // ─────────────────────────────────────────────
  // MOTIVATION
  // ─────────────────────────────────────────────

  Future<void> _loadMotivation() async {
    final prefs = await SharedPreferences.getInstance();
    _motivationText = prefs.getString('motivation_text') ?? '';
  }

  Future<void> saveMotivationText(String text) async {
    _motivationText = text;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('motivation_text', text);
    notifyListeners();
  }

  // ─────────────────────────────────────────────
  // TASKS
  // ─────────────────────────────────────────────

  Future<void> _loadTasks() async {
    _allTasks = await _db.getAllTasks();
  }

  List<Task> _tasksByDate(String date) =>
      _allTasks.where((t) => t.plannedDate == date).toList();

  Future<void> scheduleTask({
    required String title,
    required String description,
    required LifeArea lifeArea,
    required int hour,
    required int minute,
    required double durationHr,
  }) async {
    final task = Task(
      title: title,
      description: description,
      lifeArea: lifeArea.name,
      hour: hour,
      minute: minute,
      durationMinutes: (durationHr * 60).toInt(),
    );
    await _db.insertTask(task);
    await _loadAllData();
  }

  Future<void> deleteTask(Task task) async {
    if (_runningTask?.id == task.id) {
      _timerTick?.cancel();
      _runningTask = null;
      _timerIsRunning = false;
    }
    await _db.deleteTask(task.id!);
    await _loadAllData();
  }

  Future<void> triggerTaskAlert(Task task) async {
    final updated = task.copyWith(status: 'RUNNING');
    await _db.updateTask(updated);
    _notificationAlertTask = updated;
    startTimerForTask(updated);
    await _loadAllData();
  }

  void dismissAlert() { _notificationAlertTask = null; notifyListeners(); }

  void startTimerForTask(Task task) {
    _timerTick?.cancel();
    _runningTask = task;
    _timerSecondsRemaining = task.durationMinutes * 60;
    _timerIsRunning = true;
    notifyListeners();
    _timerTick = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSecondsRemaining > 0 && _timerIsRunning) {
        _timerSecondsRemaining--;
        notifyListeners();
      } else if (_timerSecondsRemaining <= 0) {
        timer.cancel();
        _timerIsRunning = false;
        _feedbackDefaultIsDone = true;
        _feedbackDialogTask = _runningTask;
        _runningTask = null;
        notifyListeners();
      }
    });
  }

  void togglePauseResumeTimer() {
    if (_runningTask == null) return;
    if (_timerIsRunning) {
      _timerIsRunning = false;
      _timerTick?.cancel();
    } else {
      _timerIsRunning = true;
      _timerTick = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timerSecondsRemaining > 0 && _timerIsRunning) {
          _timerSecondsRemaining--;
          notifyListeners();
        } else if (_timerSecondsRemaining <= 0) {
          timer.cancel();
          _timerIsRunning = false;
          _feedbackDialogTask = _runningTask;
          _runningTask = null;
          notifyListeners();
        }
      });
    }
    notifyListeners();
  }

  void stopAndCompleteTaskEarly() {
    final current = _runningTask;
    if (current == null) return;
    _timerTick?.cancel();
    _timerIsRunning = false;
    _runningTask = null;
    _feedbackDefaultIsDone = false;
    _feedbackDialogTask = current;
    notifyListeners();
  }

  void presentFeedbackDialogManually(Task task, {bool isDone = true}) {
    _feedbackDefaultIsDone = isDone;
    _feedbackDialogTask = task;
    notifyListeners();
  }

  void cancelFeedbackDialog() { _feedbackDialogTask = null; notifyListeners(); }

  Future<void> submitTaskFeedback(Task task, bool isDone, String reason) async {
    final cat = isDone ? FailureCategory.none : categorizeReason(reason);
    final updated = task.copyWith(
      status: isDone ? 'DONE' : 'NOT_DONE',
      reason: reason,
      failureCategory: cat.name,
      completedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _db.updateTask(updated);
    _feedbackDialogTask = null;
    if (_runningTask?.id == task.id) {
      _runningTask = null;
      _timerIsRunning = false;
      _timerTick?.cancel();
    }
    await _loadAllData();
  }

  // ─────────────────────────────────────────────
  // REFLECTION
  // ─────────────────────────────────────────────

  Future<void> _loadTodayReflection() async {
    _todayReflection = await _db.getReflectionByDate(DailyReflection.todayDate());
  }

  Future<void> _loadRecentReflections() async {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 30));
    _recentReflections = await _db.getReflectionsInRange(
      _dateString(start), _dateString(now));
  }

  Future<void> saveReflection(DailyReflection reflection) async {
    await _db.upsertReflection(reflection);
    await _loadTodayReflection();
    await _loadRecentReflections();
    await _snapshotDailyScore();
    notifyListeners();
  }

  // ─────────────────────────────────────────────
  // DISCIPLINE SCORE
  // ─────────────────────────────────────────────

  Future<void> _loadScoreHistory() async {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 30));
    _scoreHistory = await _db.getScoresInRange(_dateString(start), _dateString(now));
    _currentScore = _scoreHistory.isNotEmpty ? _scoreHistory.last : null;
  }

  Future<void> _snapshotDailyScore() async {
    final today = DailyReflection.todayDate();
    final last14Days = _allTasks.where((t) {
      final taskDate = DateTime.tryParse(t.plannedDate);
      if (taskDate == null) return false;
      return DateTime.now().difference(taskDate).inDays <= 13;
    }).toList();

    // Execution Rate (40%)
    final doneFailed = last14Days.where((t) => t.status == 'DONE' || t.status == 'NOT_DONE').toList();
    final executionRate = doneFailed.isEmpty ? 0.0 :
        (doneFailed.where((t) => t.status == 'DONE').length / doneFailed.length * 100);

    // Consistency (30%) — days with ≥1 done in last 14 days
    final daysWithActivity = <String>{};
    for (final t in doneFailed.where((t) => t.status == 'DONE')) {
      daysWithActivity.add(t.plannedDate);
    }
    final consistencyRate = (daysWithActivity.length / 14 * 100).clamp(0, 100).toDouble();

    // Planning Accuracy (20%)
    final planningRate = _dailyAccuracy.accuracy.clamp(0, 100);

    // Reflection (10%)
    final reflectionRate = hasReflectedToday ? 100.0 : 0.0;

    final total = DisciplineScore.calculate(
      execution: executionRate,
      consistency: consistencyRate,
      planning: planningRate.toDouble(),
      reflection: reflectionRate,
    );

    final score = DisciplineScore(
      date: today,
      executionScore: executionRate,
      consistencyScore: consistencyRate,
      planningScore: planningRate.toDouble(),
      reflectionScore: reflectionRate,
      totalScore: total.clamp(0, 100).toDouble(),
    );

    await _db.upsertScore(score);
    await _loadScoreHistory();
  }

  // ─────────────────────────────────────────────
  // ANALYTICS
  // ─────────────────────────────────────────────

  void _buildAllAnalytics() {
    _buildPlanningAccuracy();
    _buildWeeklyProgress();
    _buildFailureInsights();
    _buildLifeAreaStats();
    _buildStreak();
  }

  void _buildPlanningAccuracy() {
    final today = DailyReflection.todayDate();
    final todayTasks = _tasksByDate(today);
    _dailyAccuracy = _accuracy(todayTasks);

    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekTasks = _allTasks.where((t) {
      final d = DateTime.tryParse(t.plannedDate);
      return d != null && !d.isBefore(DateTime(weekStart.year, weekStart.month, weekStart.day));
    }).toList();
    _weeklyAccuracy = _accuracy(weekTasks);

    final monthTasks = _allTasks.where((t) {
      final d = DateTime.tryParse(t.plannedDate);
      return d != null && d.month == now.month && d.year == now.year;
    }).toList();
    _monthlyAccuracy = _accuracy(monthTasks);
  }

  PlanningAccuracy _accuracy(List<Task> tasks) {
    final planned = tasks.where((t) => t.status != 'RUNNING').length;
    final completed = tasks.where((t) => t.status == 'DONE').length;
    final failed = tasks.where((t) => t.status == 'NOT_DONE').length;
    return PlanningAccuracy(planned: planned, completed: completed, failed: failed);
  }

  void _buildWeeklyProgress() {
    final now = DateTime.now();
    final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    _weeklyDayProgress = List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      final date = _dateString(d);
      final dayTasks = _tasksByDate(date);
      return DayProgress(
        dayLabel: dayNames[d.weekday % 7],
        dateLabel: '${d.day}/${d.month}',
        completedCount: dayTasks.where((t) => t.status == 'DONE').length,
        failedCount: dayTasks.where((t) => t.status == 'NOT_DONE').length,
      );
    });
  }

  void _buildFailureInsights() {
    final failed = _allTasks.where((t) => t.status == 'NOT_DONE').toList();
    if (failed.isEmpty) { _failureInsights = []; return; }

    final categoryMap = <FailureCategory, int>{};
    for (final t in failed) {
      final cat = t.failureCategory.isNotEmpty
          ? FailureCategory.values.firstWhere((e) => e.name == t.failureCategory, orElse: () => categorizeReason(t.reason))
          : categorizeReason(t.reason);
      if (cat != FailureCategory.none) {
        categoryMap[cat] = (categoryMap[cat] ?? 0) + 1;
      }
    }

    final total = categoryMap.values.fold(0, (a, b) => a + b);
    _failureInsights = categoryMap.entries.map((e) => FailureInsight(
      category: e.key.label,
      categoryKey: e.key.name,
      emoji: e.key.emoji,
      count: e.value,
      percentage: total > 0 ? e.value / total * 100 : 0,
    )).toList()..sort((a, b) => b.count.compareTo(a.count));
  }

  void _buildLifeAreaStats() {
    final finished = _allTasks.where((t) => t.status == 'DONE' || t.status == 'NOT_DONE').toList();
    final map = <LifeArea, List<Task>>{};
    for (final t in finished) {
      final area = LifeArea.values.firstWhere((e) => e.name == t.lifeArea, orElse: () => LifeArea.general);
      map.putIfAbsent(area, () => []).add(t);
    }
    _lifeAreaStats = map.entries.map((e) => LifeAreaStat(
      area: e.key,
      planned: e.value.length,
      completed: e.value.where((t) => t.status == 'DONE').length,
    )).toList()..sort((a, b) => b.planned.compareTo(a.planned));
  }

  void _buildStreak() {
    int streak = 0;
    final now = DateTime.now();
    for (int i = 0; i < 365; i++) {
      final date = _dateString(now.subtract(Duration(days: i)));
      final dayTasks = _tasksByDate(date);
      if (dayTasks.any((t) => t.status == 'DONE')) {
        streak++;
      } else if (i > 0) {
        break;
      }
    }
    _currentStreak = streak;
  }

  WeeklyCEOReport generateWeeklyReport() {
    final now = DateTime.now();
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    String bestDay = '-', worstDay = '-';
    int bestCount = -1, worstCount = 999;

    for (int i = 0; i < 7; i++) {
      final d = now.subtract(Duration(days: 6 - i));
      final dayTasks = _tasksByDate(_dateString(d));
      final done = dayTasks.where((t) => t.status == 'DONE').length;
      final failed = dayTasks.where((t) => t.status == 'NOT_DONE').length;
      final label = dayNames[d.weekday - 1];
      if (done > bestCount) { bestCount = done; bestDay = label; }
      if (failed > 0 && failed < worstCount) { worstCount = failed; worstDay = label; }
    }

    final topCat = _failureInsights.isNotEmpty ? _failureInsights.first.category : 'None';
    final topCatKey = _failureInsights.isNotEmpty ? _failureInsights.first.categoryKey : 'none';
    final avgScore = _scoreHistory.isNotEmpty
        ? _scoreHistory.map((s) => s.totalScore).reduce((a, b) => a + b) / _scoreHistory.length
        : 0.0;
    final worstArea = _lifeAreaStats.isNotEmpty
        ? _lifeAreaStats.reduce((a, b) => a.rate < b.rate ? a : b).area.label
        : 'None';

    return WeeklyCEOReport(
      weekOf: '${now.subtract(const Duration(days: 6)).day}/${now.subtract(const Duration(days: 6)).month} - ${now.day}/${now.month}',
      successRate: _weeklyAccuracy.accuracy.toInt(),
      planningAccuracy: _weeklyAccuracy.accuracy.toInt(),
      bestDay: bestDay,
      worstDay: worstDay,
      topFailureCategory: topCat,
      topFailureCategoryKey: topCatKey,
      avgDisciplineScore: avgScore,
      biggestImprovementArea: worstArea,
      tasksCompleted: _weeklyAccuracy.completed,
      tasksFailed: _weeklyAccuracy.failed,
    );
  }

  // ─────────────────────────────────────────────
  // FUTURE SELF LETTERS
  // ─────────────────────────────────────────────

  Future<void> _loadLetters() async {
    _letters = await _db.getAllLetters();
    // Auto-unlock
    for (final letter in _letters.where((l) => !l.isUnlocked && l.shouldUnlock)) {
      await _db.updateLetter(letter.copyWith(isUnlocked: true));
    }
    _letters = await _db.getAllLetters();
  }

  Future<void> saveLetter(FutureSelfLetter letter) async {
    await _db.insertLetter(letter);
    await _loadLetters();
    notifyListeners();
  }

  Future<void> deleteLetter(int id) async {
    await _db.deleteLetter(id);
    await _loadLetters();
    notifyListeners();
  }

  // ─────────────────────────────────────────────
  // SCHEDULE OBSERVER
  // ─────────────────────────────────────────────

  void _startScheduleObserver() {
    _scheduleObserver?.cancel();
    _scheduleObserver = Timer.periodic(const Duration(seconds: 30), (_) {
      final now = DateTime.now();
      final match = _allTasks
          .where((t) => t.status == 'PENDING' && t.hour == now.hour && t.minute == now.minute)
          .firstOrNull;
      if (match != null) triggerTaskAlert(match);
    });
  }

  // ─────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────

  String _dateString(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  void dispose() {
    _timerTick?.cancel();
    _scheduleObserver?.cancel();
    super.dispose();
  }
}
