import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../providers/permission_provider.dart';
import '../../l10n/app_localizations.dart';

class PermissionSettingsWidget extends StatelessWidget {
  const PermissionSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final permissionProvider = context.watch<PermissionProvider>();

    return Column(
      children: [
        _PermissionItem(
          title: l10n.permissionMicTitle,
          statusText: _getStatusText(permissionProvider.microphoneStatus, l10n),
          isGranted: permissionProvider.microphoneStatus.isGranted,
          onTap: () => permissionProvider.requestMicrophone(),
        ),
        _PermissionItem(
          title: l10n.permissionOverlayTitle,
          statusText: permissionProvider.isOverlayGranted ? l10n.permissionStatusGranted : l10n.permissionStatusDenied,
          isGranted: permissionProvider.isOverlayGranted,
          onTap: () => permissionProvider.requestOverlay(),
        ),
        _PermissionItem(
          title: l10n.permissionNotifTitle,
          statusText: _getStatusText(permissionProvider.notificationStatus, l10n),
          isGranted: permissionProvider.notificationStatus.isGranted,
          onTap: () => permissionProvider.requestNotifications(),
        ),
      ],
    );
  }

  String _getStatusText(PermissionStatus status, AppLocalizations l10n) {
    if (status.isGranted) return l10n.permissionStatusGranted;
    if (status.isDenied) return l10n.permissionStatusDenied;
    if (status.isPermanentlyDenied) return l10n.permissionMicPermanentlyDenied;
    return l10n.permissionStatusNotAvailable;
  }
}

class _PermissionItem extends StatelessWidget {
  final String title;
  final String statusText;
  final bool isGranted;
  final VoidCallback onTap;

  const _PermissionItem({
    required this.title,
    required this.statusText,
    required this.isGranted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        statusText,
        style: TextStyle(
          color: isGranted ? Colors.green : Colors.orange,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: isGranted 
          ? const Icon(Icons.check_circle, color: Colors.green)
          : TextButton(
              onPressed: onTap,
              child: Text(AppLocalizations.of(context)!.manageButton),
            ),
    );
  }
}
