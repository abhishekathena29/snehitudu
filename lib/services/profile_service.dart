import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';

class ProfileService extends ChangeNotifier {
  ProfileService() {
    _load();
  }

  static const _key = 'localProfile';

  AppUser _profile = AppUser.initial();
  bool _isLoading = true;

  AppUser get profile => _profile;
  bool get isLoading => _isLoading;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null && raw.isNotEmpty) {
      try {
        _profile = AppUser.fromMap(
          Map<String, dynamic>.from(json.decode(raw) as Map),
        );
      } catch (_) {
        _profile = AppUser.initial();
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> update(AppUser updated) async {
    _profile = updated;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, json.encode(updated.toMap()));
  }
}
