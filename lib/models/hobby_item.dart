class HobbyItem {
  const HobbyItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.timeRequired,
    this.materials = const [],
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final String timeRequired;
  final List<String> materials;
}
