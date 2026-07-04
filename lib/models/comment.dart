import 'user.dart';

class Comment {
  final String id;
  final User author;
  final String text;
  final DateTime dateTime;
  final DateTime? updatedAt;

  Comment({
    required this.id,
    required this.author,
    required this.text,
    required this.dateTime,
    this.updatedAt,
  });

  factory Comment.fromMap(Map<String, dynamic> data) {
    return Comment(
      id: data['id'] ?? '',
      author: User.fromMap(data['author'] ?? {}),
      text: data['text'] ?? '',
      dateTime: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : DateTime.now(),
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author_id': author.id,
      'text': text,
      'created_at': dateTime.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
