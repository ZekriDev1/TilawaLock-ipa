import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../providers/permission_provider.dart';
import '../../l10n/app_localizations.dart';
import '../quran/surah_list_screen.dart';

class PermissionRequestScreen extends StatelessWidget {
  const PermissionRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final permissionProvider = context.watch<PermissionProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              Text(
                l10n.appName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.appTagline,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              _PermissionTile(
                title: l10n.permissionMicTitle,
                body: l10n.permissionMicBody,
                icon: Icons.mic,
                isGranted: permissionProvider.microphoneStatus.isGranted,
                onTap: () => permissionProvider.requestMicrophone(),
              ),
              const SizedBox(height: 16),
              _PermissionTile(
                title: l10n.permissionOverlayTitle,
                body: l10n.permissionOverlayBody,
                icon: Icons.layers,
                isGranted: permissionProvider.isOverlayGranted,
                onTap: () => permissionProvider.requestOverlay(),
              ),
              const SizedBox(height: 16),
              _PermissionTile(
                title: l10n.permissionNotifTitle,
                body: l10n.permissionNotifBody,
                icon: Icons.notifications,
                isGranted: permissionProvider.notificationStatus.isGranted,
                onTap: () => permissionProvider.requestNotifications(),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const SurahListScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(l10n.onboardingContinue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;
  final bool isGranted;
  final VoidCallback onTap;

  const _PermissionTile({
    required this.title,
    required this.body,
    required this.icon,
    required this.isGranted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: isGranted 
          ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
          : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isGranted ? Theme.of(context).colorScheme.primary : Colors.transparent,
        ),
      ),
      child: ListTile(
        onTap: isGranted ? null : onTap,
        leading: Icon(
          icon,
          color: isGranted ? Theme.of(context).colorScheme.primary : null,
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(body),
        trailing: isGranted 
            ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
            : const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
