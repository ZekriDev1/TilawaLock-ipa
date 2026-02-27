class AppLockInfo {
  final String packageName;
  final String appName;
  bool isLocked;
  DateTime? lastUnlockedAt;

  AppLockInfo({
    required this.packageName,
    required this.appName,
    this.isLocked = false,
    this.lastUnlockedAt,
  });

  bool get isCurrentlyUnlocked {
    if (lastUnlockedAt == null) return false;
    final now = DateTime.now();
    final difference = now.difference(lastUnlockedAt!);
    return difference.inHours < 2; // Maximum 2 hours usage
  }

  Map<String, dynamic> toJson() => {
    'packageName': packageName,
    'appName': appName,
    'isLocked': isLocked,
    'lastUnlockedAt': lastUnlockedAt?.toIso8601String(),
  };

  factory AppLockInfo.fromJson(Map<String, dynamic> json) => AppLockInfo(
    packageName: json['packageName'],
    appName: json['appName'],
    isLocked: json['isLocked'] ?? false,
    lastUnlockedAt: json['lastUnlockedAt'] != null 
        ? DateTime.parse(json['lastUnlockedAt']) 
        : null,
  );
}
