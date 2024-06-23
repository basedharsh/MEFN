// todo_list_screen.dart

// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todots/completedTask.dart';
import 'package:todots/handleData/todoProvider.dart';
import 'package:todots/loginPage.dart';
import 'package:todots/toDoClass.dart';

class TodoListScreen extends StatelessWidget {
  final String jwtToken;

  const TodoListScreen({super.key, required this.jwtToken});

  void _showCreateTodoModal(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
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
                      Provider.of<TodoProvider>(context, listen: false)
                          .createTodo(
                        jwtToken,
                        titleController.text,
                        descriptionController.text,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Create Todo'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showUpdateTodoModal(BuildContext context, Todo todo) {
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
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
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
                    DropdownButton(
                      value: todo.completed ? 'true' : 'false',
                      onChanged: (value) {
                        setState(() {
                          todo.completed = value == 'true';
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'true',
                          child: Text('Completed'),
                        ),
                        DropdownMenuItem(
                          value: 'false',
                          child: Text('Not Completed'),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<TodoProvider>(context, listen: false)
                            .updateTodo(
                          jwtToken,
                          todo,
                          titleController.text,
                          descriptionController.text,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('Update Todo'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<TodoProvider>(context, listen: false)
                            .deleteTodo(
                          jwtToken,
                          todo,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('Delete Todo'),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<TodoProvider>(context, listen: false).fetchTodos(jwtToken);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<TodoProvider>(context, listen: false)
                  .fetchTodos(jwtToken);
            },
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompletedTasks(jwtToken: jwtToken),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue.shade100,
              ),
              padding: const EdgeInsets.all(10),
              child: const Text("Completed Tasks"),
            ),
          ),
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, _) => ListView.builder(
          itemCount: todoProvider.todos.length,
          itemBuilder: (context, index) {
            final todo = todoProvider.todos[index];
            return ListTile(
              title: Text(todo.title),
              subtitle: Text(todo.description),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _showUpdateTodoModal(context, todo);
                },
              ),
              onTap: () {
                _showUpdateTodoModal(context, todo);
              },
              onLongPress: () {
                Provider.of<TodoProvider>(context, listen: false)
                    .deleteTodo(jwtToken, todo);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateTodoModal(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
