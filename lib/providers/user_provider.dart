// lib/providers/user_provider.dart
import 'package:flutter/material.dart';
import 'package:student_wellness_app/models/user_profile.dart';
import 'package:student_wellness_app/services/database_service.dart';
import 'package:student_wellness_app/services/local_storage_service.dart';

class UserProvider with ChangeNotifier {
  final DatabaseService _databaseService;
  final LocalStorageService _localStorage;
  UserProfile? _profile;
  String? _userId;

  UserProfile? get profile => _profile;

  UserProvider({
    required DatabaseService databaseService,
    required LocalStorageService localStorage,
  })  : _databaseService = databaseService,
        _localStorage = localStorage;

  void updateUserId(String? userId) {
    _userId = userId;
    if (userId != null) {
      _loadProfile();
    }
  }

  Future<void> _loadProfile() async {
    try {
      // Try local storage first
      _profile = await _localStorage.getUserProfile(_userId!);

      // Then try network
      final remoteProfile = await _databaseService.getUserProfile(_userId!);
      if (remoteProfile != null) {
        _profile = remoteProfile;
        await _localStorage.saveUserProfile(_profile!);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }
  }

  Future<void> updateProfile(UserProfile newProfile) async {
    _profile = newProfile;
    notifyListeners();

    await Future.wait([
      _databaseService.saveUserProfile(newProfile),
      _localStorage.saveUserProfile(newProfile),
    ]);
  }
}