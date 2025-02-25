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
      controller.text = text.replaceRange(
        selection.start,
        selection.end,
        '$prefix${text.substring(selection.start, selection.end)}$suffix',
      );

      // Position cursor after the formatted text
      controller.selection = TextSelection.collapsed(
        offset: selection.end + prefix.length + suffix.length,
      );
    } else {
      // If no text selected, insert the formatting and place cursor between prefix and suffix
      controller.text = text.replaceRange(
        selection.start,
        selection.start,
        '$prefix$suffix',
      );

      // Position cursor between prefix and suffix
      controller.selection = TextSelection.collapsed(
        offset: selection.start + prefix.length,
      );
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
      final currentPosition = controller.selection.baseOffset;

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
        controller.text = text.replaceRange(
          lineStart,
          currentPosition,
          whitespace,
        );
        controller.selection = TextSelection.collapsed(
          offset: lineStart + whitespace.length,
        );
        return true;
      } else if (numberedMatch != null &&
          numberedMatch.group(3)?.trim().isEmpty == true) {
        final whitespace = numberedMatch.group(1) ?? '';
        controller.text =
            text.replaceRange(lineStart, currentPosition, whitespace);
        controller.selection = TextSelection.collapsed(
          offset: lineStart + whitespace.length,
        );
        return true;
      }

      // Continue list if there's content
      if (bulletMatch != null) {
        _insertText(controller, '\n${bulletMatch.group(1) ?? ''}- ');
        return true;
      } else if (numberedMatch != null) {
        _insertText(
          controller,
          '\n${numberedMatch.group(1) ?? ''}${int.parse(numberedMatch.group(2) ?? '1') + 1}. ',
        );
        return true;
      }
    }
    return false;
  }

  void _insertText(TextEditingController controller, String text) {
    controller.text = controller.text.replaceRange(
      controller.selection.baseOffset,
      controller.selection.baseOffset,
      text,
    );
    controller.selection = TextSelection.collapsed(
      offset: controller.selection.baseOffset + text.length,
    );
    _saveChanges(controller.text, entityPath);
  }

  Widget floatingToolbarButton(
    BuildContext context,
    IconData icon,
    String tooltip,
    TextEditingController textController,
    FocusNode focusNode,
    String prefix, [
    String? suffix,
  ]) =>
      IconButton(
        onPressed: () => _insertFormatting(
          textController,
          focusNode,
          prefix,
          suffix ?? '',
        ),
        icon: Icon(
          icon,
          color: Theme.of(context).extension<EndernoteColors>()?.clrText,
        ),
        tooltip: tooltip,
      );

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
            builder: (context, value, _) {
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
                            floatingToolbarButton(
                              context,
                              Icons.format_bold,
                              'Bold',
                              textController,
                              focusNode,
                              '**',
                              '**',
                            ),
                            floatingToolbarButton(
                              context,
                              Icons.format_italic,
                              'Italic',
                              textController,
                              focusNode,
                              '*',
                              '*',
                            ),
                            floatingToolbarButton(
                              context,
                              Icons.format_underline,
                              'Underline',
                              textController,
                              focusNode,
                              '__',
                              '__',
                            ),
                            floatingToolbarButton(
                              context,
                              Icons.strikethrough_s,
                              'Strikethrough',
                              textController,
                              focusNode,
                              '~~',
                              '~~',
                            ),
                            floatingToolbarButton(
                              context,
                              Icons.format_list_bulleted,
                              'Bullet List',
                              textController,
                              focusNode,
                              '- ',
                            ),
                            floatingToolbarButton(
                              context,
                              Icons.format_list_numbered,
                              'Numbered List',
                              textController,
                              focusNode,
                              '1. ',
                            ),
                            floatingToolbarButton(
                              context,
                              Icons.code,
                              'Code Block',
                              textController,
                              focusNode,
                              '```\n',
                              '\n```',
                            ),
                            floatingToolbarButton(
                              context,
                              Icons.link,
                              'Link',
                              textController,
                              focusNode,
                              '[',
                              '](url)',
                            ),
                            floatingToolbarButton(
                              context,
                              Icons.image,
                              'Image',
                              textController,
                              focusNode,
                              '![alt text](',
                              ')',
                            ),
                            floatingToolbarButton(
                              context,
                              Icons.format_quote,
                              'Quote',
                              textController,
                              focusNode,
                              '> ',
                            ),
                            floatingToolbarButton(
                              context,
                              Icons.horizontal_rule,
                              'Horizontal Rule',
                              textController,
                              focusNode,
                              '\n---\n',
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
