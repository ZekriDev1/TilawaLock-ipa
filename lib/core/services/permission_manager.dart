import 'package:permission_handler/permission_handler.dart';

enum PermissionResult {
  granted,
  denied,
  permanentlyDenied,
  unknown,
}

class PermissionManager {
  PermissionManager._();
  static final PermissionManager instance = PermissionManager._();

  Future<PermissionResult> requestMicrophone() async {
    final status = await Permission.microphone.request();
    return _mapStatus(status);
  }

  Future<PermissionResult> checkMicrophone() async {
    final status = await Permission.microphone.status;
    return _mapStatus(status);
  }

  Future<PermissionResult> requestNotification() async {
    final status = await Permission.notification.request();
    return _mapStatus(status);
  }

  Future<PermissionResult> requestOverlay() async {
    final status = await Permission.systemAlertWindow.request();
    return _mapStatus(status);
  }

  Future<PermissionResult> requestUsageStats() async {
    final status = await Permission.ignoreBatteryOptimizations.request();
    // usage_stats usually handled by native channel or specific intent,
    // but here we map the permission_handler statuses.
    return _mapStatus(status);
  }

  PermissionResult _mapStatus(PermissionStatus status) {
    if (status.isGranted) return PermissionResult.granted;
    if (status.isPermanentlyDenied) return PermissionResult.permanentlyDenied;
    if (status.isDenied) return PermissionResult.denied;
    return PermissionResult.unknown;
  }
}
