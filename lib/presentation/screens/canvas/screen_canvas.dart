import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import 'edit_mode/edit_mode.dart';
import 'preview_mode/preview_mode.dart';

class ScreenCanvas extends StatelessWidget {
  ScreenCanvas({super.key});

  final ValueNotifier<bool> editOrPreview = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: editOrPreview,
      builder: (context, value, _) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(IconsaxOutline.arrow_left_2),
            ),
            title: value
                ? const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )
                : const Text(
                    'noteTitle',
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
            actions: [
              IconButton(
                icon: Icon(
                  value ? IconsaxOutline.edit_2 : IconsaxOutline.book_1,
                ),
                onPressed: () => editOrPreview.value = !editOrPreview.value,
              ),
            ],
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
