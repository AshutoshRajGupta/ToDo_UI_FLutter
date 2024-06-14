import 'package:flutter/foundation.dart';

class Todo {
  int id;
  String title;
  String description;
  String date;
  bool completed;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.completed = false,
  });

  // Getter for id
  int get getId => id;

  // Setter for id
  set setId(int newId) {
    id = newId;
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: json['date'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'completed': completed,
    };
  }
}
