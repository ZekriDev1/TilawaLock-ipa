import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:animate_do/animate_do.dart';
import 'package:tilawalock/l10n/app_localizations.dart';
import '../../core/constants/colors.dart';
import '../../core/services/local_database_manager.dart';
import '../../core/services/achievement_engine.dart';
import '../widgets/badge_card.dart';
import 'settings_screen.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Fetch real data
    final int streak = LocalDatabaseManager.getStreak();
    final int points = LocalDatabaseManager.getPoints();
    final int verses = LocalDatabaseManager.getVerses();
    final int appsBlockedCount = LocalDatabaseManager.getLockedApps().length;
    final int timeSavedMinutes = LocalDatabaseManager.getTimeSaved();
    
    // Progress calculation (e.g. daily goal is 5 verses)
    const int dailyGoal = 5;
    final double progress = (verses % dailyGoal) / dailyGoal;
    final int dailyProgressCount = verses % dailyGoal;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, l10n),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDailyProgress(l10n, dailyProgressCount, dailyGoal, progress, streak, points),
                  const SizedBox(height: 24),
                  _buildStatsGrid(l10n, appsBlockedCount, timeSavedMinutes),
                  const SizedBox(height: 32),
                  Text(
                    l10n.achievements,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.emerald),
                  ),
                  const SizedBox(height: 16),
                  _buildAchievements(l10n),
                  const SizedBox(height: 32),
                  _buildMotivationalQuote(l10n),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.emerald,
        icon: const Icon(Icons.lock_reset, color: Colors.white),
        label: Text(l10n.reciteNow, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppLocalizations l10n) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.emerald,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        title: Text(
          l10n.homeGreeting,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        background: Stack(
          children: [
            PositionedDirectional(
              end: -30,
              top: -30,
              child: Opacity(
                opacity: 0.1,
                child: Image.asset('assets/applogo.png', width: 200),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
          icon: const Icon(Icons.settings_outlined, color: Colors.white),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildDailyProgress(AppLocalizations l10n, int current, int total, double percent, int streak, int points) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.dailyRecitation,
                    style: TextStyle(color: AppColors.emerald.withOpacity(0.6), fontWeight: FontWeight.w600),
                  ),
                  Text(
                    l10n.ayatProgress(current, total),
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.emerald),
                  ),
                ],
              ),
              CircularPercentIndicator(
                radius: 40.0,
                lineWidth: 8.0,
                percent: percent.clamp(0.0, 1.0),
                center: Text(l10n.percentValue((percent * 100).toInt()), style: const TextStyle(fontWeight: FontWeight.bold)),
                progressColor: AppColors.gold,
                backgroundColor: AppColors.gold.withOpacity(0.1),
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ],
          ),
          const Divider(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSmallStat(l10n.streak, l10n.days(streak), Icons.local_fire_department_rounded, Colors.orange),
              _buildSmallStat(l10n.points, points.toString(), Icons.stars_rounded, AppColors.gold),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStat(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.emerald)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsGrid(AppLocalizations l10n, int appsCount, int timeMinutes) {
    String timeStr = timeMinutes >= 60 
        ? "${(timeMinutes / 60).floor()}h ${timeMinutes % 60}m"
        : "${timeMinutes}m";

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(l10n.appsBlocked, appsCount.toString(), Icons.block_flipped, Colors.red.shade400),
        _buildStatCard(l10n.timeSaved, timeStr, Icons.timer_outlined, Colors.blue.shade400),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.emerald)),
          Text(title, style: TextStyle(fontSize: 12, color: AppColors.emerald.withOpacity(0.6))),
        ],
      ),
    );
  }

  Widget _buildAchievements(AppLocalizations l10n) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          BadgeCard(
            name: l10n.firstVerse, 
            icon: Icons.auto_awesome, 
            isUnlocked: LocalDatabaseManager.isAchievementUnlocked(AchievementEngine.KEY_FIRST_VERSE)
          ),
          BadgeCard(
            name: l10n.threeDayStreak, 
            icon: Icons.bolt, 
            isUnlocked: LocalDatabaseManager.isAchievementUnlocked(AchievementEngine.KEY_THREE_DAY_STREAK)
          ),
          BadgeCard(
            name: l10n.nightOwl, 
            icon: Icons.nightlight_round, 
            isUnlocked: LocalDatabaseManager.isAchievementUnlocked(AchievementEngine.KEY_NIGHT_OWL)
          ),
          BadgeCard(
            name: l10n.khatim, 
            icon: Icons.menu_book, 
            isUnlocked: LocalDatabaseManager.isAchievementUnlocked(AchievementEngine.KEY_KHATIM)
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationalQuote(AppLocalizations l10n) {
    return FadeInUp(
      child: Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.ramadanGradient,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            const Icon(Icons.format_quote, color: AppColors.gold, size: 40),
            const SizedBox(height: 16),
            Text(
              l10n.prophetQuote,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontFamily: 'Georgia',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.prophetName,
              style: TextStyle(color: AppColors.gold.withOpacity(0.8), fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
