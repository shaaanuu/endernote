import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/markdown.dart';

import '../../../theme/endernote_theme.dart';

class EditMode extends StatelessWidget {
  const EditMode({super.key, required this.entityPath});

  final String entityPath;

  Future<CodeController> _initializeCodeController() async {
    return CodeController(
      text: await File(entityPath).readAsString(),
      language: markdown,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CodeController>(
      future: _initializeCodeController(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final codeController = snapshot.data!;

        codeController.addListener(
          () async => await File(entityPath).writeAsString(codeController.text),
        );

        return CodeTheme(
          data: CodeThemeData(
            styles: const {
              'root': TextStyle(color: clrText),
            },
          ),
          child: CodeField(
            controller: codeController,
            textStyle: const TextStyle(fontFamily: 'FiraCode', fontSize: 14),
          ),
        );
      },
    );
  }
}
