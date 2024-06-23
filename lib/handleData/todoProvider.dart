// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:todots/handleData/fetchTodo.dart';
import 'package:todots/toDoClass.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;
  TodoProvider() {
    fetchTodos('');
  }

  Future<void> fetchTodos(String jwtToken) async {
    try {
      _todos = await TodoService.fetchTodos(jwtToken);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching todos: $e');
      }
    }
  }

  Future<void> createTodo(
      String jwtToken, String title, String description) async {
    try {
      await TodoService.createTodo(jwtToken, title, description);
      fetchTodos(jwtToken);
    } catch (e) {
      if (kDebugMode) {
        print('Error creating todo: $e');
      }
    }
  }

  Future<void> updateTodo(
      String jwtToken, Todo todo, String title, String description) async {
    try {
      await TodoService.updateTodo(jwtToken, todo, title, description);
      fetchTodos(jwtToken);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating todo: $e');
      }
    }
  }

  Future<void> deleteTodo(String jwtToken, Todo todo) async {
    try {
      await TodoService.deleteTodo(jwtToken, todo);
      _todos.remove(todo);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting todo: $e');
      }
      rethrow;
    }
  }
}
