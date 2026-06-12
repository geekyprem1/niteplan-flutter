import 'package:workmanager/workmanager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sync_manager.dart';

const kSyncTaskName = 'niteplan_background_sync';

// Must be top-level function
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      await Firebase.initializeApp();
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.isAnonymous) {
        await SyncManager.instance.syncAll();
      }
    } catch (e) {
      // Silent fail — will retry next cycle
    }
    return Future.value(true);
  });
}

class BackgroundSync {
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  }

  static Future<void> registerPeriodicSync() async {
    await Workmanager().registerPeriodicTask(
      kSyncTaskName,
      kSyncTaskName,
      frequency: const Duration(minutes: 15),
      existingWorkPolicy: ExistingWorkPolicy.keep,
      constraints: Constraints(networkType: NetworkType.connected),
      backoffPolicy: BackoffPolicy.exponential,
      backoffPolicyDelay: const Duration(minutes: 1),
    );
  }

  static Future<void> cancelSync() async {
    await Workmanager().cancelByUniqueName(kSyncTaskName);
  }

  static Future<void> runImmediateSync() async {
    await Workmanager().registerOneOffTask(
      '${kSyncTaskName}_immediate',
      kSyncTaskName,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }
}
