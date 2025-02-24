import 'dart:io';

import 'package:flutter/material.dart';

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

          textController.addListener(
            () async {
              try {
                await File(entityPath).writeAsString(textController.text);
              } catch (e) {
                debugPrint("Error saving file: $e");
              }
            },
          );

          Widget floatingToolbarButton(IconData icon, VoidCallback onPressed) =>
              IconButton(
                onPressed: onPressed,
                icon: Icon(
                  icon,
                  color:
                      Theme.of(context).extension<EndernoteColors>()?.clrText,
                ),
              );

          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
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
                    expands: true,
                    minLines: null,
                    maxLines: null,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(12, 0, 0, 12),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        floatingToolbarButton(
                          Icons.format_bold,
                          () {},
                        ),
                        floatingToolbarButton(
                          Icons.format_italic,
                          () {},
                        ),
                        floatingToolbarButton(
                          Icons.format_underline,
                          () {},
                        ),
                        floatingToolbarButton(
                          Icons.strikethrough_s,
                          () {},
                        ),
                        floatingToolbarButton(
                          Icons.format_list_bulleted,
                          () {},
                        ),
                        floatingToolbarButton(
                          Icons.format_list_numbered,
                          () {},
                        ),
                        floatingToolbarButton(
                          Icons.code,
                          () {},
                        ),
                        floatingToolbarButton(
                          Icons.link,
                          () {},
                        ),
                        floatingToolbarButton(
                          Icons.image,
                          () {},
                        ),
                        floatingToolbarButton(
                          Icons.format_quote,
                          () {},
                        ),
                        floatingToolbarButton(
                          Icons.horizontal_rule,
                          () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
