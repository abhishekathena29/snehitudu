import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_progress.dart';

class DailyChallengeStorage {
  static const _key = 'dailyChallengeProgress';

  Future<UserProgress> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);
    if (stored == null) return UserProgress.initial();
    try {
      final data = json.decode(stored) as Map<String, dynamic>;
      return UserProgress.fromJson(data);
    } catch (_) {
      return UserProgress.initial();
    }
  }

  Future<void> saveProgress(UserProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(progress.toJson());
    await prefs.setString(_key, encoded);
  }
}
