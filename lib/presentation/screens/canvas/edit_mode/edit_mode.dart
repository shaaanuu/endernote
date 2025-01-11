import 'dart:io';

import 'package:flutter/material.dart';

class EditMode extends StatelessWidget {
  const EditMode({super.key, required this.entityPath});

  final String entityPath;

  Future<String> _loadFileContent() async {
    try {
      final file = File(entityPath);
      return await file.readAsString();
    } catch (e) {
      print("Error reading file: $e");
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _loadFileContent(),
      builder: (context, snapshot) {
        final fileContent = snapshot.data ?? "";
        final textController = TextEditingController(text: fileContent);

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(5),
              color: Colors.black12,
              child: TextField(
                decoration: const InputDecoration(border: InputBorder.none),
                controller: textController,
                expands: true,
                minLines: null,
                maxLines: null,
              ),
            ),
          );
        }
      },
    );
  }
}
