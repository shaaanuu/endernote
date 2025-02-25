import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme/app_themes.dart';

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

  void _insertFormatting(
      TextEditingController controller, FocusNode focusNode, String prefix,
      [String suffix = '']) {
    final text = controller.text;
    final selection = controller.selection;

    // If text is selected, wrap it with formatting
    if (selection.start != selection.end) {
      final selectedText = text.substring(selection.start, selection.end);
      final newText = text.replaceRange(
          selection.start, selection.end, '$prefix$selectedText$suffix');

      controller.text = newText;

      // Position cursor after the formatted text
      final newPosition = selection.end + prefix.length + suffix.length;
      controller.selection = TextSelection.collapsed(offset: newPosition);
    } else {
      // If no text selected, insert the formatting and place cursor between prefix and suffix
      final newText =
          text.replaceRange(selection.start, selection.start, '$prefix$suffix');

      controller.text = newText;

      // Position cursor between prefix and suffix
      final newPosition = selection.start + prefix.length;
      controller.selection = TextSelection.collapsed(offset: newPosition);
    }

    // Save changes to file
    _saveChanges(controller.text, entityPath);

    // Ensure the text field keeps focus
    focusNode.requestFocus();
  }

  Future<void> _saveChanges(String content, String path) async {
    try {
      await File(path).writeAsString(content);
    } catch (e) {
      debugPrint("Error saving file: $e");
    }
  }

  // Handle key events for auto-continuation of lists
  bool _handleKeyEvent(RawKeyEvent event, TextEditingController controller) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.enter) {
      final text = controller.text;
      final selection = controller.selection;
      final currentPosition = selection.baseOffset;

      // Find the start of the current line
      int lineStart = text.lastIndexOf('\n', currentPosition - 1) + 1;
      if (lineStart < 0) lineStart = 0;

      // Get the current line up to the cursor
      final currentLine = text.substring(lineStart, currentPosition);

      // Check if line starts with list markers
      final bulletMatch = RegExp(r'^(\s*)- (.*)$').firstMatch(currentLine);
      final numberedMatch =
          RegExp(r'^(\s*)(\d+)\. (.*)$').firstMatch(currentLine);

      // If empty list item (just the marker with no content), remove the marker
      if (bulletMatch != null && bulletMatch.group(2)?.trim().isEmpty == true) {
        final whitespace = bulletMatch.group(1) ?? '';
        final newText =
            text.replaceRange(lineStart, currentPosition, whitespace);
        controller.text = newText;
        controller.selection =
            TextSelection.collapsed(offset: lineStart + whitespace.length);
        return true;
      } else if (numberedMatch != null &&
          numberedMatch.group(3)?.trim().isEmpty == true) {
        final whitespace = numberedMatch.group(1) ?? '';
        final newText =
            text.replaceRange(lineStart, currentPosition, whitespace);
        controller.text = newText;
        controller.selection =
            TextSelection.collapsed(offset: lineStart + whitespace.length);
        return true;
      }

      // Continue list if there's content
      if (bulletMatch != null) {
        final whitespace = bulletMatch.group(1) ?? '';
        final newItem = '\n$whitespace- ';
        _insertText(controller, newItem);
        return true;
      } else if (numberedMatch != null) {
        final whitespace = numberedMatch.group(1) ?? '';
        final number = int.parse(numberedMatch.group(2) ?? '1') + 1;
        final newItem = '\n$whitespace$number. ';
        _insertText(controller, newItem);
        return true;
      }
    }
    return false;
  }

  void _insertText(TextEditingController controller, String text) {
    final currentPosition = controller.selection.baseOffset;
    final newText =
        controller.text.replaceRange(currentPosition, currentPosition, text);
    controller.text = newText;
    controller.selection =
        TextSelection.collapsed(offset: currentPosition + text.length);
    _saveChanges(controller.text, entityPath);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _loadFileContent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final textController = TextEditingController(
            text: snapshot.data ?? "",
          );

          final focusNode = FocusNode();

          // Set up file save listener
          textController.addListener(
            () async {
              try {
                await File(entityPath).writeAsString(textController.text);
              } catch (e) {
                debugPrint("Error saving file: $e");
              }
            },
          );

          return ValueListenableBuilder<TextEditingValue>(
            valueListenable: textController,
            builder: (context, value, child) {
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: RawKeyboardListener(
                        focusNode: FocusNode(),
                        onKey: (event) =>
                            _handleKeyEvent(event, textController),
                        child: TextField(
                          decoration: InputDecoration(
                            floatingLabelStyle: TextStyle(
                              color: Theme.of(context)
                                  .extension<EndernoteColors>()
                                  ?.clrText,
                            ),
                            border: InputBorder.none,
                            labelStyle: TextStyle(
                              color: Theme.of(context)
                                  .extension<EndernoteColors>()
                                  ?.clrText,
                            ),
                            enabledBorder: InputBorder.none,
                          ),
                          style: const TextStyle(fontFamily: 'FiraCode'),
                          controller: textController,
                          focusNode: focusNode,
                          expands: true,
                          minLines: null,
                          maxLines: null,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(12, 0, 0, 12),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          topLeft: Radius.circular(20),
                        ),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => _insertFormatting(
                                textController,
                                focusNode,
                                '**',
                                '**',
                              ),
                              icon: Icon(
                                Icons.format_bold,
                                color: Theme.of(context)
                                    .extension<EndernoteColors>()
                                    ?.clrText,
                              ),
                              tooltip: 'Bold',
                            ),
                            IconButton(
                              onPressed: () => _insertFormatting(
                                textController,
                                focusNode,
                                '*',
                                '*',
                              ),
                              icon: Icon(
                                Icons.format_italic,
                                color: Theme.of(context)
                                    .extension<EndernoteColors>()
                                    ?.clrText,
                              ),
                              tooltip: 'Italic',
                            ),
                            IconButton(
                              onPressed: () => _insertFormatting(
                                textController,
                                focusNode,
                                '__',
                                '__',
                              ),
                              icon: Icon(
                                Icons.format_underline,
                                color: Theme.of(context)
                                    .extension<EndernoteColors>()
                                    ?.clrText,
                              ),
                              tooltip: 'Underline',
                            ),
                            IconButton(
                              onPressed: () => _insertFormatting(
                                textController,
                                focusNode,
                                '~~',
                                '~~',
                              ),
                              icon: Icon(
                                Icons.strikethrough_s,
                                color: Theme.of(context)
                                    .extension<EndernoteColors>()
                                    ?.clrText,
                              ),
                              tooltip: 'Strikethrough',
                            ),
                            IconButton(
                              onPressed: () => _insertFormatting(
                                textController,
                                focusNode,
                                '- ',
                              ),
                              icon: Icon(
                                Icons.format_list_bulleted,
                                color: Theme.of(context)
                                    .extension<EndernoteColors>()
                                    ?.clrText,
                              ),
                              tooltip: 'Bullet List',
                            ),
                            IconButton(
                              onPressed: () => _insertFormatting(
                                textController,
                                focusNode,
                                '1. ',
                              ),
                              icon: Icon(
                                Icons.format_list_numbered,
                                color: Theme.of(context)
                                    .extension<EndernoteColors>()
                                    ?.clrText,
                              ),
                              tooltip: 'Numbered List',
                            ),
                            IconButton(
                              onPressed: () => _insertFormatting(
                                textController,
                                focusNode,
                                '```\n',
                                '\n```',
                              ),
                              icon: Icon(
                                Icons.code,
                                color: Theme.of(context)
                                    .extension<EndernoteColors>()
                                    ?.clrText,
                              ),
                              tooltip: 'Code Block',
                            ),
                            IconButton(
                              onPressed: () => _insertFormatting(
                                textController,
                                focusNode,
                                '[',
                                '](url)',
                              ),
                              icon: Icon(
                                Icons.link,
                                color: Theme.of(context)
                                    .extension<EndernoteColors>()
                                    ?.clrText,
                              ),
                              tooltip: 'Link',
                            ),
                            IconButton(
                              onPressed: () => _insertFormatting(
                                textController,
                                focusNode,
                                '![alt text](',
                                ')',
                              ),
                              icon: Icon(
                                Icons.image,
                                color: Theme.of(context)
                                    .extension<EndernoteColors>()
                                    ?.clrText,
                              ),
                              tooltip: 'Image',
                            ),
                            IconButton(
                              onPressed: () => _insertFormatting(
                                textController,
                                focusNode,
                                '> ',
                              ),
                              icon: Icon(
                                Icons.format_quote,
                                color: Theme.of(context)
                                    .extension<EndernoteColors>()
                                    ?.clrText,
                              ),
                              tooltip: 'Quote',
                            ),
                            IconButton(
                              onPressed: () => _insertFormatting(
                                textController,
                                focusNode,
                                '\n---\n',
                              ),
                              icon: Icon(
                                Icons.horizontal_rule,
                                color: Theme.of(context)
                                    .extension<EndernoteColors>()
                                    ?.clrText,
                              ),
                              tooltip: 'Horizontal Rule',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
