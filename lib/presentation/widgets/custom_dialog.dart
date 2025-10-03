import 'package:flutter/material.dart';

import '../theme/app_themes.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.controller,
    required this.icon,
    required this.label,
    required this.onCreate,
  });

  final TextEditingController controller;
  final IconData icon;
  final String label;
  final void Function() onCreate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: EdgeInsets.all(16),
      contentPadding: EdgeInsets.all(16),
      backgroundColor: Theme.of(context).extension<EndernoteColors>()?.clrBase,
      content: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).extension<EndernoteColors>()?.clrSecondary,
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
    );
  }
}
