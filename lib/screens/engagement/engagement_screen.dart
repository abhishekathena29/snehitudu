import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_logo.dart';

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
        title: 'Memory Match',
        description: 'Short memory rounds with familiar words',
        icon: Ionicons.sparkles_outline,
        color: const Color(0xFF4ECDC4),
        route: '/engagement/memory-games',
      ),
      _EngagementFeature(
        id: 'puzzle-games',
        title: 'Number Trail',
        description: 'Find the next number in a calm sequence',
        icon: Ionicons.grid_outline,
        color: const Color(0xFF45B7D1),
        route: '/engagement/puzzle-games',
      ),
      _EngagementFeature(
        id: 'word-games',
        title: 'Word Builder',
        description: 'Unscramble everyday words with clear choices',
        icon: Ionicons.text_outline,
        color: const Color(0xFF96CEB4),
        route: '/engagement/word-games',
      ),
      _EngagementFeature(
        id: 'logic-games',
        title: 'Logic Pick',
        description: 'Answer a simple question with one right option',
        icon: Ionicons.calculator_outline,
        color: const Color(0xFFFFEAA7),
        route: '/engagement/logic-games',
      ),
      _EngagementFeature(
        id: 'photo-puzzle',
        title: 'Family Photo Puzzle',
        description: 'Rebuild a family picture, tile by tile',
        icon: Ionicons.images_outline,
        color: const Color(0xFFE76F51),
        route: '/engagement/photo-puzzle',
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
                'Engagement',
                style: TextStyle(
                  color: colors.text,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Keep your mind active and engaged',
                style: TextStyle(color: colors.icon, fontSize: 16),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.tint.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Challenge Available!',
                      style: TextStyle(
                        color: colors.text,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        // const AppLogo(size: 48),
                        // const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                'Complete today\'s challenge to maintain your streak',
                                style: TextStyle(
                                  color: colors.icon,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),

                        ElevatedButton(
                          onPressed: () =>
                              context.push('/engagement/daily-challenge'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.tint,
                            foregroundColor: colors.buttonForeground,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Start Now',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Brain Training Activities',
                style: TextStyle(
                  color: colors.text,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                spacing: 12,
                // runSpacing: 12,
                children: [
                  for (final feature in features)
                    SizedBox(
                      // width: MediaQuery.of(context).size.width * 0.44,
                      child: InkWell(
                        onTap: () => context.push(feature.route),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colors.icon.withOpacity(0.4),
                            ),
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
                                    decoration: BoxDecoration(
                                      color: feature.color.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      feature.icon,
                                      color: feature.color,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    feature.title,
                                    style: TextStyle(
                                      color: colors.text,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    feature.description,
                                    style: TextStyle(
                                      color: colors.icon,
                                      fontSize: 18,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                'Brain Health Tips',
                style: TextStyle(
                  color: colors.text,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _TipCard(
                icon: Ionicons.bulb_outline,
                text:
                    'Regular brain training can help maintain cognitive function and improve memory as you age.',
                colors: colors,
              ),
              const SizedBox(height: 12),
              _TipCard(
                icon: Ionicons.time_outline,
                text:
                    'Try to complete at least one activity daily to build a consistent routine.',
                colors: colors,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
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
  const _TipCard({
    required this.icon,
    required this.text,
    required this.colors,
  });

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
            child: Text(
              text,
              style: TextStyle(color: colors.text, fontSize: 19, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
