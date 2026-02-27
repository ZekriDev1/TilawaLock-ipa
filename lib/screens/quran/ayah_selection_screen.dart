import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/quran_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/recitation_provider.dart';
import '../../repositories/quran_repository.dart';
import '../../models/ayah_model.dart';
import '../../l10n/app_localizations.dart';

class AyahSelectionScreen extends StatefulWidget {
  const AyahSelectionScreen({super.key});

  @override
  State<AyahSelectionScreen> createState() => _AyahSelectionScreenState();
}

class _AyahSelectionScreenState extends State<AyahSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<AyahModel> _results = [];
  bool _isSearching = false;

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;
    
    final quranProvider = context.read<QuranProvider>();
    final langCode = context.read<LocaleProvider>().currentLanguage.code;
    
    await quranProvider.searchAyahs(query, langCode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final quranProvider = context.watch<QuranProvider>();
    final results = quranProvider.searchResults;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.quranAyahSearchTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.quranAyahSearchPlaceholder,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _performSearch(_searchController.text),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onSubmitted: _performSearch,
            ),
          ),
          if (quranProvider.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (results.isEmpty && _searchController.text.isNotEmpty)
            Expanded(child: Center(child: Text(l10n.quranAyahSearchNoResults)))
          else
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final ayah = results[index];
                  return ListTile(
                    title: Text(ayah.text, maxLines: 2, overflow: TextOverflow.ellipsis),
                    subtitle: Text('Surah ${ayah.surahNumber} : ${ayah.numberInSurah}'),
                    onTap: () async {
                      // Assign and pop
                      final langCode = context.read<LocaleProvider>().currentLanguage.code;
                      await context.read<RecitationProvider>().assignAyah(
                        ayah.surahNumber,
                        'Surah ${ayah.surahNumber}',
                        ayah.numberInSurah,
                        langCode,
                      );
                      if (mounted) Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.list),
              label: Text(l10n.quranBrowseBySurah),
            ),
          ),
        ],
      ),
    );
  }
}
