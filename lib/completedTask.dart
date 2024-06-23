import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todots/configUrl.dart';
import 'package:todots/toDoClass.dart';
import 'package:http/http.dart' as http;

class CompletedTasks extends StatefulWidget {
  final String jwtToken;
  const CompletedTasks({super.key, required this.jwtToken});

  @override
  State<CompletedTasks> createState() => _CompletedTasksState();
}

class _CompletedTasksState extends State<CompletedTasks> {
  List<Todo> CompletedTodos = [];

  @override
  void initState() {
    super.initState();
    completedTodos();
  }

  Future<void> completedTodos() async {
    String url = '${Config.baseUrl}/todos?completed=true';
    final serverResponse = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.jwtToken}'
    });

    if (serverResponse.statusCode == 200) {
      List<dynamic> responseJson = jsonDecode(serverResponse.body);

      setState(() {
        CompletedTodos = responseJson
            .map((json) => Todo.fromJson(json))
            .where((todo) => todo.completed)
            .toList();
      });
    } else {
      if (kDebugMode) {
        print('Failed to fetch todos');
      }
    }
  }

  void _showUpdateTodoModal(Todo todo) {
    TextEditingController titleController =
        TextEditingController(text: todo.title);
    TextEditingController descriptionController =
        TextEditingController(text: todo.description);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(hintText: 'Title'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(hintText: 'Description'),
                    ),
                    //CHECKBOX TO MARK AS COMPLETED
                    CheckboxListTile(
                      value: todo.completed,
                      onChanged: (value) {
                        setState(() {
                          todo.completed = value!;
                        });
                      },
                      title: const Text('Completed'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _updateTodo(todo, titleController.text,
                            descriptionController.text);
                        Navigator.pop(context);
                      },
                      child: const Text('Update Todo'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _deleteTodo(todo);
                        Navigator.pop(context);
                      },
                      child: const Text('Delete Todo'),
                    )
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Future<void> _updateTodo(Todo todo, String title, String description) async {
    String url = '${Config.baseUrl}/todos/${todo.id}';
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'description': description,
          'completed': todo.completed,
        }),
      );
      if (response.statusCode == 200) {
        completedTodos();
      } else {
        if (kDebugMode) {
          print('Failed to update todo: ${response.statusCode}');
        }
        if (kDebugMode) {
          print('Response body: ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating todo: $e');
        // Handle the error here
      }
    }
  }

  Future<void> _deleteTodo(Todo todo) async {
    String url = '${Config.baseUrl}/todos/${todo.id}';
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        completedTodos();
      } else {
        if (kDebugMode) {
          print('Failed to delete todo: ${response.statusCode}');
        }
        if (kDebugMode) {
          print('Response body: ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting todo: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Completed Task'),
        ),
        body: ListView.builder(
            itemCount: CompletedTodos.length,
            itemBuilder: (context, index) {
              final todo = CompletedTodos[index];
              return ListTile(
                title: Text(todo.title),
                subtitle: Text(todo.description),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showUpdateTodoModal(todo);
                  },
                ),
              );
            }));
  }
}
