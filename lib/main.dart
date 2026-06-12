import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme/app_theme.dart';
import 'viewmodel/task_viewmodel.dart';
import 'auth/auth_viewmodel.dart';
import 'auth/auth_gate.dart';
import 'sync/background_sync.dart';
import 'l10n/language_provider.dart';
import 'screens/scheduler_tab.dart';
import 'screens/active_timer_tab.dart';
import 'screens/reflection_tab.dart';
import 'screens/discipline_score_tab.dart';
import 'profile/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await BackgroundSync.initialize();

  final langProvider = LanguageProvider();
  await langProvider.loadSavedLanguage();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider.value(value: langProvider),
      ],
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
      home: AuthGate(home: const NitePlanHome()),
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
    final authVm = context.watch<AuthViewModel>();
    final lang = context.watch<LanguageProvider>();
    final tabTitles = [
      lang.tr('appbar_plan'),
      lang.tr('appbar_focus'),
      lang.tr('appbar_reflect'),
      lang.tr('appbar_score'),
    ];
    final tabLabels = [
      lang.tr('tab_plan'),
      lang.tr('tab_focus'),
      lang.tr('tab_reflect'),
      lang.tr('tab_score'),
    ];

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
                  tabTitles[_tab],
                  style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Reflection reminder badge
          if (!vm.hasReflectedToday && DateTime.now().hour >= 21)
            IconButton(
              icon: Stack(children: [
                const Icon(Icons.nights_stay, color: kWarning),
                Positioned(right: 0, top: 0, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: kDanger, shape: BoxShape.circle))),
              ]),
              onPressed: () => setState(() => _tab = 2),
            ),

          // Guest upgrade badge
          if (authVm.isGuest)
            IconButton(
              icon: Stack(children: [
                const Icon(Icons.cloud_off, color: kWarning, size: 22),
                Positioned(right: 0, top: 0, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: kWarning, shape: BoxShape.circle))),
              ]),
              tooltip: 'Guest Mode',
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
            ),

          // Profile button
          IconButton(
            icon: CircleAvatar(
              radius: 14,
              backgroundColor: kAccent.withValues(alpha: 0.2),
              backgroundImage: authVm.currentUser?.photoURL != null
                  ? NetworkImage(authVm.currentUser!.photoURL!)
                  : null,
              child: authVm.currentUser?.photoURL == null
                  ? Text(
                      authVm.isGuest ? '👤' : (authVm.currentUser?.displayName?.substring(0, 1).toUpperCase() ?? '?'),
                      style: const TextStyle(fontSize: 12),
                    )
                  : null,
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
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
          NavigationDestination(icon: const Icon(Icons.event_note_outlined), selectedIcon: const Icon(Icons.event_note), label: tabLabels[0]),
          NavigationDestination(
            icon: Badge(isLabelVisible: vm.runningTask != null, backgroundColor: kSuccess, label: const Text('●', style: TextStyle(fontSize: 6)), child: const Icon(Icons.timer_outlined)),
            selectedIcon: const Icon(Icons.timer),
            label: tabLabels[1],
          ),
          NavigationDestination(
            icon: Badge(isLabelVisible: !vm.hasReflectedToday && DateTime.now().hour >= 21, backgroundColor: kDanger, label: const Text('!'), child: const Icon(Icons.nights_stay_outlined)),
            selectedIcon: const Icon(Icons.nights_stay),
            label: tabLabels[2],
          ),
          NavigationDestination(icon: const Icon(Icons.bar_chart_outlined), selectedIcon: const Icon(Icons.bar_chart), label: tabLabels[3]),
        ],
      ),
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
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('⏰', style: TextStyle(fontSize: 36)),
          const Text('Kaam Ka Waqt Ho Gaya!', style: TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
          Text(task.title, style: const TextStyle(color: kAccent, fontWeight: FontWeight.w900, fontSize: 18), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () { vm.dismissAlert(); onTimer(); },
              child: const Text('Chalo Shuru Karte Hain! 🚀', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          TextButton(onPressed: vm.dismissAlert, child: const Text('Baad mein', style: TextStyle(color: kTextMuted))),
        ]),
      ),
    );
  }
}
