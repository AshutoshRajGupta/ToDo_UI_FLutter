import 'package:flutter/material.dart';
import 'todo.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  // Method to update the completion status of a todo
  void updateTodoCompletion(int id, bool completed) {
    final todoIndex = _todos.indexWhere((todo) => todo.id == id);
    if (todoIndex != -1) {
      _todos[todoIndex].completed = completed;
      notifyListeners();
    }
  }

  // Method to remove a todo
  void removeTodo(int id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  // Method to add a new todo
  void addTodo(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void updateTodo(Todo updatedTodo) {
    final index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      _todos[index] = updatedTodo;
      notifyListeners();
    }
  }
}
