import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_wellness_app/models/user_profile.dart';
import 'package:student_wellness_app/models/mood.dart';
import 'package:student_wellness_app/models/journal_entry.dart';
import 'package:student_wellness_app/models/meditation_session.dart';
import 'package:student_wellness_app/models/anonymous_chat.dart';

abstract class DatabaseService {
  // User Profile Operations
  Future<UserProfile?> getUserProfile(String userId);
  Future<void> saveUserProfile(UserProfile profile);

  // Mood Operations
  Future<List<Mood>> getMoods(String userId);
  Future<void> addMood(String userId, Mood mood);
  Future<void> updateMood(String userId, Mood mood);
  Future<void> deleteMood(String userId, String moodId);

  // Journal Operations
  Future<List<JournalEntry>> getJournalEntries(String userId);
  Future<void> addJournalEntry(String userId, JournalEntry entry);
  Future<void> updateJournalEntry(String userId, JournalEntry entry);
  Future<void> deleteJournalEntry(String userId, String entryId);

  // Meditation Operations
  Future<List<MeditationSession>> getCompletedMeditationSessions(String userId);
  Future<void> addCompletedMeditationSession(String userId, MeditationSession session);
  Future<void> updateMeditationSession(String userId, MeditationSession session);
  Future<void> deleteMeditationSession(String userId, String sessionId);





  // Anonymous Chat Operations
  Future<List<AnonymousChat>> getAvailableAnonymousChats();
  Future<List<AnonymousChat>> getMyAnonymousChats(String anonymousId);
  Future<AnonymousChat?> getAnonymousChat(String chatId);
  Future<List<AnonymousChatMessage>> getAnonymousChatMessages(String chatId);
  Future<void> createAnonymousChat(AnonymousChat chat);
  Future<void> updateAnonymousChat(AnonymousChat chat);
  Future<void> sendAnonymousMessage(AnonymousChatMessage message);
  Future<void> reportAnonymousMessage(String messageId, String reason);
  Future<void> blockAnonymousUser(String userId, String blockedUserId);
}

