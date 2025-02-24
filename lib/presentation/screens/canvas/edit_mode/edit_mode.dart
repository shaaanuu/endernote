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

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  color: Colors.black12,
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
                  margin: const EdgeInsets.fromLTRB(12, 0, 0, 24),
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.format_bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.format_italic,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.format_underline,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.strikethrough_s,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.format_list_bulleted,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.format_list_numbered,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.code,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.link,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.image,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.format_quote,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.horizontal_rule,
                            color: Colors.white,
                          ),
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
