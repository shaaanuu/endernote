import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax_linear/iconsax_linear.dart';

import '../../theme/app_themes.dart';
import 'edit_mode/edit_mode.dart';
import 'preview_mode/preview_mode.dart';

class ScreenCanvas extends StatelessWidget {
  ScreenCanvas({super.key});

  final ValueNotifier<bool> editOrPreview = ValueNotifier(true);
  final ValueNotifier<String> filePathNotifier = ValueNotifier("");
  final TextEditingController titleController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();

  String _getNameWithoutExtension(String path) {
    final base = path.split(Platform.pathSeparator).last;
    return base.endsWith('.md') ? base.substring(0, base.length - 3) : base;
  }

  void _renameFile(BuildContext context, String oldPath, String newName) {
    final parentDir = Directory(oldPath).parent;
    String newPath = '${parentDir.path}/$newName.md';

    if (newPath != oldPath && newName.trim().isNotEmpty) {
      int counter = 1;
      while (File(newPath).existsSync()) {
        newPath = '${parentDir.path}/$newName ($counter).md';
        counter++;
      }

      try {
        File(oldPath).renameSync(newPath);
        filePathNotifier.value = newPath;

        // TODO: update the Files after renaming
        // context.read<DirectoryBloc>().add(FetchDirectory(parentDir.path));
      } catch (e) {
        debugPrint("Error renaming file: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (filePathNotifier.value.isEmpty) {
      filePathNotifier.value =
          ModalRoute.of(context)?.settings.arguments as String? ?? "";
      titleController.text = _getNameWithoutExtension(filePathNotifier.value);
    }

    // Open the preview screen if the file is not empty.
    // And Edit Screen if it is empty.
    editOrPreview.value =
        File(filePathNotifier.value).readAsStringSync().isNotEmpty
            ? false
            : true;

    return ValueListenableBuilder<bool>(
      valueListenable: editOrPreview,
      builder: (context, isEditing, _) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 80,
            title: Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(80),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(IconsaxLinear.arrow_left_1),
                  ),
                  Expanded(
                    child: ValueListenableBuilder<String>(
                      valueListenable: filePathNotifier,
                      builder: (context, filePath, _) {
                        return TextField(
                          // TODO: Enable after fixing the state management
                          enabled: false,
                          controller: titleController,
                          focusNode: titleFocusNode,
                          onChanged: (newName) =>
                              _renameFile(context, filePath, newName),
                          style: TextStyle(
                            fontFamily: 'FiraCode',
                            color: Theme.of(context)
                                .extension<EndernoteColors>()
                                ?.clrText,
                          ),
                          decoration: InputDecoration(
                            hintText: "Note Title",
                            hintStyle: TextStyle(
                              fontFamily: 'FiraCode',
                              color: Theme.of(context)
                                  .extension<EndernoteColors>()
                                  ?.clrText
                                  .withAlpha(100),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                          ),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isEditing ? IconsaxLinear.book_1 : IconsaxLinear.edit_2,
                    ),
                    tooltip: isEditing ? 'Preview' : 'Edit',
                    onPressed: () => editOrPreview.value = !editOrPreview.value,
                  ),
                ],
              ),
            ),
          ),
          body: isEditing
              ? EditMode(entityPath: filePathNotifier.value)
              : PreviewMode(entityPath: filePathNotifier.value),
        );
      },
    );
  }
}
