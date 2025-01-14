import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:ficonsax/ficonsax.dart';

import '../theme/endernote_theme.dart';

class CustomFAB extends StatelessWidget {
  const CustomFAB({super.key, required this.rootPath});

  final String rootPath;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isDialOpen = ValueNotifier(false);
    final TextEditingController folderController = TextEditingController();
    final TextEditingController fileController = TextEditingController();

    return SpeedDial(
      openCloseDial: isDialOpen,
      children: [
        _buildDialChild(
          context,
          controller: folderController,
          icon: IconsaxOutline.folder,
          label: "Folder",
          dialogTitle: "New Folder",
          hintText: "Folder name",
          onCreate: () async {
            if (folderController.text.isNotEmpty) {
              await Directory(
                '$rootPath/${folderController.text}',
              ).create(recursive: true);
            }
          },
        ),
        _buildDialChild(
          context,
          controller: fileController,
          icon: IconsaxOutline.task_square,
          label: "Note",
          dialogTitle: "New File",
          hintText: "File name",
          onCreate: () async {
            if (fileController.text.isNotEmpty) {
              await File(
                '$rootPath/${fileController.text}.md',
              ).create(recursive: true);
            }
          },
        ),
      ],
      child: const Icon(IconsaxOutline.add),
    );
  }

  SpeedDialChild _buildDialChild(
    BuildContext context, {
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required String dialogTitle,
    required String hintText,
    required Future<void> Function() onCreate,
  }) {
    return SpeedDialChild(
      child: Icon(icon),
      label: label,
      onTap: () => showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: clrBase,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    dialogTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: const TextStyle(
                        color: clrText,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text("Cancel"),
                        onPressed: () {
                          controller.clear();
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: const Text("Create"),
                        onPressed: () async {
                          await onCreate();
                          controller.clear();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
