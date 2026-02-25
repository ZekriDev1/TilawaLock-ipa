import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:tilawalock/l10n/app_localizations.dart';
import '../../core/constants/colors.dart';
import '../../core/services/permission_manager.dart';
import 'app_lock_setup_screen.dart';
import 'home_dashboard_screen.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _isMicGranted = false;
  bool _isNotificationGranted = false;
  bool _isOverlayGranted = false;
  bool _isUsageGranted = false;

  String? _deniedMessage;

  @override
  void initState() {
    super.initState();
    _checkInitialPermissions();
  }

  Future<void> _checkInitialPermissions() async {
    final mic = await PermissionManager.instance.checkMicrophone();
    if (mounted) {
      setState(() {
        _isMicGranted = mic == PermissionResult.granted;
      });
    }
  }

  Future<void> _requestMic() async {
    final result = await PermissionManager.instance.requestMicrophone();
    if (mounted) {
      setState(() {
        _isMicGranted = result == PermissionResult.granted;
        _deniedMessage = result != PermissionResult.granted ? "Microphone access denied." : null;
      });
    }
  }

  Future<void> _requestNotification() async {
    final result = await PermissionManager.instance.requestNotification();
    if (mounted) {
      setState(() {
        _isNotificationGranted = result == PermissionResult.granted;
        _deniedMessage = result != PermissionResult.granted ? "Notification permission denied." : null;
      });
    }
  }

  Future<void> _requestOverlay() async {
    final result = await PermissionManager.instance.requestOverlay();
    if (mounted) {
      setState(() {
        _isOverlayGranted = result == PermissionResult.granted;
        _deniedMessage = result != PermissionResult.granted ? "Overlay permission denied." : null;
      });
    }
  }

  Future<void> _requestUsage() async {
    final result = await PermissionManager.instance.requestUsageStats();
    if (mounted) {
      setState(() {
        _isUsageGranted = result == PermissionResult.granted;
        _deniedMessage = result != PermissionResult.granted ? "Usage stats access denied." : null;
      });
    }
  }

  void _handleSkip() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeDashboardScreen()),
    );
  }

  void _handleContinue() {
    if (_isMicGranted && _isNotificationGranted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AppLockSetupScreen()),
      );
    } else {
      setState(() {
        _deniedMessage = "Please grant Microphone and Notifications to continue.";
      });
    }
  }

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
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: TextButton(
                  onPressed: _handleSkip,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.emerald.withOpacity(0.65),
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

              _PermissionTile(
                title: l10n.microphone,
                description: l10n.microphoneDesc,
                icon: Icons.mic_none_rounded,
                isGranted: _isMicGranted,
                isMandatory: true,
                onTap: _requestMic,
              ),

              _PermissionTile(
                title: l10n.notifications,
                description: l10n.notificationsDesc,
                icon: Icons.notifications_none_rounded,
                isGranted: _isNotificationGranted,
                isMandatory: true,
                onTap: _requestNotification,
              ),

              _PermissionTile(
                title: l10n.usageStats,
                description: l10n.usageStatsDesc,
                icon: Icons.bar_chart_rounded,
                isGranted: _isUsageGranted,
                isMandatory: false,
                onTap: _requestUsage,
              ),

              _PermissionTile(
                title: l10n.overlay,
                description: l10n.overlayDesc,
                icon: Icons.layers_outlined,
                isGranted: _isOverlayGranted,
                isMandatory: false,
                onTap: _requestOverlay,
              ),

              const Spacer(),

              if (_deniedMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Center(
                    child: Text(
                      _deniedMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (_isMicGranted && _isNotificationGranted)
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            color: (isGranted ? AppColors.gold : AppColors.emerald).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isGranted ? AppColors.gold : AppColors.emerald,
          ),
        ),
        title: Row(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (isMandatory)
              const Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        subtitle: Text(description, style: const TextStyle(fontSize: 12)),
        trailing: isGranted
            ? const Icon(Icons.check_circle, color: AppColors.gold)
            : TextButton(
                onPressed: onTap,
                child: const Text('Allow'),
              ),
      ),
    );
  }
}
