import 'package:cloud_firestore/cloud_firestore.dart';

class AnonymousChatMessage {
  final String id;
  final String chatId;
  final String senderId; // Anonymous ID
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String? replyToId; // For threaded conversations
  final Map<String, dynamic>? metadata; // For moderation flags, etc.

  AnonymousChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.replyToId,
    this.metadata,
  });

  factory AnonymousChatMessage.fromJson(Map<String, dynamic> json) {
    return AnonymousChatMessage(
      id: json['id'] ?? '',
      chatId: json['chatId'] ?? '',
      senderId: json['senderId'] ?? '',
      message: json['message'] ?? '',
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      isRead: json['isRead'] ?? false,
      replyToId: json['replyToId'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
      'replyToId': replyToId,
      'metadata': metadata,
    };
  }

  AnonymousChatMessage copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    String? replyToId,
    Map<String, dynamic>? metadata,
  }) {
    return AnonymousChatMessage(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      replyToId: replyToId ?? this.replyToId,
      metadata: metadata ?? this.metadata,
    );
  }
}

class AnonymousChat {
  final String id;
  final String topic; // e.g., "Academic Stress", "Social Anxiety", "General Support"
  final List<String> participantIds; // Anonymous IDs
  final DateTime createdAt;
  final DateTime? lastActivity;
  final bool isActive;
  final Map<String, dynamic>? settings; // Chat settings, moderation rules, etc.

  AnonymousChat({
    required this.id,
    required this.topic,
    required this.participantIds,
    required this.createdAt,
    this.lastActivity,
    this.isActive = true,
    this.settings,
  });

  factory AnonymousChat.fromJson(Map<String, dynamic> json) {
    return AnonymousChat(
      id: json['id'] ?? '',
      topic: json['topic'] ?? '',
      participantIds: List<String>.from(json['participantIds'] ?? []),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      lastActivity: json['lastActivity'] != null 
          ? (json['lastActivity'] as Timestamp).toDate() 
          : null,
      isActive: json['isActive'] ?? true,
      settings: json['settings'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic': topic,
      'participantIds': participantIds,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActivity': lastActivity != null ? Timestamp.fromDate(lastActivity!) : null,
      'isActive': isActive,
      'settings': settings,
    };
  }

  AnonymousChat copyWith({
    String? id,
    String? topic,
    List<String>? participantIds,
    DateTime? createdAt,
    DateTime? lastActivity,
    bool? isActive,
    Map<String, dynamic>? settings,
  }) {
    return AnonymousChat(
      id: id ?? this.id,
      topic: topic ?? this.topic,
      participantIds: participantIds ?? this.participantIds,
      createdAt: createdAt ?? this.createdAt,
      lastActivity: lastActivity ?? this.lastActivity,
      isActive: isActive ?? this.isActive,
      settings: settings ?? this.settings,
    );
  }
}

class AnonymousUser {
  final String anonymousId;
  final String displayName; // Auto-generated anonymous name
  final DateTime createdAt;
  final DateTime lastSeen;
  final Map<String, dynamic>? preferences; // User preferences for chat experience

  AnonymousUser({
    required this.anonymousId,
    required this.displayName,
    required this.createdAt,
    required this.lastSeen,
    this.preferences,
  });

  factory AnonymousUser.fromJson(Map<String, dynamic> json) {
    return AnonymousUser(
      anonymousId: json['anonymousId'] ?? '',
      displayName: json['displayName'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      lastSeen: (json['lastSeen'] as Timestamp).toDate(),
      preferences: json['preferences'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'anonymousId': anonymousId,
      'displayName': displayName,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastSeen': Timestamp.fromDate(lastSeen),
      'preferences': preferences,
    };
  }

  AnonymousUser copyWith({
    String? anonymousId,
    String? displayName,
    DateTime? createdAt,
    DateTime? lastSeen,
    Map<String, dynamic>? preferences,
  }) {
    return AnonymousUser(
      anonymousId: anonymousId ?? this.anonymousId,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
      preferences: preferences ?? this.preferences,
    );
  }
} 