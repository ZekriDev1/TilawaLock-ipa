import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_lock_info.dart';
import '../core/constants/storage_keys.dart';

class LockProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  List<AppLockInfo> _lockedApps = [];
  bool _isLockEnabled = true;

  LockProvider(this._prefs) {
    _loadSettings();
  }

  List<AppLockInfo> get lockedApps => _lockedApps;
  bool get isLockEnabled => _isLockEnabled;

  void _loadSettings() {
    final listJson = _prefs.getStringList('locked_apps_list') ?? [];
    _lockedApps = listJson.map((e) => AppLockInfo.fromJson(jsonDecode(e))).toList();
    _isLockEnabled = _prefs.getBool('is_lock_enabled') ?? true;
    notifyListeners();
  }

  Future<void> toggleAppLock(String packageName, String appName) async {
    final index = _lockedApps.indexWhere((app) => app.packageName == packageName);
    if (index >= 0) {
      _lockedApps.removeAt(index);
    } else {
      _lockedApps.add(AppLockInfo(packageName: packageName, appName: appName, isLocked: true));
    }
    await _saveSettings();
  }

  Future<void> unlockApp(String packageName) async {
    final index = _lockedApps.indexWhere((app) => app.packageName == packageName);
    if (index >= 0) {
      _lockedApps[index].lastUnlockedAt = DateTime.now();
      await _saveSettings();
    }
  }

  Future<void> _saveSettings() async {
    final listJson = _lockedApps.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs.setStringList('locked_apps_list', listJson);
    await _prefs.setBool('is_lock_enabled', _isLockEnabled);
    notifyListeners();
  }

  // Logic to verify if an app should be blocked
  bool shouldBlockApp(String packageName) {
    if (!_isLockEnabled) return false;
    final app = _lockedApps.firstWhere(
      (a) => a.packageName == packageName,
      orElse: () => AppLockInfo(packageName: '', appName: ''),
    );
    
    if (app.packageName.isEmpty) return false;
    return !app.isCurrentlyUnlocked;
  }
}
