import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import '../data/task_model.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._init();
  
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Function(int)? onNotificationTapped;
  int? _initialTappedTaskId;

  int? consumeInitialTappedTaskId() {
    final id = _initialTappedTaskId;
    _initialTappedTaskId = null;
    return id;
  }

  NotificationService._init();

  Future<void> init() async {
    // 1. Initialize Timezones
    tz.initializeTimeZones();
    try {
      String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      print("[NotificationService] Detected timezone: $currentTimeZone");
      
      // Map legacy/deprecated timezone names to modern equivalents supported by timezone package
      final mapping = {
        'Asia/Calcutta': 'Asia/Kolkata',
        'Asia/Saigon': 'Asia/Ho_Chi_Minh',
        'Asia/Katmandu': 'Asia/Kathmandu',
        'Africa/Asmera': 'Africa/Asmara',
        'Atlantic/Jan_Mayen': 'Europe/Oslo',
      };
      if (mapping.containsKey(currentTimeZone)) {
        print("[NotificationService] Mapping legacy timezone $currentTimeZone to ${mapping[currentTimeZone]}");
        currentTimeZone = mapping[currentTimeZone]!;
      }
      
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
      print("[NotificationService] Timezone successfully set to: ${tz.local.name}");
    } catch (e, stack) {
      print("[NotificationService] ERROR: Timezone lookup failed: $e");
      print(stack);
      // Fallback to UTC if timezone lookup fails
      tz.setLocalLocation(tz.getLocation('UTC'));
      print("[NotificationService] Timezone fallback set to: ${tz.local.name}");
    }

    // 2. Initialize Notifications Settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          final int? taskId = int.tryParse(response.payload!);
          if (taskId != null) {
            if (onNotificationTapped != null) {
              onNotificationTapped!(taskId);
            } else {
              _initialTappedTaskId = taskId;
            }
          }
        }
      },
    );

    // Create Android notification channel explicitly
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'whyly_task_reminders', // id
        'Task Reminders', // title
        description: 'Reminders for your planned tasks', // description
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );
      try {
        await androidPlugin.createNotificationChannel(channel);
        print("[NotificationService] SUCCESS: Created notification channel 'whyly_task_reminders'");
      } catch (e) {
        print("[NotificationService] ERROR: Failed to create notification channel: $e");
      }
    }

    // Check if the app was launched by tapping a notification
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _notificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      final NotificationResponse? response =
          notificationAppLaunchDetails?.notificationResponse;
      if (response != null && response.payload != null) {
        _initialTappedTaskId = int.tryParse(response.payload!);
      }
    }
  }

  /// Request Android 13+ Notification & Exact Alarm permissions, and iOS permissions
  Future<void> requestPermissions() async {
    // Request Android notification permissions
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
      try {
        await androidPlugin.requestExactAlarmsPermission();
      } catch (_) {
        // Safe catch for older OS versions where this is not supported or not required
      }
    }

    // Request iOS permissions
    final iosPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  /// Schedule a local notification reminder at the OS level
  Future<void> scheduleTaskReminder(Task task) async {
    if (task.id == null) return;

    // Parse scheduled date
    final dateParts = task.plannedDate.split('-');
    if (dateParts.length != 3) return;

    final int year = int.parse(dateParts[0]);
    final int month = int.parse(dateParts[1]);
    final int day = int.parse(dateParts[2]);

    final localScheduleTime = DateTime(year, month, day, task.hour, task.minute);
    final zonedScheduleTime = tz.TZDateTime.from(localScheduleTime, tz.local);

    print("[NotificationService] Scheduling task: '${task.title}' (ID: ${task.id}) on ${task.plannedDate} at ${task.hour}:${task.minute}");
    print("[NotificationService] Local scheduled time: $localScheduleTime");
    print("[NotificationService] Local timezone: ${tz.local.name}");
    print("[NotificationService] Zoned scheduled time: $zonedScheduleTime");
    print("[NotificationService] Current zoned time: ${tz.TZDateTime.now(tz.local)}");

    // If scheduled time is in the past, do not schedule
    if (zonedScheduleTime.isBefore(tz.TZDateTime.now(tz.local))) {
      print("[NotificationService] WARNING: Scheduled time is in the past! Skipping scheduling.");
      return;
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'whyly_task_reminders',
      'Task Reminders',
      channelDescription: 'Reminders for your planned tasks',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notificationsPlugin.zonedSchedule(
        task.id!,
        task.title,
        task.description.isNotEmpty ? task.description : 'Time for your task!',
        zonedScheduleTime,
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: task.id!.toString(),
      );
      print("[NotificationService] SUCCESS: Notification scheduled for task ${task.id}");
    } catch (e, stack) {
      print("[NotificationService] ERROR: Failed to schedule exact alarm: $e");
      print(stack);
    }
  }

  /// Show an immediate notification for testing
  Future<void> showImmediateNotification(int id, String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'whyly_task_reminders',
      'Task Reminders',
      channelDescription: 'Reminders for your planned tasks',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notificationsPlugin.show(id, title, body, notificationDetails);
      print("[NotificationService] SUCCESS: Immediate notification shown");
    } catch (e) {
      print("[NotificationService] ERROR: Failed to show immediate notification: $e");
    }
  }

  /// Cancel a scheduled local notification reminder
  Future<void> cancelTaskReminder(int taskId) async {
    await _notificationsPlugin.cancel(taskId);
  }

  /// Reschedule all active pending reminders
  Future<void> rescheduleAllPendingReminders(List<Task> pendingTasks) async {
    // Cancel any existing alarms scheduled by the plugin to avoid duplicate alarms
    await _notificationsPlugin.cancelAll();
    
    // Reschedule only the future pending tasks
    for (final task in pendingTasks) {
      await scheduleTaskReminder(task);
    }
  }
}
