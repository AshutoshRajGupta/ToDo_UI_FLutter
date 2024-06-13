import 'package:flutter/material.dart';

class Todo {
  final int id; // Define the id property

  final String title;
  final String description;
  final String date;
  bool completed;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.completed = false,
  });
}
