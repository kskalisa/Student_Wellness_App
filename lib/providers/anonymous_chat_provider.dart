import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/anonymous_chat.dart';
import '../services/database_service.dart';
import '../services/moderation_service.dart';

class AnonymousChatProvider extends ChangeNotifier {
  final DatabaseService _databaseService;
  final ModerationService _moderationService;
  
  List<AnonymousChat> _availableChats = [];
  List<AnonymousChat> _myChats = [];
  List<AnonymousChatMessage> _currentChatMessages = [];
  AnonymousUser? _currentAnonymousUser;
  AnonymousChat? _currentChat;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<AnonymousChat> get availableChats => _availableChats;
  List<AnonymousChat> get myChats => _myChats;
  List<AnonymousChatMessage> get currentChatMessages => _currentChatMessages;
  AnonymousUser? get currentAnonymousUser => _currentAnonymousUser;
  AnonymousChat? get currentChat => _currentChat;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AnonymousChatProvider(this._databaseService, this._moderationService);

  // Initialize anonymous user
  Future<void> initializeAnonymousUser() async {
    try {
      setLoading(true);
      
      // Generate anonymous ID and display name
      final anonymousId = _generateAnonymousId();
      final displayName = _generateAnonymousName();
      
      _currentAnonymousUser = AnonymousUser(
        anonymousId: anonymousId,
        displayName: displayName,
        createdAt: DateTime.now(),
        lastSeen: DateTime.now(),
      );

      // Save to database
      await _saveAnonymousUser(_currentAnonymousUser!);
      
      notifyListeners();
    } catch (e) {
      _error = 'Failed to initialize anonymous user: $e';
      debugPrint('AnonymousChatProvider: Error initializing user: $e');
    } finally {
      setLoading(false);
    }
  }

  // Load available chat topics
  Future<void> loadAvailableChats() async {
    try {
      setLoading(true);
      _availableChats = await _databaseService.getAvailableAnonymousChats();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load available chats: $e';
      debugPrint('AnonymousChatProvider: Error loading chats: $e');
    } finally {
      setLoading(false);
    }
  }

  // Load user's active chats
  Future<void> loadMyChats() async {
    if (_currentAnonymousUser == null) return;
    
    try {
      setLoading(true);
      _myChats = await _databaseService.getMyAnonymousChats(_currentAnonymousUser!.anonymousId);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load my chats: $e';
      debugPrint('AnonymousChatProvider: Error loading my chats: $e');
    } finally {
      setLoading(false);
    }
  }

  // Join a chat
  Future<void> joinChat(String chatId) async {
    if (_currentAnonymousUser == null) return;
    
    try {
      setLoading(true);
      
      // Get chat details
      final chat = await _databaseService.getAnonymousChat(chatId);
      if (chat == null) {
        _error = 'Chat not found';
        return;
      }

      // Add user to chat participants
      final updatedChat = chat.copyWith(
        participantIds: [...chat.participantIds, _currentAnonymousUser!.anonymousId],
        lastActivity: DateTime.now(),
      );

      await _databaseService.updateAnonymousChat(updatedChat);
      
      // Load chat messages
      await loadChatMessages(chatId);
      
      _currentChat = updatedChat;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to join chat: $e';
      debugPrint('AnonymousChatProvider: Error joining chat: $e');
    } finally {
      setLoading(false);
    }
  }

  // Create a new chat
  Future<void> createChat(String topic) async {
    if (_currentAnonymousUser == null) return;
    
    try {
      setLoading(true);
      
      final chatId = _generateChatId();
      final newChat = AnonymousChat(
        id: chatId,
        topic: topic,
        participantIds: [_currentAnonymousUser!.anonymousId],
        createdAt: DateTime.now(),
        lastActivity: DateTime.now(),
        isActive: true,
      );

      await _databaseService.createAnonymousChat(newChat);
      
      // Add to my chats
      _myChats.add(newChat);
      _currentChat = newChat;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to create chat: $e';
      debugPrint('AnonymousChatProvider: Error creating chat: $e');
    } finally {
      setLoading(false);
    }
  }

  // Load messages for a specific chat
  Future<void> loadChatMessages(String chatId) async {
    if (_currentAnonymousUser == null) return;
    
    try {
      setLoading(true);
      _currentChatMessages = await _databaseService.getAnonymousChatMessages(chatId);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load messages: $e';
      debugPrint('AnonymousChatProvider: Error loading messages: $e');
    } finally {
      setLoading(false);
    }
  }

