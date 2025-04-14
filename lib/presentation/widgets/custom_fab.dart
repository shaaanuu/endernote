import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:ficonsax/ficonsax.dart';

import '../../bloc/directory/directory_bloc.dart';
import '../../bloc/directory/directory_events.dart';
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
      openCloseDial: isDialOpen,
      children: [
        _buildDialChild(
          context,
          controller: folderController,
          icon: IconsaxOutline.folder,
          label: "Folder",
          onCreate: () async {
            if (folderController.text.isNotEmpty) {
              await Directory(
                '$rootPath/${folderController.text}',
              ).create(recursive: true);
              context.read<DirectoryBloc>().add(FetchDirectory(rootPath));
            }
            Navigator.pop(context);
            folderController.clear();
          },
        ),
        _buildDialChild(
          context,
          controller: fileController,
          icon: IconsaxOutline.task_square,
          label: "Note",
          onCreate: () async {
            if (fileController.text.isNotEmpty) {
              await File(
                '$rootPath/${fileController.text}.md',
              ).create(recursive: true);
              context.read<DirectoryBloc>().add(FetchDirectory(rootPath));
            }
            Navigator.pop(context);
            fileController.clear();
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
    required Future<void> Function() onCreate,
  }) {
    return SpeedDialChild(
      child: Icon(icon),
      label: label,
      onTap: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor:
              Theme.of(context).extension<EndernoteColors>()?.clrBase,
          title: Text(
            'New $label',
            style: TextStyle(
              color: Theme.of(context).extension<EndernoteColors>()?.clrText,
            ),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: '$label name',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            onSubmitted: (value) => onCreate(),
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
