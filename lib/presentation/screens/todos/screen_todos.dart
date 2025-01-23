import 'dart:convert';
import 'dart:io';

import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import '../../theme/endernote_theme.dart';

class ScreenTodos extends StatelessWidget {
  ScreenTodos({super.key, required this.rootPath}) {
    _initializeTodos();
  }

  final String rootPath;
  final ValueNotifier<Map<String, bool>> todosNotifier = ValueNotifier({});

  void _initializeTodos() async {
    final todosFile = File('$rootPath/todos.json');
    if (await todosFile.exists()) {
      todosNotifier.value = Map<String, bool>.from(
        jsonDecode(await todosFile.readAsString()),
      );
    } else {
      todosNotifier.value = {};
      await todosFile.writeAsString(jsonEncode({}));
    }
  }

  Future<void> _updateTodosFile() async {
    await File('$rootPath/todos.json')
        .writeAsString(jsonEncode(todosNotifier.value));
  }

  void _addOrUpdateTodo({
    required BuildContext context,
    String? newTask,
    String? taskToUpdate,
    bool toggleComplete = false,
  }) {
    if (newTask != null && newTask.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task name cannot be empty.")),
      );
      return;
    }

    if (newTask != null && todosNotifier.value.containsKey(newTask)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Task '$newTask' already exists.")),
      );
      return;
    }

    final updatedTodos = Map<String, bool>.from(todosNotifier.value);
    if (taskToUpdate != null) {
      updatedTodos[taskToUpdate] = toggleComplete
          ? !updatedTodos[taskToUpdate]!
          : updatedTodos[taskToUpdate]!;
    } else if (newTask != null) {
      updatedTodos[newTask] = false;
    }
    todosNotifier.value = updatedTodos;
    _updateTodosFile();
  }

  void _removeTodo(String taskName) {
    final updatedTodos = Map<String, bool>.from(todosNotifier.value);
    updatedTodos.remove(taskName);
    todosNotifier.value = updatedTodos;
    _updateTodosFile();
  }

  Future<void> _showTodoDialog(BuildContext context,
      {String? initialTask, String? taskToEdit}) async {
    String task = initialTask ?? "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(taskToEdit == null ? "Add Task" : "Edit Task"),
        content: TextField(
          autofocus: true,
          controller: TextEditingController(text: task),
          decoration: const InputDecoration(hintText: "Enter task"),
          onChanged: (value) => task = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (task.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Task name cannot be empty.")),
                );
              } else {
                _addOrUpdateTodo(
                  context: context,
                  newTask: task,
                  taskToUpdate: taskToEdit,
                );
                Navigator.pop(context);
              }
            },
            child: Text(taskToEdit == null ? "Add" : "Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(IconsaxOutline.arrow_left_2),
        ),
        title: const Text("To-Dos"),
      ),
      body: ValueListenableBuilder<Map<String, bool>>(
        valueListenable: todosNotifier,
        builder: (context, todos, _) {
          if (todos.isEmpty) {
            return const Center(child: Text("No tasks added."));
          }
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final taskName = todos.keys.elementAt(index);
              final isCompleted = todos[taskName]!;
              return ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: clrText, width: 1.5),
                    color: isCompleted ? clrText : null,
                  ),
                  child: Checkbox(
                    value: isCompleted,
                    onChanged: (_) => _addOrUpdateTodo(
                      context: context,
                      taskToUpdate: taskName,
                      toggleComplete: true,
                    ),
                  ),
                ),
                title: Text(
                  taskName,
                  style: TextStyle(
                    fontFamily: 'FiraCode',
                    decoration: isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationThickness: 3,
                    decorationColor: clrText,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(IconsaxOutline.edit_2),
                      onPressed: () => _showTodoDialog(context,
                          initialTask: taskName, taskToEdit: taskName),
                    ),
                    IconButton(
                      icon: const Icon(IconsaxOutline.slash),
                      onPressed: () => _removeTodo(taskName),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(IconsaxOutline.add),
        onPressed: () => _showTodoDialog(context),
      ),
    );
  }
}
