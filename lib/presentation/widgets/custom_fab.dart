import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax_linear/iconsax_linear.dart';

import '../../bloc/file/file_bloc.dart';
import '../../bloc/file/file_events.dart';
import '../../bloc/file/file_states.dart';
import '../../data/models/chest_record.dart';
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
    required void Function() onCreate,
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

class CustomChestFAB extends StatelessWidget {
  const CustomChestFAB({super.key, required this.box});

  final Box<ChestRecord> box;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isDialOpen = ValueNotifier(false);
    final TextEditingController folderController = TextEditingController();

    return SpeedDial(
      shape: RoundedSuperellipseBorder(
        borderRadius: BorderRadiusGeometry.circular(16),
      ),
      overlayColor: Theme.of(context).extension<EndernoteColors>()?.clrBase,
      openCloseDial: isDialOpen,
      children: [
        _buildDialChild(
          context,
          icon: IconsaxLinear.box_1,
          label: "Open chest",
          onCreate: () async {
            try {
              final pickedDirectoryPath =
                  await FilePicker.platform.getDirectoryPath();

              if (pickedDirectoryPath != null && context.mounted) {
                Navigator.pushNamed(
                  context,
                  '/chest-view',
                  arguments: {
                    'currentPath': pickedDirectoryPath,
                    'rootPath': pickedDirectoryPath,
                  },
                );

                if (!box.values.any(
                  (element) => element.path == pickedDirectoryPath,
                )) {
                  // If it's not already exists, add it
                  box.add(
                    ChestRecord(
                      path: pickedDirectoryPath,
                      ts: DateTime.now().millisecondsSinceEpoch,
                    ),
                  );
                } else {
                  // if it's already exists, update it
                  final a = box.values.firstWhere(
                    (element) => element.path == pickedDirectoryPath,
                  );

                  box.putAt(
                    a.key,
                    ChestRecord(
                      path: pickedDirectoryPath,
                      ts: DateTime.now().millisecondsSinceEpoch,
                    ),
                  );
                }
              } else {
                // TODO: add a error msg
                print("Error, pick something you idiot...");
              }
            } catch (e) {
              // TODO: show a error msg
              print(e.toString());
            }
          },
        ),
        _buildDialChild(
          context,
          controller: folderController,
          icon: IconsaxLinear.box,
          label: "New chest",
          onCreate: () {
            final controller = TextEditingController();

            showDialog(
              context: context,
              builder: (context) => CustomDialog(
                controller: controller,
                icon: IconsaxLinear.box,
                label: 'Chest',
                onCreate: () async {
                  try {
                    final pickedDirectoryPath =
                        await FilePicker.platform.getDirectoryPath();

                    if (pickedDirectoryPath != null) {
                      await Directory(
                              '$pickedDirectoryPath/${controller.text.trim()}')
                          .create(recursive: true);

                      if (context.mounted) {
                        Navigator.pushNamed(
                          context,
                          '/chest-view',
                          arguments: {
                            'currentPath':
                                '$pickedDirectoryPath/${controller.text.trim()}',
                            'rootPath':
                                '$pickedDirectoryPath/${controller.text.trim()}',
                          },
                        );
                      }

                      if (!box.values.any(
                        (element) =>
                            element.path ==
                            '$pickedDirectoryPath/${controller.text.trim()}',
                      )) {
                        // If it's not already exists, add it
                        box.add(
                          ChestRecord(
                            path:
                                '$pickedDirectoryPath/${controller.text.trim()}',
                            ts: DateTime.now().millisecondsSinceEpoch,
                          ),
                        );
                      } else {
                        // If it's already exists, show error
                        // TODO: show a error snackbar
                        print("Error, already exists");
                      }
                    } else {
                      // TODO: add a error msg
                      print("Error, pick something you idiot...");
                    }
                  } catch (e) {
                    // TODO: show a error msg
                    print(e.toString());
                  }
                },
              ),
            );
          },
        ),
      ],
      child: const Icon(IconsaxLinear.add),
    );
  }

  SpeedDialChild _buildDialChild(
    BuildContext context, {
    required IconData icon,
    required String label,
    required void Function() onCreate,
    TextEditingController? controller,
  }) {
    return SpeedDialChild(
      child: Icon(icon),
      label: label,
      backgroundColor:
          Theme.of(context).extension<EndernoteColors>()?.clrSecondary,
      foregroundColor: Theme.of(context).extension<EndernoteColors>()?.clrText,
      labelBackgroundColor:
          Theme.of(context).extension<EndernoteColors>()?.clrSecondary,
      onTap: onCreate,
    );
  }
}
