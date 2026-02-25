import 'package:permission_handler/permission_handler.dart';

/// Result of a permission request, providing context for UI decisions.
enum MicPermissionResult {
  granted,          // Permission is granted – safe to start recording
  denied,           // Denied but can ask again next time
  permanentlyDenied,// Denied permanently – must send user to Settings
  restricted,       // Restricted by parental controls / MDM (iOS)
  unknown,          // Unknown / error state
}

/// Centralized service for managing microphone (and other) permissions.
///
/// Design goals:
///  - Single source of truth for permission state
///  - Never requests permission while app is inactive (iOS crash prevention)
///  - Separates status-check from request to avoid duplicate dialogs
///  - All async errors are swallowed and returned as [unknown]
class PermissionManager {
  PermissionManager._(); // Singleton via factory
  static final PermissionManager instance = PermissionManager._();

  // ─────────────────────────────────────────────────────────────
  // MICROPHONE
  // ─────────────────────────────────────────────────────────────

  /// Checks the *current* microphone permission status without triggering
  /// a system dialog. Safe to call at any lifecycle state.
  Future<MicPermissionResult> checkMicrophone() async {
    try {
      final status = await Permission.microphone.status;
      return _mapStatus(status);
    } catch (e) {
      // Defensive: status check should never throw but guard anyway.
      return MicPermissionResult.unknown;
    }
  }

  /// Requests microphone permission. Shows the system dialog on first call.
  ///
  /// ⚠️  Call ONLY when the app is in [AppLifecycleState.resumed].
  /// On iOS, requesting permission while inactive/background can cause
  /// unexpected behavior.
  Future<MicPermissionResult> requestMicrophone() async {
    try {
      final status = await Permission.microphone.request();
      return _mapStatus(status);
    } catch (e) {
      return MicPermissionResult.unknown;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // NOTIFICATIONS
  // ─────────────────────────────────────────────────────────────

  Future<MicPermissionResult> checkNotification() async {
    try {
      final status = await Permission.notification.status;
      return _mapStatus(status);
    } catch (e) {
      return MicPermissionResult.unknown;
    }
  }

  Future<MicPermissionResult> requestNotification() async {
    try {
      final status = await Permission.notification.request();
      return _mapStatus(status);
    } catch (e) {
      return MicPermissionResult.unknown;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // SYSTEM ALERT WINDOW (Android overlay)
  // ─────────────────────────────────────────────────────────────

  Future<MicPermissionResult> checkOverlay() async {
    try {
      final status = await Permission.systemAlertWindow.status;
      return _mapStatus(status);
    } catch (e) {
      return MicPermissionResult.unknown;
    }
  }

  /// Overlay always requires Settings page on Android 6+.
  /// Call openAppSettings() directly – do not call .request() for this one.
  Future<void> openSettings() => openAppSettings();

  // ─────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────

  MicPermissionResult _mapStatus(PermissionStatus status) {
    if (status.isGranted) return MicPermissionResult.granted;
    if (status.isPermanentlyDenied) return MicPermissionResult.permanentlyDenied;
    if (status.isRestricted) return MicPermissionResult.restricted;
    if (status.isDenied) return MicPermissionResult.denied;
    return MicPermissionResult.unknown;
  }
}
