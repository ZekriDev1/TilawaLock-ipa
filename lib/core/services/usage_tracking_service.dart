import 'dart:async';
import 'package:usage_stats/usage_stats.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'local_database_manager.dart';

class UsageTrackingService {
  // Singleton pattern
  static final UsageTrackingService _instance = UsageTrackingService._internal();
  factory UsageTrackingService() => _instance;
  UsageTrackingService._internal();

  Timer? _timer;
  final _controller = StreamController<String>.broadcast();
  
  // Set of apps that are temporarily unlocked for the current session
  static final Set<String> _tempUnlockedApps = {};

  Stream<String> get foregroundAppStream => _controller.stream;

  static void unlockApp(String packageName) {
    _tempUnlockedApps.add(packageName);
    FlutterOverlayWindow.closeOverlay();
  }

  void startMonitoring() {
    // Prevent multiple timers
    _timer?.cancel();
    
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      // Check if we have usage stats permission
      bool? isPermissionGranted = await UsageStats.checkUsagePermission();
      if (isPermissionGranted != true) return;

      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(const Duration(seconds: 5));

      List<UsageInfo> usageStats = await UsageStats.queryUsageStats(startDate, endDate);
      
      if (usageStats.isNotEmpty) {
        // Find the one with most recent lastTimeUsed
        usageStats.sort((a, b) => b.lastTimeUsed!.compareTo(a.lastTimeUsed!));
        String currentApp = usageStats.first.packageName!;
        
        // Don't lock our own app
        if (currentApp == "com.zekri.tilawalock") {
          return;
        }

        _controller.add(currentApp);
        _checkIfAppShouldBeLocked(currentApp);
      }
    });
  }

  void stopMonitoring() {
    _timer?.cancel();
  }

  void _checkIfAppShouldBeLocked(String packageName) async {
    List<String> lockedApps = LocalDatabaseManager.getLockedApps();
    
    if (lockedApps.contains(packageName)) {
      // Check if it's already temporarily unlocked
      if (_tempUnlockedApps.contains(packageName)) {
        return;
      }

      // If we haven't already shown the overlay for this app
      bool? isActive = await FlutterOverlayWindow.isActive();
      if (isActive != true) {
        print("Locked app detected: $packageName. Showing overlay.");
        
        await FlutterOverlayWindow.showOverlay(
          enableDrag: false,
          overlayContent: "Time for Tilawa",
          flag: OverlayFlag.focusPointer,
          visibility: NotificationVisibility.visibilityPublic,
          positionGravity: PositionGravity.fullScreen,
        );
      }
    } else {
      // If user switched to an unlocked app or our app, close overlay if it was open
      bool? isActive = await FlutterOverlayWindow.isActive();
      if (isActive == true) {
        FlutterOverlayWindow.closeOverlay();
      }
    }
  }
}
