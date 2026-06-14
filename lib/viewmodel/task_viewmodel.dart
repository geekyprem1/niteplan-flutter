import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/task_database.dart';
import '../data/task_model.dart';
import '../data/daily_reflection_model.dart';
import '../data/discipline_score_model.dart';
import '../data/future_self_letter_model.dart';
import '../data/identity_level_model.dart';
import '../data/milestone_model.dart';
import '../l10n/app_strings.dart';
import '../l10n/motivation_messages.dart';
import '../services/notification_service.dart';



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
  final Set<int> _dismissedAlertTaskIds = {};

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

  // ── Whyly Progression State ──
  List<String> _unlockedMilestones = [];
  List<String> get unlockedMilestones => _unlockedMilestones;

  Map<String, double> _personalRecords = {};
  Map<String, double> get personalRecords => _personalRecords;

  List<Map<String, dynamic>> _growthTimelinePoints = [];
  List<Map<String, dynamic>> get growthTimelinePoints => _growthTimelinePoints;

  IdentityLevel _currentLevel = IdentityLevelRegistry.getLevel(1);
  IdentityLevel get currentLevel => _currentLevel;

  int _promisesKeptCount = 0;
  int get promisesKeptCount => _promisesKeptCount;

  int _promisesMadeCount = 0;
  int get promisesMadeCount => _promisesMadeCount;

  double _reliabilityScore = 0.0;
  double get reliabilityScore => _reliabilityScore;

  int _reflectionsLoggedCount = 0;
  int get reflectionsLoggedCount => _reflectionsLoggedCount;


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
    await NotificationService.instance.init();

    // Set callback for notification tap
    NotificationService.instance.onNotificationTapped = (taskId) {
      _handleNotificationTap(taskId);
    };

    await _loadAllData();

    // Reschedule all active pending reminders on startup
    await NotificationService.instance.rescheduleAllPendingReminders(pendingTasks);

    // Check cold-start notification tap
    final coldStartTaskId = NotificationService.instance.consumeInitialTappedTaskId();
    if (coldStartTaskId != null) {
      _handleNotificationTap(coldStartTaskId);
    } else {
      // Check for any missed alarms when the app starts
      _checkMissedAlarmsOnStartup();
    }
  }

  Future<void> requestNotificationPermissions() async {
    await NotificationService.instance.requestPermissions();
  }

  Future<void> _handleNotificationTap(int taskId) async {
    if (_allTasks.isEmpty) {
      await _loadTasks();
    }
    final task = _allTasks.where((t) => t.id == taskId).firstOrNull;
    if (task != null && task.status == 'PENDING') {
      await triggerTaskAlert(task);
    }
  }

  void _checkMissedAlarmsOnStartup() {
    final now = DateTime.now();
    final todayStr = DailyReflection.todayDate();
    final missedTask = _allTasks.where((t) {
      if (t.status != 'PENDING') return false;
      if (t.plannedDate != todayStr) return false;
      if (t.id != null && _dismissedAlertTaskIds.contains(t.id)) return false;
      
      final taskMinutes = t.hour * 60 + t.minute;
      final nowMinutes = now.hour * 60 + now.minute;
      return taskMinutes <= nowMinutes;
    }).firstOrNull;
    
    if (missedTask != null) {
      triggerTaskAlert(missedTask);
    }
  }

  Future<void> _loadAllData() async {
    await Future.wait([
      _loadTasks(),
      _loadTodayReflection(),
      _loadRecentReflections(),
      _loadScoreHistory(),
      _loadLetters(),
      _loadProgressionData(),
    ]);
    _buildAllAnalytics();
    await _snapshotDailyScore();
    await checkProgressionTriggers();
    notifyListeners();
  }

  Future<void> _loadProgressionData() async {
    _unlockedMilestones = await _db.getUnlockedMilestones();
    final records = await _db.getPersonalRecords();
    _personalRecords = {
      for (var r in records) r['key'] as String: (r['value'] as num).toDouble()
    };
    _growthTimelinePoints = await _db.getGrowthTimelinePoints();
    _reflectionsLoggedCount = await _db.getReflectionsCount();
  }

  void _calculateCurrentLevel() {
    double bestDiscipline = _personalRecords['best_discipline_score'] ?? 0.0;
    int maxLevel = 1;
    for (int l = 2; l <= 20; l++) {
      final idLevel = IdentityLevelRegistry.getLevel(l);
      if (idLevel.canUnlock(
        promisesKept: _promisesKeptCount,
        reflectionsLogged: _reflectionsLoggedCount,
        reliability: _reliabilityScore,
        bestDisciplineScore: bestDiscipline,
      )) {
        if (maxLevel == l - 1) {
          maxLevel = l;
        }
      }
    }
    _currentLevel = IdentityLevelRegistry.getLevel(maxLevel);
  }

  Future<void> checkProgressionTriggers() async {
    // 1. Reliability & Completion metrics
    final finishedTasks = _allTasks.where((t) => t.status == 'DONE' || t.status == 'NOT_DONE').toList();
    _promisesMadeCount = finishedTasks.length;
    _promisesKeptCount = finishedTasks.where((t) => t.status == 'DONE').length;
    _reliabilityScore = _promisesMadeCount > 0 ? (_promisesKeptCount / _promisesMadeCount * 100) : 0.0;

    // 2. Personal Records updates

    
    // best_discipline_score
    final currentScoreVal = _currentScore?.totalScore ?? 0.0;
    final bestScoreVal = _personalRecords['best_discipline_score'] ?? 0.0;
    if (currentScoreVal > bestScoreVal) {
      await _db.savePersonalRecord('best_discipline_score', currentScoreVal, 'Set on ${_dateString(DateTime.now())}');
    }

    // best_streak
    final bestStreakVal = _personalRecords['best_streak'] ?? 0.0;
    if (_currentStreak > bestStreakVal) {
      await _db.savePersonalRecord('best_streak', _currentStreak.toDouble(), 'Achieved on ${_dateString(DateTime.now())}');
    }

    // best_reliability
    final bestRelVal = _personalRecords['best_reliability'] ?? 0.0;
    if (_promisesMadeCount >= 5 && _reliabilityScore > bestRelVal) {
      await _db.savePersonalRecord('best_reliability', _reliabilityScore, 'Reached after $_promisesMadeCount promises');
    }

    // best_planning_accuracy
    final bestPlanVal = _personalRecords['best_planning_accuracy'] ?? 0.0;
    final currentPlanVal = _weeklyAccuracy.accuracy;
    if (_promisesMadeCount >= 5 && currentPlanVal > bestPlanVal) {
      await _db.savePersonalRecord('best_planning_accuracy', currentPlanVal, 'Reached with weekly accuracy');
    }

    // Cumulatives
    await _db.savePersonalRecord('total_promises_kept', _promisesKeptCount.toDouble(), '');
    await _db.savePersonalRecord('total_promises_made', _promisesMadeCount.toDouble(), '');
    await _db.savePersonalRecord('total_reflections_logged', _reflectionsLoggedCount.toDouble(), '');

    // Reload progression data
    await _loadProgressionData();

    // 3. Level Upgrade
    _calculateCurrentLevel();

    // 4. Milestone checks
    for (final ms in MilestoneRegistry.milestones) {
      if (_unlockedMilestones.contains(ms.id)) continue;

      bool meetsCriteria = false;
      final parts = ms.id.split('_');
      final category = ms.category;

      if (category == 'kept') {
        final val = int.tryParse(parts.last) ?? 0;
        meetsCriteria = _promisesKeptCount >= val;
      } else if (category == 'made') {
        final val = int.tryParse(parts.last) ?? 0;
        meetsCriteria = _promisesMadeCount >= val;
      } else if (category == 'reflection') {
        final val = int.tryParse(parts.last) ?? 0;
        meetsCriteria = _reflectionsLoggedCount >= val;
      } else if (category == 'streak') {
        final val = int.tryParse(parts.last) ?? 0;
        meetsCriteria = _currentStreak >= val;
      } else if (category == 'score') {
        final val = double.tryParse(parts.last) ?? 0.0;
        meetsCriteria = (_personalRecords['best_discipline_score'] ?? 0.0) >= val;
      } else if (category == 'reliability') {
        final val = double.tryParse(parts.last) ?? 0.0;
        meetsCriteria = (_personalRecords['best_reliability'] ?? 0.0) >= val;
      } else if (category == 'planning') {
        final val = double.tryParse(parts.last) ?? 0.0;
        meetsCriteria = (_personalRecords['best_planning_accuracy'] ?? 0.0) >= val;
      } else if (category == 'area') {
        if (ms.id.startsWith('area_balance_')) {
          final countVal = LifeArea.values.where((area) {
            return _allTasks.where((t) => t.status == 'DONE' && t.lifeArea == area.name).length >= 5;
          }).length;
          if (ms.id == 'area_balance_3') meetsCriteria = countVal >= 3;
          if (ms.id == 'area_balance_5') meetsCriteria = countVal >= 5;
          if (ms.id == 'area_balance_all') meetsCriteria = countVal >= 7;
        } else {
          final areaName = parts[1];
          meetsCriteria = _allTasks.where((t) => t.status == 'DONE' && t.lifeArea == areaName).length >= 10;
        }
      } else if (category == 'time') {
        final tod = parts[1];
        final val = int.tryParse(parts.last) ?? 0;
        int todCount = 0;
        if (tod == 'morn') {
          todCount = _allTasks.where((t) => t.status == 'DONE' && t.hour >= 5 && t.hour < 12).length;
        } else if (tod == 'aft') {
          todCount = _allTasks.where((t) => t.status == 'DONE' && t.hour >= 12 && t.hour < 17).length;
        } else if (tod == 'eve') {
          todCount = _allTasks.where((t) => t.status == 'DONE' && t.hour >= 17 && t.hour < 21).length;
        } else if (tod == 'night') {
          todCount = _allTasks.where((t) => t.status == 'DONE' && (t.hour >= 21 || t.hour < 5)).length;
        }
        meetsCriteria = todCount >= val;
      } else if (category == 'week') {
        final val = int.tryParse(parts.last) ?? 0;
        meetsCriteria = _reflectionsLoggedCount >= 7 * val;
      } else if (category == 'letter') {
        if (ms.id == 'let_write_1') meetsCriteria = _letters.length >= 1;
        if (ms.id == 'let_write_3') meetsCriteria = _letters.length >= 3;
        if (ms.id == 'let_unlock_1') meetsCriteria = _letters.where((l) => l.isUnlocked).length >= 1;
        if (ms.id == 'let_unlock_3') meetsCriteria = _letters.where((l) => l.isUnlocked).length >= 3;
      } else if (category == 'fail') {
        final val = int.tryParse(parts.last) ?? 0;
        meetsCriteria = _allTasks.where((t) => t.status == 'NOT_DONE' && t.reason.isNotEmpty).length >= val;
      }

      if (meetsCriteria) {
        await _db.unlockMilestone(ms.id);
        _unlockedMilestones.add(ms.id);
      }
    }

    // 5. Growth Timeline save point
    if (_currentScore != null) {
      await _db.saveGrowthTimelinePoint(
        _dateString(DateTime.now()),
        _currentScore!.totalScore,
        _reliabilityScore,
        _currentLevel.level,
        _promisesKeptCount,
      );
      _growthTimelinePoints = await _db.getGrowthTimelinePoints();
    }

    // 6. Update motivation message dynamically
    _updateMotivationText();
  }

  void _updateMotivationText() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    _motivationText = MotivationMessages.getMessage(AppLanguage.english, _currentLevel.level, dayOfYear);
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
    // Ensure permission is requested before scheduling a reminder
    await NotificationService.instance.requestPermissions();

    final task = Task(
      title: title,
      description: description,
      lifeArea: lifeArea.name,
      hour: hour,
      minute: minute,
      durationMinutes: (durationHr * 60).toInt(),
    );
    final id = await _db.insertTask(task);
    final taskWithId = task.copyWith(id: id);
    await NotificationService.instance.scheduleTaskReminder(taskWithId);
    await _loadAllData();
  }

  Future<void> deleteTask(Task task) async {
    if (_runningTask?.id == task.id) {
      _timerTick?.cancel();
      _runningTask = null;
      _timerIsRunning = false;
    }
    if (task.id != null) {
      await NotificationService.instance.cancelTaskReminder(task.id!);
    }
    await _db.deleteTask(task.id!);
    await _loadAllData();
  }

  Future<void> triggerTaskAlert(Task task) async {
    final updated = task.copyWith(status: 'RUNNING');
    await _db.updateTask(updated);
    if (task.id != null) {
      await NotificationService.instance.cancelTaskReminder(task.id!);
    }
    _notificationAlertTask = updated;
    startTimerForTask(updated);
    await _loadAllData();
  }

  void dismissAlert() {
    if (_notificationAlertTask?.id != null) {
      _dismissedAlertTaskIds.add(_notificationAlertTask!.id!);
    }
    _notificationAlertTask = null;
    notifyListeners();
  }

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
    if (task.id != null) {
      await NotificationService.instance.cancelTaskReminder(task.id!);
    }
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
    await checkProgressionTriggers();
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
