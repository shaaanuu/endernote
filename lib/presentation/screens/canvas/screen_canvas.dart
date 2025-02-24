import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import '../../theme/app_themes.dart';
import 'edit_mode/edit_mode.dart';
import 'preview_mode/preview_mode.dart';

class ScreenCanvas extends StatelessWidget {
  ScreenCanvas({super.key});

  final ValueNotifier<bool> editOrPreview = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController =
        TextEditingController(text: 'Title');

    return ValueListenableBuilder<bool>(
      valueListenable: editOrPreview,
      builder: (context, value, _) {
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
                    icon: const Icon(IconsaxOutline.arrow_left_2),
                  ),
                  Expanded(
                    child: TextField(
                      controller: titleController,
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
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      value ? IconsaxOutline.edit_2 : IconsaxOutline.book_1,
                    ),
                    onPressed: () => editOrPreview.value = !editOrPreview.value,
                  ),
                ],
              ),
            ),
          ),
          body: value
              ? EditMode(
                  entityPath:
                      ModalRoute.of(context)?.settings.arguments as String? ??
                          "",
                )
              : PreviewMode(
                  entityPath:
                      ModalRoute.of(context)?.settings.arguments as String? ??
                          "",
                ),
        );
      },
    );
  }
}
