// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:todots/configUrl.dart';
import 'package:todots/toDoClass.dart';

class TodoService {
  static Future<List<Todo>> fetchTodos(String jwtToken) async {
    String url = '${Config.baseUrl}/todos';

    final serverResponse = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken'
      },
    );

    if (serverResponse.statusCode == 200) {
      List<dynamic> responseJson = jsonDecode(serverResponse.body);
      return responseJson
          .map((json) => Todo.fromJson(json))
          .where((todo) => !todo.completed)
          .toList();
    } else {
      if (kDebugMode) {
        print('Failed to fetch todos: ${serverResponse.statusCode}');
        print('Response body: ${serverResponse.body}');
      }
      throw Exception('Failed to fetch todos');
    }
  }

  static Future<void> createTodo(
      String jwtToken, String title, String description) async {
    String url = '${Config.baseUrl}/todos';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken'
        },
        body: jsonEncode({
          'title': title,
          'description': description,
        }),
      );
      if (response.statusCode == 201) {
      } else {
        if (kDebugMode) {
          print('Failed to create todo: ${response.statusCode}');
        }
        if (kDebugMode) {
          print('Response body: ${response.body}');
        }
        throw Exception('Failed to create todo');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating todo: $e');
      }
      rethrow;
    }
  }

  static Future<void> updateTodo(
      String jwtToken, Todo todo, String title, String description) async {
    String url = '${Config.baseUrl}/todos/${todo.id}';
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken'
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'completed': todo.completed,
        }),
      );
      if (response.statusCode == 200) {
      } else {
        if (kDebugMode) {
          print('Failed to update todo: ${response.statusCode}');
        }
        if (kDebugMode) {
          print('Response body: ${response.body}');
        }
        throw Exception('Failed to update todo');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating todo: $e');
      }
      rethrow;
    }
  }

  static Future<void> deleteTodo(String jwtToken, Todo todo) async {
    String url = '${Config.baseUrl}/todos/${todo.id}';
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken'
        },
      );
      if (response.statusCode == 200) {
      } else {
        if (kDebugMode) {
          print('Failed to delete todo: ${response.statusCode}');
        }
        if (kDebugMode) {
          print('Response body: ${response.body}');
        }
        throw Exception('Failed to delete todo');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting todo: $e');
      }
      rethrow;
    }
  }
}
