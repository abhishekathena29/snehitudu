class UserProgress {
  UserProgress({
    required this.streak,
    required this.totalPoints,
    required this.lastCompletedDate,
    required this.weeklyProgress,
    required this.gamesPlayed,
    required this.bestScores,
  });

  final int streak;
  final int totalPoints;
  final String lastCompletedDate;
  final List<bool> weeklyProgress;
  final int gamesPlayed;
  final Map<String, int> bestScores;

  factory UserProgress.initial() {
    return UserProgress(
      streak: 0,
      totalPoints: 0,
      lastCompletedDate: '',
      weeklyProgress: List<bool>.filled(7, false),
      gamesPlayed: 0,
      bestScores: <String, int>{},
    );
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      streak: json['streak'] ?? 0,
      totalPoints: json['totalPoints'] ?? 0,
      lastCompletedDate: json['lastCompletedDate'] ?? '',
      weeklyProgress: List<bool>.from(json['weeklyProgress'] ?? List<bool>.filled(7, false)),
      gamesPlayed: json['gamesPlayed'] ?? 0,
      bestScores: Map<String, int>.from(json['bestScores'] ?? <String, int>{}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'streak': streak,
      'totalPoints': totalPoints,
      'lastCompletedDate': lastCompletedDate,
      'weeklyProgress': weeklyProgress,
      'gamesPlayed': gamesPlayed,
      'bestScores': bestScores,
    };
  }

  UserProgress copyWith({
    int? streak,
    int? totalPoints,
    String? lastCompletedDate,
    List<bool>? weeklyProgress,
    int? gamesPlayed,
    Map<String, int>? bestScores,
  }) {
    return UserProgress(
      streak: streak ?? this.streak,
      totalPoints: totalPoints ?? this.totalPoints,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      weeklyProgress: weeklyProgress ?? this.weeklyProgress,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      bestScores: bestScores ?? this.bestScores,
    );
  }
}
