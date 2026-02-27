import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/recitation_provider.dart';
import '../../providers/lock_provider.dart';
import '../../providers/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecitationUnlockScreen extends StatefulWidget {
  final String packageName;
  const RecitationUnlockScreen({super.key, required this.packageName});

  @override
  State<RecitationUnlockScreen> createState() => _RecitationUnlockScreenState();
}

class _RecitationUnlockScreenState extends State<RecitationUnlockScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      context.read<RecitationProvider>().prepareUnlockSession()
    );
  }

  @override
  Widget build(BuildContext context) {
    final recitationProvider = context.watch<RecitationProvider>();
    final lockProvider = context.read<LockProvider>();
    final l10n = AppLocalizations.of(context)!;

    if (recitationProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (recitationProvider.sessionAyahs.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.errorGeneric),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      );
    }

    final currentAyah = recitationProvider.sessionAyahs[recitationProvider.currentAyahIndex];
    final isLast = recitationProvider.currentAyahIndex == recitationProvider.sessionAyahs.length - 1;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                value: (recitationProvider.currentAyahIndex + 1) / recitationProvider.sessionAyahs.length,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Recite to Unlock',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Ayah ${recitationProvider.currentAyahIndex + 1} of ${recitationProvider.sessionAyahs.length}',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        currentAyah.text,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 24,
                          height: 1.8,
                        ),
                      ),
                      const Divider(height: 32),
                      const SizedBox(height: 16),
                      const Icon(Icons.mic, size: 48, color: Colors.grey),
                      const SizedBox(height: 8),
                      Text(
                        'Tap to start reciting',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (isLast) {
                    lockProvider.unlockApp(widget.packageName);
                    Navigator.pop(context);
                  } else {
                    recitationProvider.nextAyah();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(isLast ? 'Complete & Unlock' : 'Next Ayah'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
