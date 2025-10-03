import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:iconsax_linear/iconsax_linear.dart';

import '../../bloc/file/file_bloc.dart';
import '../../bloc/file/file_events.dart';
import '../../bloc/file/file_states.dart';
import '../theme/app_themes.dart';
import 'custom_dialog.dart';

class CustomFAB extends StatelessWidget {
  const CustomFAB({super.key, required this.rootPath});

  final String rootPath;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isDialOpen = ValueNotifier(false);
    final TextEditingController folderController = TextEditingController();
    final TextEditingController fileController = TextEditingController();

    return BlocBuilder<FileBloc, FileStates>(
      builder: (context, state) => SpeedDial(
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

                if (!context.mounted) return;
                context.read<FileBloc>().add(LoadFiles(rootPath));
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

                if (!context.mounted) return;
                context.read<FileBloc>().add(LoadFiles(rootPath));
              }
              Navigator.pop(context);
              fileController.clear();
            },
          ),
        ],
        child: const Icon(IconsaxLinear.add),
      ),
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
        builder: (context) => CustomDialog(
          controller: controller,
          icon: icon,
          label: label,
          onCreate: onCreate,
        ),
      ),
    );
  }
}
