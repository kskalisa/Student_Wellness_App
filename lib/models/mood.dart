class Mood {
  final String id;
  final String userId;
  final DateTime date;
  final String moodType;
  final int intensity;
  final String? notes;

  Mood({
    required this.id,
    required this.userId,
    required this.date,
    required this.moodType,
    required this.intensity,
    this.notes,
  });

  factory Mood.fromJson(Map<String, dynamic> json) => Mood(
    id: json['id'],
    userId: json['userId'],
    date: DateTime.parse(json['date']),
    moodType: json['moodType'],
    intensity: json['intensity'],
    notes: json['notes'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'date': date.toIso8601String(),
    'moodType': moodType,
    'intensity': intensity,
    'notes': notes,
  };
}