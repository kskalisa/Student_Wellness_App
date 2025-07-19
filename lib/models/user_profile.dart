class UserProfile {
  final String userId;
  String displayName;
  String? avatarUrl;
  String university;
  List<String> interests;

  UserProfile({
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    required this.university,
    this.interests = const [],
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    userId: json['userId'],
    displayName: json['displayName'],
    avatarUrl: json['avatarUrl'],
    university: json['university'],
    interests: List<String>.from(json['interests']),
  );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'displayName': displayName,
    'avatarUrl': avatarUrl,
    'university': university,
    'interests': interests,
  };
}