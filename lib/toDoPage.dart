// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todots/toDoClass.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  TodoListScreenState createState() => TodoListScreenState();
}

class TodoListScreenState extends State<TodoListScreen> {
  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  Future<void> _createTodo(String title, String description) async {
    String url = 'http://localhost:3000/api/todos';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'description': description,
        }),
      );
      if (response.statusCode == 201) {
        fetchTodos();
      } else {
        if (kDebugMode) {
          print('Failed to create todo: ${response.statusCode}');
        }
        if (kDebugMode) {
          print('Response body: ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating todo: $e');
      }
    }
  }

  void _showCreateTodoModal(Todo todo) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
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
                    decoration: const InputDecoration(hintText: 'Description'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _createTodo(
                        titleController.text,
                        descriptionController.text,
                      );
                    },
                    child: const Text('Update Todo'),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchTodos() async {
    String url = 'http://localhost:3000/api/todos';
    final serverResponse = await http.get(Uri.parse(url));

    if (serverResponse.statusCode == 200) {
      List<dynamic> responseJson = jsonDecode(serverResponse.body);
      setState(() {
        todos = responseJson.map((json) => Todo.fromJson(json)).toList();
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

  Future<void> _deleteTodo(Todo todo) async {
    String url = 'http://localhost:3000/api/todos/${todo.id}';
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        fetchTodos();
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

  Future<void> _updateTodo(Todo todo, String title, String description) async {
    String url = 'http://localhost:3000/api/todos/${todo.id}';
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
        fetchTodos();
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return ListTile(
            title: Text(todo.title),
            subtitle: Text(todo.description),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              _showUpdateTodoModal(todo);
            },
            onLongPress: () {
              _deleteTodo(todo);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateTodoModal(Todo(
            id: '',
            title: '',
            description: '',
            completed: false,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


// TODO: Improve the UI