class JournalEntry {
  final String id;
  final String userId;
  final DateTime date;
  final String title;
  final String content;
  final String? mood;

  JournalEntry({
    required this.id,
    required this.userId,
    required this.date,
    required this.title,
    required this.content,
    this.mood,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
    id: json['id'],
    userId: json['userId'],
    date: DateTime.parse(json['date']),
    title: json['title'],
    content: json['content'],
    mood: json['mood'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'date': date.toIso8601String(),
    'title': title,
    'content': content,
    'mood': mood,
  };
}