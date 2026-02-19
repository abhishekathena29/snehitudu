class Challenge {
  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.points,
    required this.completed,
    required this.gameData,
  });

  final String id;
  final String title;
  final String description;
  final String type;
  final String difficulty;
  final int points;
  final bool completed;
  final Map<String, dynamic> gameData;
}
