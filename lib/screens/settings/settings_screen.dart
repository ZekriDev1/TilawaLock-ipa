import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/permission_provider.dart';
import '../../providers/quran_provider.dart';
import '../../services/quran_cache_service.dart';
import 'language_selector_widget.dart';
import 'permission_settings_widget.dart';
import 'app_selector_screen.dart';
import '../../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: ListView(
        children: [
          _SectionHeader(title: l10n.settingsLanguageSection),
          const LanguageSelectorWidget(),
          const Divider(),
          _SectionHeader(title: l10n.settingsPermissionsSection),
          const PermissionSettingsWidget(),
          const Divider(),
          _SectionHeader(title: 'Locking Settings'),
          ListTile(
            leading: const Icon(Icons.apps),
            title: const Text('Apps to Lock'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AppSelectorScreen()),
            ),
          ),
          const Divider(),
          _SectionHeader(title: l10n.settingsQuranSection),
          ListTile(
            leading: const Icon(Icons.delete_sweep, color: Colors.red),
            title: Text(l10n.settingsClearCache),
            onTap: () => _showClearCacheDialog(context),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'Tilawa Lock v1.0.0',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsClearCache),
        content: Text(l10n.settingsClearCacheConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () async {
              await context.read<QuranProvider>().clearCache();
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(l10n.confirmButton, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
