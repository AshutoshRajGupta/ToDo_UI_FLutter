import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'todo.dart';

enum TodoFilter {
  All,
  Completed,
  Incomplete,
}

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];
  int _nextId = 1; // Initialize id counter

  TodoFilter _filter = TodoFilter.All;
  String _searchQuery = '';

  List<Todo> get todos {
    List<Todo> filteredTodos;

    switch (_filter) {
      case TodoFilter.Completed:
        return _todos.where((todo) => todo.completed).toList();
        break;
      case TodoFilter.Incomplete:
        return _todos.where((todo) => !todo.completed).toList();
        break;
      case TodoFilter.All:
      default:
        filteredTodos = List<Todo>.from(_todos);
    }
    if (_searchQuery.isNotEmpty) {
      filteredTodos = filteredTodos
          .where((todo) =>
              todo.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              todo.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filteredTodos;
  }

  TodoFilter get filter => _filter;

  set filter(TodoFilter newFilter) {
    _filter = newFilter;
    notifyListeners();
  }

  set searchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  TodoProvider() {
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosString = prefs.getString('todos');
    if (todosString != null) {
      final List<dynamic> decodedTodos = jsonDecode(todosString);
      _todos = decodedTodos.map((json) => Todo.fromJson(json)).toList();
    }
    notifyListeners();
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String todosString =
        jsonEncode(_todos.map((todo) => todo.toJson()).toList());
    await prefs.setString('todos', todosString);
  }

  void addTodo(Todo todo) {
    todo.id = _nextId++; // Assign unique id and then increment for next todo
    _todos.add(todo);
    _saveTodos();
    notifyListeners();
  }

  void updateTodoCompletion(int id, bool completed) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index].completed = completed;
      _saveTodos();
      notifyListeners();
    }
  }

  void updateTodo(Todo updatedTodo) {
    final index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      _todos[index] = updatedTodo;
      _saveTodos();
      notifyListeners();
    }
  }

  void removeTodo(int id) {
    _todos.removeWhere((todo) => todo.id == id);
    _saveTodos();
    notifyListeners();
  }

  void setFilter(String filter) {
    switch (filter) {
      case 'All':
        _filter = TodoFilter.All;
        break;
      case 'Completed':
        _filter = TodoFilter.Completed;
        break;
      case 'Incomplete':
        _filter = TodoFilter.Incomplete;
        break;
      default:
        _filter = TodoFilter.All;
    }
    notifyListeners();
  }
}
