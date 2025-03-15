class LevelProgress {
  final int level;
  final int stars; // 0-3 stars based on accuracy

  LevelProgress({required this.level, required this.stars});

  factory LevelProgress.fromJson(Map<String, dynamic> json) {
    return LevelProgress(level: json['level'], stars: json['stars']);
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'stars': stars,
    };
  }
}
