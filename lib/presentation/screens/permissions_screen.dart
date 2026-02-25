import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:tilawalock/l10n/app_localizations.dart';
import '../../core/constants/colors.dart';
import '../../core/services/permission_manager.dart';
import '../../core/services/lifecycle_permission_handler.dart';
import 'app_selection_screen.dart';
import 'home_dashboard_screen.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

/// Uses [LifecyclePermissionMixin] so:
///   - Permission re-checked automatically when user returns from Settings
///   - No crashes from stale state
///   - No duplicate requests
class _PermissionsScreenState extends State<PermissionsScreen>
    with WidgetsBindingObserver, LifecyclePermissionMixin {
  // Track each individual permission for the UI.
  bool _isMicGranted = false;
  bool _isNotificationGranted = false;
  bool _isOverlayGranted = false;
  bool _isUsageGranted = false;

  // Guard: prevents requesting while another request is in flight.
  bool _isRequestingNotification = false;

  @override
  void initState() {
    super.initState();
    // Register lifecycle observer + schedule initial permission check.
    initLifecyclePermission();
    // Also check the other permissions on launch.
    _checkAllPermissions();
  }

  @override
  void dispose() {
    // Must unregister before disposal to prevent memory leaks / crashes.
    disposeLifecyclePermission();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────
  // Called by LifecyclePermissionMixin whenever mic state changes
  // (including on resume from Settings)
  // ─────────────────────────────────────────────────────────────
  @override
  void onMicPermissionChanged(MicPermissionResult result) {
    if (!mounted) return; // Safety: never setState on a disposed widget
    setState(() => _isMicGranted = result == MicPermissionResult.granted);
  }

  // ─────────────────────────────────────────────────────────────
  // Check notification + overlay on resume too (via lifecycle)
  // ─────────────────────────────────────────────────────────────
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Let the mixin handle the mic re-check.
    super.didChangeAppLifecycleState(state);

    // Also refresh notifications + overlay on resume.
    if (state == AppLifecycleState.resumed) {
      _checkAllPermissions();
    }
  }

  Future<void> _checkAllPermissions() async {
    if (!mounted) return;
    final notification = await PermissionManager.instance.checkNotification();
    final overlay = await PermissionManager.instance.checkOverlay();

    if (!mounted) return;
    setState(() {
      _isNotificationGranted = notification == MicPermissionResult.granted;
      _isOverlayGranted = overlay == MicPermissionResult.granted;
      // Treat overlay granted as a proxy for usage stats (both advanced Android)
      _isUsageGranted = overlay == MicPermissionResult.granted;
    });
  }

  // ─────────────────────────────────────────────────────────────
  // Permission request handlers
  // ─────────────────────────────────────────────────────────────

  Future<void> _requestMic() async {
    // Delegates to LifecyclePermissionMixin which handles all edge cases.
    await requestMicPermission(context);
  }

  Future<void> _requestNotification() async {
    if (_isRequestingNotification || !mounted) return;
    _isRequestingNotification = true;
    try {
      final current = await PermissionManager.instance.checkNotification();

      if (current == MicPermissionResult.granted) {
        if (mounted) setState(() => _isNotificationGranted = true);
        return;
      }

      if (current == MicPermissionResult.permanentlyDenied) {
        if (mounted) _showSettingsDialog('Notifications', 'notification');
        return;
      }

      final result = await PermissionManager.instance.requestNotification();
      if (!mounted) return;

      if (result == MicPermissionResult.permanentlyDenied) {
        _showSettingsDialog('Notifications', 'notification');
      } else {
        setState(() => _isNotificationGranted = result == MicPermissionResult.granted);
      }
    } finally {
      _isRequestingNotification = false;
    }
  }

  /// Usage Stats + Overlay both require the dedicated Android Settings page.
  void _requestUsage() {
    if (!mounted) return;
    _showSettingsDialog(
      'Usage Statistics Access',
      'usage stats',
      detail: 'Please enable "Usage Access" or "Apps with usage access" for Tilawa Lock.',
    );
  }

  void _requestOverlay() {
    if (!mounted) return;
    _showSettingsDialog(
      'Display Over Other Apps',
      'overlay',
      detail: 'Please enable "Display over other apps" for Tilawa Lock.',
    );
  }

  void _showSettingsDialog(String permName, String shortName, {String? detail}) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '$permName Permission',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.emerald,
          ),
        ),
        content: Text(
          detail ??
              '$permName permission was denied. Please enable it in '
                  'Settings for Tilawa Lock.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              // When user returns, didChangeAppLifecycleState(resumed)
              // automatically triggers _checkAllPermissions().
              PermissionManager.instance.openSettings();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.emerald),
            child: const Text('Open Settings',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Continue gating: microphone + notification are mandatory
  // ─────────────────────────────────────────────────────────────

  void _handleSkip() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeDashboardScreen()),
    );
  }

  bool get _canContinue => _isMicGranted && _isNotificationGranted;

  void _handleContinue() {
    if (_canContinue) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AppSelectionScreen()),
      );
    } else {
      final missing = [
        if (!_isMicGranted) 'Microphone',
        if (!_isNotificationGranted) 'Notifications',
      ].join(' and ');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please grant $missing to continue.'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // UI
  // ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Skip button row ────────────────────────────
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: TextButton(
                  onPressed: _handleSkip,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.emerald.withValues(alpha: 0.65),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              FadeInDown(
                child: Text(
                  l10n.permissionsTitle,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              FadeInDown(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  l10n.permissionsSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.emerald.withOpacity(0.7),
                      ),
                ),
              ),
              const SizedBox(height: 40),

              // ── Microphone (mandatory) ─────────────
              _PermissionTile(
                title: l10n.microphone,
                description: l10n.microphoneDesc,
                icon: Icons.mic_none_rounded,
                isGranted: _isMicGranted,
                isMandatory: true,
                onTap: _requestMic,
              ),

              // ── Notifications (mandatory) ──────────
              _PermissionTile(
                title: l10n.notifications,
                description: l10n.notificationsDesc,
                icon: Icons.notifications_none_rounded,
                isGranted: _isNotificationGranted,
                isMandatory: true,
                onTap: _requestNotification,
              ),

              // ── Usage Stats (optional / Android) ──
              _PermissionTile(
                title: l10n.usageStats,
                description: l10n.usageStatsDesc,
                icon: Icons.bar_chart_rounded,
                isGranted: _isUsageGranted,
                isMandatory: false,
                onTap: _requestUsage,
              ),

              // ── System Overlay (optional / Android) ─
              _PermissionTile(
                title: l10n.overlay,
                description: l10n.overlayDesc,
                icon: Icons.layers_outlined,
                isGranted: _isOverlayGranted,
                isMandatory: false,
                onTap: _requestOverlay,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canContinue
                        ? AppColors.emerald
                        : AppColors.emerald.withOpacity(0.45),
                  ),
                  child: Text(l10n.continueText),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable permission row widget
// ─────────────────────────────────────────────────────────────────────────────

class _PermissionTile extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isGranted;
  final bool isMandatory;
  final VoidCallback onTap;

  const _PermissionTile({
    required this.title,
    required this.description,
    required this.icon,
    required this.isGranted,
    required this.isMandatory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isGranted
            ? Border.all(color: AppColors.gold.withOpacity(0.4), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                (isGranted ? AppColors.gold : AppColors.emerald).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isGranted ? AppColors.gold : AppColors.emerald,
          ),
        ),
        title: Row(
          children: [
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            if (isMandatory) ...[
              const SizedBox(width: 4),
              const Text('*',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ],
          ],
        ),
        subtitle: Text(description,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        trailing: isGranted
            ? const Icon(Icons.check_circle, color: AppColors.gold)
            : ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  minimumSize: const Size(80, 36),
                ),
                child: Text(l10n.allow),
              ),
      ),
    );
  }
}
