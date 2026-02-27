import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/quran_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/recitation_provider.dart';
import '../../models/surah_model.dart';
import '../../models/ayah_model.dart';
import '../../l10n/app_localizations.dart';

class SurahDetailScreen extends StatefulWidget {
  final SurahModel surah;
  const SurahDetailScreen({super.key, required this.surah});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final langCode = context.read<LocaleProvider>().currentLanguage.code;
      context.read<QuranProvider>().fetchSurahDetail(widget.surah.number, langCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final quranProvider = context.watch<QuranProvider>();
    final langCode = context.watch<LocaleProvider>().currentLanguage.code;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.surah.englishName),
            Text(
              widget.surah.name,
              style: const TextStyle(fontFamily: 'Amiri', fontSize: 14),
            ),
          ],
        ),
      ),
      body: quranProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : quranProvider.currentSurah?.ayahs == null
              ? Center(child: Text(l10n.quranLoadError))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: quranProvider.currentSurah!.ayahs!.length,
                  separatorBuilder: (_, __) => const Divider(height: 32),
                  itemBuilder: (context, index) {
                    final ayah = quranProvider.currentSurah!.ayahs![index];
                    return _AyahRow(
                      ayah: ayah, 
                      surahName: widget.surah.englishName,
                      langCode: langCode,
                    );
                  },
                ),
    );
  }
}

class _AyahRow extends StatelessWidget {
  final AyahModel ayah;
  final String surahName;
  final String langCode;

  const _AyahRow({
    required this.ayah, 
    required this.surahName,
    required this.langCode,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Text(
                ayah.numberInSurah.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                ayah.text,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 22,
                  height: 1.8,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Note: In a real app, we'd fetch the translation here or merge it in the provider
        // For this demo, we assume ayah.text is the requested edition if lang is not Arabic
        if (langCode != 'ar')
          Text(
            l10n.quranTranslation + ":", // Placeholder for actual translation if not loaded
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey),
          ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () async {
              try {
                await context.read<RecitationProvider>().assignAyah(
                  ayah.surahNumber,
                  surahName,
                  ayah.numberInSurah,
                  langCode,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.quranAyahAssigned)),
                  );
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.errorGeneric)),
                  );
                }
              }
            },
            icon: const Icon(Icons.add_task),
            label: Text(l10n.quranAssignAyah),
          ),
        ),
      ],
    );
  }
}
