import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../models/hobby_item.dart';
import '../../services/memory_photo_service.dart';
import '../../theme/app_theme.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

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
    final photoService = context.watch<MemoryPhotoService>();
    final photos = photoService.photos;

    final hobbyItems = <HobbyItem>[
      const HobbyItem(
        id: '1',
        title: 'Watercolor Painting',
        description:
            'Express your creativity with gentle watercolor techniques perfect for beginners.',
        category: 'creative',
        difficulty: 'beginner',
        timeRequired: '1-2 hours',
        materials: ['Watercolor set', 'Brushes', 'Watercolor paper', 'Water container'],
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
                'Memories',
                style: TextStyle(
                  color: colors.text,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Photos of family and friends, kept just on this phone.',
                style: TextStyle(color: colors.icon, fontSize: 18, height: 1.4),
              ),
              const SizedBox(height: 18),
              _AddPhotoActions(service: photoService),
              const SizedBox(height: 18),
              if (photos.isEmpty)
                _EmptyMemories(colors: colors)
              else
                _PhotoGrid(photos: photos, colors: colors),
              const SizedBox(height: 32),
              Text(
                'Hobbies to enjoy',
                style: TextStyle(
                  color: colors.text,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              for (final hobby in hobbyItems)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: colors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.icon.withOpacity(0.4)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
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
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: colors.tint.withOpacity(0.18),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(_hobbyIcon(hobby.category),
                                color: colors.tint, size: 30),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              hobby.title,
                              style: TextStyle(
                                color: colors.text,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        hobby.description,
                        style: TextStyle(
                          color: colors.text,
                          fontSize: 18,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '⏱ ${hobby.timeRequired}',
                        style: TextStyle(
                          color: colors.icon,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddPhotoActions extends StatelessWidget {
  const _AddPhotoActions({required this.service});

  final MemoryPhotoService service;

  Future<void> _pick(BuildContext context, bool fromCamera) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final photo = fromCamera
          ? await service.addFromCamera()
          : await service.addFromGallery();
      if (photo == null) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Memory added')),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Could not add photo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton.icon(
          onPressed: () => _pick(context, false),
          icon: const Icon(Ionicons.images_outline),
          label: const Text('Add from gallery'),
        ),
        ElevatedButton.icon(
          onPressed: () => _pick(context, true),
          icon: const Icon(Ionicons.camera_outline),
          label: const Text('Take a photo'),
        ),
      ],
    );
  }
}

class _EmptyMemories extends StatelessWidget {
  const _EmptyMemories({required this.colors});

  final AppThemeColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: colors.tint.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.tint.withOpacity(0.4), width: 1.5),
      ),
      child: Column(
        children: [
          Icon(Ionicons.images_outline, size: 56, color: colors.tint),
          const SizedBox(height: 12),
          Text(
            'No memories yet',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: colors.text, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a picture of family or grandkids. You can also turn any photo into a puzzle.',
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.icon, fontSize: 17, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _PhotoGrid extends StatelessWidget {
  const _PhotoGrid({required this.photos, required this.colors});

  final List<MemoryPhoto> photos;
  final AppThemeColors colors;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final p = photos[index];
        return _PhotoTile(photo: p, colors: colors);
      },
    );
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({required this.photo, required this.colors});

  final MemoryPhoto photo;
  final AppThemeColors colors;

  Future<void> _showOptions(BuildContext context) async {
    final service = context.read<MemoryPhotoService>();
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Ionicons.create_outline, size: 28),
                title: const Text('Add a name', style: TextStyle(fontSize: 19)),
                onTap: () => Navigator.of(ctx).pop('rename'),
              ),
              ListTile(
                leading:
                    const Icon(Ionicons.extension_puzzle_outline, size: 28),
                title:
                    const Text('Make a puzzle', style: TextStyle(fontSize: 19)),
                onTap: () => Navigator.of(ctx).pop('puzzle'),
              ),
              ListTile(
                leading: const Icon(Ionicons.trash_outline,
                    size: 28, color: Color(0xFFE53935)),
                title: const Text('Remove',
                    style:
                        TextStyle(fontSize: 19, color: Color(0xFFE53935))),
                onTap: () => Navigator.of(ctx).pop('delete'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (!context.mounted) return;
    switch (result) {
      case 'rename':
        await _rename(context, service);
        break;
      case 'delete':
        await service.deletePhoto(photo);
        break;
      case 'puzzle':
        context.push('/engagement/photo-puzzle');
        break;
    }
  }

  Future<void> _rename(
      BuildContext context, MemoryPhotoService service) async {
    final controller = TextEditingController(text: photo.label);
    final newLabel = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Name this memory'),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(fontSize: 19),
          decoration: const InputDecoration(
            hintText: 'e.g. Diwali with grandkids',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
              child: const Text('Save')),
        ],
      ),
    );
    if (newLabel != null) {
      await service.renamePhoto(photo, newLabel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showOptions(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.icon.withOpacity(0.3), width: 1.5),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.file(File(photo.path), fit: BoxFit.cover),
            ),
            if (photo.label.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(14),
                    ),
                  ),
                  child: Text(
                    photo.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
