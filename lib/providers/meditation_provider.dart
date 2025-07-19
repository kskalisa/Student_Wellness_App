import 'package:flutter/material.dart';
import '../models/meditation_session.dart';
import '../services/database_service.dart';

class MeditationProvider with ChangeNotifier {
  final DatabaseService _databaseService;
  List<MeditationSession> _sessions = [];
  List<MeditationSession> _completedSessions = [];
  String? _userId;
  bool _isLoading = false;

  MeditationProvider(this._databaseService);

  List<MeditationSession> get sessions => _sessions;
  List<MeditationSession> get completedSessions => _completedSessions;
  bool get isLoading => _isLoading;

  void updateUserId(String? userId) {
    debugPrint('MeditationProvider: updateUserId called with userId: $userId');
    _userId = userId;
    if (userId != null) {
      debugPrint('MeditationProvider: Loading meditation sessions for user: $userId');
      _loadSessions();
    } else {
      debugPrint('MeditationProvider: userId is null, clearing sessions');
      _sessions.clear();
      _completedSessions.clear();
      notifyListeners();
    }
  }

  Future<void> _loadSessions() async {
    if (_userId == null) {
      debugPrint('MeditationProvider: _loadSessions called but userId is null');
      return;
    }
    
    debugPrint('MeditationProvider: Starting to load meditation sessions for user: $_userId');
    setState(() {
      _isLoading = true;
    });

    try {
      // Load available sessions (this would typically come from a predefined list or API)
      _sessions = _getDefaultSessions();
      
      // Load completed sessions from database
      _completedSessions = await _databaseService.getCompletedMeditationSessions(_userId!);
      
      debugPrint('MeditationProvider: Loaded ${_sessions.length} sessions and ${_completedSessions.length} completed sessions');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading meditation sessions: $e');
      // Fallback to default sessions if database fails
      _sessions = _getDefaultSessions();
      notifyListeners();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<MeditationSession> _getDefaultSessions() {
    return [
      MeditationSession(
        id: 'basic_breathing',
        userId: _userId ?? 'default',
        title: 'Basic Breathing',
        description: 'Learn basic breathing techniques for stress relief and relaxation',
        durationMinutes: 5,
        category: 'Calm',
        isPremium: false,
      ),
      MeditationSession(
        id: 'deep_relaxation',
        userId: _userId ?? 'default',
        title: 'Deep Relaxation',
        description: 'Guided meditation for deep relaxation and inner peace',
        durationMinutes: 15,
        category: 'Relax',
        isPremium: true,
      ),
      MeditationSession(
        id: 'sleep_meditation',
        userId: _userId ?? 'default',
        title: 'Sleep Meditation',
        description: 'Gentle meditation to help you fall asleep naturally',
        durationMinutes: 10,
        category: 'Sleep',
        isPremium: false,
      ),
      MeditationSession(
        id: 'focus_meditation',
        userId: _userId ?? 'default',
        title: 'Focus & Concentration',
        description: 'Improve your focus and concentration with this guided session',
        durationMinutes: 12,
        category: 'Focus',
        isPremium: true,
      ),
      MeditationSession(
        id: 'breathing_exercises',
        userId: _userId ?? 'default',
        title: 'Breathing Exercises',
        description: 'Master various breathing techniques for better health',
        durationMinutes: 8,
        category: 'Breath',
        isPremium: false,
      ),
      MeditationSession(
        id: 'morning_meditation',
        userId: _userId ?? 'default',
        title: 'Morning Meditation',
        description: 'Start your day with positive energy and mindfulness',
        durationMinutes: 7,
        category: 'Calm',
        isPremium: false,
      ),
    ];
  }

  Future<void> completeSession(String sessionId, {int? rating}) async {
    if (_userId == null) {
      debugPrint('MeditationProvider: completeSession called but userId is null');
      return;
    }
    
    try {
      final session = _sessions.firstWhere((s) => s.id == sessionId);
      final completedSession = session.copyWith(
        completedAt: DateTime.now(),
        rating: rating,
      );

      await _databaseService.addCompletedMeditationSession(_userId!, completedSession);
      _completedSessions.insert(0, completedSession);
      notifyListeners();
      
      debugPrint('MeditationProvider: Session completed: ${session.title}');
    } catch (e) {
      debugPrint('Error completing meditation session: $e');
      rethrow;
    }
  }

  List<MeditationSession> getSessionsByCategory(String category) {
    return _sessions.where((session) => session.category == category).toList();
  }

  List<MeditationSession> getCompletedSessionsForDateRange(DateTime start, DateTime end) {
    return _completedSessions.where((session) => 
      session.completedAt != null &&
      session.completedAt!.isAfter(start.subtract(const Duration(days: 1))) && 
      session.completedAt!.isBefore(end.add(const Duration(days: 1)))
    ).toList();
  }

  int getTotalMinutesCompleted() {
    return _completedSessions.fold(0, (total, session) => total + session.durationMinutes);
  }

  double getAverageRating() {
    final ratedSessions = _completedSessions.where((session) => session.rating != null).toList();
    if (ratedSessions.isEmpty) return 0;
    final totalRating = ratedSessions.fold(0, (total, session) => total + (session.rating ?? 0));
    return totalRating / ratedSessions.length;
  }

  String getMostPopularCategory() {
    final categoryCounts = <String, int>{};
    for (final session in _completedSessions) {
      categoryCounts[session.category] = (categoryCounts[session.category] ?? 0) + 1;
    }
    
    String? mostPopular;
    int maxCount = 0;
    categoryCounts.forEach((category, count) {
      if (count > maxCount) {
        maxCount = count;
        mostPopular = category;
      }
    });
    
    return mostPopular ?? 'Calm';
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }
} 