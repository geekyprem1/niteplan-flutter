import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'viewmodel/task_viewmodel.dart';
import 'screens/scheduler_tab.dart';
import 'screens/active_timer_tab.dart';
import 'screens/reflection_tab.dart';
import 'screens/discipline_score_tab.dart';
import 'screens/future_self_screen.dart';

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
  int _tab = 0;

  final _screens = const [
    SchedulerTab(),
    ActiveTimerTab(),
    ReflectionTab(),
    DisciplineScoreTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();

    return Scaffold(
      backgroundColor: kSurface,
      appBar: AppBar(
        backgroundColor: kSurface,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('NITEPLAN', style: TextStyle(color: kAccent, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
            Row(
              children: [
                const Text('🌙 ', style: TextStyle(fontSize: 14)),
                Text(
                  ['Plan Karo', 'Focus Karo', 'Reflect Karo', 'Grow Karo'][_tab],
                  style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Reflection reminder badge
          if (!vm.hasReflectedToday && DateTime.now().hour >= 21)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.nights_stay, color: kWarning),
                    Positioned(
                      right: 0, top: 0,
                      child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: kDanger, shape: BoxShape.circle)),
                    ),
                  ],
                ),
                onPressed: () => setState(() => _tab = 2),
              ),
            ),
          // Future Self Letters
          IconButton(
            icon: const Icon(Icons.mail_outline, color: kTextMuted),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FutureSelfScreen())),
          ),
          // Running task dot
          if (vm.runningTask != null)
            Padding(
              padding: const EdgeInsets.only(right: 16, top: 12),
              child: Container(
                width: 10, height: 10,
                decoration: BoxDecoration(
                  color: vm.timerIsRunning ? kSuccess : kWarning,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: (vm.timerIsRunning ? kSuccess : kWarning).withValues(alpha: 0.5), blurRadius: 6)],
                ),
              ),
            ),
        ],
      ),
      body: IndexedStack(index: _tab, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        backgroundColor: kCardBg,
        height: 65,
        destinations: [
          const NavigationDestination(icon: Icon(Icons.event_note_outlined), selectedIcon: Icon(Icons.event_note), label: 'Plan'),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: vm.runningTask != null,
              backgroundColor: kSuccess,
              label: const Text('●', style: TextStyle(fontSize: 6)),
              child: const Icon(Icons.timer_outlined),
            ),
            selectedIcon: const Icon(Icons.timer),
            label: 'Focus',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: !vm.hasReflectedToday && DateTime.now().hour >= 21,
              backgroundColor: kDanger,
              label: const Text('!'),
              child: const Icon(Icons.nights_stay_outlined),
            ),
            selectedIcon: const Icon(Icons.nights_stay),
            label: 'Reflect',
          ),
          const NavigationDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart), label: 'Score'),
        ],
      ),

      // Scheduled Task Alert
      floatingActionButton: vm.notificationAlertTask != null
          ? _TaskAlertOverlay(vm: vm, onTimer: () => setState(() => _tab = 1))
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _TaskAlertOverlay extends StatelessWidget {
  final TaskViewModel vm;
  final VoidCallback onTimer;
  const _TaskAlertOverlay({required this.vm, required this.onTimer});

  @override
  Widget build(BuildContext context) {
    final task = vm.notificationAlertTask!;
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: kAccent.withValues(alpha: 0.5)),
          boxShadow: [BoxShadow(color: kAccent.withValues(alpha: 0.2), blurRadius: 20)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('⏰', style: TextStyle(fontSize: 36)),
            const SizedBox(height: 4),
            const Text('Kaam Ka Waqt Ho Gaya!', style: TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(task.title, style: const TextStyle(color: kAccent, fontWeight: FontWeight.w900, fontSize: 18), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text('${task.durationMinutes} min · ${task.hour.toString().padLeft(2,'0')}:${task.minute.toString().padLeft(2,'0')}', style: const TextStyle(color: kTextMuted, fontSize: 13)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () { vm.dismissAlert(); onTimer(); },
                child: const Text('Chalo Shuru Karte Hain! 🚀', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            TextButton(onPressed: vm.dismissAlert, child: const Text('Baad mein', style: TextStyle(color: kTextMuted))),
          ],
        ),
      ),
    );
  }
}
