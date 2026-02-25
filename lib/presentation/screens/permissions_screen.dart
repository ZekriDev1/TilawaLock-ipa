import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:animate_do/animate_do.dart';
import 'package:tilawalock/l10n/app_localizations.dart';
import '../../core/constants/colors.dart';
import 'app_selection_screen.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen>
    with WidgetsBindingObserver {
  bool _isMicGranted = false;
  bool _isUsageGranted = false;
  bool _isNotificationGranted = false;
  bool _isOverlayGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Re-check permissions automatically when user returns from device Settings
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    final mic = await Permission.microphone.status;
    final notification = await Permission.notification.status;
    final overlay = await Permission.systemAlertWindow.status;

    setState(() {
      _isMicGranted = mic.isGranted;
      _isNotificationGranted = notification.isGranted;
      _isOverlayGranted = overlay.isGranted;
      // Mark usage as granted if overlay is granted (both are advanced perms)
      _isUsageGranted = overlay.isGranted;
    });
  }

  // ─────────────── MICROPHONE ───────────────
  Future<void> _requestMic() async {
    final status = await Permission.microphone.status;

    if (status.isGranted) {
      setState(() => _isMicGranted = true);
    } else if (status.isPermanentlyDenied) {
      // User hit "Don't ask again" → must go to Settings
      _showSettingsDialog(
        'Microphone Permission Required',
        'Microphone access was permanently denied. Please open Settings and enable it to use the recitation feature.',
      );
    } else {
      // isDenied or isRestricted → show system popup
      final result = await Permission.microphone.request();
      setState(() => _isMicGranted = result.isGranted);
      if (result.isPermanentlyDenied) {
        _showSettingsDialog(
          'Microphone Permission Required',
          'Please open Settings and enable Microphone access for Tilawa Lock.',
        );
      }
    }
  }

  // ─────────────── NOTIFICATIONS ───────────────
  Future<void> _requestNotification() async {
    final status = await Permission.notification.status;

    if (status.isGranted) {
      setState(() => _isNotificationGranted = true);
    } else if (status.isPermanentlyDenied) {
      _showSettingsDialog(
        'Notifications Permission Required',
        'Notification permission was permanently denied. Please enable it in Settings to receive session reminders.',
      );
    } else {
      final result = await Permission.notification.request();
      setState(() => _isNotificationGranted = result.isGranted);
      if (result.isPermanentlyDenied) {
        _showSettingsDialog(
          'Notifications Permission Required',
          'Please open Settings and enable Notifications for Tilawa Lock.',
        );
      }
    }
  }

  // ─────────────── USAGE STATS (Android) ───────────────
  Future<void> _requestUsage() async {
    // Usage Stats requires the special Android Settings page
    _showSettingsDialog(
      'Usage Statistics Access',
      'Tilawa Lock needs usage statistics access to monitor app usage. Tap "Open Settings" and enable it for Tilawa Lock.',
      onConfirm: () async {
        await openAppSettings();
        // _checkPermissions() will be called on resume via didChangeAppLifecycleState
      },
    );
  }

  // ─────────────── SYSTEM OVERLAY (Android) ───────────────
  Future<void> _requestOverlay() async {
    final status = await Permission.systemAlertWindow.status;

    if (status.isGranted) {
      setState(() => _isOverlayGranted = true);
    } else {
      // SYSTEM_ALERT_WINDOW always needs the dedicated Settings page on Android
      _showSettingsDialog(
        'Display Over Other Apps',
        'Tilawa Lock needs to display over other apps to show the lock screen. Tap "Open Settings" and enable "Display over other apps".',
        onConfirm: () async {
          await openAppSettings();
        },
      );
    }
  }

  // ─────────────── SETTINGS DIALOG ───────────────
  void _showSettingsDialog(String title, String message,
      {VoidCallback? onConfirm}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.emerald),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (onConfirm != null) {
                onConfirm();
              } else {
                openAppSettings();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.emerald),
            child: const Text('Open Settings',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Microphone + Notification are the minimum required permissions.
  /// Overlay + Usage are advanced Android-only and can be skipped.
  bool get _requiredGranted => _isMicGranted && _isNotificationGranted;

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
              const SizedBox(height: 20),
              FadeInDown(
                child: Text(
                  l10n.permissionsTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
              _PermissionTile(
                title: l10n.microphone,
                description: l10n.microphoneDesc,
                icon: Icons.mic_none_rounded,
                isGranted: _isMicGranted,
                onTap: _requestMic,
              ),
              _PermissionTile(
                title: l10n.notifications,
                description: l10n.notificationsDesc,
                icon: Icons.notifications_none_rounded,
                isGranted: _isNotificationGranted,
                onTap: _requestNotification,
              ),
              _PermissionTile(
                title: l10n.usageStats,
                description: l10n.usageStatsDesc,
                icon: Icons.bar_chart_rounded,
                isGranted: _isUsageGranted,
                onTap: _requestUsage,
              ),
              _PermissionTile(
                title: l10n.overlay,
                description: l10n.overlayDesc,
                icon: Icons.layers_outlined,
                isGranted: _isOverlayGranted,
                onTap: _requestOverlay,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_requiredGranted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (_) => const AppSelectionScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Please grant Microphone and Notifications to continue.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _requiredGranted
                        ? AppColors.emerald
                        : AppColors.emerald.withOpacity(0.5),
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

class _PermissionTile extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isGranted;
  final VoidCallback onTap;

  const _PermissionTile({
    required this.title,
    required this.description,
    required this.icon,
    required this.isGranted,
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (isGranted ? AppColors.gold : AppColors.emerald)
                .withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isGranted ? AppColors.gold : AppColors.emerald,
          ),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
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
