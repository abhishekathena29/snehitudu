import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../models/news_item.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_logo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _random = Random();
  int totalPuzzles = 0;
  int totalGames = 0;
  int totalUsers = 0;
  int completedToday = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    setState(() {
      totalPuzzles = 24 + _random.nextInt(10);
      totalGames = 8 + _random.nextInt(5);
      totalUsers = 1547 + _random.nextInt(100);
      completedToday = 1 + _random.nextInt(5);
    });
  }

  Color _categoryColor(String category, AppThemeColors colors) {
    switch (category.toLowerCase()) {
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
      default:
        return colors.tint;
    }
  }

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
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
      default:
        return Ionicons.newspaper_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final user = context.watch<AuthService>().user;

    final recentNews = <NewsItem>[
      const NewsItem(
        id: '1',
        title: 'New Study Shows Benefits of Daily Walking for Seniors',
        category: 'Health',
        readTime: '3 min read',
      ),
      const NewsItem(
        id: '2',
        title: 'Spring Gardening Tips for Beginners',
        category: 'Gardening',
        readTime: '5 min read',
      ),
      const NewsItem(
        id: '3',
        title: 'Easy Mediterranean Recipes for Heart Health',
        category: 'Cooking',
        readTime: '4 min read',
      ),
    ];

    final gameCards =
        <
          ({
            String title,
            String description,
            String route,
            IconData icon,
            Color color,
          })
        >[
          (
            title: 'Memory Match',
            description: 'Remember four gentle prompts',
            route: '/engagement/memory-games',
            icon: Ionicons.sparkles_outline,
            color: const Color(0xFF4ECDC4),
          ),
          (
            title: 'Number Trail',
            description: 'Fill in the next number',
            route: '/engagement/puzzle-games',
            icon: Ionicons.grid_outline,
            color: const Color(0xFF45B7D1),
          ),
          (
            title: 'Word Builder',
            description: 'Unscramble a familiar word',
            route: '/engagement/word-games',
            icon: Ionicons.text_outline,
            color: const Color(0xFF96CEB4),
          ),
          (
            title: 'Logic Pick',
            description: 'Choose the best answer',
            route: '/engagement/logic-games',
            icon: Ionicons.calculator_outline,
            color: const Color(0xFFFFC857),
          ),
        ];

    final greeting = () {
      final hour = DateTime.now().hour;
      if (hour < 12) return 'Morning';
      if (hour < 17) return 'Afternoon';
      return 'Evening';
    }();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good $greeting!',
                        style: TextStyle(
                          color: colors.text.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.name ?? 'User',
                        style: TextStyle(
                          color: colors.text,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => context.go('/profile'),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: colors.tint.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Ionicons.person, color: colors.tint),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.tint.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const AppLogo(size: 56),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ready for a calm, active day?',
                            style: TextStyle(
                              color: colors.text,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Start with a daily challenge or pick a short game.',
                            style: TextStyle(
                              color: colors.icon,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Today's Overview",
                style: TextStyle(
                  color: colors.text,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StatCard(
                    icon: Ionicons.extension_puzzle_outline,
                    value: totalPuzzles.toString(),
                    label: 'Puzzles',
                    iconColor: const Color(0xFF4CAF50),
                    colors: colors,
                  ),
                  _StatCard(
                    icon: Ionicons.game_controller_outline,
                    value: totalGames.toString(),
                    label: 'Games',
                    iconColor: const Color(0xFF2196F3),
                    colors: colors,
                  ),
                  _StatCard(
                    icon: Ionicons.people_outline,
                    value: totalUsers.toString(),
                    label: 'Users',
                    iconColor: const Color(0xFF9C27B0),
                    colors: colors,
                  ),
                  _StatCard(
                    icon: Ionicons.checkmark_circle_outline,
                    value: completedToday.toString(),
                    label: 'Completed',
                    iconColor: const Color(0xFFFF9800),
                    colors: colors,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                'Quick Actions',
                style: TextStyle(
                  color: colors.text,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.go('/engagement');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.tint,
                        foregroundColor: colors.buttonForeground,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Ionicons.bulb_outline),
                      label: const Text(
                        'Start Challenge',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => context.go('/explore'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.tint,
                        foregroundColor: colors.buttonForeground,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Ionicons.newspaper_outline),
                      label: const Text(
                        'Read News',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mini Games',
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/engagement'),
                    child: Text(
                      'Open All',
                      style: TextStyle(
                        color: colors.tint,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final game in gameCards)
                    InkWell(
                      onTap: () => context.push(game.route),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.42,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colors.background,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: game.color.withOpacity(0.35),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: game.color.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(game.icon, color: game.color),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              game.title,
                              style: TextStyle(
                                color: colors.text,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              game.description,
                              style: TextStyle(
                                color: colors.icon,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent News',
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/explore'),
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color: colors.tint,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              for (final item in recentNews)
                InkWell(
                  onTap: () => context.push('/article/${item.id}'),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.icon.withOpacity(0.4)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
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
                                    item.category,
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
                            Text(
                              item.readTime,
                              style: TextStyle(
                                color: colors.icon,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.title,
                          style: TextStyle(
                            color: colors.text,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.tint.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.tint),
                ),
                child: Row(
                  children: [
                    Icon(Ionicons.heart_outline, color: colors.tint, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '"Every day is a new opportunity to learn something new and stay active!"',
                        style: TextStyle(
                          color: colors.text,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
    required this.colors,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;
  final AppThemeColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.42,
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
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: colors.text,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: colors.icon, fontSize: 12)),
        ],
      ),
    );
  }
}
