import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/task_database.dart';
import '../data/task_model.dart';

class DayProgress {
  final String dayLabel;
  final String dateLabel;
  final int completedCount;
  final int failedCount;

  DayProgress({
    required this.dayLabel,
    required this.dateLabel,
    required this.completedCount,
    required this.failedCount,
  });
}

class ReasonCount {
  final String reason;
  final int count;
  ReasonCount({required this.reason, required this.count});
}

class AnalyticsData {
  final int completionRatePercentage;
  final int completedCount;
  final int failedCount;
  final int totalCount;
  final List<DayProgress> weeklyDayProgress;
  final List<ReasonCount> topFailureReasons;
  final List<ReasonCount> topSuccessReasons;

  AnalyticsData({
    this.completionRatePercentage = 0,
    this.completedCount = 0,
    this.failedCount = 0,
    this.totalCount = 0,
    this.weeklyDayProgress = const [],
    this.topFailureReasons = const [],
    this.topSuccessReasons = const [],
  });
}

class TaskViewModel extends ChangeNotifier {
  final TaskDatabase _db = TaskDatabase.instance;

  List<Task> _allTasks = [];
  List<Task> get allTasks => _allTasks;

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

  String _motivationText = '';
  String get motivationText => _motivationText;

  Timer? _timerTick;
  Timer? _scheduleObserver;

  AnalyticsData _analyticsData = AnalyticsData();
  AnalyticsData get analyticsData => _analyticsData;

  final List<String> successReasonsSuggestion = [
    'Puri tarah focused tha (Fully Focused)',
    'Time se pehle khatam kar liya (Finished Early)',
    'Asan kaam tha (Easy Task)',
    'Energy level high thhi (High Energy)',
    'Koi distractions nahi thhe (No Distractions)',
  ];

  final List<String> failureReasonsSuggestion = [
    'Thak gaya tha/Neend aa rahi thi (Tired/Sleepy)',
    'Social media/Distractions control nahi hue (Distracted)',
    'Kisi aur zaroori kaam me lag gaya (Urgent conflict)',
    'Kaam bada thha, time frame chota thha (Task too big)',
    'Internet/Tech issue thha (Technical barriers)',
  ];

  TaskViewModel() {
    _init();
  }

  Future<void> _init() async {
    await _loadMotivation();
    await _loadTasks();
    _startScheduleObserver();
    await _prefillIfEmpty();
  }

  Future<void> _loadMotivation() async {
    final prefs = await SharedPreferences.getInstance();
    _motivationText = prefs.getString('motivation_text') ?? '';
    notifyListeners();
  }

  Future<void> saveMotivationText(String text) async {
    _motivationText = text;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('motivation_text', text);
    notifyListeners();
  }

  Future<void> _loadTasks() async {
    _allTasks = await _db.getAllTasks();
    _buildAnalytics();
    notifyListeners();
  }

