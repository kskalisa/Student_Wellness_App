import 'package:flutter/material.dart';
import 'package:student_wellness_app/models/mood.dart';
import 'package:student_wellness_app/services/database_service.dart';

class MoodProvider with ChangeNotifier {
  final DatabaseService _databaseService;
  List<Mood> _moods = [];
  String? _userId;
  bool _isLoading = false;

  MoodProvider(this._databaseService);

  List<Mood> get moods => _moods;
  bool get isLoading => _isLoading;

  void updateUserId(String? userId) {
    debugPrint('MoodProvider: updateUserId called with userId: $userId');
    _userId = userId;
    if (userId != null) {
      debugPrint('MoodProvider: Loading moods for user: $userId');
      _loadMoods();
    } else {
      debugPrint('MoodProvider: userId is null, clearing moods');
      _moods.clear();
      notifyListeners();
    }
  }

  Future<void> _loadMoods() async {
    if (_userId == null) {
      debugPrint('MoodProvider: _loadMoods called but userId is null');
      return;
    }
    
    debugPrint('MoodProvider: Starting to load moods for user: $_userId');
    setState(() {
      _isLoading = true;
    });

    try {
      _moods = await _databaseService.getMoods(_userId!);
      debugPrint('MoodProvider: Loaded ${_moods.length} moods');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading moods: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> addMood(Mood mood) async {
    if (_userId == null) {
      debugPrint('MoodProvider: addMood called but userId is null');
      return;
    }
    
    debugPrint('MoodProvider: Adding mood: ${mood.moodType} with intensity: ${mood.intensity}');
    try {
      await _databaseService.addMood(_userId!, mood);
      _moods.insert(0, mood); // Add to beginning of list
      debugPrint('MoodProvider: Successfully added mood, total moods: ${_moods.length}');
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding mood: $e');
      rethrow;
    }
  }

  Future<void> updateMood(Mood mood) async {
    if (_userId == null) return;
    
    try {
      await _databaseService.updateMood(_userId!, mood);
      final index = _moods.indexWhere((m) => m.id == mood.id);
      if (index != -1) {
        _moods[index] = mood;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating mood: $e');
      rethrow;
    }
  }

  Future<void> deleteMood(String moodId) async {
    if (_userId == null) return;
    
    try {
      await _databaseService.deleteMood(_userId!, moodId);
      _moods.removeWhere((mood) => mood.id == moodId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting mood: $e');
      rethrow;
    }
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }

  // Get moods for a specific date range
  List<Mood> getMoodsForDateRange(DateTime start, DateTime end) {
    return _moods.where((mood) => 
      mood.date.isAfter(start.subtract(const Duration(days: 1))) && 
      mood.date.isBefore(end.add(const Duration(days: 1)))
    ).toList();
  }

  // Get most common mood
  String? getMostCommonMood() {
    if (_moods.isEmpty) return null;
    
    final moodCounts = <String, int>{};
    for (final mood in _moods) {
      moodCounts[mood.moodType] = (moodCounts[mood.moodType] ?? 0) + 1;
    }
    
    String? mostCommon;
    int maxCount = 0;
    moodCounts.forEach((mood, count) {
      if (count > maxCount) {
        maxCount = count;
        mostCommon = mood;
      }
    });
    
    return mostCommon;
  }

  // Get average intensity
  double getAverageIntensity() {
    if (_moods.isEmpty) return 0;
    final total = _moods.fold(0, (sum, mood) => sum + mood.intensity);
    return total / _moods.length;
  }
}