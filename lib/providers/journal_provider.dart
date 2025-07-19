import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../services/database_service.dart';

class JournalProvider with ChangeNotifier {
  final DatabaseService _databaseService;
  List<JournalEntry> _entries = [];
  String? _userId;
  bool _isLoading = false;

  JournalProvider(this._databaseService);

  List<JournalEntry> get entries => _entries;
  bool get isLoading => _isLoading;

  void updateUserId(String? userId) {
    debugPrint('JournalProvider: updateUserId called with userId: $userId');
    _userId = userId;
    if (userId != null) {
      debugPrint('JournalProvider: Loading journal entries for user: $userId');
      _loadEntries();
    } else {
      debugPrint('JournalProvider: userId is null, clearing entries');
      _entries.clear();
      notifyListeners();
    }
  }

  Future<void> _loadEntries() async {
    if (_userId == null) {
      debugPrint('JournalProvider: _loadEntries called but userId is null');
      return;
    }
    
    debugPrint('JournalProvider: Starting to load journal entries for user: $_userId');
    setState(() {
      _isLoading = true;
    });

    try {
      _entries = await _databaseService.getJournalEntries(_userId!);
      debugPrint('JournalProvider: Loaded ${_entries.length} journal entries');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading journal entries: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> addEntry(JournalEntry entry) async {
    if (_userId == null) {
      debugPrint('JournalProvider: addEntry called but userId is null');
      return;
    }
    
    debugPrint('JournalProvider: Adding journal entry: ${entry.title}');
    try {
      await _databaseService.addJournalEntry(_userId!, entry);
      _entries.insert(0, entry); // Add to beginning of list
      debugPrint('JournalProvider: Successfully added journal entry, total entries: ${_entries.length}');
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding journal entry: $e');
      rethrow;
    }
  }

  Future<void> updateEntry(JournalEntry entry) async {
    if (_userId == null) {
      debugPrint('JournalProvider: updateEntry called but userId is null');
      return;
    }
    
    try {
      await _databaseService.updateJournalEntry(_userId!, entry);
      final index = _entries.indexWhere((e) => e.id == entry.id);
      if (index != -1) {
        _entries[index] = entry;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating journal entry: $e');
      rethrow;
    }
  }

  Future<void> deleteEntry(String entryId) async {
    if (_userId == null) {
      debugPrint('JournalProvider: deleteEntry called but userId is null');
      return;
    }
    
    try {
      await _databaseService.deleteJournalEntry(_userId!, entryId);
      _entries.removeWhere((entry) => entry.id == entryId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting journal entry: $e');
      rethrow;
    }
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }

  // Get entries for a specific date range
  List<JournalEntry> getEntriesForDateRange(DateTime start, DateTime end) {
    return _entries.where((entry) => 
      entry.date.isAfter(start.subtract(const Duration(days: 1))) && 
      entry.date.isBefore(end.add(const Duration(days: 1)))
    ).toList();
  }

  // Get most recent entries
  List<JournalEntry> getRecentEntries(int count) {
    return _entries.take(count).toList();
  }

  // Search entries by title or content
  List<JournalEntry> searchEntries(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _entries.where((entry) => 
      entry.title.toLowerCase().contains(lowercaseQuery) ||
      entry.content.toLowerCase().contains(lowercaseQuery)
    ).toList();
  }
}