  void _buildAnalytics() {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 6));
    final sevenDaysAgoStart = DateTime(
            sevenDaysAgo.year, sevenDaysAgo.month, sevenDaysAgo.day)
        .millisecondsSinceEpoch;

    final weeklyTasks = _allTasks.where((t) {
      return t.createdAt >= sevenDaysAgoStart ||
          (t.completedAt >= sevenDaysAgoStart && t.completedAt > 0);
    }).toList();

    final completed = weeklyTasks.where((t) => t.status == 'DONE').toList();
    final failed = weeklyTasks.where((t) => t.status == 'NOT_DONE').toList();
    final finalCount = completed.length + failed.length;
    final rate = finalCount > 0 ? (completed.length * 100) ~/ finalCount : 0;

    final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final List<DayProgress> dayProgresses = [];

    for (int i = 0; i < 7; i++) {
      final loopDate = now.subtract(Duration(days: 6 - i));
      final dayStart =
          DateTime(loopDate.year, loopDate.month, loopDate.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      final tasksOnDay = weeklyTasks.where((t) {
        final ts = t.completedAt > 0 ? t.completedAt : t.createdAt;
        return ts >= dayStart.millisecondsSinceEpoch &&
            ts < dayEnd.millisecondsSinceEpoch;
      }).toList();

      dayProgresses.add(DayProgress(
        dayLabel: dayNames[loopDate.weekday % 7],
        dateLabel: '${loopDate.day}/${loopDate.month}',
        completedCount:
            tasksOnDay.where((t) => t.status == 'DONE').length,
        failedCount:
            tasksOnDay.where((t) => t.status == 'NOT_DONE').length,
      ));
    }

    final failureMap = <String, int>{};
    for (final t in failed.where((t) => t.reason.isNotEmpty)) {
      failureMap[t.reason] = (failureMap[t.reason] ?? 0) + 1;
    }
    final successMap = <String, int>{};
    for (final t in completed.where((t) => t.reason.isNotEmpty)) {
      successMap[t.reason] = (successMap[t.reason] ?? 0) + 1;
    }

    _analyticsData = AnalyticsData(
      completionRatePercentage: rate,
      completedCount: completed.length,
      failedCount: failed.length,
      totalCount: weeklyTasks.length,
      weeklyDayProgress: dayProgresses,
      topFailureReasons: failureMap.entries
          .map((e) => ReasonCount(reason: e.key, count: e.value))
          .toList()
        ..sort((a, b) => b.count.compareTo(a.count)),
      topSuccessReasons: successMap.entries
          .map((e) => ReasonCount(reason: e.key, count: e.value))
          .toList()
        ..sort((a, b) => b.count.compareTo(a.count)),
    );
  }

  void _startScheduleObserver() {
    _scheduleObserver?.cancel();
    _scheduleObserver =
        Timer.periodic(const Duration(seconds: 10), (_) async {
      final now = DateTime.now();
      final pending =
          _allTasks.where((t) => t.status == 'PENDING').toList();
      final match = pending.where((t) =>
          t.hour == now.hour && t.minute == now.minute).firstOrNull;
      if (match != null) {
        triggerTaskAlert(match);
      }
    });
  }

  Future<void> _prefillIfEmpty() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (_allTasks.isEmpty) {
      final now = DateTime.now();
      final daysAgo = (int d) =>
          now.subtract(Duration(days: d)).millisecondsSinceEpoch;

      await _db.insertTask(Task(
        title: 'Database indexing study',
        description: 'Raat ko focused index optimization check',
        hour: 21,
        minute: 30,
        durationMinutes: 120,
        status: 'DONE',
        reason: 'Puri tarah focused tha (Fully Focused)',
        createdAt: daysAgo(1),
        completedAt: daysAgo(1) + 7200000,
      ));
      await _db.insertTask(Task(
        title: 'Compose animations testing',
        description: 'Tabs and bars transition test',
        hour: 20,
        minute: 0,
        durationMinutes: 90,
        status: 'NOT_DONE',
        reason: 'Thak gaya tha/Neend aa rahi thi (Tired/Sleepy)',
        createdAt: daysAgo(2),
        completedAt: daysAgo(2) + 5400000,
      ));
      await _db.insertTask(Task(
        title: 'Figma design converting',
        description: 'NitePlan visual converting',
        hour: 22,
        minute: 0,
        durationMinutes: 180,
        status: 'DONE',
        reason: 'Time se pehle khatam kar liya (Finished Early)',
        createdAt: daysAgo(3),
        completedAt: daysAgo(3) + 10800000,
      ));
      await _db.insertTask(Task(
        title: 'Network components audit',
        description: 'Inspect retrofit cache models',
        hour: 19,
        minute: 30,
        durationMinutes: 120,
        status: 'NOT_DONE',
        reason: 'Kisi aur zaroori kaam me lag gaya (Urgent conflict)',
        createdAt: daysAgo(4),
        completedAt: daysAgo(4) + 1,
      ));
      await _db.insertTask(Task(
        title: 'Self write logging setup',
        description: 'Keep records on excel',
        hour: 23,
        minute: 0,
        durationMinutes: 60,
        status: 'DONE',
        reason: 'Koi distractions nahi thhe (No Distractions)',
        createdAt: daysAgo(5),
        completedAt: daysAgo(5) + 3600000,
      ));
      await _loadTasks();
    }
  }

  Future<void> scheduleTask({
    required String title,
    required String description,
    required int hour,
    required int minute,
    required double durationHr,
  }) async {
    final task = Task(
      title: title,
      description: description,
      hour: hour,
      minute: minute,
      durationMinutes: (durationHr * 60).toInt(),
    );
    await _db.insertTask(task);
    await _loadTasks();
  }

  Future<void> deleteTask(Task task) async {
    if (_runningTask?.id == task.id) {
      _timerTick?.cancel();
      _runningTask = null;
      _timerIsRunning = false;
    }
    await _db.deleteTask(task.id!);
    await _loadTasks();
  }

  Future<void> triggerTaskAlert(Task task) async {
    final updated = task.copyWith(status: 'RUNNING');
    await _db.updateTask(updated);
    _notificationAlertTask = updated;
    startTimerForTask(updated);
    await _loadTasks();
  }

  void dismissAlert() {
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

  void cancelFeedbackDialog() {
    _feedbackDialogTask = null;
    notifyListeners();
  }

  Future<void> submitTaskFeedback(
      Task task, bool isDone, String reason) async {
    final updated = task.copyWith(
      status: isDone ? 'DONE' : 'NOT_DONE',
      reason: reason,
      completedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _db.updateTask(updated);
    if (_feedbackDialogTask?.id == task.id) {
      _feedbackDialogTask = null;
    }
    if (_runningTask?.id == task.id) {
      _runningTask = null;
      _timerIsRunning = false;
      _timerTick?.cancel();
    }
    await _loadTasks();
  }

  @override
  void dispose() {
    _timerTick?.cancel();
    _scheduleObserver?.cancel();
    super.dispose();
  }
}
