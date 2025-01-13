import 'dart:io';

import 'package:flutter/material.dart';

import '../../../theme/endernote_theme.dart';

class EditMode extends StatelessWidget {
  const EditMode({super.key, required this.entityPath});

  final String entityPath;

  Future<String> _loadFileContent() async {
    try {
      return await File(entityPath).readAsString();
    } catch (e) {
      return "Error reading file: $e";
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
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(5),
              color: Colors.black12,
              child: TextField(
                decoration: const InputDecoration(
                  floatingLabelStyle: TextStyle(color: clrText),
                  border: InputBorder.none,
                  labelStyle: TextStyle(color: clrText),
                  enabledBorder: InputBorder.none,
                ),
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
