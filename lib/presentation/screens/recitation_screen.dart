import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:animate_do/animate_do.dart';
import 'package:tilawalock/l10n/app_localizations.dart';
import '../../core/constants/colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/permission_manager.dart';
import '../../core/services/lifecycle_permission_handler.dart';

class RecitationScreen extends StatefulWidget {
  const RecitationScreen({super.key});

  @override
  State<RecitationScreen> createState() => _RecitationScreenState();
}

class _RecitationScreenState extends State<RecitationScreen>
    with
        SingleTickerProviderStateMixin,
        WidgetsBindingObserver,
        LifecyclePermissionMixin {
  // ── Speech ───────────────────────────────────────────────────
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _recognizedText = '';

  // ── Verse progress ───────────────────────────────────────────
  int _currentVerseIndex = 0;

  // ── Animation ────────────────────────────────────────────────
  late AnimationController _waveController;

  // ── Mic permission state ──────────────────────────────────────
  // isMicGranted comes from LifecyclePermissionMixin.

  final List<Map<String, String>> _verses = const [
    {
      'arabic': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      'transliteration': 'Bismillahir Rahmanir Rahim',
    },
    {
      'arabic': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
      'transliteration': "Alhamdu lillahi rabbil 'alamin",
    },
    {
      'arabic': 'الرَّحْمَٰنِ الرَّحِيمِ',
      'transliteration': 'Ar-Rahmanir-Rahim',
    },
    {
      'arabic': 'مَالِكِ يَوْمِ الدِّينِ',
      'transliteration': 'Maliki yawmid-din',
    },
    {
      'arabic': 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
      'transliteration': "Iyyaka na'budu wa iyyaka nasta'in",
    },
  ];

  // ─────────────────────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // Registers WidgetsBinding observer + triggers initial mic check.
    initLifecyclePermission();
  }

  @override
  void dispose() {
    // Stop any active recording before disposal to prevent OS-level audio errors.
    if (_isListening) {
      _speech.stop();
    }
    _waveController.dispose();
    // Unregisters the binding observer – must happen before super.dispose().
    disposeLifecyclePermission();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────
  // LifecyclePermissionMixin callback – called on resume from Settings
  // ─────────────────────────────────────────────────────────────

  @override
  void onMicPermissionChanged(MicPermissionResult result) {
    if (!mounted) return;
    // Just rebuild the UI – the getter [isMicGranted] reflects the new state.
    setState(() {});
  }

  // ─────────────────────────────────────────────────────────────
  // Recording logic
  // ─────────────────────────────────────────────────────────────

  /// Main entry point when user taps the mic button.
  Future<void> _handleMicTap() async {
    if (!mounted) return;

    // ── Stopping ─────────────────────────────────────────────
    if (_isListening) {
      await _stopListening();
      return;
    }

    // ── Permission check before starting ─────────────────────
    if (!isMicGranted) {
      // Delegate to mixin: handles first-time dialog, permanently denied → Settings.
      await requestMicPermission(context);
      // If still not granted after the request, bail out.
      if (!isMicGranted || !mounted) return;
    }

    // ── Start recording ───────────────────────────────────────
    await _startListening();
  }

  Future<void> _startListening() async {
    if (!mounted) return;

    try {
      final initialized = await _speech.initialize(
        // onStatus lets us react to the STT engine ending on its own.
        onStatus: (status) {
          if (!mounted) return;
          if (status == 'done' || status == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        onError: (error) {
          if (!mounted) return;
          setState(() => _isListening = false);
          // Only show an error if it's not a "no match" which is benign.
          if (error.errorMsg != 'error_no_match') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Speech error: ${error.errorMsg}'),
                backgroundColor: Colors.red.shade700,
              ),
            );
          }
        },
      );

      if (!initialized || !mounted) return;

      setState(() {
        _isListening = true;
        _recognizedText = '';
      });

      await _speech.listen(
        onResult: (result) {
          if (!mounted) return;
          setState(() {
            _recognizedText = result.recognizedWords;
          });
          // Simple matching: check if recognized text matches transliteration
          final expected = _verses[_currentVerseIndex]['transliteration']!
              .toLowerCase();
          final spoken = result.recognizedWords.toLowerCase();
          if (spoken.isNotEmpty &&
              (spoken.contains(expected.split(' ').first))) {
            _handleNextVerse();
          }
        },
        // locale: 'ar-SA' for Arabic recognition – adjust as needed
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isListening = false);
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    if (mounted) setState(() => _isListening = false);
  }

  void _handleNextVerse() {
    // Stop recording before transitioning.
    _speech.stop();
    setState(() => _isListening = false);

    if (_currentVerseIndex < _verses.length - 1) {
      setState(() {
        _currentVerseIndex++;
        _recognizedText = '';
      });
    } else {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.mashaAllah),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.gold, size: 60),
            const SizedBox(height: 16),
            Text(l10n.successMessage),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
            child: Text(l10n.finish),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // UI
  // ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l10n.timeForTilawa)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // ── Progress bar ──────────────────────────────────
            LinearProgressIndicator(
              value: (_currentVerseIndex + 1) / _verses.length,
              backgroundColor: AppColors.gold.withOpacity(0.1),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.gold),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.verseCounter(_currentVerseIndex + 1, _verses.length),
              style: TextStyle(
                color: AppColors.emerald.withOpacity(0.6),
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),

            // ── Verse card ────────────────────────────────────
            FadeInRight(
              key: ValueKey(_currentVerseIndex),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      _verses[_currentVerseIndex]['arabic']!,
                      style: AppTheme.arabicStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _verses[_currentVerseIndex]['transliteration']!,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // ── Recognized text ───────────────────────────────
            if (_recognizedText.isNotEmpty)
              FadeIn(
                child: Text(
                  _recognizedText,
                  style: const TextStyle(
                    color: AppColors.emerald,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // ── Permission denied banner ──────────────────────
            if (!isMicGranted)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Colors.orange, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Microphone access required',
                      style: TextStyle(
                          color: Colors.orange.shade800,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 40),

            // ── Mic button ────────────────────────────────────
            GestureDetector(
              onTap: _handleMicTap,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_isListening)
                    ...List.generate(3, _buildRipple),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: !isMicGranted
                          ? Colors.grey
                          : (_isListening
                              ? Colors.red
                              : AppColors.emerald),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (!isMicGranted
                                  ? Colors.grey
                                  : _isListening
                                      ? Colors.red
                                      : AppColors.emerald)
                              .withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isListening ? Icons.stop : Icons.mic,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _isListening ? l10n.listening : l10n.tapToRecite,
              style: TextStyle(
                color: _isListening ? Colors.red : AppColors.emerald,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildRipple(int index) {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (_, __) {
        final value = (_waveController.value + index * 0.3) % 1.0;
        return Container(
          width: 80 + (100 * value),
          height: 80 + (100 * value),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.red.withOpacity(1 - value),
              width: 2,
            ),
          ),
        );
      },
    );
  }
}
