import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';
import 'package:tilawalock/l10n/app_localizations.dart';
import '../../core/constants/colors.dart';
import '../providers/lock_provider.dart';
import 'home_dashboard_screen.dart';

class AppLockSetupScreen extends ConsumerStatefulWidget {
  const AppLockSetupScreen({super.key});

  @override
  ConsumerState<AppLockSetupScreen> createState() => _AppLockSetupScreenState();
}

class _AppLockSetupScreenState extends ConsumerState<AppLockSetupScreen> {
  List<AppInfo> _allApps = [];
  List<AppInfo> _filteredApps = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadApps();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadApps() async {
    try {
      // Exclude system apps, include icons
      final apps = await InstalledApps.getInstalledApps(true, true);
      apps.sort((a, b) =>
          (a.name ?? '').toLowerCase().compareTo((b.name ?? '').toLowerCase()));
      if (mounted) {
        setState(() {
          _allApps = apps;
          _filteredApps = apps;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredApps = query.isEmpty
          ? _allApps
          : _allApps
              .where((app) =>
                  (app.name ?? '').toLowerCase().contains(query) ||
                  (app.packageName ?? '').toLowerCase().contains(query))
              .toList();
    });
  }

  void _toggleApp(String packageName) {
    ref.read(lockProvider.notifier).toggleApp(packageName);
  }

  void _proceed() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeDashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lockState = ref.watch(lockProvider);
    final selectedApps = lockState.selectedApps.toSet();
    final selectedCount = selectedApps.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────
            _buildHeader(context, l10n, selectedCount),

            // ── Search bar ──────────────────────────────────────
            _buildSearchBar(l10n),

            // ── Selected count chip ─────────────────────────────
            if (selectedCount > 0)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Wrap(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.emerald,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$selectedCount app${selectedCount == 1 ? '' : 's'} selected',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

            // ── App grid ────────────────────────────────────────
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.emerald))
                  : _filteredApps.isEmpty
                      ? Center(
                          child: Text(
                            'No apps found',
                            style: TextStyle(
                                color: AppColors.emerald.withValues(alpha: 0.5)),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.82,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: _filteredApps.length,
                          itemBuilder: (ctx, i) {
                            final app = _filteredApps[i];
                            final pkg = app.packageName ?? '';
                            final isSelected = selectedApps.contains(pkg);
                            return _AppTile(
                              app: app,
                              isSelected: isSelected,
                              onTap: () => _toggleApp(pkg),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),

      // ── Bottom CTA ────────────────────────────────────────────
      bottomNavigationBar: _buildBottomBar(context, l10n, selectedCount),
    );
  }

  Widget _buildHeader(
      BuildContext context, AppLocalizations l10n, int selectedCount) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.emerald, Color(0xFF065F46)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock_outline_rounded,
                  color: Colors.white, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.selectApps,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Skip button
              TextButton(
                onPressed: _proceed,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Choose apps that require Quran recitation to unlock.',
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: l10n.searchApps,
          prefixIcon: const Icon(Icons.search, color: AppColors.emerald),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    FocusScope.of(context).unfocus();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildBottomBar(
      BuildContext context, AppLocalizations l10n, int selectedCount) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: _proceed,
            icon: const Icon(Icons.check_circle_outline),
            label: Text(
              selectedCount == 0
                  ? 'Continue without locking'
                  : 'Lock $selectedCount app${selectedCount == 1 ? '' : 's'} & Continue',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  selectedCount > 0 ? AppColors.emerald : Colors.grey.shade400,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Individual app tile
// ─────────────────────────────────────────────────────────────────────────────

class _AppTile extends StatelessWidget {
  final AppInfo app;
  final bool isSelected;
  final VoidCallback onTap;

  const _AppTile({
    required this.app,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.emerald.withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.gold : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.08 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lock badge + icon
              Stack(
                alignment: Alignment.topRight,
                children: [
                  app.icon != null
                      ? Image.memory(app.icon!, width: 48, height: 48)
                      : const Icon(Icons.apps, size: 48,
                          color: AppColors.emerald),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock,
                          color: Colors.white, size: 12),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                app.name ?? '',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? AppColors.emerald
                      : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
