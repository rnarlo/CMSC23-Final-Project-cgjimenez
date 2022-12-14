import 'dart:convert';

class Todo {
  final String userId;
  String? id;
  String title;
  bool completed;
  List<dynamic> sharedWith;

  Todo({
    required this.userId,
    this.id,
    required this.title,
    required this.completed,
    required this.sharedWith,
  });

  // Factory constructor to instantiate object from json format
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
      sharedWith: json['sharedWith'],
    );
  }

  static List<Todo> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Todo>((dynamic d) => Todo.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Todo todo) {
    return {
      'userId': todo.userId,
      'title': todo.title,
      'completed': todo.completed,
      'sharedWith': todo.sharedWith,
    };
  }
}
