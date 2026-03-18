import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../models/hobby_item.dart';
import '../../models/news_item.dart';
import '../../theme/app_theme.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  Color _categoryColor(String category, AppThemeColors colors) {
    switch (category) {
      case 'health':
        return const Color(0xFF4CAF50);
      case 'gardening':
        return const Color(0xFF8BC34A);
      case 'cooking':
        return const Color(0xFFFF9800);
      case 'travel':
        return const Color(0xFF2196F3);
      case 'technology':
        return const Color(0xFF9C27B0);
      case 'books':
        return const Color(0xFF795548);
      default:
        return colors.tint;
    }
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'health':
        return Ionicons.fitness_outline;
      case 'gardening':
        return Ionicons.leaf_outline;
      case 'cooking':
        return Ionicons.restaurant_outline;
      case 'travel':
        return Ionicons.airplane_outline;
      case 'technology':
        return Ionicons.laptop_outline;
      case 'books':
        return Ionicons.book_outline;
      default:
        return Ionicons.newspaper_outline;
    }
  }

  IconData _hobbyIcon(String category) {
    switch (category) {
      case 'indoor':
        return Ionicons.home_outline;
      case 'outdoor':
        return Ionicons.sunny_outline;
      case 'creative':
        return Ionicons.color_palette_outline;
      case 'social':
        return Ionicons.people_outline;
      default:
        return Ionicons.heart_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    final newsItems = <NewsItem>[
      const NewsItem(
        id: '1',
        title: 'New Study Shows Benefits of Daily Walking for Seniors',
        summary:
            'Research indicates that 30 minutes of daily walking can improve cardiovascular health and cognitive function in older adults.',
        category: 'health',
        readTime: '3 min read',
      ),
      const NewsItem(
        id: '2',
        title: 'Spring Gardening Tips for Beginners',
        summary:
            'Learn the best practices for starting your garden this spring, from soil preparation to plant selection.',
        category: 'gardening',
        readTime: '5 min read',
        isBookmarked: true,
      ),
      const NewsItem(
        id: '3',
        title: 'Easy Mediterranean Recipes for Heart Health',
        summary:
            'Discover simple and delicious Mediterranean dishes that are perfect for maintaining heart health.',
        category: 'cooking',
        readTime: '4 min read',
      ),
      const NewsItem(
        id: '4',
        title: 'Top 5 Accessible Travel Destinations for 2024',
        summary:
            'Explore senior-friendly travel destinations that offer comfort, accessibility, and unforgettable experiences.',
        category: 'travel',
        readTime: '6 min read',
      ),
      const NewsItem(
        id: '5',
        title: 'How to Use Video Calling Apps to Stay Connected',
        summary:
            'A beginner-friendly guide to using video calling apps to stay in touch with family and friends.',
        category: 'technology',
        readTime: '4 min read',
        isBookmarked: true,
      ),
    ];

    final hobbyItems = <HobbyItem>[
      const HobbyItem(
        id: '1',
        title: 'Watercolor Painting',
        description:
            'Express your creativity with gentle watercolor techniques perfect for beginners.',
        category: 'creative',
        difficulty: 'beginner',
        timeRequired: '1-2 hours',
        materials: [
          'Watercolor set',
          'Brushes',
          'Watercolor paper',
          'Water container',
        ],
      ),
      const HobbyItem(
        id: '2',
        title: 'Bird Watching',
        description:
            'Connect with nature by observing local bird species in your backyard or nearby parks.',
        category: 'outdoor',
        difficulty: 'beginner',
        timeRequired: '30-60 minutes',
        materials: ['Binoculars', 'Bird guide book', 'Notebook'],
      ),
      const HobbyItem(
        id: '3',
        title: 'Knitting',
        description:
            'Create warm, handmade items while improving hand-eye coordination and reducing stress.',
        category: 'creative',
        difficulty: 'beginner',
        timeRequired: '1-3 hours',
        materials: ['Knitting needles', 'Yarn', 'Pattern book'],
      ),
      const HobbyItem(
        id: '4',
        title: 'Photography',
        description:
            'Capture beautiful moments and memories with your smartphone or camera.',
        category: 'creative',
        difficulty: 'beginner',
        timeRequired: '30 minutes - 2 hours',
        materials: ['Smartphone or camera', 'Tripod (optional)'],
      ),
      const HobbyItem(
        id: '5',
        title: 'Book Club',
        description:
            'Join a local or virtual book club to discuss literature and make new friends.',
        category: 'social',
        difficulty: 'beginner',
        timeRequired: '1-2 hours weekly',
        materials: ['Books', 'Discussion questions'],
      ),
    ];

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Explore',
                style: TextStyle(
                  color: colors.text,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Personalized content for your interests',
                style: TextStyle(color: colors.icon, fontSize: 16),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's News",
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Ionicons.ellipsis_horizontal,
                    color: colors.icon,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              for (final item in newsItems)
                InkWell(
                  onTap: () => context.push('/article/${item.id}'),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.background,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.icon.withOpacity(0.4)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _categoryColor(
                                  item.category,
                                  colors,
                                ).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _categoryIcon(item.category),
                                    size: 16,
                                    color: _categoryColor(
                                      item.category,
                                      colors,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.category[0].toUpperCase() +
                                        item.category.substring(1),
                                    style: TextStyle(
                                      color: _categoryColor(
                                        item.category,
                                        colors,
                                      ),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              item.isBookmarked
                                  ? Ionicons.bookmark
                                  : Ionicons.bookmark_outline,
                              color: item.isBookmarked
                                  ? colors.tint
                                  : colors.icon,
                              size: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.title,
                          style: TextStyle(
                            color: colors.text,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.summary ?? '',
                          style: TextStyle(
                            color: colors.icon,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.readTime,
                              style: TextStyle(
                                color: colors.icon,
                                fontSize: 12,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  context.push('/article/${item.id}'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.tint,
                                foregroundColor: colors.buttonForeground,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Read More',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Discover Hobbies',
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Ionicons.add_circle_outline,
                    color: colors.tint,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              for (final hobby in hobbyItems)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.icon.withOpacity(0.4)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: colors.tint.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _hobbyIcon(hobby.category),
                              color: colors.tint,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hobby.title,
                                  style: TextStyle(
                                    color: colors.text,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colors.tint.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        hobby.difficulty[0].toUpperCase() +
                                            hobby.difficulty.substring(1),
                                        style: TextStyle(
                                          color: colors.tint,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      hobby.timeRequired,
                                      style: TextStyle(
                                        color: colors.icon,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        hobby.description,
                        style: TextStyle(
                          color: colors.icon,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      if (hobby.materials.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Materials needed:',
                          style: TextStyle(
                            color: colors.text,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            for (final material in hobby.materials)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.tint.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  material,
                                  style: TextStyle(
                                    color: colors.tint,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => _showHobbyDialog(context, hobby),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.tint,
                          foregroundColor: colors.buttonForeground,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showHobbyDialog(BuildContext context, HobbyItem hobby) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Get Started with ${hobby.title}'),
        content: Text(
          'Would you like to learn more about ${hobby.title}?\n\n'
          'Time Required: ${hobby.timeRequired}\n'
          'Difficulty: ${hobby.difficulty[0].toUpperCase() + hobby.difficulty.substring(1)}\n\n'
          'This hobby is perfect for ${hobby.category} activities.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showHobbyDetails(context, hobby);
            },
            child: const Text('Learn More'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showInfo(
                context,
                'Saved!',
                '${hobby.title} has been added to your favorites.',
              );
            },
            child: const Text('Save to Favorites'),
          ),
        ],
      ),
    );
  }

  void _showHobbyDetails(BuildContext context, HobbyItem hobby) {
    final materials = hobby.materials.isNotEmpty
        ? hobby.materials.map((m) => '• $m').join('\n')
        : 'No special materials required';
    _showInfo(
      context,
      '${hobby.title} - Details',
      'Description: ${hobby.description}\n\nMaterials Needed:\n$materials\n\nTips:\n• Start with short sessions\n• Don\'t be afraid to make mistakes\n• Enjoy the learning process!',
    );
  }

  void _showInfo(BuildContext context, String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
