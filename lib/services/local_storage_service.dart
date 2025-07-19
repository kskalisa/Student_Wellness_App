// lib/services/local_storage_service.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_wellness_app/models/user_profile.dart';
import 'package:student_wellness_app/models/mood.dart';
import 'package:student_wellness_app/models/journal_entry.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  // User Profile
  Future<UserProfile?> getUserProfile(String userId) async {
    final json = _prefs.getString('user_$userId');
    return json != null ? UserProfile.fromJson(jsonDecode(json)) : null;
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    await _prefs.setString('user_${profile.userId}', jsonEncode(profile.toJson()));
  }

  // Mood Data
  Future<List<Mood>> getMoods(String userId) async {
    final jsonList = _prefs.getStringList('moods_$userId') ?? [];
    return jsonList.map((json) => Mood.fromJson(jsonDecode(json))).toList();
  }

  Future<void> saveMoods(String userId, List<Mood> moods) async {
    await _prefs.setStringList(
      'moods_$userId',
      moods.map((mood) => jsonEncode(mood.toJson())).toList(),
    );
  }

  // Journal Entries
  Future<List<JournalEntry>> getJournalEntries(String userId) async {
    final jsonList = _prefs.getStringList('journals_$userId') ?? [];
    return jsonList.map((json) => JournalEntry.fromJson(jsonDecode(json))).toList();
  }

  Future<void> saveJournalEntries(String userId, List<JournalEntry> entries) async {
    await _prefs.setStringList(
      'journals_$userId',
      entries.map((entry) => jsonEncode(entry.toJson())).toList(),
    );
  }
}