import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../theme/app_theme.dart';

class EngagementScreen extends StatelessWidget {
  const EngagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    final features = [
      _EngagementFeature(
        id: 'daily-challenge',
        title: 'Daily Challenge',
        description: "Complete today's brain training challenge",
        icon: Ionicons.trophy_outline,
        color: const Color(0xFFFF6B6B),
        route: '/engagement/daily-challenge',
      ),
      _EngagementFeature(
        id: 'memory-games',
        title: 'Memory Games',
        description: 'Train your memory with fun games',
        icon: Ionicons.fitness_outline,
        color: const Color(0xFF4ECDC4),
        route: '/engagement/memory-games',
      ),
      _EngagementFeature(
        id: 'puzzle-games',
        title: 'Puzzle Games',
        description: 'Solve puzzles and brain teasers',
        icon: Ionicons.grid_outline,
        color: const Color(0xFF45B7D1),
        route: '/engagement/puzzle-games',
      ),
      _EngagementFeature(
        id: 'word-games',
        title: 'Word Games',
        description: 'Expand your vocabulary with word games',
        icon: Ionicons.text_outline,
        color: const Color(0xFF96CEB4),
        route: '/engagement/word-games',
      ),
      _EngagementFeature(
        id: 'logic-games',
        title: 'Logic Games',
        description: 'Improve logical thinking skills',
        icon: Ionicons.calculator_outline,
        color: const Color(0xFFFFEAA7),
        route: '/engagement/logic-games',
      ),
      _EngagementFeature(
        id: 'progress-tracker',
        title: 'Progress Tracker',
        description: 'View your improvement over time',
        icon: Ionicons.trending_up_outline,
        color: const Color(0xFFDDA0DD),
        route: '/engagement/progress',
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
              Text('Engagement', style: TextStyle(color: colors.text, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Keep your mind active and engaged', style: TextStyle(color: colors.icon, fontSize: 16)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.tint.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(color: colors.tint, shape: BoxShape.circle),
                      child: const Icon(Ionicons.trophy, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Daily Challenge Available!', style: TextStyle(color: colors.text, fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('Complete today\'s challenge to maintain your streak', style: TextStyle(color: colors.icon, fontSize: 14)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => context.push('/engagement/daily-challenge'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.tint,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Start Now', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text('Brain Training Activities', style: TextStyle(color: colors.text, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final feature in features)
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.44,
                      child: InkWell(
                        onTap: () {
                          if (feature.id == 'daily-challenge') {
                            context.push(feature.route);
                          } else {
                            _showDialog(context, 'Coming Soon!', 'This feature will be available in the next update.');
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colors.icon.withOpacity(0.4)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(color: feature.color.withOpacity(0.2), shape: BoxShape.circle),
                                    child: Icon(feature.icon, color: feature.color, size: 24),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(feature.title, style: TextStyle(color: colors.text, fontSize: 14, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(feature.description, style: TextStyle(color: colors.icon, fontSize: 12, height: 1.3)),
                                ],
                              ),
                              if (feature.id != 'daily-challenge')
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: const Color(0xFFFF9800), borderRadius: BorderRadius.circular(8)),
                                    child: const Text('Coming Soon', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 30),
              Text('Brain Health Tips', style: TextStyle(color: colors.text, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _TipCard(
                icon: Ionicons.bulb_outline,
                text: 'Regular brain training can help maintain cognitive function and improve memory as you age.',
                colors: colors,
              ),
              const SizedBox(height: 12),
              _TipCard(
                icon: Ionicons.time_outline,
                text: 'Try to complete at least one activity daily to build a consistent routine.',
                colors: colors,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
        ],
      ),
    );
  }
}

class _EngagementFeature {
  const _EngagementFeature({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.route,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String route;
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.icon, required this.text, required this.colors});

  final IconData icon;
  final String text;
  final AppThemeColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.icon.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.tint, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: TextStyle(color: colors.text, fontSize: 14, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
