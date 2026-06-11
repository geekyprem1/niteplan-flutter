import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'viewmodel/task_viewmodel.dart';
import 'screens/scheduler_tab.dart';
import 'screens/active_timer_tab.dart';
import 'screens/analytics_tab.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskViewModel(),
      child: const NitePlanApp(),
    ),
  );
}

class NitePlanApp extends StatelessWidget {
  const NitePlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NitePlan',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const NitePlanHome(),
    );
  }
}

class NitePlanHome extends StatefulWidget {
  const NitePlanHome({super.key});

  @override
  State<NitePlanHome> createState() => _NitePlanHomeState();
}

class _NitePlanHomeState extends State<NitePlanHome> {
  int _selectedTab = 0;

  final List<Widget> _screens = const [
    SchedulerTab(),
    ActiveTimerTab(),
    AnalyticsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "TONIGHT'S PLAN",
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
                letterSpacing: 1,
              ),
            ),
            Row(
              children: [
                Icon(Icons.bedtime,
                    color: theme.colorScheme.primary, size: 18),
                const SizedBox(width: 6),
                Text(
                  'NitePlan',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (vm.runningTask != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 7,
                backgroundColor: vm.timerIsRunning
                    ? const Color(0xFF00E676)
                    : const Color(0xFFFF9100),
              ),
            ),
        ],
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: (i) => setState(() => _selectedTab = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.alarm_add),
            label: 'Planning',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: vm.runningTask != null,
              backgroundColor: vm.timerIsRunning
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFFFF9100),
              label: const Text('LIVE'),
              child: const Icon(Icons.timer),
            ),
            label: 'Timer',
          ),
          const NavigationDestination(
            icon: Icon(Icons.analytics),
            label: 'Progress',
          ),
        ],
      ),

      // Scheduled Alert Dialog
      floatingActionButton: vm.notificationAlertTask != null
          ? _ScheduledAlertOverlay(vm: vm,
              onGoToTimer: () => setState(() => _selectedTab = 1))
          : null,
    );
  }
}

class _ScheduledAlertOverlay extends StatelessWidget {
  final TaskViewModel vm;
  final VoidCallback onGoToTimer;

  const _ScheduledAlertOverlay(
      {required this.vm, required this.onGoToTimer});

  @override
  Widget build(BuildContext context) {
    final task = vm.notificationAlertTask!;
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.center,
        child: Card(
          margin: const EdgeInsets.all(24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.notifications_active,
                    color: theme.colorScheme.primary, size: 40),
                const SizedBox(height: 8),
                const Text('⏰ Kaam Ka Waqt Ho Gaya!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 8),
                Text(task.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 16),
                    textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Text('Target: ${task.durationMinutes} mins',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary)),
                      Text(
                          'Scheduled: ${task.hour.toString().padLeft(2, '0')}:${task.minute.toString().padLeft(2, '0')}'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    vm.dismissAlert();
                    onGoToTimer();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white),
                  child: const Text('Chalo Kaam Shuru Karein!',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                TextButton(
                  onPressed: vm.dismissAlert,
                  child: const Text('Baad Mein Karunga'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
