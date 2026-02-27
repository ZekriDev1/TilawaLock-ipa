import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/quran_provider.dart';
import '../../providers/locale_provider.dart';
import '../../models/surah_model.dart';
import 'surah_detail_screen.dart';
import '../settings/settings_screen.dart';
import '../../l10n/app_localizations.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      context.read<QuranProvider>().fetchSurahList()
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final quranProvider = context.watch<QuranProvider>();
    final isArabic = context.watch<LocaleProvider>().currentLanguage.code == 'ar';

    final filteredSurahs = quranProvider.surahList.where((surah) {
      final name = surah.englishName.toLowerCase();
      final arabicName = surah.name;
      final number = surah.number.toString();
      final search = _searchQuery.toLowerCase();
      return name.contains(search) || arabicName.contains(search) || number.contains(search);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.quranSurahListTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: l10n.quranSearchPlaceholder,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ),
      body: quranProvider.isLoading 
        ? const Center(child: CircularProgressIndicator())
        : quranProvider.errorMessage != null
          ? _ErrorView(message: quranProvider.errorMessage!, onRetry: quranProvider.fetchSurahList)
          : Stack(
              children: [
                ListView.builder(
                  itemCount: filteredSurahs.length,
                  itemBuilder: (context, index) {
                    final surah = filteredSurahs[index];
                    return _SurahTile(surah: surah, isArabic: isArabic);
                  },
                ),
                if (quranProvider.isOffline)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        l10n.quranOfflineBanner,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _SurahTile extends StatelessWidget {
  final SurahModel surah;
  final bool isArabic;

  const _SurahTile({required this.surah, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SurahDetailScreen(surah: surah)),
      ),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Text(
          surah.number.toString(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(surah.englishName, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            surah.name,
            style: const TextStyle(
              fontFamily: 'Amiri',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          _Badge(text: surah.revelationType == 'Meccan' ? l10n.quranMeccan : l10n.quranMedinan),
          const SizedBox(width: 8),
          Text(l10n.quranAyahCount(surah.numberOfAyahs)),
        ],
      ),
      trailing: Icon(
        isArabic ? Icons.chevron_left : Icons.chevron_right,
        color: Colors.grey,
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(l10n.quranRetry),
          ),
        ],
      ),
    );
  }
}
