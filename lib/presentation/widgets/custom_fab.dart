import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:iconsax_linear/iconsax_linear.dart';

import '../theme/app_themes.dart';

class CustomFAB extends StatelessWidget {
  const CustomFAB({super.key, required this.rootPath});

  final String rootPath;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isDialOpen = ValueNotifier(false);
    final TextEditingController folderController = TextEditingController();
    final TextEditingController fileController = TextEditingController();

    return SpeedDial(
      shape: RoundedSuperellipseBorder(
        borderRadius: BorderRadiusGeometry.circular(16),
      ),
      overlayColor: Theme.of(context).extension<EndernoteColors>()?.clrBase,
      openCloseDial: isDialOpen,
      children: [
        _buildDialChild(
          context,
          controller: folderController,
          icon: IconsaxLinear.folder,
          label: "Folder",
          onCreate: () async {
            if (folderController.text.isNotEmpty) {
              await Directory(
                '$rootPath/${folderController.text}',
              ).create(recursive: true);
              // TODO: rebuild/fix bloc
              // context.read<DirectoryBloc>().add(FetchDirectory(path: rootPath));
            }
            Navigator.pop(context);
            folderController.clear();
          },
        ),
        _buildDialChild(
          context,
          controller: fileController,
          icon: IconsaxLinear.document_text_1,
          label: "Note",
          onCreate: () async {
            if (fileController.text.isNotEmpty) {
              await File(
                '$rootPath/${fileController.text}.md',
              ).create(recursive: true);
              // TODO: rebuild/fix bloc
              // context.read<DirectoryBloc>().add(FetchDirectory(rootPath));
            }
            Navigator.pop(context);
            fileController.clear();
          },
        ),
      ],
      child: const Icon(IconsaxLinear.add),
    );
  }

  SpeedDialChild _buildDialChild(
    BuildContext context, {
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required Future<void> Function() onCreate,
  }) {
    return SpeedDialChild(
      child: Icon(icon),
      label: label,
      backgroundColor:
          Theme.of(context).extension<EndernoteColors>()?.clrSecondary,
      foregroundColor: Theme.of(context).extension<EndernoteColors>()?.clrText,
      labelBackgroundColor:
          Theme.of(context).extension<EndernoteColors>()?.clrSecondary,
      onTap: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actionsPadding: EdgeInsets.all(16),
          contentPadding: EdgeInsets.all(16),
          backgroundColor:
              Theme.of(context).extension<EndernoteColors>()?.clrBase,
          content: Container(
            decoration: BoxDecoration(
              color:
                  Theme.of(context).extension<EndernoteColors>()?.clrSecondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: '$label name',
                hintStyle: TextStyle(
                  color: Theme.of(context)
                      .extension<EndernoteColors>()
                      ?.clrTextSecondary
                      .withAlpha(179),
                ),
                suffixIcon: Icon(icon),
                suffixIconColor: Theme.of(context)
                    .extension<EndernoteColors>()
                    ?.clrTextSecondary
                    .withAlpha(179),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
              onSubmitted: (value) => onCreate(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller.clear();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: onCreate,
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