  // Send a message
  Future<void> sendMessage(String message) async {
    if (_currentAnonymousUser == null || _currentChat == null) return;
    
    try {
      // Moderate message content
      final moderatedMessage = await _moderationService.moderateMessage(message);
      if (!moderatedMessage.isAppropriate) {
        _error = 'Message contains inappropriate content';
        return;
      }

      final chatMessage = AnonymousChatMessage(
        id: _generateMessageId(),
        chatId: _currentChat!.id,
        senderId: _currentAnonymousUser!.anonymousId,
        message: moderatedMessage.content,
        timestamp: DateTime.now(),
        metadata: {
          'moderated': true,
          'originalLength': message.length,
          'moderationFlags': moderatedMessage.flags,
        },
      );

      await _databaseService.sendAnonymousMessage(chatMessage);
      
      // Add to current messages
      _currentChatMessages.add(chatMessage);
      
      // Update chat last activity
      final updatedChat = _currentChat!.copyWith(lastActivity: DateTime.now());
      await _databaseService.updateAnonymousChat(updatedChat);
      _currentChat = updatedChat;
      
      notifyListeners();
    } catch (e) {
      _error = 'Failed to send message: $e';
      debugPrint('AnonymousChatProvider: Error sending message: $e');
    }
  }

  // Leave a chat
  Future<void> leaveChat(String chatId) async {
    if (_currentAnonymousUser == null) return;
    
    try {
      setLoading(true);
      
      final chat = _myChats.firstWhere((c) => c.id == chatId);
      final updatedChat = chat.copyWith(
        participantIds: chat.participantIds.where((id) => id != _currentAnonymousUser!.anonymousId).toList(),
      );

      await _databaseService.updateAnonymousChat(updatedChat);
      
      // Remove from my chats
      _myChats.removeWhere((c) => c.id == chatId);
      
      if (_currentChat?.id == chatId) {
        _currentChat = null;
        _currentChatMessages.clear();
      }
      
      notifyListeners();
    } catch (e) {
      _error = 'Failed to leave chat: $e';
      debugPrint('AnonymousChatProvider: Error leaving chat: $e');
    } finally {
      setLoading(false);
    }
  }

  // Report a message
  Future<void> reportMessage(String messageId, String reason) async {
    try {
      await _databaseService.reportAnonymousMessage(messageId, reason);
      // Could also notify moderation service
    } catch (e) {
      _error = 'Failed to report message: $e';
      debugPrint('AnonymousChatProvider: Error reporting message: $e');
    }
  }

  // Block a user
  Future<void> blockUser(String anonymousId) async {
    if (_currentAnonymousUser == null) return;
    
    try {
      await _databaseService.blockAnonymousUser(_currentAnonymousUser!.anonymousId, anonymousId);
    } catch (e) {
      _error = 'Failed to block user: $e';
      debugPrint('AnonymousChatProvider: Error blocking user: $e');
    }
  }

  // Update user preferences
  Future<void> updatePreferences(Map<String, dynamic> preferences) async {
    if (_currentAnonymousUser == null) return;
    
    try {
      final updatedUser = _currentAnonymousUser!.copyWith(
        preferences: preferences,
        lastSeen: DateTime.now(),
      );
      
      await _saveAnonymousUser(updatedUser);
      _currentAnonymousUser = updatedUser;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update preferences: $e';
      debugPrint('AnonymousChatProvider: Error updating preferences: $e');
    }
  }

  // Clear current chat
  void clearCurrentChat() {
    _currentChat = null;
    _currentChatMessages.clear();
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Helper methods
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  String _generateAnonymousId() {
    return 'anon_${DateTime.now().millisecondsSinceEpoch}_${(1000 + (DateTime.now().millisecondsSinceEpoch % 9000))}';
  }

  String _generateAnonymousName() {
    final adjectives = ['Supportive', 'Caring', 'Understanding', 'Helpful', 'Kind', 'Warm', 'Friendly', 'Compassionate'];
    final nouns = ['Student', 'Peer', 'Friend', 'Helper', 'Listener', 'Supporter', 'Buddy', 'Companion'];
    
    final random = DateTime.now().millisecondsSinceEpoch;
    final adjective = adjectives[random % adjectives.length];
    final noun = nouns[random % nouns.length];
    final number = (random % 999) + 1;
    
    return '$adjective$noun$number';
  }

  String _generateChatId() {
    return 'chat_${DateTime.now().millisecondsSinceEpoch}_${(10000 + (DateTime.now().millisecondsSinceEpoch % 90000))}';
  }

  String _generateMessageId() {
    return 'msg_${DateTime.now().millisecondsSinceEpoch}_${(100000 + (DateTime.now().millisecondsSinceEpoch % 900000))}';
  }

  Future<void> _saveAnonymousUser(AnonymousUser user) async {
    // This would typically save to a secure, anonymous user collection
    // For now, we'll just store in memory
    _currentAnonymousUser = user;
  }
} 