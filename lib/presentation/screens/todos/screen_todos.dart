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
  final ValueNotifier<List<Map<String, dynamic>>> todosNotifier =
      ValueNotifier([]);

  void _initializeTodos() async {
    final todosFile = File('$rootPath/todos.json');
    if (await todosFile.exists()) {
      todosNotifier.value = List<Map<String, dynamic>>.from(
        jsonDecode(await todosFile.readAsString()),
      );
    } else {
      todosNotifier.value = [];
      await todosFile.writeAsString(jsonEncode([]));
    }
  }

  Future<void> _updateTodosFile() async {
    await File('$rootPath/todos.json')
        .writeAsString(jsonEncode(todosNotifier.value));
  }

  void _addOrUpdateTodo({
    String? newTask,
    int? indexToUpdate,
    bool toggleComplete = false,
  }) {
    todosNotifier.value = [
      for (int i = 0; i < todosNotifier.value.length; i++)
        if (i == indexToUpdate)
          {
            "task": newTask ?? todosNotifier.value[i]["task"],
            "completed": toggleComplete
                ? !todosNotifier.value[i]["completed"]
                : todosNotifier.value[i]["completed"],
          }
        else
          todosNotifier.value[i],
      if (indexToUpdate == null) {"task": newTask, "completed": false}
    ];
    _updateTodosFile();
  }

  void _removeTodoAt(int index) {
    todosNotifier.value = [
      for (int i = 0; i < todosNotifier.value.length; i++)
        if (i != index) todosNotifier.value[i]
    ];
    _updateTodosFile();
  }

  Future<void> _showTodoDialog(BuildContext context,
      {String? initialTask, int? indexToEdit}) async {
    String task = initialTask ?? "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(indexToEdit == null ? "Add Task" : "Edit Task"),
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
              if (task.isNotEmpty) {
                _addOrUpdateTodo(newTask: task, indexToUpdate: indexToEdit);
              }
              Navigator.pop(context);
            },
            child: Text(indexToEdit == null ? "Add" : "Update"),
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
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: todosNotifier,
        builder: (context, todos, _) {
          if (todos.isEmpty) {
            return const Center(child: Text("No tasks added."));
          }
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: clrText, width: 1.5),
                    color: todo["completed"] ? clrText : null,
                  ),
                  child: Checkbox(
                    value: todo["completed"],
                    onChanged: (_) => _addOrUpdateTodo(
                      indexToUpdate: index,
                      toggleComplete: true,
                    ),
                  ),
                ),
                title: Text(
                  todo["task"],
                  style: TextStyle(
                    fontFamily: 'FiraCode',
                    decoration: todo["completed"]
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
                          initialTask: todo["task"], indexToEdit: index),
                    ),
                    IconButton(
                      icon: const Icon(IconsaxOutline.slash),
                      onPressed: () => _removeTodoAt(index),
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
