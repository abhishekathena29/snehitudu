import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../services/memory_photo_service.dart';
import '../../theme/app_theme.dart';

class PhotoPuzzleScreen extends StatefulWidget {
  const PhotoPuzzleScreen({super.key});

  @override
  State<PhotoPuzzleScreen> createState() => _PhotoPuzzleScreenState();
}

class _PhotoPuzzleScreenState extends State<PhotoPuzzleScreen> {
  static const int _gridSize = 3; // 3x3
  final Random _random = Random();

  MemoryPhoto? _activePhoto;
  List<int> _order = [];
  int _selectedIndex = -1;
  int _moves = 0;
  bool _solved = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final photos = context.read<MemoryPhotoService>().photos;
      if (photos.isNotEmpty) {
        _start(photos.first);
      }
    });
  }

  void _start(MemoryPhoto photo) {
    final n = _gridSize * _gridSize;
    var order = List<int>.generate(n, (i) => i);
    do {
      order.shuffle(_random);
    } while (_isSolved(order));
    setState(() {
      _activePhoto = photo;
      _order = order;
      _selectedIndex = -1;
      _moves = 0;
      _solved = false;
    });
  }

  bool _isSolved(List<int> order) {
    for (int i = 0; i < order.length; i++) {
      if (order[i] != i) return false;
    }
    return true;
  }

  void _handleTap(int index) {
    if (_solved) return;
    if (_selectedIndex == -1) {
      setState(() => _selectedIndex = index);
      return;
    }
    if (_selectedIndex == index) {
      setState(() => _selectedIndex = -1);
      return;
    }
    final newOrder = List<int>.from(_order);
    final tmp = newOrder[_selectedIndex];
    newOrder[_selectedIndex] = newOrder[index];
    newOrder[index] = tmp;
    final solved = _isSolved(newOrder);
    setState(() {
      _order = newOrder;
      _selectedIndex = -1;
      _moves += 1;
      _solved = solved;
    });
    if (solved) {
      _showWinDialog();
    }
  }

  void _showWinDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('🎉 You did it!'),
        content: Text(
          'You completed the puzzle in $_moves moves.',
          style: const TextStyle(fontSize: 19),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Done'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (_activePhoto != null) _start(_activePhoto!);
            },
            child: const Text('Play again'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    final service = context.read<MemoryPhotoService>();
    final photo = await service.addFromGallery();
    if (photo != null) _start(photo);
  }

  Future<void> _pickFromCamera() async {
    final service = context.read<MemoryPhotoService>();
    final photo = await service.addFromCamera();
    if (photo != null) _start(photo);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final photos = context.watch<MemoryPhotoService>().photos;
    final hasPhoto = _activePhoto != null;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Family Photo Puzzle'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE76F51).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE76F51),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Ionicons.images_outline, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Family Photo Puzzle',
                              style: TextStyle(color: colors.text, fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(
                            'Pick a family photo, then tap two tiles to swap and rebuild the picture.',
                            style: TextStyle(color: colors.icon, fontSize: 17, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (!hasPhoto)
                _emptyState(colors, photos)
              else
                _puzzleBoard(colors),
              const SizedBox(height: 20),
              _photoSelector(colors, photos),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickFromGallery,
                    icon: const Icon(Ionicons.images_outline),
                    label: const Text('Add from gallery'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _pickFromCamera,
                    icon: const Icon(Ionicons.camera_outline),
                    label: const Text('Take a photo'),
                  ),
                  if (hasPhoto)
                    OutlinedButton.icon(
                      onPressed: () => _start(_activePhoto!),
                      icon: const Icon(Ionicons.refresh_outline),
                      label: const Text('Shuffle again'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState(AppThemeColors colors, List<MemoryPhoto> photos) {
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
            photos.isEmpty
                ? 'Add a family photo to start the puzzle'
                : 'Pick one of your saved photos below',
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.text, fontSize: 20, fontWeight: FontWeight.w600, height: 1.4),
          ),
          const SizedBox(height: 8),
          Text(
            'Photos stay on this phone — they are not uploaded anywhere.',
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.icon, fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _puzzleBoard(AppThemeColors colors) {
    final photo = _activePhoto!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = constraints.maxWidth.clamp(0.0, 480.0);
        final tileSize = boardSize / _gridSize;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Moves: $_moves',
                    style: TextStyle(color: colors.text, fontSize: 19, fontWeight: FontWeight.w600)),
                if (photo.label.isNotEmpty)
                  Flexible(
                    child: Text(photo.label,
                        textAlign: TextAlign.right,
                        style: TextStyle(color: colors.icon, fontSize: 17, fontStyle: FontStyle.italic)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: SizedBox(
                width: boardSize,
                height: boardSize,
                child: Stack(
                  children: [
                    for (int i = 0; i < _order.length; i++)
                      _buildTile(
                        photoPath: photo.path,
                        slot: i,
                        tileIndex: _order[i],
                        tileSize: tileSize,
                        selected: _selectedIndex == i,
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTile({
    required String photoPath,
    required int slot,
    required int tileIndex,
    required double tileSize,
    required bool selected,
  }) {
    final col = slot % _gridSize;
    final row = slot ~/ _gridSize;
    final origCol = tileIndex % _gridSize;
    final origRow = tileIndex ~/ _gridSize;
    return Positioned(
      left: col * tileSize,
      top: row * tileSize,
      width: tileSize,
      height: tileSize,
      child: GestureDetector(
        onTap: () => _handleTap(slot),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? const Color(0xFFFFC857) : Colors.white,
              width: selected ? 4 : 2,
            ),
          ),
          child: ClipRect(
            child: OverflowBox(
              alignment: Alignment.topLeft,
              maxWidth: tileSize * _gridSize,
              maxHeight: tileSize * _gridSize,
              child: Transform.translate(
                offset: Offset(-origCol * tileSize, -origRow * tileSize),
                child: Image.file(
                  File(photoPath),
                  width: tileSize * _gridSize,
                  height: tileSize * _gridSize,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _photoSelector(AppThemeColors colors, List<MemoryPhoto> photos) {
    if (photos.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your photos',
            style: TextStyle(color: colors.text, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: photos.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final p = photos[index];
              final isActive = _activePhoto?.path == p.path;
              return GestureDetector(
                onTap: () => _start(p),
                child: Container(
                  width: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isActive ? colors.tint : colors.icon.withOpacity(0.4),
                      width: isActive ? 3 : 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.file(
                      File(p.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
