import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/app_user.dart';

class AuthService extends ChangeNotifier {
  AuthService() {
    _subscription = _auth.authStateChanges().listen(_handleAuthStateChange);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  StreamSubscription<User?>? _subscription;
  AppUser? _user;
  bool _isLoading = true;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<void> _handleAuthStateChange(User? firebaseUser) async {
    if (firebaseUser == null) {
      _user = null;
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final doc = await _db.collection('users').doc(firebaseUser.uid).get();
      if (doc.exists && doc.data() != null) {
        _user = AppUser.fromMap(firebaseUser.uid, doc.data()!);
      } else {
        final defaultUser = AppUser(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'User',
          email: firebaseUser.email ?? '',
          preferences: const UserPreferences(
            notifications: true,
            accessibility: true,
            theme: 'auto',
          ),
        );
        _user = defaultUser;
        try {
          await _db.collection('users').doc(firebaseUser.uid).set(defaultUser.toMap());
        } catch (_) {
          // Ignore Firestore permission errors and keep local state.
        }
      }
    } catch (_) {
      _user = AppUser(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? 'User',
        email: firebaseUser.email ?? '',
        preferences: const UserPreferences(
          notifications: true,
          accessibility: true,
          theme: 'auto',
        ),
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (error) {
      throw Exception(error.message ?? 'Login failed');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);

      final user = AppUser(
        id: credential.user!.uid,
        name: name,
        email: email,
        preferences: const UserPreferences(
          notifications: true,
          accessibility: true,
          theme: 'auto',
        ),
      );

      await _db.collection('users').doc(credential.user!.uid).set(user.toMap());
      _user = user;
      return true;
    } on FirebaseAuthException catch (error) {
      throw Exception(error.message ?? 'Registration failed');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> updateUserProfile(AppUser updatedUser) async {
    _user = updatedUser;
    notifyListeners();
    try {
      await _db.collection('users').doc(updatedUser.id).set(updatedUser.toMap(), SetOptions(merge: true));
    } catch (_) {
      // Ignore Firestore permission errors and keep local state.
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
