import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'permission_manager.dart';

/// A mixin that adds lifecycle-aware permission re-checking to any [State].
///
/// Usage:
///   class _MyState extends State<MyWidget>
///       with WidgetsBindingObserver, LifecyclePermissionMixin {
///
///     @override
///     void onMicPermissionChanged(MicPermissionResult result) {
///       setState(() => _micGranted = result == MicPermissionResult.granted);
///     }
///   }
///
/// The mixin will:
///  1. Register/unregister the observer automatically (caller must call
///     super.initState() / super.dispose() – or call the provided helpers).
///  2. Re-check microphone status on every [AppLifecycleState.resumed].
///  3. Guarantee no duplicate requests and no calls while inactive.
mixin LifecyclePermissionMixin<T extends StatefulWidget>
    on State<T>, WidgetsBindingObserver {
  // Track the last known result to avoid redundant setState() calls.
  MicPermissionResult _lastMicResult = MicPermissionResult.unknown;

  // Whether a permission request is currently in-flight (prevents doubles).
  bool _isRequestingMic = false;

  // ─────────────────────────────────────────────────────────────
  // Init / dispose helpers – must be called by the consumer State.
  // ─────────────────────────────────────────────────────────────

  /// Call this inside your [initState] after [super.initState()].
  void initLifecyclePermission() {
    WidgetsBinding.instance.addObserver(this);
    // Do the initial check after first frame so context is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshMic());
  }

  /// Call this inside your [dispose] before [super.dispose()].
  void disposeLifecyclePermission() {
    WidgetsBinding.instance.removeObserver(this);
  }

  // ─────────────────────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────────────────────

  /// Called by Flutter when app lifecycle changes.
  /// We only care about [AppLifecycleState.resumed] – when the user
  /// has just switched back from the system Settings page.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Guard: do NOT touch the microphone/permissions while inactive.
      _refreshMic();
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Permission check (NO dialog shown – status only)
  // ─────────────────────────────────────────────────────────────

  Future<void> _refreshMic() async {
    // Defensive: avoid acting on a disposed widget.
    if (!mounted) return;

    final result = await PermissionManager.instance.checkMicrophone();

    // Only rebuild UI when the state has actually changed.
    if (result != _lastMicResult) {
      _lastMicResult = result;
      if (mounted) {
        onMicPermissionChanged(result);
      }
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Public API for the consumer widget
  // ─────────────────────────────────────────────────────────────

  /// Override this in your State to react to permission changes.
  void onMicPermissionChanged(MicPermissionResult result) {}

  /// Call this when the user taps the "Record" / "Allow" button.
  ///
  /// Handles the full flow:
  ///   granted            → calls [onMicPermissionChanged] with granted
  ///   denied             → shows system dialog (first time only)
  ///   permanentlyDenied  → opens Settings via [showPermissionSettingsDialog]
  Future<void> requestMicPermission(BuildContext context) async {
    // Prevent duplicate simultaneous requests.
    if (_isRequestingMic) return;
    _isRequestingMic = true;

    try {
      // Check current state – never assume.
      final current = await PermissionManager.instance.checkMicrophone();

      if (current == MicPermissionResult.granted) {
        _lastMicResult = current;
        if (mounted) onMicPermissionChanged(current);
        return;
      }

      if (current == MicPermissionResult.permanentlyDenied ||
          current == MicPermissionResult.restricted) {
        // Cannot show dialog – must go to Settings.
        if (mounted) {
          showPermissionSettingsDialog(context);
        }
        return;
      }

      // First-time / previously denied → try to show system dialog.
      // ⚠️ Only call .request() when the app is active (resumed).
      final result = await PermissionManager.instance.requestMicrophone();
      _lastMicResult = result;

      if (!mounted) return;

      if (result == MicPermissionResult.permanentlyDenied) {
        // User hit "Don't ask again" just now → need a local ref for context.
        // ignore: use_build_context_synchronously
        showPermissionSettingsDialog(context);
      } else {
        onMicPermissionChanged(result);
      }
    } finally {
      // Always unlock even if an error occurs.
      _isRequestingMic = false;
    }
  }

  /// Shows an explanation dialog that directs the user to device Settings.
  /// After returning from Settings, [didChangeAppLifecycleState] fires and
  /// automatically re-checks the permission.
  void showPermissionSettingsDialog(BuildContext context) {
    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Microphone Access Required',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Microphone permission was denied.\n\n'
          'Please tap "Open Settings", enable the Microphone permission '
          'for Tilawa Lock, then come back to the app.\n\n'
          'The app will detect the change automatically.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Not Now'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              // Opens the app-level settings page.
              // When user returns, didChangeAppLifecycleState(resumed) fires.
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// Convenience getter for the current known mic status.
  MicPermissionResult get currentMicResult => _lastMicResult;
  bool get isMicGranted => _lastMicResult == MicPermissionResult.granted;
}
