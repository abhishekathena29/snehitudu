class NewsItem {
  const NewsItem({
    required this.id,
    required this.title,
    required this.category,
    required this.readTime,
    this.summary,
    this.isBookmarked = false,
  });

  final String id;
  final String title;
  final String category;
  final String readTime;
  final String? summary;
  final bool isBookmarked;
}
