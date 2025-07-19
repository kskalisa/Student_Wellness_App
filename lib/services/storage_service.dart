import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/mood.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<void> saveMoods(List<Mood> moods) async {
    final jsonList = moods.map((mood) => mood.toJson()).toList();
    await _prefs.setString('moods', jsonEncode(jsonList));
  }

  Future<List<Mood>> loadMoods() async {
    final jsonString = _prefs.getString('moods') ?? '[]';
    final jsonList = jsonDecode(jsonString) as List;
    return jsonList.map((json) => Mood.fromJson(json)).toList();
  }

// Similar methods for journal entries, etc.
}