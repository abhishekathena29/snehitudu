import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoryPhoto {
  const MemoryPhoto({required this.path, required this.label, required this.addedAt});

  final String path;
  final String label;
  final DateTime addedAt;

  Map<String, dynamic> toMap() => {
        'path': path,
        'label': label,
        'addedAt': addedAt.toIso8601String(),
      };

  factory MemoryPhoto.fromMap(Map<String, dynamic> map) {
    return MemoryPhoto(
      path: map['path'] as String,
      label: (map['label'] as String?) ?? '',
      addedAt: DateTime.tryParse(map['addedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class MemoryPhotoService extends ChangeNotifier {
  MemoryPhotoService() {
    _load();
  }

  static const _key = 'memoryPhotos';

  final ImagePicker _picker = ImagePicker();
  List<MemoryPhoto> _photos = const [];
  bool _isLoading = true;

  List<MemoryPhoto> get photos => _photos;
  bool get isLoading => _isLoading;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? const [];
    final photos = <MemoryPhoto>[];
    for (final entry in raw) {
      try {
        final decoded = json.decode(entry);
        if (decoded is! Map) continue;
        final photo = MemoryPhoto.fromMap(Map<String, dynamic>.from(decoded));
        if (await File(photo.path).exists()) {
          photos.add(photo);
        }
      } catch (_) {
        // Skip bad entries.
      }
    }
    _photos = photos;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = _photos.map((p) => json.encode(p.toMap())).toList();
    await prefs.setStringList(_key, raw);
  }

  Future<MemoryPhoto?> addFromGallery({String label = ''}) {
    return _addFromSource(ImageSource.gallery, label);
  }

  Future<MemoryPhoto?> addFromCamera({String label = ''}) {
    return _addFromSource(ImageSource.camera, label);
  }

  Future<MemoryPhoto?> _addFromSource(ImageSource source, String label) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (picked == null) return null;

    final dir = await getApplicationDocumentsDirectory();
    final memoriesDir = Directory('${dir.path}/memories');
    if (!await memoriesDir.exists()) {
      await memoriesDir.create(recursive: true);
    }
    final ext = _extensionFor(picked.path);
    final filename = 'memory_${DateTime.now().millisecondsSinceEpoch}$ext';
    final destination = '${memoriesDir.path}/$filename';
    await File(picked.path).copy(destination);

    final photo = MemoryPhoto(
      path: destination,
      label: label,
      addedAt: DateTime.now(),
    );
    _photos = [photo, ..._photos];
    notifyListeners();
    await _persist();
    return photo;
  }

  Future<void> renamePhoto(MemoryPhoto target, String newLabel) async {
    _photos = _photos
        .map((p) => p.path == target.path
            ? MemoryPhoto(path: p.path, label: newLabel, addedAt: p.addedAt)
            : p)
        .toList();
    notifyListeners();
    await _persist();
  }

  Future<void> deletePhoto(MemoryPhoto target) async {
    _photos = _photos.where((p) => p.path != target.path).toList();
    notifyListeners();
    await _persist();
    try {
      final file = File(target.path);
      if (await file.exists()) await file.delete();
    } catch (_) {
      // Ignore deletion errors.
    }
  }

  String _extensionFor(String path) {
    final i = path.lastIndexOf('.');
    if (i == -1 || i == path.length - 1) return '.jpg';
    return path.substring(i).toLowerCase();
  }
}
