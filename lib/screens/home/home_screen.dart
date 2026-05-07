import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../services/memory_photo_service.dart';
import '../../services/profile_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final user = context.watch<ProfileService>().profile;
    final photos = context.watch<MemoryPhotoService>().photos;

    final greeting = () {
      final hour = DateTime.now().hour;
      if (hour < 12) return 'Morning';
      if (hour < 17) return 'Afternoon';
      return 'Evening';
    }();

    final games = <_GameCardData>[
      _GameCardData(
        title: 'Daily Challenge',
        description: "Today's brain warm-up",
        route: '/engagement/daily-challenge',
        icon: Ionicons.trophy_outline,
        color: const Color(0xFFFF6B6B),
      ),
      _GameCardData(
        title: 'Family Photo Puzzle',
        description: 'Rebuild a picture of someone you love',
        route: '/engagement/photo-puzzle',
        icon: Ionicons.images_outline,
        color: const Color(0xFFE76F51),
      ),
      _GameCardData(
        title: 'Memory Match',
        description: 'Remember four gentle words',
        route: '/engagement/memory-games',
        icon: Ionicons.sparkles_outline,
        color: const Color(0xFF4ECDC4),
      ),
      _GameCardData(
        title: 'Number Trail',
        description: 'Find the next number',
        route: '/engagement/puzzle-games',
        icon: Ionicons.grid_outline,
        color: const Color(0xFF45B7D1),
      ),
      _GameCardData(
        title: 'Word Builder',
        description: 'Unscramble a familiar word',
        route: '/engagement/word-games',
        icon: Ionicons.text_outline,
        color: const Color(0xFF96CEB4),
      ),
      _GameCardData(
        title: 'Logic Pick',
        description: 'Choose the best answer',
        route: '/engagement/logic-games',
        icon: Ionicons.calculator_outline,
        color: const Color(0xFFFFC857),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good $greeting!',
                          style: TextStyle(
                            color: colors.text.withOpacity(0.85),
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          user.name,
                          style: TextStyle(
                            color: colors.text,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => context.go('/profile'),
                    borderRadius: BorderRadius.circular(36),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colors.tint.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Ionicons.person, color: colors.tint, size: 32),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _DailyChallengeBanner(colors: colors),
              const SizedBox(height: 28),
              Text(
                'Today’s Activities',
                style: TextStyle(
                  color: colors.text,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              for (final game in games) ...[
                _BigGameButton(data: game, colors: colors),
                const SizedBox(height: 14),
              ],
              const SizedBox(height: 12),
              if (photos.isNotEmpty) _RecentMemory(photos: photos, colors: colors),
              const SizedBox(height: 24),
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.tint.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.tint),
                ),
                child: Row(
                  children: [
                    Icon(Ionicons.heart_outline, color: colors.tint, size: 32),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        '“A small puzzle each day keeps the mind playful.”',
                        style: TextStyle(
                          color: colors.text,
                          fontSize: 19,
                          fontStyle: FontStyle.italic,
                          height: 1.45,
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

class _GameCardData {
  const _GameCardData({
    required this.title,
    required this.description,
    required this.route,
    required this.icon,
    required this.color,
  });

  final String title;
  final String description;
  final String route;
  final IconData icon;
  final Color color;
}

class _DailyChallengeBanner extends StatelessWidget {
  const _DailyChallengeBanner({required this.colors});

  final AppThemeColors colors;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/engagement/daily-challenge'),
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.tint.withOpacity(0.10),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const AppLogo(size: 64),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ready for today?',
                      style: TextStyle(
                        color: colors.text,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tap here to play your Daily Challenge.',
                      style: TextStyle(
                        color: colors.icon,
                        fontSize: 18,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Ionicons.chevron_forward, color: colors.tint, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class _BigGameButton extends StatelessWidget {
  const _BigGameButton({required this.data, required this.colors});

  final _GameCardData data;
  final AppThemeColors colors;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(data.route),
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: data.color.withOpacity(0.6), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: data.color.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(data.icon, color: data.color, size: 34),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: TextStyle(
                        color: colors.text,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.description,
                      style: TextStyle(
                        color: colors.icon,
                        fontSize: 17,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Ionicons.chevron_forward, color: colors.icon, size: 26),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentMemory extends StatelessWidget {
  const _RecentMemory({required this.photos, required this.colors});

  final List<MemoryPhoto> photos;
  final AppThemeColors colors;

  @override
  Widget build(BuildContext context) {
    final latest = photos.first;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.go('/explore'),
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.icon.withOpacity(0.35), width: 1.5),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  File(latest.path),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A recent memory',
                      style: TextStyle(
                        color: colors.icon,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      latest.label.isNotEmpty ? latest.label : 'Tap to see all',
                      style: TextStyle(
                        color: colors.text,
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Ionicons.chevron_forward, color: colors.icon, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
