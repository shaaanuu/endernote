import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/markdown.dart';

import '../../../theme/endernote_theme.dart';

class EditMode extends StatefulWidget {
  const EditMode({super.key, required this.entityPath});

  final String entityPath;

  @override
  State<EditMode> createState() => _EditModeState();
}

class _EditModeState extends State<EditMode> {
  late Future<CodeController> _codeControllerFuture;

  @override
  void initState() {
    super.initState();
    _codeControllerFuture = _initializeCodeController();
  }

  Future<CodeController> _initializeCodeController() async {
    return CodeController(
      text: await File(widget.entityPath).readAsString(),
      language: markdown,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<CodeController>(
        future: _codeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final codeController = snapshot.data!;

          codeController.addListener(
            () async => await File(widget.entityPath)
                .writeAsString(codeController.text),
          );

          return CodeTheme(
            data: CodeThemeData(
              styles: const {
                'root': TextStyle(color: clrText),
              },
            ),
            child: CodeField(
              controller: codeController,
              textStyle: const TextStyle(
                fontFamily: 'FiraCode',
                fontSize: 14,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _codeControllerFuture.then((controller) => controller.dispose());
    super.dispose();
  }
}
