class MeditationSession {
  final String id;
  final String userId;
  final String title;
  final String description;
  final int durationMinutes;
  final String category;
  final bool isPremium;
  final String? audioUrl;
  final String? imageUrl;
  final DateTime? completedAt;
  final int? rating;

  MeditationSession({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.category,
    this.isPremium = false,
    this.audioUrl,
    this.imageUrl,
    this.completedAt,
    this.rating,
  });

  factory MeditationSession.fromJson(Map<String, dynamic> json) => MeditationSession(
    id: json['id'],
    userId: json['userId'],
    title: json['title'],
    description: json['description'],
    durationMinutes: json['durationMinutes'],
    category: json['category'],
    isPremium: json['isPremium'] ?? false,
    audioUrl: json['audioUrl'],
    imageUrl: json['imageUrl'],
    completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
    rating: json['rating'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'title': title,
    'description': description,
    'durationMinutes': durationMinutes,
    'category': category,
    'isPremium': isPremium,
    'audioUrl': audioUrl,
    'imageUrl': imageUrl,
    'completedAt': completedAt?.toIso8601String(),
    'rating': rating,
  };

  MeditationSession copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    int? durationMinutes,
    String? category,
    bool? isPremium,
    String? audioUrl,
    String? imageUrl,
    DateTime? completedAt,
    int? rating,
  }) {
    return MeditationSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      category: category ?? this.category,
      isPremium: isPremium ?? this.isPremium,
      audioUrl: audioUrl ?? this.audioUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      completedAt: completedAt ?? this.completedAt,
      rating: rating ?? this.rating,
    );
  }
} 