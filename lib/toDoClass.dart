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
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