class FirebaseDatabaseService implements DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User Profile Implementation
  @override
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists ? UserProfile.fromJson(doc.data()!) : null;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      await _firestore
          .collection('users')
          .doc(profile.userId)
          .set(profile.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save user profile: $e');
    }
  }

  // Mood Operations Implementation
  @override
  Future<List<Mood>> getMoods(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('moods')
          .orderBy('date', descending: true)
          .get();
      return snapshot.docs.map((doc) => Mood.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to get moods: $e');
    }
  }

  @override
  Future<void> addMood(String userId, Mood mood) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('moods')
          .doc(mood.id)
          .set(mood.toJson());
    } catch (e) {
      throw Exception('Failed to add mood: $e');
    }
  }

  @override
  Future<void> updateMood(String userId, Mood mood) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('moods')
          .doc(mood.id)
          .update(mood.toJson());
    } catch (e) {
      throw Exception('Failed to update mood: $e');
    }
  }

  @override
  Future<void> deleteMood(String userId, String moodId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('moods')
          .doc(moodId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete mood: $e');
    }
  }

  // Journal Operations Implementation
  @override
  Future<List<JournalEntry>> getJournalEntries(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('journals')
          .orderBy('date', descending: true)
          .get();
      return snapshot.docs.map((doc) => JournalEntry.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to get journal entries: $e');
    }
  }

  @override
  Future<void> addJournalEntry(String userId, JournalEntry entry) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('journals')
          .doc(entry.id)
          .set(entry.toJson());
    } catch (e) {
      throw Exception('Failed to add journal entry: $e');
    }
  }

  @override
  Future<void> updateJournalEntry(String userId, JournalEntry entry) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('journals')
          .doc(entry.id)
          .update(entry.toJson());
    } catch (e) {
      throw Exception('Failed to update journal entry: $e');
    }
  }

  @override
  Future<void> deleteJournalEntry(String userId, String entryId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('journals')
          .doc(entryId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete journal entry: $e');
    }
  }

  // Meditation Operations Implementation
  @override
  Future<List<MeditationSession>> getCompletedMeditationSessions(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('meditationSessions')
          .orderBy('date', descending: true)
          .get();
      return snapshot.docs.map((doc) => MeditationSession.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to get meditation sessions: $e');
    }
  }

  @override
  Future<void> addCompletedMeditationSession(String userId, MeditationSession session) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('meditationSessions')
          .doc(session.id)
          .set(session.toJson());
    } catch (e) {
      throw Exception('Failed to add meditation session: $e');
    }
  }

  @override
  Future<void> updateMeditationSession(String userId, MeditationSession session) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('meditationSessions')
          .doc(session.id)
          .update(session.toJson());
    } catch (e) {
      throw Exception('Failed to update meditation session: $e');
    }
  }

  @override
  Future<void> deleteMeditationSession(String userId, String sessionId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('meditationSessions')
          .doc(sessionId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete meditation session: $e');
    }
  }





  // Anonymous Chat Operations Implementation
  @override
  Future<List<AnonymousChat>> getAvailableAnonymousChats() async {
    try {
      final snapshot = await _firestore
          .collection('anonymous_chats')
          .where('isActive', isEqualTo: true)
          .orderBy('lastActivity', descending: true)
          .get();
      return snapshot.docs.map((doc) => AnonymousChat.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to get available anonymous chats: $e');
    }
  }

  @override
  Future<List<AnonymousChat>> getMyAnonymousChats(String anonymousId) async {
    try {
      final snapshot = await _firestore
          .collection('anonymous_chats')
          .where('participantIds', arrayContains: anonymousId)
          .where('isActive', isEqualTo: true)
          .orderBy('lastActivity', descending: true)
          .get();
      return snapshot.docs.map((doc) => AnonymousChat.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to get my anonymous chats: $e');
    }
  }

  @override
  Future<AnonymousChat?> getAnonymousChat(String chatId) async {
    try {
      final doc = await _firestore.collection('anonymous_chats').doc(chatId).get();
      return doc.exists ? AnonymousChat.fromJson(doc.data()!) : null;
    } catch (e) {
      throw Exception('Failed to get anonymous chat: $e');
    }
  }

  @override
  Future<List<AnonymousChatMessage>> getAnonymousChatMessages(String chatId) async {
    try {
      final snapshot = await _firestore
          .collection('anonymous_chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(100) // Limit for performance
          .get();
      return snapshot.docs.map((doc) => AnonymousChatMessage.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to get anonymous chat messages: $e');
    }
  }

  @override
  Future<void> createAnonymousChat(AnonymousChat chat) async {
    try {
      await _firestore
          .collection('anonymous_chats')
          .doc(chat.id)
          .set(chat.toJson());
    } catch (e) {
      throw Exception('Failed to create anonymous chat: $e');
    }
  }

  @override
  Future<void> updateAnonymousChat(AnonymousChat chat) async {
    try {
      await _firestore
          .collection('anonymous_chats')
          .doc(chat.id)
          .update(chat.toJson());
    } catch (e) {
      throw Exception('Failed to update anonymous chat: $e');
    }
  }

  @override
  Future<void> sendAnonymousMessage(AnonymousChatMessage message) async {
    try {
      await _firestore
          .collection('anonymous_chats')
          .doc(message.chatId)
          .collection('messages')
          .doc(message.id)
          .set(message.toJson());
    } catch (e) {
      throw Exception('Failed to send anonymous message: $e');
    }
  }

  @override
  Future<void> reportAnonymousMessage(String messageId, String reason) async {
    try {
      await _firestore
          .collection('reports')
          .add({
        'messageId': messageId,
        'reason': reason,
        'reportedAt': Timestamp.now(),
        'status': 'pending',
      });
    } catch (e) {
      throw Exception('Failed to report anonymous message: $e');
    }
  }

  @override
  Future<void> blockAnonymousUser(String userId, String blockedUserId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('blocked_users')
          .doc(blockedUserId)
          .set({
        'blockedAt': Timestamp.now(),
        'blockedUserId': blockedUserId,
      });
    } catch (e) {
      throw Exception('Failed to block anonymous user: $e');
    }
  }
}