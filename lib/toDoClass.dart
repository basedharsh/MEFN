// ignore_for_file: file_names

class Todo {
  final String id;
  final String title;
  final String description;
  bool completed;
  final DateTime createdAt;
  final DateTime updatedAt;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['_id'] ?? '', // Handle null case for id
      title: json['title'] ?? '', // Handle null case for title
      description:
          json['description'] ?? '', // Handle null case for description
      completed: json['completed'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(), // Handle null case for createdAt
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(), // Handle null case for updatedAt
    );
  }
}
